#include <stdint.h>

#include "opengl_bridge.h"

extern void init();
extern void draw();

#define MB_CONTROL_PAGE_ADDRESS 0x00708000
#include "mb/sw/control.h"

#define UNUSED(x) (void)(x)

// main function, it all begins here
void kernel_main(uint32_t r0, uint32_t r1, uint32_t atags) {
    UNUSED(r0);
    UNUSED(r1);
    UNUSED(atags);

    mb_core_message("OpenGL Bridge - Proof of Concept");

    sdl2Open();
 
    init();
   
    while (1) {
        draw();
        sdl2Swap();
    }

    sdl2Close();
}

