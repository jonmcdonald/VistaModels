#include "VistaCM3.h"

#define FFFULL		0x3A
#define FFEMPTY		0x05

#define IOSINK          0x40000100
#define IOCNT           0x40000200

#define true 1
#define false 0

int ffFull;

int main () {
  int i;
  int c;

  NVIC_EnableIRQ(1);

  while (true) {

    while (!ffFull) {
      Vista_ExtIn0->STATUS = 0;
      __WFI();
      Vista_ExtIn0->STATUS = 1;
    }

    c = Vista_FIFO0->Count;
    /*while (c != 0) {*/
    while (Vista_FIFO0->Status.b.nEmpty) {
      i = Vista_FIFO0->Data;
      c = Vista_FIFO0->Count;
    }
    ffFull = false;
  }

  return 0;
}

void __attribute__ ((interrupt)) __cs3_isr_external_1(void) {
    ffFull = true;
    Vista_FIFO0->ClearIRQ = 0;
}
