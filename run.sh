#!/bin/bash
export ONEAPI_DEVICE_SELECTOR=level_zero:gpu
mpirun -np 4 ./allreduce -c 16 -t fp16 : -np 3 ./allreduce -c 16 -t fp16
