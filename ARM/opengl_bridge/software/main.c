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
   
//    glOrtho(0.0, 4.0, 0.0, 3.0, -1.0, 1.0);

//        glClear(GL_COLOR_BUFFER_BIT);
//        glColor3f(0.7, 0.5, 0.8);
//        glRectf(1.2, 1.0, 3.0, 2.0);

    while (1) {
        draw();
        sdl2Swap();
    }

    sdl2Close();
}

