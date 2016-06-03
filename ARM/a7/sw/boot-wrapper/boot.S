
	.syntax	unified
	.text

	.globl	_start
_start:
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
	@ Secondary CPUs 
	@
loop:
//	ldr	r0, =0x40000000
//	ldr	r1, [r0]
	wfi
	BAL loop


	@
	@ UART initialisation (38400 8N1)
	@
2:

	ldr	r0, =0x1C090000			@ UART base 
	mov	r1, #0x10			@ ibrd
	str	r1, [r0, #0x24]
	mov	r1, #0xc300
	orr	r1, #0x0001			@ cr
	str	r1, [r0, #0x30]

	@
	@ Kernel parameters
	@
	mov	r0, #0
	ldr	r1, =4576			
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

	.asciz	"console=ttyAMA0 root=/dev/mmcblk0 rw rootwait mem=256M earlyprintk ignore_loglevel" 

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
