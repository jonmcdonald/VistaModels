#include <stdint.h>
#include "irq.h"
#include "../../../splatform/models/MemoryMap.h"
#include "mb/sw/control.h"

#define BRIDGE_BASE 0x10000000
#define REVS_REG    (*((volatile uint32_t*) BRIDGE_BASE + 0x0))
#define SPEED_REG   (*((volatile uint32_t*) BRIDGE_BASE + 0x1))

#define CAN_BASE 0x20000000
#define CAN_DATA_REG (*((volatile uint32_t*) (CAN_BASE + CAN_DATA)))
#define CAN_IDENT_REG (*((volatile uint32_t*) (CAN_BASE + CAN_IDENT)))
#define CAN_RTR_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RTR)))
#define CAN_IDE_REG (*((volatile uint32_t*) (CAN_BASE + CAN_IDE)))
#define CAN_SIZE_REG (*((volatile uint32_t*) (CAN_BASE + CAN_SIZE)))
#define CAN_RXDATA_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RXDATA)))
#define CAN_RXIDENT_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RXIDENT)))
#define CAN_RXRTR_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RXRTR)))
#define CAN_RXIDE_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RXIDE)))
#define CAN_RXSIZE_REG (*((volatile uint32_t*) (CAN_BASE + CAN_RXSIZE)))
#define CAN_ACK_REG (*((volatile uint32_t*) (CAN_BASE + CAN_ACK)))


void irq0_Handler(void) 
{
//    mb_core_message("irq!\n");
    CAN_ACK_REG = 0;
    uint32_t id = CAN_RXIDENT_REG;
//    mb_core_print(id);
//    uint32_t data = CAN_RXDATA_REG;
//    mb_core_print(data);
    switch(id) {
      case SPEEDID:
        SPEED_REG = CAN_RXDATA_REG;
        break;
      case RPMID:
        REVS_REG = CAN_RXDATA_REG;
        break;
      default:
        break;
    }

}

int main( void )
{
    mb_core_message("M4 Started!\n");

    NVIC_EnableIRQ(0);

    while (1) {
//        mb_core_message("waiting for interrupt!\n");
        asm volatile ("wfi");
    }

    return 0;
}


