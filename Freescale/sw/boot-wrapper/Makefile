# Makefile - build a kernel+filesystem image for stand-alone Linux booting
#
# Copyright (C) 2011 ARM Limited. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.txt file.

CPPFLAGS	+= -DSMP
#CPPFLAGS	+= -DUSE_INITRD
#CPPFLAGS	+= -DTHUMB2_KERNEL
CPPFLAGS	+= -march=armv7-a

BOOTLOADER	= boot.S
ifneq ($(IMXMEL),)
KERNEL_SRC ?= $(IMXMEL)/uImage
else
KERNEL_SRC ?= $(LINUX_TREE)/arch/arm/boot/uImage
endif

KERNEL		= uImage
FILESYSTEM	= 

DTS             = dts/imx6q-sabrelite_MEL13.dts
#DTS             = dts/imx6q-sabrelite.dts
#DTB             = imx6q-sabrelite.dtb
DTB             = ../packages/linux-$(VER_LINUX)/arch/arm/boot/dts/imx6q-vista.dtb

IMAGE		= linux-imx6.elf
LD_SCRIPT	= model.lds.S

CROSS_COMPILE	?= arm-unknown-eabi-

CC		= $(CROSS_COMPILE)gcc
LD		= $(CROSS_COMPILE)ld

all: $(IMAGE)

clean:
	rm -f $(IMAGE) boot.o model.lds uImage $(DTB)

$(DTB): $(DTS)
	$(LINUX_TREE)/scripts/dtc/dtc -O dtb -I dts -o $@ $^

$(KERNEL): $(KERNEL_SRC)
	if [ `od -A n -t x4 -N 4 $<` = 56190527 ]; then \
	   cp $< $@; \
	else \
	   head -c 64 /dev/zero | cat - $(KERNEL_SRC) >$@; \
	fi


$(IMAGE): boot.o model.lds $(KERNEL) $(FILESYSTEM) $(DTB) Makefile
	$(LD) -o $@ --script=model.lds

boot.o: $(BOOTLOADER)
	$(CC) $(CPPFLAGS) -c -o $@ $<

monitor.o: $(MONITOR)
	$(CC) $(CPPFLAGS) -c -o $@ $<

model.lds: $(LD_SCRIPT) Makefile
	$(CC) $(CPPFLAGS) -E -P -C -o $@ $<

.PHONY: all clean
