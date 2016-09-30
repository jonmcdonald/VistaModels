
#include <stdio.h>


#define ADR (*((volatile unsigned long *)    0xF0000000))
#define CTL (*((volatile unsigned long *)    0xF0000004))


int factorial(int n) {
	if (n == 0)
		return 1;
	return n * factorial (n - 1);
}

int main () {
	int i;
	int n;

	int core_id = get_core_id();
	if (core_id == 0) {

		for (i = 0; i < 10; ++i) {
			n = factorial (i);
			printf ("factorial(%d) = %d\n", i, n);
		}

		ADR = 0x08000000;
		CTL = 0x1;
	}

	while (1) {
			asm volatile ("wfi");
	}

	return 0;
}
