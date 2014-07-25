
#include "uart.h"
#include "led.h"
#include "nvic.h"

#include "../hw/registers/output/registers.h"

int main( void )
{
    init_UART0();
    print_UART0("Initialising System\n");

    NVIC_EnableIRQ(0);
 
    print_UART0("Waiting for IRQ0 Interrupt\n");

    while (1) {
      asm volatile ("wfi");
    }

    print_UART0("OK - Finishing\n");
 
    return 0;
}

void irq0_Handler(void)
{
  static int red = 0;
  static int blue = 0;
  static int green = 0;

  print_UART0("IRQ0: Interrupt_Handler\n");

  NVIC_ClearPendingIRQ(0);

  top_ptr regtop = TOP__BASE;

  int state = (regtop->controller).STATE;
  (regtop->controller).STATE = 0;

  if(state & (1 << 0)) {
    print_UART0("Toggling Red LED\n");
    red = !red;
    red_enable(red);
  }
  if(state & (1 << 1)) {
    print_UART0("Toggling Green LED\n");
    green = !green;
    green_enable(green);
  }
  if(state & (1 << 2)) {
    print_UART0("Toggling Blue LED\n");
    blue = !blue;
    blue_enable(blue);
  }
}


