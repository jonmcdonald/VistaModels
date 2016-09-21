#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/commtests

make

export SYSROOT=$SW_ROOT/sdcard/sysroot

cp gpiotest $SYSROOT/root
cp i2ctest $SYSROOT/root
cp spitest $SYSROOT/root
cp client $SYSROOT/root
cp server $SYSROOT/root
