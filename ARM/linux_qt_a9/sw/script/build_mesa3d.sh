#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

export PATH=$SW_ROOT/tools/build/bin\:$PATH

export PKG_CONFIG_PATH=$SW_ROOT/packages/sysroot/lib/pkgconfig

cd $SW_ROOT/packages/Mesa-$VER_MESA3D
./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/sysroot --disable-dri3 --enable-egl --enable-gles1 --enable-gles2 --with-egl-platforms=fbdev --with-dri-drivers="" --enable-glx=no --with-gallium-drivers="swrast" --enable-gallium-egl 
make -j 15
make install

