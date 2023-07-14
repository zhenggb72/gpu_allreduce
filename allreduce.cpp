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


static size_t align_up(size_t size, size_t align_sz) {
    return ((size + align_sz -1) / align_sz) * align_sz;
}

void *mmap_host(size_t map_size, int dma_buf_fd) {
  auto page_size = getpagesize();
  map_size = align_up(map_size, page_size);
  return mmap(nullptr, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, dma_buf_fd, 0);
}

template <typename T>
bool checkResults(T *ptr, T c, size_t count, int rank, bool check_output, int iter) {
    bool returnval = true;

#if DEBUG_DUMP_TO_DEDICATED_OFFSET
    //print debug info
    //sleep(rank*0.001);
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

    if (check_output)
    {
        for (int i = 0; i < count; ++i) {
            if (ptr[i] != c)
            {
                printf("rank%d: mismatched at index %d, ref=%f, kernel=%f\n", rank, i, (double)c, (double)ptr[i]);
                returnval = false;
                return returnval;
            }
        }
    }
#else
    //print debug info
    //sleep(rank*0.001);
    //printf("\nthread0\n");
    for (int i = 0; i < 2; ++i) {
        printf("%d, ", ((int *)ptr)[i]);
    }
    //printf("\nthread1\n");
    for (int i = SIMD * UNROLL_SIZE / (sizeof(int) / sizeof(sycl::half)); i < SIMD * UNROLL_SIZE / (sizeof(int) / sizeof(sycl::half)) + 2; ++i) {
        printf("%d, ", ((int *)ptr)[i]);
        if (((int *)ptr)[i] >= LOOP_COUNT_LIMIT)
        {
            printf("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPOTENTIAL HANG\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
        }

    }

    for (int i = SIMD * UNROLL_SIZE * 2; i < count; ++i) {
        if (ptr[i] != c)
        {
            printf("rank%d: mismatched at index %d, ref=%f, kernel=%f\n", rank, i, (double)c, (double)ptr[i]);
            returnval = false;
            return returnval;
        }
    }
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

  alloc_size = count * sizeof(sycl::half); 

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
  
  printf("buffer size=%d\n", (int)(alloc_size * world));

  // rank 0, device 0, subdevice 0
  // rank 1, device 0, subdevice 1
  // rank 2, device 1, subdevice 0
  // ...
  auto queue = currentQueue(rank / 2, rank & 1);
  allreducer<sycl::half> ar;
  //printf("DEBUG rank%d: init\n", rank);
  ar.init(queue, rank, world);
  //printf("DEBUG rank%d: malloc_shared\n", rank);
  // temporal buffer used for allreduce temporal use only.
  void* buffer = sycl::malloc_shared(alloc_size + DEBUG_DATA_SIZE * DEBUG_THREAD_COUNT * sizeof(int), queue);
  using namespace __ESIMD_NS;
  using namespace __ESIMD_ENS;
  uint32_t total_threads_needed = (count + SIMD - 1) / SIMD;
  int wg_size = 1;
  sycl::event e;
  //printf("DEBUG rank%d: input_init_kernel\n", rank);
  e = queue.submit([&](sycl::handler& cgh) {
      cgh.parallel_for<class copy_kernel1>(
          sycl::nd_range<1>({ total_threads_needed }, wg_size), [=](sycl::item<1> idx) SYCL_ESIMD_KERNEL{

            simd<sycl::half, SIMD> grf; //4 registers allocated.
            uint32_t index = idx * SIMD;

            // init buffer
            grf = rank;
            sycl::half * ptr = (sycl::half*)buffer;
            lsc_block_store<sycl::half, SIMD, lsc_data_size::default_size, cache_hint::uncached, cache_hint::uncached>
                (ptr + index, grf);
            lsc_fence<lsc_memory_kind::untyped_global, lsc_fence_op::none, lsc_scope::system>();
          });
  });
  e.wait();

  int repetition = 4;
  bool check = false;

  sycl::half sum;
  if (repetition == 1)
  {
      sum = world * (world - 1) / 2;
  }
  else
  {
      sum = world * (world - 1) / 2;
      for (int i = 0; i < repetition - 1; i++)
      {
          sum = (int)world * (int)sum;
      }
  }

  printf("DEBUG rank%d: allreduce\n", rank);
  for (int i = 0; i < repetition; i++)
  {
      //printf("rank%d: started iteration%d\n", rank, i);
      int index_to_triple_buffer = i % 3;
      //int index_to_triple_buffer = 0; //must be 0, 1 or 2. Vary this 0,1,2,0,1,2... for each allreduce calls. This is needed to successfully run the allreduce without host level sync.
      ar.allreduce(queue, buffer, count, index_to_triple_buffer);
#if DEBUG
      checkResults((sycl::half *)buffer, (sycl::half)sum, count, rank, false, i);
#endif
  }

  // avoid race condition
  queue.wait();
  //printf("DEBUG rank%d: MPI_Barrier\n", rank);
  MPI_Barrier(MPI_COMM_WORLD);
  //printf("DEBUG rank%d: MPI_Finalize\n", rank);
  MPI_Finalize();

  //printf("DEBUG rank%d: check result\n", rank);
  check = checkResults((sycl::half *)buffer, (sycl::half)sum, count, rank, true, -1);
  //std::cout<<"world:"<<world<<"\nrank:" <<rank <<"\nvalue:"<<((sycl::half *)buffer)[0]<<std::endl;
    
  
  if (check)
    std::cout<< "rank" << rank << ": Successfully fill remote buffer"<<std::endl;
  else
    std::cout<< "rank" << rank << ":###################### Error occured when fill remote buffer ##############################"<<std::endl;

  // Clean up, close/put ipc handles, free memory, etc.
  ar.release(queue);
  sycl::free(buffer, queue);
}
