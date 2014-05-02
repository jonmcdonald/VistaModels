
#include "gic.h"
#include <stdint.h>

#define IS_SGI_INDEX_IN_RANGE(sgi) ( (sgi) >= 32 ) && ( (sgi) < 256 ) 
struct icd_registers //unused
{
  uint32_t icddcr;	// 0x000 RW 0x0                32 Distributor Control Register
  uint32_t icdictr;	// 0x004 RO dependent          32 Interrupt Controller Type Register
  uint32_t icddiidr;	// 0x008 RO 0x0102043B}        32 Distributor Implementer Identification
  uint32_t reserved_0[(0x080 - 0x00c) / sizeof(uint32_t)]; // 0x00C - 0x07C

  uint32_t icdisr[8];   // 0x080 - 0x09c RW 0x00000000 32 Interrupt Security Registers
  uint32_t icdisr_reserved[24];  // GIC

  uint32_t icdiser[8];  // 0x100 - 0x11C RW 0x00000000 32 Interrupt Set-Enable Registers. Reset value
                        // for register containing SGI and PPI interrupts is implementation-dependent
  uint32_t icdiser_reserved[24];

  uint32_t icdicer[8];  // 0x180 - 0x19C RW 0x00000000 32 Interrupt Clear-Enable Registers
  uint32_t icdicer_reserved[24];

  uint32_t icdispr[8];  // 0x200 - 0x21C RW 0x00000000 32 Interrupt Set-Pending Registers
  uint32_t icdispr_reserved[24];

  uint32_t icdicpr[8];  // 0x280 - 0x29C RW 0x00000000 32 Interrupt Clear-Pending Registers
  uint32_t icdicpr_reserved[24];

  uint32_t icdabr[8];   // 0x300 - 0x31C RO 0x00000000 32 Active Bit registers
  uint32_t icdabr_reserved[24];

  uint32_t reserved_1[32]; // 0x380 - 0x3FC

  uint8_t  icdipr[256]; // 0x400 - 0x4FC RW 0x00000000 32/8 Interrupt Priority Registers
  uint8_t  icdipr_reserved[3][256]; // 0x500 - 0x7FF

  uint8_t  icdiptr[256];// 0x800 - 0x8FC RW 0x00000000 32/8 Interrupt Processor Targets Registers
  uint8_t  icdiptr_reserved[3][256]; // 0x900 - 0xBFF

  uint32_t icdicfr[16]; // 0xC00 - 0xC3C RW dependent  32 Interrupt Configuration Registers
  uint32_t icdicfr_reserved[48]; // 0xC40 - 0xCFC

  uint32_t ppi_status;  // 0xD00         -  0x00000000 32 PPI Status Register
  uint32_t spi_status[7]; // 0xD04-0xD1C RO 0x00000000 32 SPI Status Registers
  uint32_t spi_status_reserved[24];
  uint32_t reserved_3[32+64]; // 0xD80 - 0xEFC

  uint32_t icdsgir;     // 0xF00         WO -          32 Software Generated Interrupt Register
  uint32_t reserved_4[(0xFD0 - 0xF04) / sizeof(uint32_t)]; // 0xF04 - 0xFCC

  uint8_t  periph_id[32]; // 0xFD0 - 0xFEC RO dependent  8 Peripheral Identification Registers
  uint8_t  component_id[16]; // 0xFF0 - 0xFFC RO - 8 PrimeCell Identification Registers
};

struct icc_registers //unused
{
  uint32_t iccicr;   // 0x000 RW 0x00000000 32 CPU Interface Control Register
  uint32_t iccpmr;   // 0x004 RW 0x00000000 32 Interrupt Priority Mask Register
  uint32_t iccbpr;   // 0x008 RW 0x2/0x3    32 Binary Point Register
  uint32_t icciar;   // 0x00C RO 0x000003FF 32 Interrupt Acknowledge Register
  uint32_t icceoir;  // 0x010 WO -          32 End Of Interrupt Register
  uint32_t iccrpr;   // 0x014 RO 0x000000FF 32 Running Priority Register
  uint32_t icchpir;  // 0x018 RO 0x000003FF 32 Highest Pending Interrupt Register
  uint32_t iccabpr;  // 0x01C RW 0x3        32 Aliased Non-secure Binary Point Register
                     // Accessible only when processor performs a secure access
  uint8_t  reserved[0xFC - 0x20];
  uint32_t iccidr;   //  0x0FC RO 0x3901243B 32 CPU Interface Implementer Identification Register
};

struct icd_registers ICD __attribute__ ((section (".icd")));
struct icc_registers ICC __attribute__ ((section (".icc")));

static char message[256];
void gic_init()
{
  unsigned int u;
 
  /* cpu interface */
  ICC.iccicr = 3; // enable both secure and non secure interrupts
  ICC.iccpmr = 0xff; // all interrupts are allowed

  /* distribitor */
  ICD.icddcr = 3;  // enable both secure and non secure interrupts
  
  ICD.icdiser[1] = 0xFFFFFFF; // enable shared interrupts 32-63
  ICD.icdicfr[2] = ICD.icdicfr[3] = 0; // level driven, N-N model
  for (u = 32; u < 64; ++u) {
    ICD.icdipr[u] = 0;   // priority 0 
    ICD.icdiptr[u] = 0xFF;   // target all 
  }

 
}

unsigned int gic_acknowledge_irq()
{
  return ICC.icciar;
}

void gic_complete_irq(unsigned int irq)
{
  ICC.icceoir = irq;
}

void gic_assign_binary_point(unsigned int bpr)
{
  if(bpr <= 7)
  {
    ICC.iccbpr = bpr;
  }
}

void gic_set_priority_2_interrupt(unsigned int irq, unsigned char priority)
{   
  if(IS_SGI_INDEX_IN_RANGE(irq))
  {
    /* Priority comes in values of 0 to 255 */
    ICD.icdipr[irq] = priority;
  }
}

void gic_set_target_2_interrupt(unsigned int irq, unsigned char target_cpu)
{
  if(IS_SGI_INDEX_IN_RANGE(irq))
  {
    /* Assign the target cpu to handle the given interrupt */
    ICD.icdiptr[irq] = (1 << target_cpu);
  }
}

unsigned char gic_get_priority_2_interrupt(unsigned int irq)
{
  return IS_SGI_INDEX_IN_RANGE(irq) ? ICD.icdipr[irq] : 0xFF;
}

unsigned char gic_get_priority_group_mask( void )
{
  return (0xFF >> ICC.iccbpr) << ICC.iccbpr;
}

static IRQHandler* table[64];

void gic_register_handler(int irq, IRQHandler* handler)
{
  table[irq] = handler;
}

void do_irq()
{
  unsigned int irq = gic_acknowledge_irq();
  if (table[irq])
    table[irq]();
  gic_complete_irq(irq);
}

void do_fiq()
{
}
