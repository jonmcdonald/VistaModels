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

INPUT(./BOOT_O)
INPUT(./KERNEL)
#ifdef USE_INITRD
INPUT(FILESYSTEM)
#endif

PHYS_OFFSET = 0x80000000;

SECTIONS
{
	. = PHYS_OFFSET;
	.text : { BOOT_O }

	. = PHYS_OFFSET + 0x8000 - KERNEL_HDR_SZ;
	kernel = . + KERNEL_HDR_SZ;
	.kernel : { ./KERNEL }

	. = . + 0x2000000;

#ifdef USE_INITRD
	filesystem = .;
	.filesystem : { FILESYSTEM }
	fs_size = . - filesystem;
#endif

	.data : { *(.data) }
	.bss : { *(.bss) }
}
