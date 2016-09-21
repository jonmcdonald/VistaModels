#!/bin/bash

export SW_ROOT=$(dirname $0)/..

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/boot-wrapper

make clean

make LINUX_TREE=../packages/linux-$VER_LINUX KERNEL_SRC=../packages/linux-$VER_LINUX/arch/arm/boot/uImage

#make LINUX_TREE=/mnt/store/data/platforms/linux-mel-3.10.45-mel-fsl-imx6q-1 KERNEL_SRC=/mnt/store/data/platforms/linux-mel-3.10.45-mel-fsl-imx6q-1/arch/arm/boot/uImage

#make LINUX_TREE=/mnt/store/data/platforms/linux-mel-3.10.45-mel-fsl-imx6q-1 KERNEL_SRC=/tmp/uImage

rm -f vmlinux
ln -s ../packages/linux-$VER_LINUX/vmlinux .

