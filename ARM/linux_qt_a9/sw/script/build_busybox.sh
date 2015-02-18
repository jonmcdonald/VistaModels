#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/busybox-$VER_BUSYBOX

make defconfig

make -j 15

export SYSROOT=$SW_ROOT/sdcard/sysroot
make install CONFIG_PREFIX=$SYSROOT

