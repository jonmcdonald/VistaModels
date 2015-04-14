#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_apps.sh

cd $SW_ROOT/cluster
make -f Makefile.arm

export SYSROOT=$SW_ROOT/sdcard/sysroot
cp cluster $SYSROOT/root

