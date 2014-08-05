#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/kernel_modules/linux-module-virtfb
make -C ../../packages/linux-$VER_LINUX M=`pwd`

cd $SW_ROOT/kernel_modules/peripheral_driver
make -C ../../packages/linux-$VER_LINUX M=`pwd`

