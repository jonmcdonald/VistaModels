#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

export PKG_CONFIG_PATH=$SW_ROOT/packages/sysroot/lib/pkgconfig

cd $SW_ROOT/packages/openssh-$VER_OPENSSH
./configure --target=arm-none-linux-gnueabi --host=arm-none-linux-gnueabi -prefix $SW_ROOT/packages/sysroot --with-zlib=$SW_ROOT/packages/zlib-$VER_ZLIB --with-ssl-dir=$SW_ROOT/packages/openssl-$VER_OPENSSL --disable-strip

make -j 15 sftp-server


