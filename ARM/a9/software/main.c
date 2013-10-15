/* main.c - the entry point for the kernel */
 
#include <stdint.h>

#define MB_CONTROL_PAGE_ADDRESS 0x00708000
#include "mb/sw/control.h"

#include "lcd.h"
#include "examples/ui.h"

#define UNUSED(x) (void)(x)
 
// kernel main function, it all begins here
void kernel_main(uint32_t r0, uint32_t r1, uint32_t atags) {
    UNUSED(r0);
    UNUSED(r1);
    UNUSED(atags);

    // example of semi hosting print message
    mb_core_message("*** ARM A9 OpenGL Platform ***");

    init_lcd();
  
    ui_loop();
}

