# Makefile - build a kernel+filesystem image for stand-alone Linux booting
#
# Copyright (C) 2011 ARM Limited. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.txt file.

LINUX ?= /home/jon/work/xilinx/linux-xlnx
FILESYSTEM ?= arm_ramdisk.image.gz

ZYNQBL		= ../../../zynq/Software/boot-wrapper
BOOTLOADER	= $(ZYNQBL)/boot.S
KERNEL		= $(ZYNQBL)/zImage
KERNEL_HDR_SZ	= 0x0	# 0x40 for uImage
FILESYSTEM	= filesystem.cpio.gz

IMAGE		= linux-system.axf
LD_SCRIPT	= $(ZYNQBL)/model.lds.S

CROSS_COMPILE	= arm-none-eabi-

CC		= $(CROSS_COMPILE)gcc -g
LD		= $(CROSS_COMPILE)ld

CPPFLAGS	+= -DKERNEL=$(KERNEL)
CPPFLAGS	+= -DKERNEL_HDR_SZ=$(KERNEL_HDR_SZ)
CPPFLAGS	+= -DFILESYSTEM=\"$(FILESYSTEM)\"

CPPFLAGS	+= -DUSE_INITRD

CPPFLAGS	+= -DSMP
CPPFLAGS	+= -march=armv7-a

# MPS (Cortex-M3) definitions
#CPPFLAGS	+= -DCORTEX_M
#CPPFLAGS	+= -DMACH_MPS
#CPPFLAGS	+= -march=armv7-m
#CPPFLAGS	+= -mthumb -Wa,-mthumb -Wa,-mimplicit-it=always

all: $(IMAGE)

clean:
	rm -f boot.o model.lds zImage

$(IMAGE): boot.o model.lds $(KERNEL) $(FILESYSTEM)
	$(LD) -o $@ --script=model.lds

boot.o: $(BOOTLOADER)
	$(CC) $(CPPFLAGS) -c -o $@ $<

model.lds: $(LD_SCRIPT)
	$(CC) $(CPPFLAGS) -E -P -C -o $@ $<

mount: arm_ramdisk.image mnt
	if [ ! -d mnt/bin ]; then sudo mount -o loop,rw,offset=0 arm_ramdisk.image mnt; fi

mnt:
	mkdir mnt

arm_ramdisk.image:
	gzip -d arm_ramdisk.image.gz

umount:
	sudo umount mnt
	gzip arm_ramdisk.image
	build.sh $(LINUX)

update: mount ../../../module-peripheral/peripheral_driver.ko
	sudo cp ../../../module-peripheral/peripheral_driver.ko mnt/lib/modules/3.6.0
	sudo umount mnt
	gzip arm_ramdisk.image
	build.sh $(LINUX)

build:
	build.sh $(LINUX)

arm_ramdisk.image.gz:
	wget http://www.wiki.xilinx.com/file/view/arm_ramdisk.image.gz
