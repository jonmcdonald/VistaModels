/*
 * boot.S - simple register setup code for stand-alone Linux booting
 *
 * Copyright (C) 2011 ARM Limited. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE.txt file.
 */

	.syntax	unified
	.arch_extension sec
	.text

	.globl	_start
_start:
	@
	@ CPU initialisation
	@
	mrc	p15, 0, r0, c0, c0, 5		@ MPIDR (ARMv7 only)
	and	r0, r0, #15			@ CPU number
	cmp	r0, #0				@ primary CPU?
	beq	2f

	@
	@ Secondary CPUs (should follow the iMX boot protocol. Depends on SRC module.)
	@ Currently not running
1:
	wfe
	b	1b

2:
	@
	@ UART initialisation (115200 8N1)
	@
@	uart
	ldr	r0, =0x02020000			@ UART1 base
@	ldr	r0, =0x021E8000			@ UART2 base
	ldr	r10, =0x021E8000			@ UART2 base
#if 0
@
@       refclk = 96MHz,
@       UFCR.RFDIV = 0 after reset (div = 6) =>
@	uartclk = 16MHz
	mov	r1, #(115200/100)
	ldr	r2, =(16000000/16/100)
	sub	r1, r1, #1
	sub	r2, r2, #1	
	str	r1, [r0, #0xa4]     @ UBIR
	str	r2, [r0, #0xa8]     @ UBMR
@ 8N1 :	 8 - UCR2.WS N - UCR2.PREN 1 -  UCR2.STPB
	ldr	r1, [r0, #0x84]     @ UCR2
	bic	r1, #((1<<8) | (1<<6)) @ UCR2.PREN | UCR2.STPB
	orr	r1, r1, #(1<<5)     @ UCR2.WS
	orr	r1, r1, #(1<<14)    @ UCR2.IRTS
	orr	r1, r1, #(1<<2)     @ UCR2.TXEN

	ldr	r2, [r0, #0x80] @ UCR1
	orr	r2, r2, #((1<<0) | (1<<2)) @ UCR1.UARTEN | UCR1.UARTCLKEN

	str	r2, [r0, #0x80]
	str	r1, [r0, #0x84]
#endif
	@
	@ Kernel parameters
	@
	mov	r0, #0

	ldr	r1, =4307 @ MX6SL_EVK

        ldr	r2, =dtb
	mov	r3, #0
	ldr	lr, =kernel
	mov     pc, lr				@ jump to the kernel
