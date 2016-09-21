#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/packages/dropbear-$VER_DROPBEAR

CC=$TARGET-gcc ./configure --host=$TARGET --disable-zlib 

CC=$TARGET-gcc make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

export SYSROOT=$SW_ROOT/sdcard/sysroot
cp dropbear $SYSROOT/sbin
cp dbclient $SYSROOT/sbin
cp dropbearkey $SYSROOT/sbin
cp scp $SYSROOT/bin

