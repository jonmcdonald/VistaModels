
#include <stdint.h>

typedef volatile struct {
 uint32_t DR;
 uint32_t RSR_ECR;
 uint8_t reserved1[0x10];
 const uint32_t FR;
 uint8_t reserved2[0x4];
 uint32_t LPR;
 uint32_t IBRD;
 uint32_t FBRD;
 uint32_t LCR_H;
 uint32_t CR;
 uint32_t IFLS;
 uint32_t IMSC;
 const uint32_t RIS;
 const uint32_t MIS;
 uint32_t ICR;
 uint32_t DMACR;
} pl011_T;

enum {
 RXFE = 0x10,
 TXFF = 0x20,
};

pl011_T* const UART0 = (pl011_T *) 0x4000C000;

void print_UART0(char *ptr)
{
  // Enable the UART for transmit and recieve
  UART0->CR = 0b1100000001;

  while (*ptr != '\0') {
    while(UART0->FR & TXFF);
    UART0->DR = *ptr++;
  }
}

