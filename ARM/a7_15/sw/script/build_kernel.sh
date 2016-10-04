#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SW_ROOT="$(dirname "$SCRIPT")"

source $SW_ROOT/setup.sh

source $SW_ROOT/script/setup_kernel.sh

cd $SW_ROOT/linux-$VER_LINUX

if [ ! -f arch/arm/boot/dts/vista.dts ]; then
	sed -i 's/.*CONFIG_ARCH_VEXPRESS.*/dtb-$(CONFIG_ARCH_VISTA) += vista.dtb\n&/' arch/arm/boot/dts/Makefile
	sed -i 's/.*mach-vexpress.*/source \"arch\/arm\/mach-vista\/Kconfig\"\n\n&/' arch/arm/Kconfig
	sed -i 's/.*CONFIG_ARCH_VEXPRESS.*/machine-$(CONFIG_ARCH_VISTA)\t\t+= vista\n&/' arch/arm/Makefile
	echo -e "vista\t\t\tMACH_VISTA\t\tVISTA\t\t\t4576" >> arch/arm/tools/mach-types
	sed -i '/global-timer: non support for this cpu version/,+1 s/^/\/\//' drivers/clocksource/arm_global_timer.c
	sed -i "/.*ocr &= host->ocr_avail*/i return ocr;" drivers/mmc/core/core.c
fi

cp -rv $SW_ROOT/kernel_patches/src/* .

make vista_defconfig

make -j 20

#export SYSROOT=$SW_ROOT/sdcard/sysroot
#make headers_install INSTALL_HDR_PATH=$SYSROOT/usr

