#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh
source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/sdcard

rm -f `find . -name "*~" -print`
#rm -rf sysroot

mkdir -p sysroot

export SYSROOT=$SW_ROOT/sdcard/sysroot
mkdir -p $SYSROOT/dev
mkdir -p $SYSROOT/tmp

mkdir -p template/root
cp -r template/* sysroot

cp -ar $TOOL_CHAIN/$TARGET/libc/etc $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/lib $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/sbin $SYSROOT
cp -ar $TOOL_CHAIN/$TARGET/libc/usr $SYSROOT
mkdir -p $SYSROOT/usr/include/c++
cp -ar $TOOL_CHAIN/$TARGET/include/c++/* $SYSROOT/usr/include/c++


