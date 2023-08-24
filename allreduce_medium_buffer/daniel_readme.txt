
daniel's New step
===================

PVC 4 node (a4bf0190574b.jf.intel.com)
---------------------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/gca/cdrhee/dpcpp_and_esimd_version_medium_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh

787 machine (10.45.77.116) cdrhee/Intel@123
Stable 4-PVC node.
----------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/cdrhee/workspace/dpcpp_and_esimd_version_medium_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh
/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

SMC machine (smc-ubb.itwn.intel.com (10.227.107.160)) root/intel@123
Stable 8-PVC node.
To reserve: ttps://wiki.ith.intel.com/display/MICPAE/Super+Micro+x8+PVC+UBB+system+Reservation
To reboot, connect with browser to smc-ubb-bmc.itwn.intel.com (10.227.107.146) USERID/PASSW0RD#1
----------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /root/cdrhee/allreduce/dpcpp_and_esimd_version_medium_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh
/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

