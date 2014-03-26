#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

mkdir -p $SW_ROOT/packages/sysroot/lib/pkgconfig
echo "prefix=/mnt/store/data/VistaModels/ARM/linux_qt_a9/sw/packages/release/libpthread-stubs-0.1
exec_prefix=${prefix}
libdir=${exec_prefix}/lib

Name: pthread stubs
Description: Stubs missing from libc for standard pthread functions
Version: 0.1
Libs: 
" > $SW_ROOT/packages/sysroot/lib/pkgconfig/pthread-stubs.pc

export PKG_CONFIG_PATH=$SW_ROOT/packages/sysroot/lib/pkgconfig

cd $SW_ROOT/packages/libdrm-$VER_DRM
./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/sysroot --with-kernel-source=$SW_ROOT/packages/linux-$VER_LINUX --disable-libkms --disable-vmwgfx --disable-radeon --disable-nouveau
make -j 15
make install

