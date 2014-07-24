
#include "led.h"
#include "../hw/registers/output/registers.h"

top_ptr regtop = TOP__BASE;

void red_enable(uint32_t value)
{
  (regtop->led).RED_EN = value;
}

void green_enable(uint32_t value)
{
  (regtop->led).GREEN_EN = value;
}

void blue_enable(uint32_t value)
{
  (regtop->led).BLUE_EN = value;
}
