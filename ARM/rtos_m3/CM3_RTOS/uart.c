
#include "uart.h"
#include "../registers/output/registers.h"

void init_UART0()
{
  top_ptr regtop = TOP__BASE;

  // Enable the UART for transmit and recieve
  (regtop->uart).UARTCR = (UARTCR__UARTCR_UARTEN__MASK |
                           UARTCR__UARTCR_TXE__MASK |
                           UARTCR__UARTCR_RXE__MASK);
}

void print_UART0(char *ptr)
{
  top_ptr regtop = TOP__BASE;

  // Send characters to the UART when possible
  while (*ptr != '\0') {
    while(UARTFR__UARTFR_TXFF__GET((regtop->uart).UARTFR));
    (regtop->uart).UARTDR = *ptr++;
  }
}


