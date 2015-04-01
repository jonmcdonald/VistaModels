/*
 * boot.S - simple register setup code for stand-alone Linux booting
 *
 * Copyright (C) 2011 ARM Limited. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE.txt file.
 */

	.syntax	unified
	.text

	.globl	_start
_start:
#ifdef SMP
	@
	@ Program architected timer frequency
	@
	mrc	p15, 0, r0, c0, c1, 1		@ CPUID_EXT_PFR1
	lsr	r0, r0, #16
	ands	r0, r0, #1			@ Check generic timer support
	beq	1f
	ldr	r0, =24000000			@ 24MHz timer frequency
	mcr	p15, 0, r0, c14, c0, 0		@ CNTFRQ
1:
	@
	@ CPU initialisation
	@
	mrc	p15, 0, r0, c0, c0, 5		@ MPIDR (ARMv7 only)
	and	r0, r0, #15			@ CPU number
	cmp	r0, #0				@ primary CPU?
	beq	2f

	@
	@ Secondary CPUs (following the RealView SMP booting protocol)
	@
	ldr	r0, =0				
	mov	pc, r1				
1:
	wfe
	ldr	r1, [r0]
	cmp	r1, #0
	beq	1b
	mov	pc, r1				@ branch to the given address
#endif

	@
	@ UART initialisation (38400 8N1)
	@
2:
        ldr r0, =0xe0001000
        ldr r1, [r0, #0]
        orr r1, #(1 << 4)
        and r1, #~(1 << 5)
        str r1, [r0, #0]

	@
	@ Kernel parameters
	@
	mov	r0, #0
	ldr	r1, =2272			@ Not used
	adr	r2, atags
	mov	r3, #0
	ldr	lr, =kernel
	mov     pc, lr				@ jump to the kernel

	.org	0x100
atags:
	@ ATAG_CORE
	.long	2
	.long	0x54410001

	@ ATAG_CMDLINE
	.long	(1f - .) >> 2
	.long	0x54410009
        .asciz  "rdinit=/linuxrc console=ttyPS0 mem=512M@0x0 earlyprintk";
	.align	2
1:

#ifdef USE_INITRD
	@ ATAG_INITRD2
	.long	4
	.long	0x54420005
	.long	filesystem
	.long	fs_size
#endif

	@ ATAG_NONE
	.long	0
	.long	0x00000000
