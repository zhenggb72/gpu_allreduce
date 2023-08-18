
daniel's New step
===================

PVC 4 node (a4bf0190574b.jf.intel.com)
---------------------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/gca/cdrhee/dpcpp_and_esimd_version_very_large_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh

787 machine (10.45.77.116)
----------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/cdrhee/workspace/dpcpp_and_esimd_version_very_large_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh


/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

