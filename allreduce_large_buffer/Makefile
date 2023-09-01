CC=icx
CXX=icpx

OPT=-O3

SYCLFLAGS=-fsycl -fsycl-targets=spir64_gen -Xsycl-target-backend=spir64_gen "-device pvc -options \"-vc-codegen\" -internal_options -ze-intel-has-buffer-offset-arg -internal_options -cl-intel-greater-than-4GB-buffer-required"
CCL_ROOT=../ccl/release/_install

INCLUDES=-I$(CCL_ROOT)/include
LIBRARIES=-L$(CCL_ROOT)/lib -lmpi -lze_loader

CXXFLAGS=-std=c++17 -fopenmp $(SYCLFLAGS) $(OPT) -Wall $(INCLUDES) $(LIBRARIES) -Wextra -Wno-unused-parameter -Werror -Wno-implicit-fallthrough

all : allreduce

clean:
	rm -f allreduce
