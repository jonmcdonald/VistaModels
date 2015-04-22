#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

echo "*** clean.sh cleaning"

cd $SW_ROOT
rm `find . -name "*~" -print`

source $SW_ROOT/script/setup_kernel.sh
cd $SW_ROOT/kernel_modules/bridge_driver
if [ -d ../../packages/linux-$VER_LINUX ]; then
  make -C ../../packages/linux-$VER_LINUX M=`pwd` clean
fi

cd $SW_ROOT/packages
rm -rf linux-$VER_LINUX
rm -rf busybox-$VER_BUSYBOX
rm -rf dropbear-$VER_DROPBEAR
rm -rf zlib-$VER_ZLIB
rm -rf openssl-$VER_OPENSSL
rm -rf openssh-$VER_OPENSSH
rm -rf qt-everywhere-opensource-src-$VER_QT
rm -rf genext2fs-1.4.1

cd $SW_ROOT/sdcard
rm -rf sysroot
rm -f sysroot.ext2

cd $SW_ROOT/boot
make clean

cd $SW_ROOT/cluster
if [ -f Makefile ]; then
  make -f Makefile clean
fi

echo "*** clean.sh COMPLETE"

