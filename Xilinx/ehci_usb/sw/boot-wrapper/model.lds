/*
 * model.lds.S - simple linker script for stand-alone Linux booting
 *
 * Copyright (C) 2011 ARM Limited. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE.txt file.
 */
OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
TARGET(binary)
INPUT(./boot.o)
INPUT(./zImage)
INPUT("arm_ramdisk.image.gz")
PHYS_OFFSET = 0x10000000;
SECTIONS
{
 . = PHYS_OFFSET;
 .text : { boot.o }
 . = PHYS_OFFSET + 0x8000 - 0x0;
 kernel = . + 0x0;
 .kernel : { ./zImage }
 . = . + 0x2000000;
 filesystem = .;
 .filesystem : { "arm_ramdisk.image.gz" }
 fs_size = . - filesystem;
 .data : { *(.data) }
 .bss : { *(.bss) }
}
