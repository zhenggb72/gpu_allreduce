#!/bin/bash
export ONEAPI_DEVICE_SELECTOR=level_zero:gpu
mpirun -np 4 ./allreduce -c 16 -t float : -np 3 ./allreduce -c 16 -t float
