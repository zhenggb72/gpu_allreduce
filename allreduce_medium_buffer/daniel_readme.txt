
daniel's New step
------------------
ssh connect
sudo su     #might be required
source /opt/intel/oneapi/setvars.sh
cd /home/gca/cdrhee/dpcpp_and_esimd_version_very_large_buf
bash ./daniel_build_run.sh
bash ./daniel_run.sh

/home/gca/cdrhee/pti-gpu/tools/onetrace/build/onetrace --chrome-call-logging --chrome-device-timeline --demangle --kernels-per-tile ./daniel_build_run.sh

