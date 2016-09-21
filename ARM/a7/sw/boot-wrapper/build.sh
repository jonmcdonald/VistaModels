#!/bin/sh

LINUX=../linux-$VER_LINUX
PLATFORM=A7

make clean PLATFORM=$PLATFORM

mkdir -p $PLATFORM
cat $LINUX/arch/arm/boot/zImage $LINUX/arch/arm/boot/dts/vista.dtb | dd of=$PLATFORM/zImage bs=4 conv=sync
 
make PLATFORM=$PLATFORM CROSS_COMPILE=$CROSS_COMPILE
