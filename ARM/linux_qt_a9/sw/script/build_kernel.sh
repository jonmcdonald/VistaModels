#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/packages/linux-$VER_LINUX

patch -p1 < ../../kernel_patches/lcd.patch

patch -p1 < ../../kernel_patches/ehci.patch

patch -p1 < ../../kernel_patches/vista.patch

make vista_defconfig

make -j 20

