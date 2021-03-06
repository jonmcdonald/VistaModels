#!/bin/bash

export SW_ROOT=$(dirname $0)/..

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/boot

make clean

cat ../packages/linux-$VER_LINUX/arch/arm/boot/zImage ../packages/linux-$VER_LINUX/arch/arm/boot/dts/vista.dtb | dd of=zImage bs=4 conv=sync

make CROSS_COMPILE=$CROSS_COMPILE

rm -f vmlinux
ln -s ../packages/linux-$VER_LINUX/vmlinux .

