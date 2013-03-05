/**************************************************************************//**
 * @file     VistaCM3.h
 * @brief    CMSIS Cortex-M3 Core Peripheral Access Layer Header File for
 *           Device VistaCM3
 * @version  V3.01
 * @date     19. February 2013
 *
 * @note
 * Copyright (C) 2010-2012 ARM Limited. All rights reserved.
 *
 * @par
 * ARM Limited (ARM) is supplying this software for use with Cortex-M 
 * processor based microcontrollers.  This file can be freely distributed 
 * within development tools that are supporting such ARM based processors. 
 *
 * @par
 * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
 * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 ******************************************************************************/


#ifndef VistaCM3_H      /* MentorGraphics: replaced '<Device>' with VistaCM3 */
#define VistaCM3_H

#ifdef __cplusplus
 extern "C" {
#endif 

/** @addtogroup VistaCM3_Definitions VistaCM3 Definitions
  This file defines all structures and symbols for VistaCM3:
    - registers and bitfields
    - peripheral base address
    - peripheral ID
    - Peripheral definitions
  @{
*/


/******************************************************************************/
/*                Processor and Core Peripherals                              */
/******************************************************************************/
/** @addtogroup VistaCM3_CMSIS Device CMSIS Definitions
  Configuration of the Cortex-M3 Processor and Core Peripherals
  @{
*/

/*
 * ==========================================================================
 * ---------- Interrupt Number Definition -----------------------------------
 * ==========================================================================
 */

typedef enum IRQn
{
/******  Cortex-M3 Processor Exceptions Numbers ***************************************************/

/* Cortex interrupt numbers for CORTEX-M3 / Cortex-M4 devices       */
  NonMaskableInt_IRQn           = -14,      /*!<  2 Non Maskable Interrupt                        */
  MemoryManagement_IRQn         = -12,      /*!<  4 Memory Management Interrupt                   */
  BusFault_IRQn                 = -11,      /*!<  5 Bus Fault Interrupt                           */
  UsageFault_IRQn               = -10,      /*!<  6 Usage Fault Interrupt                         */
  SVCall_IRQn                   = -5,       /*!< 11 SV Call Interrupt                             */
  DebugMonitor_IRQn             = -4,       /*!< 12 Debug Monitor Interrupt                       */
  PendSV_IRQn                   = -2,       /*!< 14 Pend SV Interrupt                             */
  SysTick_IRQn                  = -1,       /*!< 15 System Tick Interrupt                         */

/******  Device Specific Interrupt Numbers ********************************************************/
/* Add here your device specific external interrupt numbers
         according the interrupt handlers defined in startup_Device.s
         eg.: Interrupt for Timer#1       TIM1_IRQHandler   ->   TIM1_IRQn                        */
  SuperFIFO_IRQn        		= 1,        /*!< Device Interrupt                                 */
} IRQn_Type;


/*
 * ==========================================================================
 * ----------- Processor and Core Peripheral Section ------------------------
 * ==========================================================================
 */

/* Configuration of the Cortex-M3 Processor and Core Peripherals */
/* Set the defines according your Device                                                    */
#define __CM3_REV                 0x0201    /*!< Core Revision r2p1                               */
#define __NVIC_PRIO_BITS          2         /*!< Number of Bits used for Priority Levels          */
#define __Vendor_SysTickConfig    0         /*!< Set to 1 if different SysTick Config is used     */
#define __MPU_PRESENT             0         /*!< MPU present or not                               */
#define __FPU_PRESENT             0         /*!< FPU present or not                                */

/*@}*/ /* end of group VistaCM3_CMSIS */


#include <core_cm3.h>                       /* Cortex-M3 processor and core peripherals           */
#include "system_VistaCM3.h"           /* VistaCM3 System  include file                      */


/******************************************************************************/
/*                Device Specific Peripheral registers structures             */
/******************************************************************************/
/** @addtogroup VistaCM3_Peripherals VistaCM3 Peripherals
  VistaCM3 Device Specific Peripheral registers structures
  @{
*/

#if defined ( __CC_ARM   )
#pragma anon_unions
#endif

/* ToDo: add here your device specific peripheral access structure typedefs
         following is an example for a timer                                  */

/*------------- SuperFIFO (FIFO) -----------------------------*/
/** @addtogroup VistaCM3_FIFO VistaCM3 SuperFIFO (FIFO)
  @{
*/
// SuperFIFO
// Top.bus_inst.s1_base_address = 0x40000000
// Top.bus_inst.s1_size         = 0x00000100
// declare_register s d 0x0 {} -rw_access r/w -is_trigger -width 32
// declare_register s status 0x40 {} -rw_access r/w -is_trigger -width 32 -reset_value 0x5
// declare_register s count 0x44 {} -rw_access r/w -width 32 -reset_value 0x0
// declare_register s clrIRQ 0x50 {} -rw_access r/w -is_trigger -width 32

typedef struct
{
  __IO uint32_t Data;                       /*!< Offset: 0x0000   Data Register           */
       uint32_t RESERVED0[60];
  __IO uint32_t Status;                     /*!< Offset: 0x0040   Status Register         */
  __IO uint32_t Count;                      /*!< Offset: 0x0044   Count Register          */
       uint32_t RESERVED1[8];
  __IO uint32_t ClearIRQ;                   /*!< Offset: 0x0050   Clear IRQ Register      */
       uint32_t RESERVED2[172];
} Vista_FIFO_TypeDef;

/*@}*/ /* end of group VistaCM3_FIFO */

/*------------- ExtIn (EXTIN) -----------------------------*/
/** @addtogroup VistaCM3_EXTIN VistaCM3 ExtIn (EXTIN)
  @{
*/
//
// extIn registers:
// Top.bus_inst.s3_base_address = 0x40000200
// Top.bus_inst.s3_size         = 0x00000100
// declare_register a haveData 0x0 {} -rw_access r -width 32
// declare_register a status 0x4 {} -rw_access r/w -width 32


typedef struct
{
  __IO uint32_t haveData;                   /*!< Offset: 0x0000   haveData Register           */
  __IO uint32_t STATUS;                     /*!< Offset: 0x0004   Status Register         */
       uint32_t RESERVED2[248];
} Vista_EXTIN_TypeDef;

/*@}*/ /* end of group VistaCM3_EXTIN */

#if defined ( __CC_ARM   )
#pragma no_anon_unions
#endif

/*@}*/ /* end of group VistaCM3_Peripherals */


/******************************************************************************/
/*                         Peripheral memory map                              */
/******************************************************************************/
/* ToDo: add here your device peripherals base addresses                
         following is an example for timer                                    */
/** @addtogroup VistaCM3_MemoryMap VistaCM3 Memory Mapping
  @{
*/

/* Peripheral and SRAM base address */
#define Vista_FLASH_BASE       (0x00000000UL)                              /*!< (FLASH     ) Base Address */
#define Vista_SRAM_BASE        (0x20000000UL)                              /*!< (SRAM      ) Base Address */
#define Vista_PERIPH_BASE      (0x40000000UL)                              /*!< (Peripheral) Base Address */

/* Peripheral memory map */
#define Vista_FIFO0_BASE         (Vista_PERIPH_BASE)          /*!< (SuperFIFO0    ) Base Address */
#define Vista_FIFO1_BASE         (Vista_PERIPH_BASE + 0x0100) /*!< (SuperFIFO1    ) Base Address */
#define Vista_EXTIN0_BASE	          (Vista_PERIPH_BASE + 0x0200) /*!< (ExtIn0    ) Base Address */
/*@}*/ /* end of group VistaCM3_MemoryMap */


/******************************************************************************/
/*                         Peripheral declaration                             */
/******************************************************************************/
/* ToDo: add here your device peripherals pointer definitions                
         following is an example for timer                                    */

/** @addtogroup VistaCM3_PeripheralDecl VistaCM3 Peripheral Declaration
  @{
*/

#define Vista_FIFO0        ((Vista_FIFO_TypeDef *) Vista_FIFO0_BASE)
#define Vista_FIFO1        ((Vista_FIFO_TypeDef *) Vista_FIFO1_BASE)
#define Vista_ExtIn0	        ((Vista_EXTIN_TypeDef *) Vista_EXTIN0_BASE)

/*@}*/ /* end of group VistaCM3_PeripheralDecl */

/*@}*/ /* end of group VistaCM3_Definitions */

#ifdef __cplusplus
}
#endif

#endif  /* VistaCM3_H */
