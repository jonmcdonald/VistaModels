#!/bin/sh

LINUX=../linux-$VER_LINUX
PLATFORM=A7
FILESYSTEM=$1

if [ -z "$FILESYSTEM" ]; then
  FILESYSTEM=small_vts.cpio.gz
fi

make clean PLATFORM=$PLATFORM

mkdir -p $PLATFORM
cat $LINUX/arch/arm/boot/zImage $LINUX/arch/arm/boot/dts/vista.dtb | dd of=$PLATFORM/zImage bs=4 conv=sync
 
make PLATFORM=$PLATFORM FILESYSTEM=$FILESYSTEM CROSS_COMPILE=$CROSS_COMPILE
