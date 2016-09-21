#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/packages/linux-$VER_LINUX

make imx_v6_v7_defconfig
#echo "CONFIG_DEBUG_INFO=y" >> .config

make -j 20
make uImage LOADADDR=0x10008000

export SYSROOT=$SW_ROOT/sdcard/sysroot
make headers_install INSTALL_HDR_PATH=$SYSROOT/usr
make INSTALL_MOD_PATH=$SYSROOT modules_install

