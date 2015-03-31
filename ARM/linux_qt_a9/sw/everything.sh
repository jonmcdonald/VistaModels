#!/bin/bash

./script/fetch.sh

./script/build_sysroot.sh

./script/build_kernel.sh
./script/build_modules.sh
./script/build_busybox.sh
./script/build_dropbear.sh
./script/build_zlib.sh
./script/build_ssl.sh
./script/build_openssh.sh
./script/build_qt.sh 
./script/build_watch.sh 

./script/build_sdcard.sh

./script/build_axf.sh

