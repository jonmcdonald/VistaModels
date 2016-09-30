/*
 * assembly.s
 *
 *  Created on: 22 Sep 2016
 *      Author: markca
 */


    .global get_core_id
    .type get_core_id, %function
get_core_id:
    mrc		p15, 0, r0, c0, c0, 5		@ MPIDR (ARMv7 only)
    and		r0, r0, #15			@ CPU number
    bx		lr
