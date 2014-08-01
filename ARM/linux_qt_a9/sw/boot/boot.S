
	.syntax	unified
	.text

	.globl	_start
_start:
	mrc	p15, 0, r0, c0, c1, 1		@ CPUID_EXT_PFR1
	lsr	r0, r0, #16
	ands	r0, r0, #1			@ Check generic timer support
	beq	1f
	ldr	r0, =24000000			@ 24MHz timer frequency
	mcr	p15, 0, r0, c14, c0, 0		@ CNTFRQ
1:

	mrc	p15, 0, r0, c0, c0, 5		@ MPIDR (ARMv7 only)
	and	r0, r0, #15			@ CPU number
	cmp	r0, #0				@ primary CPU?
	beq	2f

	ldr	r1, =filesystem - 0x100
	adr	r2, 1f
	ldmia	r2, {r3 - r7}			@ move the code to a location
	stmia	r1, {r3 - r7}			@ less likely to be overridden

//	ldr	r0, =0x10000030			@ RealView SYS_FLAGS register

	mov	pc, r1				@ branch to the relocated code
1:
	wfe
	ldr	r1, [r0]
	cmp	r1, #0
	beq	1b
	mov	pc, r1				@ branch to the given address


2:
	ldr	r0, =0x10000000			@ UART base 
	mov	r1, #0x10			@ ibrd
	str	r1, [r0, #0x24]
	mov	r1, #0xc300
	orr	r1, #0x0001			@ cr
	str	r1, [r0, #0x30]

	mov	r0, #0				@ CPU arch ID
	ldr	r1, =4576			@ Vista

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

	.asciz	"console=ttyAMA0 rdinit=/linuxrc mem=512M earlyprintk verbose debug ignore_loglevel coherent_pool=4M" 
	.align	2
1:
	@ ATAG_INITRD2
	.long	4
	.long	0x54420005
	.long	filesystem
	.long	fs_size

	@ ATAG_NONE
	.long	0
	.long	0x00000000
