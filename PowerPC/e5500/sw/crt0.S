#include "reg_defs.h"

//#define STACK_TOP (0x20000000-1024)


        .weak mcp_isr
        .weak int_isr
        .weak exception_isr
        .weak smi_isr

.global _start
_start:
	b system_reset_code

// system_reset unrecoverable
rst_entry:
	ba	system_reset_code
rst_end:
// mcp vector at 0x0200
mcp_entry:
	stwu	r1, -136(r1)
	stw	r0, 16(r1)
	mflr	r0
	stw	r0, 140(r1)
	mfcr	r0
	stw	r0, 12(r1)
	stmw	r3, 20(r1)
	bla	mcp_isr
	lmw     r3, 20(r1)
	lwz	r0, 12(r1)
	mtcr	r0
	lwz	r0, 140(r1)
	mtlr	r0
	lwz	r0, 16(r1)
	addi	r1, r1, 136
	rfi
mcp_end:

// int vector at 0x0500
int_entry:
	stwu	r1, -136(r1)
	stw	r0, 16(r1)
	mflr	r0
	stw	r0, 140(r1)
	mfcr	r0
	stw	r0, 12(r1)
	stmw	r3, 20(r1)
	bla	int_isr
	lmw     r3, 20(r1)
	lwz	r0, 12(r1)
	mtcr	r0
	lwz	r0, 140(r1)
	mtlr	r0
	lwz	r0, 16(r1)
	addi	r1, r1, 136
	rfi
int_end:

// exception handler at 0x0700
exc_entry:
	stwu	r1, -136(r1)
	stw	r0, 16(r1)
	mflr	r0
	stw	r0, 140(r1)
	mfcr	r0
	stw	r0, 12(r1)
	stmw	r3, 20(r1)
	bla	exception_isr
	lmw     r3, 20(r1)
	lwz	r0, 12(r1)
	mtcr	r0
	lwz	r0, 140(r1)
	mtlr	r0
	lwz	r0, 16(r1)
	addi	r1, r1, 136
	rfi
exc_end:

// smi vector at 0x1400
smi_entry:
	stwu	r1, -136(r1)
	stw	r0, 16(r1)
	mflr	r0
	stw	r0, 140(r1)
	mfcr	r0
	stw	r0, 12(r1)
	stmw	r3, 20(r1)
	bla	smi_isr
	lmw     r3, 20(r1)
	lwz	r0, 12(r1)
	mtcr	r0
	lwz	r0, 140(r1)
	mtlr	r0
	lwz	r0, 16(r1)
	addi	r1, r1, 136
	rfi
smi_end:

system_reset_code:
	addis	r0,0,0x0000
	// Invalidate them all to avoid error states
#ifndef PPC440
       	mtspr	ibat0u,r0
	mtspr	ibat1u,r0
	mtspr	ibat2u,r0
	mtspr	ibat3u,r0
	isync
	mtspr	dbat0u,r0
	mtspr	dbat1u,r0
	mtspr	dbat2u,r0
	mtspr	dbat3u,r0
	isync
#endif
	bl set_isr
	isync

	// Set up stack pointer for the user application
//	addis	r1,0,stack_top@h
//	ori	r1,r1,stack_top@l

	addis	r1,0,__stack@h
	ori	r1,r1,__stack@l

                
	// make sure the word the stack pointer points to is NULL
//	addis	r14,r0,0x0000
//	stw	r14,0(r1)

        addis	r14,r0,0x0000
	stw	r14,0(r1)

#if 1
	addis	r3,0,main@h
	ori	r3,r3,main@l
	mtspr	srr0,r3

	// Set the MSR.
	// we just move the value into srr1 - it will get copied into
	// the msr upon the rfi.
	addis	r4,0,0x0000
	ori	r4,r4,0xb900    // turn on EE, fp, enable fp & machine check exceptions
	// Put r4 into srr1 so it gets copied into the msr on rfi
	mtspr	srr1,r4

	// let's put something in the link register
	addis	r3,0,error@h
	ori	r3,r3,error@l
	mtlr	r3

	// go to the C code
	rfi
#else
	addis	r4,0,0x0000
	ori	r4,r4,0xb900    // turn on EE, fp, enable fp & machine check exceptions
	mtmsr	r4

	bl	main
	b	error
#endif

#define COPY_CODE		\
	mtctr	r4;		\
1:	lwzx	r8,0,r3;	\
	stwx	r8,0,r5;	\
	addi	r3, r3, 4;	\
	addi	r5, r5,	4;	\
	bdnz	1b;

// Function:	set_isr
set_isr:
	addis	r3,0,rst_entry@h
	ori	r3,r3,rst_entry@l
	addi	r4,0,(rst_end - rst_entry)>>2
	addi	r5,0,0x100
	COPY_CODE

	addis	r3,0,mcp_entry@h
	ori	r3,r3,mcp_entry@l
	addi	r4,0,(mcp_end-mcp_entry)>>2
	addi	r5,0,0x200
	COPY_CODE

	addis	r3,0,int_entry@h
	ori	r3,r3,int_entry@l
	addi	r4,0,(int_end-int_entry)>>2
	addi	r5,0,0x500
	COPY_CODE

	addis	r3,0,exc_entry@h
	ori	r3,r3,exc_entry@l
	addi	r4,0,(exc_end-exc_entry)>>2
	addi	r5,0,0x700
	COPY_CODE

	addis	r3,0,smi_entry@h
	ori	r3,r3,smi_entry@l
	addi	r4,0,(smi_end-smi_entry)>>2
	addi	r5,0,0x1400
	COPY_CODE

#ifdef PPC440
        addis	r4,0,0x0000
        mtivpr  r4
        ori     r4, r4, 0x500
        mtivor4 r4
#endif
	blr

error:
	b	error

.global dcr_read
dcr_read:
        mfdcrx  r3, r3
        blr

.global dcr_write
dcr_write:
        mtdcrx  r3, r4
        blr

//.space  4096
//stack_top:
//.space 36
        
                      
