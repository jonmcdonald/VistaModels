#!/bin/bash

./script/fetch.sh
./script/build_kernel.sh
./script/build_busybox.sh
./script/build_dropbear.sh
./script/build_ssl.sh
./script/build_zlib.sh
./script/build_sftp.sh
./script/build_tools.sh     
./script/build_drm.sh 
./script/build_expat.sh 
./script/build_mesa3d.sh
./script/build_gears.sh 
#./script/build_sdl.sh 
./script/build_modules.sh

if [ "$VER_QT_MAJOR" == "4.8" ]; then
	./script/build_qt.sh 
fi

./script/build_ramdisk.sh
./script/build_axf.sh

