#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/openssl-$VER_OPENSSL

export cross=arm-none-linux-gnueabi-
./Configure dist --prefix=$SW_ROOT/sdcard/sysroot
make CC="${cross}gcc" AR="${cross}ar r" RANLIB="${cross}ranlib"
make install

