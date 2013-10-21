#include <stdint.h>

#define MB_CONTROL_PAGE_ADDRESS 0x00708000
#include "mb/sw/control.h"

#define INT_DIGITS 19
#define UINT_DIGITS 20
#define UNUSED(x) (void)(x)


char *i_to_a(int i)
{
  static char buf[INT_DIGITS + 2];
  char *p = buf + INT_DIGITS + 1;
  if (i >= 0) {
    do {
      *--p = '0' + (i % 10);
      i /= 10;
    } while (i != 0);
    return p;
  }
  else {
    do {
      *--p = '0' - (i % 10);
      i /= 10;
    } while (i != 0);
    *--p = '-';
  }
  return p;
}
 
void my_function() {
    int x = 10;
    int y = 20;

my_label_1: ;

    mb_core_message("On target: x = ");
    mb_core_message(i_to_a(x));
    mb_core_message("\n");

my_label_2: ;

    mb_core_message("On target: y = ");
    mb_core_message(i_to_a(y));
    mb_core_message("\n");
}

// kernel main function, it all begins here
void kernel_main(uint32_t r0, uint32_t r1, uint32_t atags) {
    UNUSED(r0);
    UNUSED(r1);
    UNUSED(atags);

    my_function();

    mb_stop(0);
}

