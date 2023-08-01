#!/bin/bash
export ONEAPI_DEVICE_SELECTOR=level_zero:gpu
export FI_PROVIDER=tcp
export IGC_DumpToCustomDir=./dump
export IGC_ShaderDumpEnable=1

rm -rf dump
mkdir dump
make clean
make

#mpirun -np 8 ./allreduce -c 14336 -t float
#mpirun -np 8 ./allreduce -c 458752 -t float
#mpirun -np 8 ./allreduce -c 67108855 -t float
#mpirun -np 8 ./allreduce -c 1 -t float
#mpirun -np 8 ./allreduce -c 257 -t float

#mpirun -np 8 ./allreduce -c 8 -t float
#mpirun -np 8 ./allreduce -c 16 -t float
#mpirun -np 8 ./allreduce -c 32 -t float
#mpirun -np 8 ./allreduce -c 64 -t float
#mpirun -np 8 ./allreduce -c 128 -t float
#mpirun -np 8 ./allreduce -c 256 -t float
#mpirun -np 8 ./allreduce -c 512 -t float
#mpirun -np 8 ./allreduce -c 1024 -t float
#mpirun -np 8 ./allreduce -c 2048 -t float
#mpirun -np 8 ./allreduce -c 4096 -t float
#mpirun -np 8 ./allreduce -c 8192 -t float
#mpirun -np 8 ./allreduce -c 16384 -t float
#mpirun -np 8 ./allreduce -c 32768 -t float
#mpirun -np 8 ./allreduce -c 65536 -t float
#mpirun -np 8 ./allreduce -c 131072 -t float
#mpirun -np 8 ./allreduce -c 262144 -t float
#mpirun -np 8 ./allreduce -c 524288 -t float
mpirun -np 8 ./allreduce -c 1048576 -t float
#mpirun -np 8 ./allreduce -c 2097152 -t float
#mpirun -np 8 ./allreduce -c 4194304 -t float
#mpirun -np 8 ./allreduce -c 8388608 -t float
#mpirun -np 8 ./allreduce -c 16777216 -t float
#mpirun -np 8 ./allreduce -c 33554432 -t float
#mpirun -np 8 ./allreduce -c 67108864 -t float
#mpirun -np 8 ./allreduce -c 134217728 -t float
#mpirun -np 8 ./allreduce -c 268435456 -t float
#mpirun -np 8 ./allreduce -c 536870912 -t float
#mpirun -np 8 ./allreduce -c 1073741824 -t float
