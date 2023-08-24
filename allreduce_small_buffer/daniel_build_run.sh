#!/bin/bash
export ONEAPI_DEVICE_SELECTOR=level_zero:gpu
export FI_PROVIDER=tcp
export IGC_DumpToCustomDir=./dump
export IGC_ShaderDumpEnable=1

rm -rf dump
mkdir dump
make clean
make

#mpirun -np 8 ./allreduce -c 16 -t float
#mpirun -np 8 ./allreduce -c 128 -t float
#mpirun -np 8 ./allreduce -c 4096 -t float
mpirun -np 16 ./allreduce -c 14336 -t float
#mpirun -np 8 ./allreduce -c 262144 -t float
#mpirun -np 8 ./allreduce -c 458752 -t float
#mpirun -np 8 ./allreduce -c 524288 -t float