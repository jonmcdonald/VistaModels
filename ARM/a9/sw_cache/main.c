
#include <stdio.h>

#define MB_CONTROL_PAGE_ADDRESS 0x00708000
#include "mb/sw/control.h"

extern void board_init();
extern void gic_init();
extern void mmu_init();
extern void init_lcd();
extern void ui_loop();

int main(void)
{
    // example of semi hosting print message
#ifdef GPU
    mb_core_message("*** ARM A9 OpenGL Platform - GPU ENABLED ***");
#else
    mb_core_message("*** ARM A9 OpenGL Platform ***");
#endif

  board_init();
  gic_init();
  mmu_init();

  init_lcd();
  ui_loop(3);  // do 10 frames then quit

  mb_flush_db();
  mb_stop(0);

  return 0;
}

