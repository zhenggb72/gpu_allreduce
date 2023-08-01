#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <system_error>

#include <mpi.h>
#include <sycl/sycl.hpp>
#include <level_zero/ze_api.h>
#include <ext/intel/esimd.hpp>

#include "cxxopts.hpp"
#include "ze_exception.hpp"
#include "sycl_misc.hpp"

#define MAX_REPETITION 4
#define INIT_SIZE 64
#define INIT_COUNT 1
#define MAX_RANK 8
#define SIMD_INIT (INIT_SIZE * INIT_COUNT)
#define SIMD_ATOMIC 32
#define BUFFER_COUNT 2
#define SYNC_BYTE (SIMD_ATOMIC * sizeof(int) * 2)
#define ALIGNMENT_BYTE 256
#define MAX_COUNT (64*1024*1024/sizeof(data_type))
#define EU_COUNT_PER_RANK 512
#define THREAD_COUNT_PER_EU 8
#define HW_THREAD_COUNT (EU_COUNT_PER_RANK * THREAD_COUNT_PER_EU)
#define KERNEL_NUM 5

struct exchange_contents 
{
  // first 4-byte is file descriptor for drmbuf or gem object
  union 
  {
    ze_ipc_mem_handle_t ipc_handle;
    int fd = -1;
  };
  size_t offset = 0;
  int pid = -1;
};

#define sysCheck(x) \
  if (x == -1) {  \
    throw std::system_error(  \
        std::make_error_code(std::errc(errno)));  \
  }


class timer 
{
public:
    virtual double get_us(uint32_t i) const = 0;
    virtual int size() const = 0;
};

template <uint32_t steps_per_instance = 1>
class gpu_timer :timer 
{
    std::array<sycl::event, steps_per_instance> v_events;
public:
    inline void record(uint32_t i, sycl::event e) {
        v_events[i] = e;
    }
    double get_us(uint32_t i) const {
        auto start = v_events[i].template get_profiling_info<sycl::info::event_profiling::command_start>();
        auto end = v_events[i].template get_profiling_info<sycl::info::event_profiling::command_end>();
        return (end - start) / 1000.0;
    }
    double get_start_us(uint32_t i) const {
        auto start = v_events[i].template get_profiling_info<sycl::info::event_profiling::command_start>();
        return start / 1000.0;
    }
    double get_end_us(uint32_t i) const {
        auto end = v_events[i].template get_profiling_info<sycl::info::event_profiling::command_end>();
        return end / 1000.0;
    }
    int size() const { return steps_per_instance; }
};

template <uint32_t steps_per_instance = 1>
class cpu_timer :timer {
    std::array<std::chrono::time_point<std::chrono::steady_clock>, steps_per_instance> v_start, v_end;
public:
    inline void start(uint32_t i) {
        v_start[i] = std::chrono::steady_clock::now();
    }
    inline void stop(uint32_t i) {
        v_end[i] = std::chrono::steady_clock::now();
    }
    double get_us(uint32_t i) const {
        using namespace std::chrono;
        return duration_cast<microseconds>(v_end[i] - v_start[i]).count();
    }
    int size() const { return steps_per_instance; }
};

template <uint32_t TEMP_WORLD, typename T>
void compute_all_reduce(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;
    //sycl::_V1::ext::oneapi::experimental::printf("size=%f\n", (float)size);

    //read the input data
    uint32_t read_offset = (idx + threads_already_processed) * SIMD_ATOMIC * TEMP_WORLD;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer = 0;
#if 1
    //This section takes about <1 us ??
    if (read_offset + SIMD_ATOMIC * TEMP_WORLD > size)
    {
        int count = (size - read_offset + SIMD_ATOMIC - 1) / SIMD_ATOMIC;
        for (uint32_t i = 0; i < count; i++)
        {
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                ((T *)inout_buffer + read_offset + i * SIMD_ATOMIC);
        }
        //sycl::_V1::ext::oneapi::experimental::printf("in1=%d read_offset=%d count=%d\n", buffer[0], read_offset, count);
    }
    else
    {
#pragma unroll
        for (uint32_t i = 0; i < TEMP_WORLD; i++)
        {
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                ((T *)inout_buffer + read_offset + i * SIMD_ATOMIC);
        }
        //sycl::_V1::ext::oneapi::experimental::printf("in2=%d read_offset=%d count=%d\n", buffer[0], read_offset, TEMP_WORLD);
    }
#endif
    //sycl::_V1::ext::oneapi::experimental::printf("in=%f\n", buffer[0]);

    //if (outer_iter) sycl::_V1::ext::oneapi::experimental::printf("idx=%d\n", idx);

    //use the temp buffer for the current rank to copy the data to.
    //This section takes about  us
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD; i++)
    {
        T * ptr = (T*)temp_buffer[i];
        ptr += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
        lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            (ptr + temp_rank * SIMD_ATOMIC, buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i));
    }
}

template <uint32_t TEMP_WORLD, typename T>
void local_reduce(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    //This section takes about  us
    T * ptr = (T*)temp_buffer[temp_rank];
    int read_offset = idx * SIMD_ATOMIC * TEMP_WORLD;
    ptr += read_offset + size_per_buffer_kernel * buffer_index_kernel;
    simd<T, SIMD_ATOMIC> sum = 0;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer = 0;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD; i++)
    {
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            ((T *)ptr + i * SIMD_ATOMIC);
    }
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD; i++)
    {
        sum = sum + buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i);
    }
    //store the result
    lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
        (ptr, sum);
}

template <uint32_t TEMP_WORLD, typename T>
void output_result_and_reset_tempbuf(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    //This section takes about 35 us
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer;
#if 1
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD; i++)
    {
        //read the values
        T *read_ptr_int = (T*)temp_buffer[i];
        read_ptr_int += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::cached>
            (read_ptr_int);
    }
#endif

    //write out the results
    //This section takes about 7 us
    uint32_t write_offset = (idx + threads_already_processed) * SIMD_ATOMIC * TEMP_WORLD;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> results = buffer; //convert fp32 to fp16
    T * write_ptr = (T*)inout_buffer;
    write_ptr += write_offset;
    if (write_offset + SIMD_ATOMIC * TEMP_WORLD > size)
    {
        int count = (size - write_offset + SIMD_ATOMIC - 1) / SIMD_ATOMIC;
        for (uint32_t i = 0; i < count; i++)
        {
            lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (write_ptr + i * SIMD_ATOMIC, results.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i));
        }
    }
    else
    {
#pragma unroll
        for (uint32_t i = 0; i < TEMP_WORLD; i++)
        {
            lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (write_ptr + i * SIMD_ATOMIC, results.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i));
        }
    }
}

template <typename data_type, uint32_t max_rank = 8, uint32_t max_buffer = 1024 /*KB*/>
class allreducer 
{
public:
    allreducer()
    {
        initialized = false;
        size_per_buffer = 0;
        buffer_index = 0;
    }

    void init(sycl::queue& queue, uint32_t rank_in, uint32_t world_in)
    {
        using namespace __ESIMD_NS;
        using namespace __ESIMD_ENS;
        rank = rank_in;
        world = world_in;
        // temporal buffer used for allreduce temporal use only.
        data_size_per_buffer = ((MAX_COUNT + SIMD_ATOMIC * SIMD_INIT - 1) / (SIMD_ATOMIC * SIMD_INIT)) * SIMD_ATOMIC * SIMD_INIT;
        size_per_buffer = data_size_per_buffer * sizeof(data_type) + (SYNC_BYTE + SIMD_ATOMIC * SIMD_INIT * sizeof(data_type) - 1) / (SIMD_ATOMIC * SIMD_INIT * sizeof(data_type)) * SIMD_ATOMIC * SIMD_INIT * sizeof(data_type);
        void* local_buffer = sycl::malloc_shared(size_per_buffer * BUFFER_COUNT, queue);
        int data_size_per_buffer_kernel = data_size_per_buffer;

        uint32_t total_threads_needed = (SYNC_BYTE /sizeof(data_type) + SIMD_INIT - 1) / SIMD_INIT;
        int wg_size = 1;
        sycl::event e;
        //initialize the sync buffers to 0.
        //format of the triple buffer: count_sync_count_sync_count_sync
        //There are three sync buffers in triple buffer.
        e = queue.submit([&](sycl::handler& cgh) 
        {
            cgh.parallel_for<class init_kernel>(
                sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                {

                  simd<data_type, SIMD_INIT> grf; //4 registers allocated.
                  uint32_t index = idx * SIMD_INIT + data_size_per_buffer_kernel;

                  // init buffer
                  grf = 0;
                  data_type * ptr = (data_type*)local_buffer + index;
                  //init the sync buffer in triple buffer
                  lsc_block_store<data_type, SIMD_INIT, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr, grf);
                  lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::system>();

                });
        });
        e.wait();


        // XXX: gain access to remote pointers
        exchange_peer_ipc_mem(queue, local_buffer);
        initialized = true;

    }
    void allreduce(sycl::queue& queue, void* inout_buffer, uint32_t size, int repetition, bool print_en)
    {
        using namespace __ESIMD_NS;
        using namespace __ESIMD_ENS;

        gpu_timer<KERNEL_NUM> gtimer;
        cpu_timer<MAX_REPETITION + 1> ctimer;
        float total_kernel_time ;
        float kernel_time[KERNEL_NUM] ;

        if (repetition > MAX_REPETITION)
        {
            printf("error: repetition cannot be larger than %d. This is for the testing purpose only. If the repetition count is higher than the limit, all the results will be inf and testing won't be good.\n", MAX_REPETITION);
            exit(-1);
        }
        uint32_t temp_rank = rank;
        uint32_t temp_world = world;
        int r;
        assert(initialized == true);
        void* temp_buffer[max_rank];
        for (int i = 0; i < world; i++) 
        {
            temp_buffer[i] = buffers[i];
        }
        void* temp_sync_buffer[max_rank];
        for (int i = 0; i < world; i++) 
        {
            temp_sync_buffer[i] = sync_buffer[i];
        }
        int size_per_buffer_kernel = size_per_buffer / sizeof(data_type);
        int buffer_index_kernel = buffer_index;
        int outerloop_iter_count = (size + MAX_COUNT - 1) / MAX_COUNT;
        int outer_iter;
        //todo:
        //1. Since the temp buffer can hold 64MB, for W number of ranks, (64MB * W) can be processed within a outerloop iteration. Currently only 64MB is processed.
        //2. persistent thread. done
        //3. cache control fine tune
        //4, tune the temp buffer size so that there are whole number of waves instead of fractional waves.
        //5. prefetch in persistent threads?
        sycl::event e[KERNEL_NUM];
        bool executed[KERNEL_NUM];
        for (r = 0; r < repetition; r++)
        {
            ctimer.start(r);
            if(r == 1)
                ctimer.start(MAX_REPETITION); //to measure the overall clk count starting from the second run

            int threads_already_processed = 0;
            //printf("outerloop_iter_count = %d\n", outerloop_iter_count);
            total_kernel_time = 0;
            kernel_time[0] = kernel_time[1] = kernel_time[2] = kernel_time[3] = kernel_time[4] = 0;
            for (outer_iter = 0; outer_iter < outerloop_iter_count; outer_iter++)
            {
                executed[0] = executed[1] = executed[2] = executed[3] = executed[4] = false;
                uint32_t total_threads_needed;
                if (size - outer_iter * MAX_COUNT > MAX_COUNT)
                {
                    total_threads_needed = (MAX_COUNT + SIMD_ATOMIC * temp_world - 1) / (SIMD_ATOMIC * temp_world);
                }
                else
                {
                    total_threads_needed = (size - outer_iter * MAX_COUNT + SIMD_ATOMIC * temp_world - 1) / (SIMD_ATOMIC * temp_world);
                }
                int wg_size = 1;

                int innerloop_iter_count = (total_threads_needed + HW_THREAD_COUNT - 1) / HW_THREAD_COUNT;
                    
                uint32_t persist_threads_needed = total_threads_needed;
                if (persist_threads_needed > HW_THREAD_COUNT)
                    persist_threads_needed = HW_THREAD_COUNT;

                //printf("DEBUG: total_threads_needed=%d, innerloop_iter_count=%d\n", total_threads_needed, innerloop_iter_count);
                //if (outer_iter)
                //    continue;

#define KERNEL_EXEC_MAP (1+2+4+8+16) //0x3f

#if KERNEL_EXEC_MAP & 1
                //run atomic reduction kernel
                //For 1M count, following kernel takes 38~90 us. rank1&2 are consistently worse than other ranks, as much as 2x worse.
                executed[0] = true;
                e[0] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class AllReduce>(
                        sycl::nd_range<1>({ persist_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {

                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel

                            for (int inner_iter = 0; inner_iter < innerloop_iter_count; inner_iter++)
                            {
                                int index = idx + inner_iter * HW_THREAD_COUNT;
                                if (index >= total_threads_needed)
                                    break;

                                switch (temp_world)
                                {
                                case 1:
                                    compute_all_reduce<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    compute_all_reduce<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    compute_all_reduce<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    compute_all_reduce<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    compute_all_reduce<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    compute_all_reduce<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    compute_all_reduce<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    compute_all_reduce<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[0].wait();
                gtimer.record(0, e[0]);
                total_kernel_time += gtimer.get_us(0);
                kernel_time[0] += gtimer.get_us(0);
#endif
#if KERNEL_EXEC_MAP & 2

                //sync all the ranks here before consuming the results.
                //For 1M count, following kernel takes 11 us by itself. When above kernels are included, 101 us is used. The above kernel perf ranges from 38~90 us depending on the rank.
                uint32_t total_threads_needed_sync = 1;
                executed[1] = true;
                e[1] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class RankSync1>(
                        sycl::nd_range<1>({ total_threads_needed_sync }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {
                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel
                            simd<ushort, SIMD_ATOMIC> ramp;
#pragma unroll
                            for (uint32_t i = 0; i < SIMD_ATOMIC; i++)
                            {
                                ramp[i] = i * sizeof(int);
                            }

                            //since each threads are copying small chunks of data to temp buffer, all the threads needs to sync globally using atomics within this rank
                            simd_mask<SIMD_ATOMIC> pred;
                            simd<int, SIMD_ATOMIC> status0;
                            pred = false;
                            pred[0] = true;

                            //sync .
                            for (uint32_t i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr = (int*)temp_sync_buffer[i];
                                ////never true. Used to force dependecy with prev kernel
                                //if (total_threads_needed_sync == 0x7fffffff)
                                //    sync_ptr = temp_buffer[0];
                                lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank];
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (status0[0] != temp_world)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                        });//parallel_for
                });//submit()
                e[1].wait();
                gtimer.record(1, e[1]);
                total_kernel_time += gtimer.get_us(1);
                kernel_time[1] += gtimer.get_us(1);
#endif
#if KERNEL_EXEC_MAP & 4
                //local reduction kernel
                //For 1M count, following kernel takes  us. 
                executed[2] = true;
                e[2] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class local_reduction>(
                        sycl::nd_range<1>({ persist_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {

                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel

                            for (int inner_iter = 0; inner_iter < innerloop_iter_count; inner_iter++)
                            {
                                int index = idx + inner_iter * HW_THREAD_COUNT;
                                if (index >= total_threads_needed)
                                    break;

                                switch (temp_world)
                                {
                                case 1:
                                    local_reduce<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    local_reduce<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    local_reduce<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    local_reduce<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    local_reduce<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    local_reduce<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    local_reduce<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    local_reduce<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[2].wait();
                gtimer.record(2, e[2]);
                total_kernel_time += gtimer.get_us(2);
                kernel_time[2] += gtimer.get_us(2);
#endif
#if KERNEL_EXEC_MAP & 8

                //sync all the ranks here before consuming the results.
                //For 1M count, following kernel takes 11 us by itself. When above kernels are included, 101 us is used. The above kernel perf ranges from 38~90 us depending on the rank.
                executed[3] = true;
                e[3] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class RankSync2>(
                        sycl::nd_range<1>({ total_threads_needed_sync }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {
                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel
                            simd<ushort, SIMD_ATOMIC> ramp;
#pragma unroll
                            for (uint32_t i = 0; i < SIMD_ATOMIC; i++)
                            {
                                ramp[i] = i * sizeof(int);
                            }

                            //since each threads are copying small chunks of data to temp buffer, all the threads needs to sync globally using atomics within this rank
                            simd_mask<SIMD_ATOMIC> pred;
                            simd<int, SIMD_ATOMIC> status0;
                            pred = false;
                            pred[1] = true;

                            //sync .
                            for (uint32_t i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr = (int*)temp_sync_buffer[i];
                                ////never true. Used to force dependecy with prev kernel
                                //if (total_threads_needed_sync == 0x7fffffff)
                                //    sync_ptr = temp_buffer[0];
                                lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank];
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (!(status0[1] == temp_world || status0[1] == 0))
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                            //init the atomic counter to 0 for the next run
                            status0 = 0;
                            pred = true;
                            lsc_atomic_update<atomic_op::store, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, status0, pred); //initialize the counter for the next run
                        });//parallel_for
                });//submit()
                e[3].wait();
                gtimer.record(3, e[3]);
                total_kernel_time += gtimer.get_us(3);
                kernel_time[3] += gtimer.get_us(3);
#endif

#if KERNEL_EXEC_MAP & 16
                //copy the results to all the ranks.
                //For 1M count, following kernel takes 4 us by itself. When all the above kernels are included, 182 us is used. When immediately above kenrel is include, 93 us.
                executed[4] = true;
                e[4] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class WriteOut>(
                        sycl::nd_range<1>({ persist_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {
                            //if(idx == 0) sycl::_V1::ext::oneapi::experimental::printf("1\n");
                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel
                            for (int inner_iter = 0; inner_iter < innerloop_iter_count; inner_iter++)
                            {
                                //if (idx == 0) sycl::_V1::ext::oneapi::experimental::printf("2\n");
                                int index = idx + inner_iter * HW_THREAD_COUNT;
                                if (index >= total_threads_needed)
                                    break;

                                //if (idx == 0) sycl::_V1::ext::oneapi::experimental::printf("3\n");
                                switch (temp_world)
                                {
                                case 1:
                                    output_result_and_reset_tempbuf<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    output_result_and_reset_tempbuf<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    output_result_and_reset_tempbuf<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    output_result_and_reset_tempbuf<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    output_result_and_reset_tempbuf<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    output_result_and_reset_tempbuf<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    output_result_and_reset_tempbuf<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    //if (idx == 0) sycl::_V1::ext::oneapi::experimental::printf("4\n");
                                    output_result_and_reset_tempbuf<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                                //if (idx == 0) sycl::_V1::ext::oneapi::experimental::printf("5\n");
                            }
                        });//parallel_for
                });//submit()
                e[4].wait();
                gtimer.record(4, e[4]);
                total_kernel_time += gtimer.get_us(4);
                kernel_time[4] += gtimer.get_us(4);
#endif

                buffer_index_kernel++;
                buffer_index_kernel &= 1;
                threads_already_processed += total_threads_needed;
            }//for (outer_iter = 0; outer_iter < outerloop_iter_count; outer_iter++)
            ctimer.stop(r);
        } // for (r = 0; r < repetition; r++)
        buffer_index += outerloop_iter_count * repetition;
        buffer_index &= 1;
        ctimer.stop(MAX_REPETITION);

        if (print_en)
        {
            sleep(temp_rank);
            for (r = 1; r < repetition; r++)
            {
                std::cout << "rank" << temp_rank << " rep_idx" << r << " host us= " << ctimer.get_us(r) << "\n";
            }
            std::cout << "rank"<< temp_rank <<" avg host us= " << ctimer.get_us(MAX_REPETITION) / (repetition - 1) << "\n";
            std::cout << "rank" << temp_rank << " GPU five kernel us = ";
            for (r = 0; r < KERNEL_NUM; r++)
            {
                if(executed[r])
                    std::cout << "\t" << kernel_time[r];
            }
            std::cout << "\t total kernel us= " << total_kernel_time << "\n";

        }
        else
        {
            std::cout << "rank" << temp_rank << " warmup done " << "\n";

        }
    }
    void release(sycl::queue& queue)
    {        
        // Clean up, close/put ipc handles, free memory, etc.
        auto l0_ctx = sycl::get_native<
            sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        for (int i = 0; i < world; i++) 
        {
            if (i != rank)
            {
                zeCheck(zeMemCloseIpcHandle(l0_ctx, (char *)buffers[i] - offsets[i]));
            }                
        }     
        
        sycl::free(buffers[rank], queue);
        initialized = false;
    }

private:
    void exchange_peer_ipc_mem(sycl::queue& queue, void* ptr) 
    {
        // Step 1: Get base address of the pointer
        sycl::context ctx = queue.get_context();
        auto l0_ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(ctx);

        void *base_addr;
        size_t base_size;
        zeCheck(zeMemGetAddressRange(l0_ctx, ptr, &base_addr, &base_size));

        // Step 2: Get IPC mem handle from base address
        alignas(64) exchange_contents send_buf;
        alignas(64) exchange_contents recv_buf[world];

        // fill in the exchange info
        zeCheck(zeMemGetIpcHandle(l0_ctx, base_addr, &send_buf.ipc_handle));
        send_buf.offset = (char*)ptr - (char*)base_addr;
        send_buf.pid = getpid();

        // Step 3: Exchange the handles and offsets
        memset(recv_buf, 0, sizeof(recv_buf));
        // Overkill if we don't really needs all peer's handles
        MPI_Allgather(
            &send_buf, sizeof(send_buf), MPI_BYTE, recv_buf, sizeof(send_buf), MPI_BYTE, MPI_COMM_WORLD);

        
        for (uint32_t i = 0; i < world; i++)
        {
            // Step 4: Prepare pid file descriptor of next process
            auto* peer = recv_buf + i;
            auto pid_fd = syscall(__NR_pidfd_open, peer->pid, 0);
            sysCheck(pid_fd);
            //
            // Step 5: Duplicate GEM object handle to local process
            // and overwrite original file descriptor number
            //
            peer->fd = syscall(__NR_pidfd_getfd, pid_fd, peer->fd, 0);
            sysCheck(peer->fd);

            // Step 6: Open IPC handle of remote peer
            auto l0_device
                = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_device());
            void* peer_base;

            zeCheck(zeMemOpenIpcHandle(
                    l0_ctx, l0_device, peer->ipc_handle, ZE_IPC_MEMORY_FLAG_BIAS_CACHED, &peer_base));
            buffers[i] = (char*)peer_base + peer->offset;
            sync_buffer[i] = (char*)peer_base + peer->offset + data_size_per_buffer * sizeof(data_type);
            offsets[i] = peer->offset;
            ipc_handle[i] = send_buf.ipc_handle;
        }
    }
    
    bool initialized;
    void* buffers[max_rank];
    void* sync_buffer[max_rank];
    size_t offsets[max_rank];
    ze_ipc_mem_handle_t ipc_handle[max_rank];
    int rank, world;
    int size_per_buffer;
    int data_size_per_buffer;
    int buffer_index;
};
