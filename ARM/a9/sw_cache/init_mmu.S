
        .section .text

        .globl enable_mmu
	.type	enable_mmu, %function

        .globl clean_dcache_mva
	.type	clean_dcache_mva, %function
        
enable_mmu:

  PUSH {r4}
        
  MOV   r4,#0x0
  MCR   p15, 0, r4, c2, c0, 2 // Write Translation Table Base Control Register
  MCR   p15, 0, r0, c2, c0, 0 // Write Translation Table Base Register 0

  // Set all Domains to Client
  MRC   p15, 0, r4, c3, c0, 0 // Read Domain Access Control Register
  LDR   r4, =0x55555555
  MCR   p15, 0, r4, c3, c0, 0 // Write Domain Access Control Register

  MRC p15, 0, r0, c1, c0, 0 /* Read SCTLR */
  orr	r0, r0, #0x1000
  orr	r0, r0, #0x4
  orr	r0, r0, #0x1
  MCR p15, 0, r0, c1, c0, 0 /* Write SCTLR */
        
  MRC p15, 0,r0, c1, c0, 1 // Read ACTLR
  orr	r0, r0, #0x2
  MCR p15, 0,r0, c1, c0, 1 // Write ACTLR

  POP {r4}
  BX  lr


clean_dcache_mva:
   MCR p15, 0, r0, c7, c10, 1
   BX  lr  
