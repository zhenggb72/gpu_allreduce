
daniel's New step
------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/gca/cdrhee/dpcpp_and_esimd_version_very_medium_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh

/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

787 machine (10.45.77.116) cdrhee/Intel@123
----------------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/cdrhee/workspace/dpcpp_and_esimd_version_medium_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh
#export ZEX_NUMBER_OF_CCS=0:4,1:4,2:4,3:4

/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

