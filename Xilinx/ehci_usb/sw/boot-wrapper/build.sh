#!/bin/sh

LINUX=$1
FILESYSTEM=$2

if [ -z "$LINUX" ]; then
  echo "Usage: $0 LINUX-TREE [FILESYSTEM]"
  exit 1
fi

if [ -z "$FILESYSTEM" ]; then
  if [ ! -f arm_ramdisk.image.gz ]; then
    wget "http://www.wiki.xilinx.com/file/view/arm_ramdisk.image.gz/419243558/arm_ramdisk.image.gz"
  fi
  FILESYSTEM=arm_ramdisk.image.gz
fi

$LINUX/scripts/dtc/dtc -o blob.dtb -O dtb dts/zynq-zc702-base-trd.dts
cat $LINUX/arch/arm/boot/zImage blob.dtb | dd of=zImage bs=4 conv=sync

make clean
make FILESYSTEM=$FILESYSTEM CROSS_COMPILE=$CROSS_COMPILE
