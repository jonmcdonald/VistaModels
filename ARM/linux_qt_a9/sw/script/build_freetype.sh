#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

export PKG_CONFIG_PATH=$SW_ROOT/packages/sysroot/lib/pkgconfig

cd $SW_ROOT/packages/freetype-$VER_FREETYPE
./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/sysroot -prefix $SW_ROOT/packages/sysroot --with-zlib=yes ZLIB_CFLAGS=-I$SW_ROOT/packages/sysroot/include ZLIB_LIBS=-L$SW_ROOT/packages/sysroot/lib LIBPNG_CFLAGS=-I$SW_ROOT/packages/sysroot/include LIBPNG_LIBS=-L$SW_ROOT/packages/sysroot/lib
make -j 15 
make install

