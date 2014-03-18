#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/DirectFB-$VER_DIRECTFB

./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi --with-gfxdrivers="none" --with-inputdrivers="keyboard,linuxinput,ps2mouse,serialmouse" --disable-x11 --disable-png --disable-drmkms --prefix $SW_ROOT/packages/dfb-$VER_DIRECTFB

#make -j 15

#make install

