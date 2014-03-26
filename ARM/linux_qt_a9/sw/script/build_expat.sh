#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

export PKG_CONFIG_PATH=$SW_ROOT/packages/sysroot/lib/pkgconfig

cd $SW_ROOT/packages/expat-$VER_EXPAT
./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/sysroot
make -j 15
make install

cp $SW_ROOT/packages/sysroot/lib/pkgconfig/expat.pc $SW_ROOT/packages/sysroot/lib/pkgconfig/EXPAT.pc
