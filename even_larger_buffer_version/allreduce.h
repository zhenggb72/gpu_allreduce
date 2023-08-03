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
#define KERNEL_NUM 11
#define RANKS_PER_GPU 2

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
void distribute_input_to_local_rank(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    uint32_t read_offset = (idx + threads_already_processed) * SIMD_ATOMIC * TEMP_WORLD;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer = 0;

    if (read_offset + SIMD_ATOMIC * TEMP_WORLD > size)
    {
        int count = (size - read_offset + SIMD_ATOMIC - 1) / SIMD_ATOMIC;
        for (uint32_t i = 0; i < count; i++)
        {
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                ((T *)inout_buffer + read_offset + i * SIMD_ATOMIC);

        }
    }
    else
    {
#pragma unroll
        for (uint32_t i = 0; i < TEMP_WORLD; i++)
        {
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                ((T *)inout_buffer + read_offset + i * SIMD_ATOMIC);

        }
    }

    //T temp = buffer[0];
    //float temp2 = temp;
    //sycl::_V1::ext::oneapi::experimental::printf("in: rank%d: val=%f\n", temp_rank, temp2);

    //use the temp buffer for the current rank to copy the data to.
    //save the first four elements in even rank, the second four elements to odd rank. 
    //In each rank's temp slot, first 4 elements are from even rank of the pair. The next 4 elements are from odd rank of the pair.
    T * ptr = (T*)temp_buffer[temp_rank & 0xfffffffe];
    ptr += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + (temp_rank & 1) * SIMD_ATOMIC * TEMP_WORLD / 2;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            (ptr + i * SIMD_ATOMIC, buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i));
    }

    ptr = (T*)temp_buffer[temp_rank | 1];
    ptr += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + (temp_rank & 1) * SIMD_ATOMIC * TEMP_WORLD / 2;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            (ptr + i * SIMD_ATOMIC, buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i + SIMD_ATOMIC * TEMP_WORLD / 2));
    }
}

template <uint32_t TEMP_WORLD, typename T>
void local_sum(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    T * ptr = (T*)temp_buffer[temp_rank];
    int read_offset = idx * SIMD_ATOMIC * TEMP_WORLD;
    ptr += read_offset + size_per_buffer_kernel * buffer_index_kernel;
    simd<T, SIMD_ATOMIC * TEMP_WORLD / 2> sum;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD; i++)
    {
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            ((T *)ptr + i * SIMD_ATOMIC);
    }
    sum = buffer.template select<SIMD_ATOMIC * TEMP_WORLD / 2, 1>(0) + buffer.template select<SIMD_ATOMIC * TEMP_WORLD / 2, 1>(SIMD_ATOMIC * TEMP_WORLD / 2);

    //store the result in the first half of the temp buffer slot. The second half will be used for all reduction.
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            ((T *)ptr + i * SIMD_ATOMIC, sum.template select<SIMD_ATOMIC, 1>(i * SIMD_ATOMIC));
    }
}

template <uint32_t TEMP_WORLD, typename T>
void distribute_input_to_ranks(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    uint32_t read_offset = idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
    simd<T, SIMD_ATOMIC * TEMP_WORLD / 2> buffer;

#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            ((T *)temp_buffer[temp_rank] + read_offset + i * SIMD_ATOMIC);
    }

    //distribute to other ranks. But even(odd) rank goes to other even(odd) rank.
    //The distributed data will go to the second half of the temp slot. Within the second half, the data will be ordered based on rank ID.
    if (temp_rank & 1)
    {
#pragma unroll
        for (uint32_t i = 1; i < TEMP_WORLD; i += 2)
        {
            T * ptr = (T*)temp_buffer[i];
            ptr += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + TEMP_WORLD / 2 * SIMD_ATOMIC;
            lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (ptr + (temp_rank / 2) * SIMD_ATOMIC, buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * (i / 2)));
        }
    }
    else
    {
#pragma unroll
        for (uint32_t i = 0; i < TEMP_WORLD; i += 2)
        {
            T * ptr = (T*)temp_buffer[i];
            ptr += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + TEMP_WORLD / 2 * SIMD_ATOMIC;
            lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (ptr + (temp_rank / 2) * SIMD_ATOMIC, buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * (i / 2)));
        }
    }
}

template <uint32_t TEMP_WORLD, typename T>
void all_sum(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    T * ptr = (T*)temp_buffer[temp_rank];
    int read_offset = idx * SIMD_ATOMIC * TEMP_WORLD;
    ptr += read_offset + size_per_buffer_kernel * buffer_index_kernel + SIMD_ATOMIC * TEMP_WORLD / 2; //points to second half of the temp slot since that where the data is from other ranks.
    simd<T, SIMD_ATOMIC> sum = 0;
    simd<T, SIMD_ATOMIC * TEMP_WORLD / 2> buffer;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            ((T *)ptr + i * SIMD_ATOMIC);
    }
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        sum = sum + buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i);
    }
    //store the result
    lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached> //save the all sum in the second half of the temp slot.
        (ptr, sum);
}

template <uint32_t TEMP_WORLD, typename T>
void gather(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    simd<T, SIMD_ATOMIC * TEMP_WORLD / 2> buffer;

    if (temp_rank & 1)
    {
#pragma unroll
        for (uint32_t i = 1; i < TEMP_WORLD; i += 2)
        {
            //read the values
            T *read_ptr_int = (T*)temp_buffer[i];
            read_ptr_int += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + SIMD_ATOMIC * TEMP_WORLD / 2; //get the sum from the second half of temp slot
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * (i / 2)) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::cached>
                (read_ptr_int);
        }

    }
    else
    {
#pragma unroll
        for (uint32_t i = 0; i < TEMP_WORLD; i += 2)
        {
            //read the values
            T *read_ptr_int = (T*)temp_buffer[i];
            read_ptr_int += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel + SIMD_ATOMIC * TEMP_WORLD / 2; //get the sum from the second half of temp slot
            buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * (i / 2)) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::cached>
                (read_ptr_int);
        }

    }

    //write out the results
    uint32_t write_offset = idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
    simd<T, SIMD_ATOMIC * TEMP_WORLD / 2> results = buffer;
    T * write_ptr = (T*)temp_buffer[temp_rank];
    write_ptr += write_offset;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        lsc_block_store<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
            (write_ptr + i * SIMD_ATOMIC, results.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i));//save the results in the first half of temp slot
    }
}

template <uint32_t TEMP_WORLD, typename T>
void gather_and_output(int idx, void* inout_buffer, uint32_t size, int threads_already_processed, void *temp_buffer[], uint32_t temp_rank, int outer_iter, int size_per_buffer_kernel, int buffer_index_kernel)
{
    using namespace __ESIMD_NS;
    using namespace __ESIMD_ENS;

    //read the input data
    simd<T, SIMD_ATOMIC * TEMP_WORLD> buffer;
    T *read_ptr_int = (T*)temp_buffer[temp_rank & 0xfffffffe];//read even rank first since it has the first 4 values
    read_ptr_int += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        //read the values
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::cached>
            (read_ptr_int + i * SIMD_ATOMIC);
    }
    read_ptr_int = (T*)temp_buffer[temp_rank | 1];//read the odd rank next since it has the second 4 values
    read_ptr_int += idx * SIMD_ATOMIC * TEMP_WORLD + size_per_buffer_kernel * buffer_index_kernel;
#pragma unroll
    for (uint32_t i = 0; i < TEMP_WORLD / 2; i++)
    {
        //read the values
        buffer.template select<SIMD_ATOMIC, 1>(SIMD_ATOMIC * i + SIMD_ATOMIC * TEMP_WORLD / 2) = lsc_block_load<T, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::uncached, cache_hint::cached>
            (read_ptr_int + i * SIMD_ATOMIC);
    }

    //write out the results
    uint32_t write_offset = (idx + threads_already_processed) * SIMD_ATOMIC * TEMP_WORLD;
    simd<T, SIMD_ATOMIC * TEMP_WORLD> results = buffer; 
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
        int size_per_buffer_kernel = size_per_buffer / sizeof(data_type);

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
                  data_type * ptr2 = (data_type*)local_buffer + index + size_per_buffer_kernel;
                  //init the sync buffer in triple buffer
                  lsc_block_store<data_type, SIMD_INIT, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr, grf);
                  lsc_block_store<data_type, SIMD_INIT, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr2, grf);
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
        int size_per_buffer_for_sync_kernel = size_per_buffer_kernel / (sizeof(int) / sizeof(data_type));
        int buffer_index_kernel = buffer_index;
        int outerloop_iter_count = (size + MAX_COUNT - 1) / MAX_COUNT;
        printf("outerloop_iter_count=%d\n", outerloop_iter_count);
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
            total_kernel_time = 0;
            for (int i = 0; i < KERNEL_NUM; i++)
                kernel_time[i] = 0;
            uint32_t total_threads_needed_sync = 1;
            for (outer_iter = 0; outer_iter < outerloop_iter_count; outer_iter++)
            {
                int kernel_index = 0;
                for (int i = 0; i < KERNEL_NUM; i++)
                    executed[i] = false;
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

#define KERNEL_EXEC_MAP (1+2+4+8+16+32+64+128+256+512+1024) //0x3f

#if KERNEL_EXEC_MAP & 1
                //Data is sent to other tile within the same gpu via MDFI
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_distribute_inputs_to_local_rank>(
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
                                    distribute_input_to_local_rank<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    distribute_input_to_local_rank<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    distribute_input_to_local_rank<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    distribute_input_to_local_rank<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    distribute_input_to_local_rank<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    distribute_input_to_local_rank<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    distribute_input_to_local_rank<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    distribute_input_to_local_rank<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel0\n");
#endif
#if KERNEL_EXEC_MAP & 2
                //sync all the ranks within the GPU.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_rankSync1>(
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

                            //sync only the rank pair within the same gpu.
                            simd_mask<SIMD_ATOMIC> pred;
                            simd<int, SIMD_ATOMIC> status0;
                            pred = false;
                            pred[0] = true;

                            //sync .
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank ^ 1] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            sync_ptr = (int*)temp_sync_buffer[temp_rank] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (status0[0] != RANKS_PER_GPU)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel1\n");
#endif
#if KERNEL_EXEC_MAP & 4
                //local reduction kernel
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_local_summation>(
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
                                    local_sum<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    local_sum<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    local_sum<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    local_sum<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    local_sum<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    local_sum<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    local_sum<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    local_sum<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel2\n");
#endif
#if KERNEL_EXEC_MAP & 8
                //sync all the ranks here before consuming the results.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_rankSync2>(
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

                            //since other ranks might still be doing local_sum, we need to sync ranks here. After the sync is done, the second half of hte temp buffer will be replaced with new sum val.
                            simd_mask<SIMD_ATOMIC> pred;
                            simd<int, SIMD_ATOMIC> status0;
                            pred = false;
                            pred[1] = true;

                            //sync .
                            for (uint32_t i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr = (int*)temp_sync_buffer[i] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                                ////never true. Used to force dependecy with prev kernel
                                //if (total_threads_needed_sync == 0x7fffffff)
                                //    sync_ptr = temp_buffer[0];
                                lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (status0[1] != temp_world)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel3\n");
#endif
#if KERNEL_EXEC_MAP & 16
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_distribute_inputs_to_ranks>(
                        sycl::nd_range<1>({ persist_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL
                        {

                            /////////////////////////////////////////////////////////////////////////////////
                            //ESIMD kernel
                            //move the local sum to other ranks
                            for (int inner_iter = 0; inner_iter < innerloop_iter_count; inner_iter++)
                            {
                                int index = idx + inner_iter * HW_THREAD_COUNT;
                                if (index >= total_threads_needed)
                                    break;

                                switch (temp_world)
                                {
                                case 1:
                                    distribute_input_to_ranks<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    distribute_input_to_ranks<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    distribute_input_to_ranks<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    distribute_input_to_ranks<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    distribute_input_to_ranks<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    distribute_input_to_ranks<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    distribute_input_to_ranks<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    distribute_input_to_ranks<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel4\n");
#endif
#if KERNEL_EXEC_MAP & 32
                //sync all the ranks here before consuming the results.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_rankSync3>(
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
                            pred[2] = true;

                            //sync .
                            for (uint32_t i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr = (int*)temp_sync_buffer[i] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                                ////never true. Used to force dependecy with prev kernel
                                //if (total_threads_needed_sync == 0x7fffffff)
                                //    sync_ptr = temp_buffer[0];
                                lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (status0[2] != temp_world)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel5\n");
#endif
#if KERNEL_EXEC_MAP & 64
                //local reduction kernel
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_all_summation>(
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
                                    all_sum<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    all_sum<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    all_sum<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    all_sum<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    all_sum<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    all_sum<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    all_sum<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    all_sum<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }

                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel6\n");
#endif
#if KERNEL_EXEC_MAP & 128
                //sync all the ranks here before consuming the results.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_rankSync4>(
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
                            pred[3] = true;

                            //sync .
                            for (uint32_t i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr = (int*)temp_sync_buffer[i] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                                ////never true. Used to force dependecy with prev kernel
                                //if (total_threads_needed_sync == 0x7fffffff)
                                //    sync_ptr = temp_buffer[0];
                                lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (status0[3] != temp_world)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, pred);
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel7\n");
#endif
#if KERNEL_EXEC_MAP & 256
                //copy the results to all the ranks.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_gather>(
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
                                    gather<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    gather<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    gather<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    gather<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    gather<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    gather<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    gather<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    gather<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel8\n");
#endif
#if KERNEL_EXEC_MAP & 512
                //sync all the ranks within the GPU.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_rankSync5>(
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
                            pred[4] = true;

                            //sync .
                            int * sync_ptr = (int*)temp_sync_buffer[temp_rank ^ 1] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            sync_ptr = (int*)temp_sync_buffer[temp_rank] + size_per_buffer_for_sync_kernel * buffer_index_kernel;
                            lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);

                            //wait for all the local TG to sync. Then sync the other remote GPUs
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (sync_ptr, ramp, pred);
                            while (!(status0[4] == RANKS_PER_GPU || status0[4] == 0))
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
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel9\n");
#endif
#if KERNEL_EXEC_MAP & 1024
                //copy the results to all the ranks.
                executed[kernel_index] = true;
                e[kernel_index] = queue.submit([&](sycl::handler& cgh)
                {
                    cgh.parallel_for<class Kernel_gather_and_output>(
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
                                    gather_and_output<1, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 2:
                                    gather_and_output<2, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 3:
                                    gather_and_output<3, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 4:
                                    gather_and_output<4, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 5:
                                    gather_and_output<5, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 6:
                                    gather_and_output<6, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 7:
                                    gather_and_output<7, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                case 8:
                                    gather_and_output<8, data_type>(index, inout_buffer, size, threads_already_processed, (void **)temp_buffer, temp_rank, outer_iter, size_per_buffer_kernel, buffer_index_kernel);
                                    break;
                                default:
                                    break;
                                }
                            }
                        });//parallel_for
                });//submit()
                e[kernel_index].wait();
                gtimer.record(kernel_index, e[kernel_index]);
                total_kernel_time += gtimer.get_us(kernel_index);
                kernel_time[kernel_index] += gtimer.get_us(kernel_index);
                kernel_index++;
                //printf("kernel10\n");
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
