#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <system_error>

#include <mpi.h>
#include <sycl/sycl.hpp>
#include <level_zero/ze_api.h>

#include "cxxopts.hpp"
#include "ze_exception.hpp"
#include "allreduce.h"
#include <chrono>
#include <thread>

static size_t align_up(size_t size, size_t align_sz) {
    return ((size + align_sz -1) / align_sz) * align_sz;
}

void *mmap_host(size_t map_size, int dma_buf_fd) {
  auto page_size = getpagesize();
  map_size = align_up(map_size, page_size);
  return mmap(nullptr, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, dma_buf_fd, 0);
}

void *mmap_device_to_host(void *ptr, sycl::queue queue) {
  sycl::context ctx = queue.get_context();
  auto l0_ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(ctx);

  void *base_addr;
  size_t base_size;
  zeCheck(zeMemGetAddressRange(l0_ctx, ptr, &base_addr, &base_size));

  alignas(64) exchange_contents send_buf;

  // fill in the exchange info
  zeCheck(zeMemGetIpcHandle(l0_ctx, base_addr, &send_buf.ipc_handle));
  auto* host_ptr = mmap_host(base_size, send_buf.fd);
  return (char *) host_ptr + ((char *)ptr - (char *)base_addr);
}

void *copy_device_to_host(void *ptr, sycl::queue queue) {
  sycl::context ctx = queue.get_context();
  auto l0_ctx = sycl::get_native<sycl::backend::ext_oneapi_level_zero>(ctx);

  void *base_addr;
  size_t base_size;
  zeCheck(zeMemGetAddressRange(l0_ctx, ptr, &base_addr, &base_size));

  auto * host_ptr = sycl::malloc_host(base_size, queue);
  queue.memcpy(host_ptr, ptr, base_size);
  queue.wait();

  return host_ptr;
}

template <typename T>
bool checkResults(T *ptr, size_t count, int rank, bool check_output, int repetition, int world) {
    bool returnval = true;

#if 1
    //print debug info
    //sleep(rank*0.001);
    /*
    for (int i = count/ (sizeof(int) / sizeof(sycl::half)); i < count/(sizeof(int)/sizeof(sycl::half)) + DEBUG_DATA_SIZE * DEBUG_THREAD_COUNT; ++i) {
        int thread_idx = (i - count / (sizeof(int) / sizeof(sycl::half))) / DEBUG_DATA_SIZE;
        //if ((i - count / (sizeof(int) / sizeof(sycl::half))) % DEBUG_DATA_SIZE == 0)
        //    printf("\nthread%d\n", thread_idx);
        //printf("%d, ", ((int *)ptr)[i]);

        //check the counter
        {
            if (((int *)ptr)[i] >= LOOP_COUNT_LIMIT)
            {
                int rel_idx = (i - count / (sizeof(int) / sizeof(sycl::half)));

                printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n##### POTENTIAL HANG #####\n");
                printf("counter=%d\n", ((int *)ptr)[i]);
                printf("whileloop ID=%d\n", ((int *)ptr)[i - 1]);
                printf("thread ID=%d\n", thread_idx);
                printf("debug element ID=%d\n", rel_idx % DEBUG_DATA_SIZE);
                printf("rank%d iter%d\n", ((int *)ptr)[i + 1], ((int *)ptr)[i + 2]);
                printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
            }
        }
    }
    */

    if (check_output)
    {
#pragma omp parallel for
        for (int i = 0; i < count; ++i) {
            T in[MAX_RANK];
            //create the input values
            for (int r = 0; r < world; ++r)
            {
                in[r] = (r + ((i / SIMD_INIT) & 0x3ff) + (i & 0x3f)) * 1.0 / 1024;
            }
            //compute the reference result.
            T sum;
            for (int rep = 0; rep < repetition; ++rep)
            {
                sum = 0;
                for (int r = 0; r < world; r+=2)
                {
                    sum += (T)(in[r] + in[r+1]);
                }
                for (int r = 0; r < world; ++r)
                {
                    in[r] = sum;
                }
            }

            //check the kernel result against the reference result
            if (ptr[i] != (T)sum)
            {
                printf("rank%d: mismatched at index %d, ref=%f, kernel=%f\n", rank, i, (double)sum, (double)ptr[i]);
                returnval = false;
            }
            //else
            //    printf("matched %f at index %d\n", (double)sum, i);
        }
    }
#else
#endif
    return returnval;
}

int main(int argc, char* argv[]) {
  // parse command line options
  cxxopts::Options opts(
      "Fill remote GPU memory",
      "Exchange IPC handle to next rank (wrap around), and fill received buffer");

  opts.allow_unrecognised_options();
  opts.add_options()
    ("c,count", "Data content count", cxxopts::value<size_t>()->default_value("8192"))
    ("t,type", "Data content type", cxxopts::value<std::string>()->default_value("fp16"))
    ;

  auto parsed_opts = opts.parse(argc, argv);
  auto count = parsed_opts["count"].as<size_t>();
  auto dtype = parsed_opts["type"].as<std::string>();

  size_t alloc_size = 0;
  alloc_size = (count + SIMD_COMPUTE * MAX_RANK - 1) / (SIMD_COMPUTE * MAX_RANK) * SIMD_COMPUTE * MAX_RANK * sizeof(sycl::half); //force the input buffer to be 4KB aligned so that there is no page fault when accessing beyond buffer boundary

  // init section
  auto ret = MPI_Init(&argc, &argv);
  if (ret == MPI_ERR_OTHER) {
    std::cout<<"MPI init error"<<std::endl;
    return -1;
  }

  zeCheck(zeInit(0));
  int rank, world;

  MPI_Comm_size(MPI_COMM_WORLD, &world);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  //only 2,4,6,8,16 are supported.
  if ((world & 1) != 0)
  {
      printf("error: world size of %d is not supported.\n", world);
      exit(-1);
  }
  if (world >= 10 && world <= 14)
  {
      printf("error: world size of %d is not supported.\n", world);
      exit(-1);
  }

  printf("---------------------------------------------------------------------\n");
  printf("buffer size=%d world=%d\n", (int)(count * sizeof(sycl::half)), world);

  // rank 0, device 0, subdevice 0
  // rank 1, device 0, subdevice 1
  // rank 2, device 1, subdevice 0
  // ...
  auto queue = currentQueue(rank / 2, rank & 1);
  allreducer<sycl::half> ar;
  ar.init(queue, rank, world);
  // temporal buffer used for allreduce temporal use only.
  void* buffer = sycl::malloc_device(alloc_size, queue);
  using namespace __ESIMD_NS;
  using namespace __ESIMD_ENS;
  uint32_t total_threads_needed = (count + SIMD_INIT - 1) / (SIMD_INIT);
  int wg_size = 1;
  sycl::event e;
  e = queue.submit([&](sycl::handler& cgh) {
      cgh.parallel_for<class input_init_kernel1>(
          sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL{

            simd<sycl::half, SIMD_INIT> grf; //4 registers allocated.
            uint32_t index = idx * SIMD_INIT;

            // init buffer
            simd<int, SIMD_INIT> ramp;
            for (int i = 0; i < SIMD_INIT; i++)
                ramp[i] = i;
            grf = (rank + (idx & 0x3ff) + ramp) * 1.0 / 1024;
            sycl::half * ptr = (sycl::half*)buffer;
            lsc_block_store<sycl::half, SIMD_INIT, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (ptr + index, grf);
            lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::system>();
          });
  });
  e.wait();

  int repetition = 4;
  bool check = false;

  //warm up runs
  float cpu_time = 0.0;
  ar.allreduce(queue, buffer, count, repetition, &cpu_time);
  std::cout << "rank" << rank << " warmup done " << "\n";
  //reinit the input buffer content
  e = queue.submit([&](sycl::handler& cgh) {
      cgh.parallel_for<class input_init_kernel2>(
          sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL{

            simd<sycl::half, SIMD_INIT> grf; //4 registers allocated.
            uint32_t index = idx * SIMD_INIT;

            // init buffer
            simd<int, SIMD_INIT> ramp;
            for (int i = 0; i < SIMD_INIT; i++)
                ramp[i] = i;
            grf = (rank + (idx & 0x3ff) + ramp) * 1.0 / 1024;
            sycl::half * ptr = (sycl::half*)buffer;
            lsc_block_store<sycl::half, SIMD_INIT, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (ptr + index, grf);
            lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::system>();
          });
  });
  e.wait();
  //real runs
  cpu_time = 0.0;
  float total_kernel_time = ar.allreduce(queue, buffer, count, repetition, &cpu_time);
  //sleep(rank);
  std::this_thread::sleep_for(std::chrono::milliseconds(rank * 100));
  std::cout << "rank" << rank;
  std::cout << "\t total kernel us= " << total_kernel_time;
  std::cout << "\t total cpu us= " << cpu_time << "\n";

  // avoid race condition
  queue.wait();
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();

  auto *host_buffer = copy_device_to_host(buffer, queue);
  check = checkResults((sycl::half *)host_buffer, count, rank, true, repetition, world);
  
  if (check)
    std::cout<< "rank" << rank << ": Successfully fill remote buffer"<<std::endl;
  else
    std::cout<< "rank" << rank << ":###################### Error occured when fill remote buffer ##############################"<<std::endl;

  // Clean up, close/put ipc handles, free memory, etc.
  ar.release(queue);
  sycl::free(buffer, queue);
  sycl::free(host_buffer, queue);
}
