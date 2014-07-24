
#include "uart.h"
#include "led.h"
#include "nvic.h"

#include "../hw/registers/output/registers.h"

#include "mb/sw/control.h"

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
  if((regtop->controller).BUTTON_X) {
    print_UART0("Toggling Red LED\n");
    red = !red;
    red_enable(red);
    (regtop->controller).BUTTON_X = 0;
  }
  if((regtop->controller).BUTTON_Y) {
    print_UART0("Toggling Green LED\n");
    green = !green;
    green_enable(green);
    (regtop->controller).BUTTON_Y = 0;
  }
  if((regtop->controller).BUTTON_Z) {
    print_UART0("Toggling Blue LED\n");
    blue = !blue;
    blue_enable(blue);
    (regtop->controller).BUTTON_Z = 0;
  }
}


