
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include "nvic.h"

#define hw_addr(x)	(volatile unsigned long*)(x)
#define hw_read(x)	*hw_addr(x)
#define hw_write(x,y)	*hw_addr(x)=(y)

#define FF		0x40000000
#define FFSTATUS	(FF+0x40)
#define FFCOUNT		(FF+0x44)
#define FFCLRIRQ	(FF+0x50)
#define FFFULL		0x3A
#define FFEMPTY		0x05

#define UART            0x40000100
#define UARTIBRD        (UART+0x24)
#define UARTCR          (UART+0x30)
#define IOCNT           0x40000200
#define IOSTATUS        (IOCNT+0x4)

#define true 1
#define false 0

int ffFull;

int isPrime(int num) {
  if (num <= 1)
    return false;
  else if (num == 2)
    return true;
  else if (num % 2 == 0)
    return false;
  else{
    int prime = true;
    int divisor = 3;
    double md = sqrt(55.5);
    while ((divisor * divisor) < num) {
      if (num % divisor == 0) {
        prime = false;
        break; }
      divisor += 2; }
    return prime; }
}

int GetNextPrimes(int n, int pcount) {
  int havePrime;
  int i;
  int p = 0;

  while (p++ < pcount) {
    havePrime = false;
    i = n;
    while (!havePrime) {
      i++;
      havePrime = isPrime(i);
    }
    n = i+1;
  }
  return i;
}

void writeUart(char *s) {
  char* ch = s;
  while (*ch != NULL) {
    hw_write(UART, *ch);
    ch++;
  }
}

int main () {
  int i;
  int c;

  /* Initialize UART */
  hw_write(UARTIBRD, 0x01);
  hw_write(UARTCR, 0x0301);

  hw_write(IOSTATUS, 1);
  //printf ("Starting main\n");
  ffFull = false;

  writeUart("Testing\n");

  i = GetNextPrimes(10000000, 100);
  hw_write(IOSTATUS, 2);
  printf ("Prime is %d\n", i);

  /*asm volatile ("cpsie i");*/
  NVIC_EnableIRQ(1);

  while (true) {

    while (!ffFull) {
      //printf ("Called wfi\n");
      hw_write(IOSTATUS, 0);
      asm volatile("wfi"); 
      hw_write(IOSTATUS, 1);
    }
  
    c = hw_read(FFCOUNT);
    while (c != 0) {
      i = hw_read(FF);
      c = hw_read(FFCOUNT);
      //printf ("Read i = %d\n", i);
    }
    //printf ("Finished read loop\n");
    ffFull = false;
  }

  //i = GetNextPrimes(1000, 10);
  //printf ("Returning from main\n");
  return 0;
}

void __attribute__ ((interrupt)) __cs3_isr_external_1(void) {
    ffFull = true;
    hw_write(FFCLRIRQ, 0);
    //printf ("        Called isr 1\n");
}
