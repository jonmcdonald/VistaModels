#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

echo "*** clean.sh cleaning"

cd $SW_ROOT
rm -f `find . -name "*~" -print`

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/packages
rm -rf linux-$VER_LINUX
rm -rf busybox-$VER_BUSYBOX
rm -rf dropbear-$VER_DROPBEAR
rm -rf zlib-$VER_ZLIB
rm -rf openssl-$VER_OPENSSL
rm -rf openssh-$VER_OPENSSH
rm -rf genext2fs-1.4.1

cd $SW_ROOT/sdcard
rm -rf sysroot
rm -f sysroot.ext2

cd $SW_ROOT/boot-wrapper
make clean

echo "*** clean.sh COMPLETE"

