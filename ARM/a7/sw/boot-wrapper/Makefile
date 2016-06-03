# Makefile - build a kernel+filesystem image for stand-alone Linux booting
#
# Copyright (C) 2011 ARM Limited. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.txt file.

PLATFORM        = A9
BOOTLOADER	= boot.S
BOOT_O          = $(PLATFORM)/boot.o
KERNEL		= $(PLATFORM)/zImage
KERNEL_HDR_SZ	= 0x0	# 0x40 for uImage
FILESYSTEM	= filesystem.cpio.gz

IMAGE		= $(PLATFORM)/linux-system.axf
LD_SCRIPT	= model.lds.S

CROSS_COMPILE	= arm-none-eabi-

CC		= $(CROSS_COMPILE)gcc -g
LD		= $(CROSS_COMPILE)ld

CPPFLAGS	+= -DBOOT_O=$(BOOT_O)
CPPFLAGS	+= -DKERNEL=$(KERNEL)
CPPFLAGS	+= -DKERNEL_HDR_SZ=$(KERNEL_HDR_SZ)
CPPFLAGS	+= -DFILESYSTEM=\"$(FILESYSTEM)\"
CPPFLAGS	+= -march=armv7-a


all: $(IMAGE)

clean:
	rm -rf $(IMAGE) $(PLATFORM)

$(IMAGE): $(PLATFORM)/boot.o $(PLATFORM)/model.lds $(KERNEL) $(FILESYSTEM)
	$(LD) -o $@ --script=$(PLATFORM)/model.lds

$(PLATFORM)/boot.o: $(BOOTLOADER)
	mkdir -p $(PLATFORM)
	$(CC) $(CPPFLAGS) -c -o $@ $<

$(PLATFORM)/model.lds: $(LD_SCRIPT)
	mkdir -p $(PLATFORM)
	$(CC) $(CPPFLAGS) -E -P -C -o $@ $<
