/*
 * assembly.s
 *
 *  Created on: 22 Sep 2016
 *      Author: jonm
 */

	.section .cs3.reset,"ax",%progbits
	.global __cs3_reset

__cs3_reset:
	bl get_core_id
	cmp r0,#0
	beq 2f

loop:
	wfi
	b loop

    .global get_core_id
    .type get_core_id, %function
get_core_id:
    mrc		p15, 0, r0, c0, c0, 5		@ MPIDR (ARMv7 only)
    and		r0, r0, #15			@ CPU number
    bx		lr

2:
	b __cs3_reset_base_ram
