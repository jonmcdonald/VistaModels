
#include <stdint.h>

typedef volatile struct {
 uint32_t RED_EN;     // 0x0000
 uint32_t GREEN_EN;   // 0x0004
 uint32_t BLUE_EN;    // 0x0008
} LED_T;


LED_T* const led = (LED_T *) 0x4000D000;

void red_enable(unsigned int value)
{
  led->RED_EN = value;
}

void green_enable(unsigned int value)
{
  led->GREEN_EN = value;
}

void blue_enable(unsigned int value)
{
  led->BLUE_EN = value;
}

