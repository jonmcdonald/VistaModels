#include <stdint.h>
#include "mb/sw/control.h"

#define BRIDGE_BASE 0x10000000
#define REVS_REG    (*((volatile uint32_t*) BRIDGE_BASE + 0x0))
#define SPEED_REG   (*((volatile uint32_t*) BRIDGE_BASE + 0x1))


int main( void )
{
    mb_core_message("M4 Started!\n");

    uint32_t revs = 0;
    uint32_t speed = 0;

    int revup = 1;
    int speedup = 1;

    while(1) {
      REVS_REG = revs;
      SPEED_REG = speed / 25;

      if(revup) {
        revs++;
        if(revs == 8000) {
  	  revup = 0;
        } 
      }
      else {
        revs--;
        if(revs == 0) {
          revup = 1;
        } 
      }

      if(speedup) {
        speed++;
        if(speed == 140*25) {
	  speedup = 0;
        } 
      }
      else {
        speed--;
        if(speed == 0) {
	  speedup = 1;
        } 
      }
    }

    while (1) {
        asm volatile ("wfi");
    }

    return 0;
}


