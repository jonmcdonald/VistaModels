# Makefile - build a kernel+filesystem image for stand-alone Linux booting
#
# Copyright (C) 2011 ARM Limited. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.txt file.

BOOTLOADER	= boot.S
KERNEL		= zImage
KERNEL_HDR_SZ	= 0x0	# 0x40 for uImage
FILESYSTEM	= filesystem.cpio.gz

IMAGE		= linux-system.axf
LD_SCRIPT	= model.lds.S

CROSS_COMPILE	= arm-linux-gnueabi-

CC		= $(CROSS_COMPILE)gcc -g
LD		= $(CROSS_COMPILE)ld

CPPFLAGS	+= -DKERNEL=$(KERNEL)
CPPFLAGS	+= -DKERNEL_HDR_SZ=$(KERNEL_HDR_SZ)
CPPFLAGS	+= -DFILESYSTEM=$(FILESYSTEM)

CPPFLAGS	+= -DUSE_INITRD
CPPFLAGS	+= -march=armv7-a

all: $(IMAGE)

clean:
	rm -f $(IMAGE) boot.o model.lds zImage

$(IMAGE): boot.o model.lds $(KERNEL) $(FILESYSTEM)
	$(LD) -o $@ --script=model.lds

boot.o: $(BOOTLOADER)
	$(CC) $(CPPFLAGS) -c -o $@ $<

model.lds: $(LD_SCRIPT)
	$(CC) $(CPPFLAGS) -E -P -C -o $@ $<
