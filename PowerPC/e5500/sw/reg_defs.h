/*
 * reg_defs.h
 *
 * This file contains defines for the register names as well as bit definitions
 * for the BATs and the L2CR 
 *
 */

/* define names for stuff to make the asm easier to read  - some compilers don't
  have this built in */
#define r0 0
#define r1 1
#define r2 2
#define r3 3
#define r4 4
#define r5 5
#define r6 6
#define r7 7
#define r8 8
#define r9 9
#define r13 13
#define r14 14
#define hid0  1008
#define srr1 27
#define srr0 26
#define	ibat0u 528
#define	ibat0l 529
#define	ibat1u 530
#define	ibat1l 531
#define	ibat2u 532
#define	ibat2l 533
#define	ibat3u 534
#define	ibat3l 535
#define	dbat0u 536
#define	dbat0l 537
#define	dbat1u 538
#define	dbat1l 539
#define	dbat2u 540
#define	dbat2l 541
#define	dbat3u 542
#define	dbat3l 543
#define	pvr 287
#define l2cr 1017

/* general BAT defines for bit settings to compose BAT regs */
/* represent all the different block lengths */
/* The BL field	is part of the Upper Bat Register */
#define BAT_BL_128K		0x00000000
#define BAT_BL_256K		0x00000004
#define BAT_BL_512K		0x0000000c
#define BAT_BL_1M		0x0000001c
#define BAT_BL_2M		0x0000003c
#define BAT_BL_4M		0x0000007c
#define BAT_BL_8M		0x000000fc
#define BAT_BL_16M		0x000001fc
#define BAT_BL_32M		0x000003fc
#define BAT_BL_64M		0x000007fc
#define BAT_BL_128M		0x00000ffc
#define BAT_BL_256M		0x00001ffc

/* supervisor/user valid mode definitions  - Upper BAT*/
#define BAT_VALID_SUPERVISOR	0x00000002
#define BAT_VALID_USER		0x00000001
#define BAT_INVALID		0x00000000

/* WIMG bit settings  - Lower BAT */
#define BAT_WRITE_THROUGH	0x00000040
#define	BAT_CACHE_INHIBITED	0x00000020
#define BAT_COHERENT		0x00000010
#define BAT_GUARDED		0x00000008					

/* Protection bits - Lower BAT */
#define BAT_NO_ACCESS		0x00000000
#define BAT_READ_ONLY		0x00000001
#define BAT_READ_WRITE		0x00000002		

/* Bit defines for the L2CR register */
#define L2CR_L2E          0x80000000 /* bit 0 - enable */
#define L2CR_L2PE         0x40000000 /* bit 1 - data parity */
#define L2CR_L2SIZ_2M	  0x00000000 /* bits 2-3 2 MB; MPC7400 ONLY! */
#define L2CR_L2SIZ_1M     0x30000000 /* bits 2-3 1MB */
#define L2CR_L2SIZ_HM     0x20000000 /* bits 2-3 512K */
#define L2CR_L2SIZ_QM     0x10000000 /* bits 2-3 256K; MPC750 ONLY */
#define L2CR_L2CLK_1      0x02000000 /* bits 4-6 Clock Ratio div 1 */
#define L2CR_L2CLK_1_5    0x04000000 /* bits 4-6 Clock Ratio div 1.5 */
#define L2CR_L2CLK_2      0x08000000 /* bits 4-6 Clock Ratio div 2 */
#define L2CR_L2CLK_2_5    0x0a000000 /* bits 4-6 Clock Ratio div 2.5 */
#define L2CR_L2CLK_3      0x0c000000 /* bits 4-6 Clock Ratio div 3 */
#define L2CR_L2RAM_BURST  0x01000000 /* bits 7-8 burst SRAM */
#define L2CR_DO           0x00400000 /* bit 9 Enable caching of instr. in L2 */
#define L2CR_L2I          0x00200000 /* bit 10 Global invalidate bit */
#define L2CR_TS           0x00040000 /* bit 13 Test support on  */
#define L2CR_TS_OFF       ~L2CR_TS   /* bit 13 Test support off */
#define L2CR_L2OH_5       0x00000000 /* bits 14-15 Output Hold time = 0.5ns*/
#define L2CR_L2OH_1       0x00010000 /* bits 14-15 Output Hold time = 1.0ns*/
#define L2CR_L2OH_INV     0x00020000 /* bits 14-15 Output Hold time = 1.0ns*/
