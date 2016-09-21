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

/* INPUT(./monitor.o) */
INPUT(./boot.o)
INPUT(./uImage)
INPUT(./imx6q-sabrelite.dtb)
#ifdef USE_INITRD
 INPUT(./filesystem.cpio.gz)
#endif




PHYS_OFFSET = 0x10000000;

SECTIONS
{
 . = PHYS_OFFSET;
 .text : { boot.o }

 . = PHYS_OFFSET + 0x8000 - 0x40;
 kernel = . + 0x40;
 .kernel : { ./uImage }

#ifdef USE_INITRD
 . = PHYS_OFFSET + 0x00800000;
 filesystem = .;
 .filesystem : { ./filesystem.cpio.gz }
 fs_size = . - filesystem;
#endif

 . = PHYS_OFFSET + 0x10000000; 
 dtb = .;
 .dtb : { ./imx6q-sabrelite.dtb }

 .data : { *(.data) }
 .bss : { *(.bss) }

}
