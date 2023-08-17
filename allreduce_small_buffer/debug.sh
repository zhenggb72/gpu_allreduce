#!/bin/bash
export ONEAPI_DEVICE_SELECTOR=level_zero:gpu
mpirun -disable-auto-cleanup -np 1 gdbserver :44444 ./fill_remote -c 16 -t fp16 : -np 1 gdbserver :44555 ./fill_remote -c 16 -t fp16
