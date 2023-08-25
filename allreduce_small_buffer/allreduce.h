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
#include <chrono>
#include <thread>

#define MAX_REPETITION 4
#define SIMD 128
#define SIMD_ATOMIC 16
#define MAX_RANK 16
#define UNROLL_SIZE 1
#define TRIPLE_BUFFER 3
#define SYNC_BYTE (SIMD_ATOMIC * sizeof(int) * 2)
#define ALIGNMENT_BYTE 256
#define MAX_COUNT (512*1024)
#define LOOP_COUNT_LIMIT (1000000)
#define DEBUG_DATA_SIZE 16
#define DEBUG_THREAD_COUNT 2
#define DEBUG_DUMP_TO_DEDICATED_OFFSET 1
#define DEBUG 0

const int kernel_inner_loop = 1;

struct exchange_contents {
  // first 4-byte is file descriptor for drmbuf or gem object
  union {
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


class timer {
public:
    virtual double get_us(uint32_t i) const = 0;
    virtual int size() const = 0;
};

template <uint32_t steps_per_instance = 1>
class gpu_timer :timer {
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


template <typename data_type, uint32_t max_rank = MAX_RANK, uint32_t max_buffer = 1024 /*KB*/>
class allreducer {
public:
    allreducer(){
        initialized = false;
        buffer_index = 0;
        size_per_buffer = 0;
    }

    void init(sycl::queue& queue, uint32_t rank_in, uint32_t world_in){
        using namespace __ESIMD_NS;
        using namespace __ESIMD_ENS;
        rank = rank_in;
        world = world_in;
        // temporal buffer used for allreduce temporal use only.
        data_size_per_buffer = ((MAX_COUNT + SIMD * UNROLL_SIZE * kernel_inner_loop - 1) / (SIMD * UNROLL_SIZE * kernel_inner_loop)) * SIMD * UNROLL_SIZE * kernel_inner_loop;
        data_size_per_buffer = ((data_size_per_buffer * sizeof(data_type) + ALIGNMENT_BYTE - 1) / ALIGNMENT_BYTE) * ALIGNMENT_BYTE / sizeof(data_type); //aligned size
        size_per_buffer = data_size_per_buffer * sizeof(data_type) + SYNC_BYTE;
        int size_per_buffer_kernel = size_per_buffer;
        void* local_triple_buffer = sycl::malloc_shared(size_per_buffer * TRIPLE_BUFFER, queue);

        uint32_t total_threads_needed = (SYNC_BYTE /sizeof(data_type) + SIMD - 1) / SIMD;
        int wg_size = 1;
        uint32_t buffer_offset_to_sync = data_size_per_buffer;
        sycl::event e;
        //initialize the sync buffers to 0.
        //format of the triple buffer: count_sync_count_sync_count_sync
        //There are three sync buffers in triple buffer.
        e = queue.submit([&](sycl::handler& cgh) {
            cgh.parallel_for<class copy_kernel2>(
                sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL{

                  simd<data_type, SIMD> grf; //4 registers allocated.
                  uint32_t index = idx * SIMD;

                  // init buffer
                  grf = 0;
                  data_type * ptr = (data_type*)local_triple_buffer;
                  //init the sync buffer in triple buffer
                  lsc_block_store<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr + index + buffer_offset_to_sync, grf);
                  lsc_block_store<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr + index + buffer_offset_to_sync + size_per_buffer_kernel / sizeof(data_type), grf);
                  lsc_block_store<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                      (ptr + index + buffer_offset_to_sync + 2 * size_per_buffer_kernel / sizeof(data_type), grf);
                  lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::system>();

                });
        });
        e.wait();

        // XXX: gain access to remote pointers
        exchange_peer_ipc_mem(queue, local_triple_buffer);
        initialized = true;

    }
    void allreduce(sycl::queue& queue, void* inout_buffer, uint32_t size, int repetition, bool print_en){
        using namespace __ESIMD_NS;
        using namespace __ESIMD_ENS;

        gpu_timer<MAX_REPETITION> gtimer;
        cpu_timer<MAX_REPETITION + 1> ctimer;
        sycl::event e[MAX_REPETITION];

        if (repetition > MAX_REPETITION)
        {
            printf("error: repetition cannot be larger than %d\n", MAX_REPETITION);
            exit(-1);
        }
        uint32_t temp_rank = rank;
        uint32_t temp_world = world;
        int r;
        assert(initialized == true);
        void* temp_buffer[max_rank];
        for (uint32_t i = 0; i < world; i++) {
            temp_buffer[i] = buffer[i];
        }
        void* temp_sync_buffer[max_rank];
        for (uint32_t i = 0; i < world; i++) {
            temp_sync_buffer[i] = sync_buffer[i];
        }
        uint32_t total_threads_needed = (size + SIMD * UNROLL_SIZE * kernel_inner_loop - 1) / (SIMD * UNROLL_SIZE * kernel_inner_loop); //ceiling
        printf("rank%d required gpu hw thread count = %d\n", rank, total_threads_needed);
        int wg_size = 1;
        int size_per_buffer_kernel = size_per_buffer;

        for (r = 0; r < repetition; r++)
        {
            ctimer.start(r);
            if(r == 1)
                ctimer.start(MAX_REPETITION); //to measure the overall clk count starting from the second run

            int index_to_triple_buffer = r % 3;
            buffer_index = index_to_triple_buffer;
            int buffer_index_kernel = index_to_triple_buffer;
            e[r] = queue.submit([&](sycl::handler& cgh) {
                cgh.parallel_for<class Allreduce_kernel>(
                    sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL{

                        //slm_init(1024);
                        //uint32_t idx = idx2.get_linear_id();

                        /////////////////////////////////////////////////////////////////////////////////
                        //ESIMD kernel
                        uint offset = idx * SIMD * UNROLL_SIZE * kernel_inner_loop;
                        simd<data_type, max_rank * SIMD * UNROLL_SIZE> buffer; //64 registers
                        simd<data_type, SIMD> buffer_small; 
                        simd<ushort, SIMD_ATOMIC> ramp;

                        //to do:
                        //O3 compiler optimization: not much difference after the change.
                        //tune the fence: good perf improvements
                        //tune the cacheability for each IO message: no noticeable improvement
                        //tune the thread size: not much improvements
                        //tune the polling freq
    #pragma unroll
                        for (uint32_t i = 0; i < SIMD_ATOMIC; i++)
                        {
                            ramp[i] = i * sizeof(int);
                        }

                        //do copy from input buffer to temp buffer.
                        for (int i = 0; i < kernel_inner_loop; i++) {
    #pragma unroll
                            for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++) {
                                buffer_small.template select<SIMD, 1>(unroll_i * SIMD) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::cached, cache_hint::cached>
                                    ((data_type *)inout_buffer + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                            }

                            //use the temp buffer for the current rank to copy the data to.
                            data_type * local_temp_ptr = (data_type*)temp_buffer[temp_rank];
                            local_temp_ptr += (buffer_index_kernel * size_per_buffer_kernel / sizeof(data_type)); //point to the correct buffer inside the triple buffer

    #pragma unroll
                            for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++) {
                                lsc_block_store<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                    ((data_type *)local_temp_ptr + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE, buffer_small.template select<SIMD, 1>(unroll_i * SIMD));
                            }
                        }
                        lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::gpus>();

                        //since each threads are copying small chunks of data to temp buffer, all the threads needs to sync globally using atomics within this rank
                        simd_mask<SIMD_ATOMIC> pred;
                        simd<int, SIMD_ATOMIC>status0;
                        pred = false;
                        pred[0] = true;
                        //pred[14] = pred[15] = false;

                        //sync locally within local GPU first.
                        int * local_sync_ptr = (int*)temp_sync_buffer[temp_rank]; //the buffer might be located in remote GPU. But during the atomics, local L2 should be utilized.
                        local_sync_ptr += (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                        status0 = lsc_atomic_update<atomic_op::inc, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                            (local_sync_ptr, ramp, pred);

                        //wait for all the local TG to sync. Then sync the other remote GPUs
                        {
                            while (status0[0] != total_threads_needed)
                            {
                                status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (local_sync_ptr, ramp, pred);
                            }
                        }

                        //once the local level sync is done, atomically write its counter to other remote gpus' atomic counter
                        pred = false;
                        pred[1] = true; //use different lane for the remote gpu sync
                        if (idx == 0) //one thread in the local gpu notifies the remote gpu of its status.
                        {
                            status0 = total_threads_needed;
                            for (int i = 0; i < temp_world; i++)
                            {
                                int * sync_ptr;

                                /////////////////////////////////////////////////////////////////////////////
                                // DEBUG
                                // -----
                                // rank3 seems to have some problem where its cpu time is always ~100us
                                // to debug this, change the way inter-gpu are synced.

                                sync_ptr = (int*)temp_sync_buffer[i]; //the buffer might be located in remote GPU. But during the atomics, local L2 should be utilized.
                                sync_ptr += (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                lsc_atomic_update<atomic_op::add, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                    (sync_ptr, ramp, status0, pred);
                                /////////////////////////////////////////////////////////////////////////////

                            }
                        }

                        //once all the local TGs are sync, do fence so that other GPU can see.
                        //lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::gpus>();

                        //wait for completion of the atomic sync
                        status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                            (local_sync_ptr, ramp, pred);
                        while (status0[1] != total_threads_needed * temp_world)
                        {
                            status0 = lsc_atomic_update<atomic_op::load, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (local_sync_ptr, ramp, pred);
                        }

                        //reset the sync counter for the next allreduce session. Each rank reset's its own buffer
                        if (idx == 0) //one thread in the local gpu notifies the remote gpu of its status.
                        {
                            int buffer_index_to_reset = (buffer_index_kernel + 2) % 3;
                            status0 = 0;
                            pred = true;
                            local_sync_ptr = (int*)temp_sync_buffer[temp_rank]; //the buffer might be located in remote GPU. But during the atomics, local L2 should be utilized.
                            local_sync_ptr += (buffer_index_to_reset * size_per_buffer_kernel / sizeof(int));
                            lsc_atomic_update<atomic_op::store, int, SIMD_ATOMIC, lsc_data_size::default_size, cache_hint::none, cache_hint::none>
                                (local_sync_ptr, ramp, status0, pred); //reset the first half of sync buffer
                        }

                        //at this point, all the threads are done copying data from input buffer to temp buffer.
                        //do All reduce
                        simd<data_type, SIMD * UNROLL_SIZE> result;
                        for (int i = 0; i < kernel_inner_loop; i++)
                        {
                            if (temp_world == 8)
                            {
                                int * peer_ptr0 = ((int*)temp_buffer[0]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr1 = ((int*)temp_buffer[1]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr2 = ((int*)temp_buffer[2]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr3 = ((int*)temp_buffer[3]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr4 = ((int*)temp_buffer[4]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr5 = ((int*)temp_buffer[5]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr6 = ((int*)temp_buffer[6]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr7 = ((int*)temp_buffer[7]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));

#pragma unroll
                                for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++)
                                {
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 0 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr0 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 1 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr1 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 2 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr2 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 3 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr3 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 4 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr4 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 5 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr5 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 6 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr6 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 7 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr7 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                }
                                //do the actual reduction
                                result = 0;
#pragma unroll
                                for (int r = 0; r < 8; r++)
                                {
                                    //result += buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                    result = result + buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                }

                            }
                            else if (temp_world == 16)
                            {
                                //first 8 ranks processing
                                int * peer_ptr0 = ((int*)temp_buffer[0]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr1 = ((int*)temp_buffer[1]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr2 = ((int*)temp_buffer[2]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr3 = ((int*)temp_buffer[3]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr4 = ((int*)temp_buffer[4]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr5 = ((int*)temp_buffer[5]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr6 = ((int*)temp_buffer[6]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr7 = ((int*)temp_buffer[7]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                //second 8 ranks processing
                                int * peer_ptr8 = ((int*)temp_buffer[8]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr9 = ((int*)temp_buffer[9]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr10 = ((int*)temp_buffer[10]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr11 = ((int*)temp_buffer[11]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr12 = ((int*)temp_buffer[12]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr13 = ((int*)temp_buffer[13]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr14 = ((int*)temp_buffer[14]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
                                int * peer_ptr15 = ((int*)temp_buffer[15]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));

#pragma unroll
                                for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++)
                                {
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 0 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr0 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 1 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr1 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 2 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr2 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 3 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr3 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 4 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr4 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 5 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr5 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 6 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr6 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 7 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr7 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 8 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr8 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 9 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr9 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 10 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr10 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 11 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr11 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 12 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr12 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 13 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr13 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 14 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr14 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                    buffer.template select<SIMD, 1>(unroll_i * SIMD + 15 * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                        ((data_type *)peer_ptr15 + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);
                                }
                                //do the actual reduction
                                result = 0;
#pragma unroll
                                for (int r = 0; r < 16; r++)
                                {
                                    //result += buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                    result = result + buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                }

                            }
                            else //this is for 2,4,6 ranks. So there is no problem of overflowing the buffer.
                            {
                                for (int r = 0; r < temp_world; r++)
                                {
                                    int * peer_ptr = ((int*)temp_buffer[r]) + (buffer_index_kernel * size_per_buffer_kernel / sizeof(int));
    #pragma unroll
                                    for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++)
                                    {
                                        buffer.template select<SIMD, 1>(unroll_i * SIMD + r * SIMD * UNROLL_SIZE) = lsc_block_load<data_type, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                                            ((data_type *)peer_ptr + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE);

                                    }
                                }
                                //do the actual reduction
                                result = 0;
                                for (int r = 0; r < temp_world; r++)
                                {
                                    //result += buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                    result = result + buffer.template select<SIMD * UNROLL_SIZE, 1>(r * SIMD * UNROLL_SIZE);
                                }
                            }

                            //write out the results
    #pragma unroll
                            for (int unroll_i = 0; unroll_i < UNROLL_SIZE; unroll_i++) {
                                lsc_block_store<data_type, SIMD, lsc_data_size::default_size, cache_hint::write_back, cache_hint::write_back>
                                    ((data_type *)inout_buffer + offset + unroll_i * SIMD + i * SIMD * UNROLL_SIZE, result.template select<SIMD, 1>(unroll_i * SIMD));
                            }

                        }

                    });
            });
            e[r].wait();
            ctimer.stop(r);

        } // for (r = 0; r < repetition; r++)

        ctimer.stop(MAX_REPETITION);
        for (r = 1; r < repetition; r++)
        {
            gtimer.record(r, e[r]);
        }

        if (print_en)
        {
            //sleep(temp_rank);
            std::this_thread::sleep_for(std::chrono::milliseconds(temp_rank * 100));
            for (r = 1; r < repetition; r++)
            {
                std::cout << "rank" << temp_rank << " rep_idx" << r << ": kernel us= " << gtimer.get_us(r);
                std::cout << " host us= " << ctimer.get_us(r) << "\n";
            }
            std::cout << " avg host us= " << ctimer.get_us(MAX_REPETITION) / (repetition - 1) << "\n";

        }
        else
        {
            std::cout << "rank" << temp_rank << " warmup done " << "\n";

        }
    }
    void release(sycl::queue& queue){        
        // Clean up, close/put ipc handles, free memory, etc.
        auto l0_ctx = sycl::get_native<
            sycl::backend::ext_oneapi_level_zero>(queue.get_context());
        for (uint32_t i = 0; i < world; i++){
            if (i != rank){
                zeCheck(zeMemCloseIpcHandle(l0_ctx, (char *)buffer[i] - offset[i]));
            }                
        }     
        
        sycl::free(buffer[rank], queue);
        initialized = false;
    }

private:
    void exchange_peer_ipc_mem(sycl::queue& queue, void* ptr) {
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

        
        for (uint32_t i = 0; i < world; i++){
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
            buffer[i] = (char*)peer_base + peer->offset;
            sync_buffer[i] = (char*)peer_base + peer->offset + data_size_per_buffer * sizeof(data_type);
            offset[i] = peer->offset;
            ipc_handle[i] = send_buf.ipc_handle;
        }
    }
    
    bool initialized;
    void* buffer[max_rank];
    void* sync_buffer[max_rank];
    size_t offset[max_rank];
    ze_ipc_mem_handle_t ipc_handle[max_rank];
    int rank, world;
    int buffer_index;
    int size_per_buffer;
    int data_size_per_buffer;
};
