
#include <stdio.h>
#include "nvic.h"
#include "mb/sw/control.h"


#define PWMCR       (*((volatile uint32_t *)  0x40012C00))
#define PWMSR       (*((volatile uint32_t *)  0x40012C04))
#define PWMIR       (*((volatile uint32_t *)  0x40012C08))
#define PWMSAR      (*((volatile uint32_t *)  0x40012C0C))
#define PWMPR       (*((volatile uint32_t *)  0x40012C10))
#define PWMCNR      (*((volatile uint32_t *)  0x40012C14))

#define CHECK_BIT(var,pos) ((var) & (1<<(pos)))

uint32_t counter = 0;
uint32_t cmp = 0x0;

void __attribute__ ((interrupt)) __cs3_isr_wwdg(void) {
	uint32_t msr = PWMSR;
	PWMSR = 0b111000;
	if(CHECK_BIT(msr, 5)) {
//		mb_core_message("COMPARE\n");
	}
	if(CHECK_BIT(msr, 4)) {
//		mb_core_print(msr);
	}
	if(CHECK_BIT(msr, 3)) {
//		mb_core_message("FIFO-EMPTY\n");
		// push a new compare value
		counter++;
		if(counter == 250) {        // change speed 4 times a second
			counter = 0;
			cmp++;
			if(cmp == 5) {
				cmp = 0;
			}
		}
		PWMSAR = (cmp * (99 / 4)) + 1;
	}
}

int main () {
	NVIC_EnableIRQ(0);

	mb_core_message("PWM test\n");

	// 1. Configure the desired settings for the PWM Control Register (PWMx_PWMCR)
	// while keeping the PWM disabled (PWMx_PWMCR[0]=0).

	// P = PCOUC, CS = clock select, pppppp = prescaler, e = enable
	// P { 00 = Output pin is set at rollover and cleared at comparison }
	//                          PPCSpppppppppppp   e         CS { 10 = high frequency }
	uint32_t cr = 0b00000000000000100000000000000000;
	PWMCR = cr;

	// 2. Enable the desired interrupts in the PWM Interrupt Register (PWMx_PWMIR).
	//  c=compare r=roll-over e=fifo-empty
	//        cre
	PWMIR = 0b001;

	// 3. One to three initial samples may be written to the PWM Sample Register
	// (PWMx_PWMSAR). The initial sample values will be loaded into the PWM FIFO
	// even if the PWM is not yet enabled. Do not write a 4th sample because the FIFO will
	// become full and trigger a FIFO Write Error (FWE). This error will prevent the PWM
	// from starting once it is enabled.
	PWMSAR = (cmp * (99 / 4)) + 1;

	// 4. Check the FIFO Write Error status bit (FWE), the Compare status bit (CMP) and the
	// Roll-over status bit (ROV) in the PWM Status Register (PWMx_PWMSR) to make
	// sure they are all zero. Any non-zero status bits should be cleared by writing a 1 to
	// them.
	// FWE=f, CMP=c, ROV=r, FE=e, FIFOAV= v
	//        fcrevvv
	PWMSR = 0b1110000;

	// 5. Write the desired period to the PWM Period Register (PWMx_PWMPR).
	// 1 KHz rollover speed using clock freq of 100KHz
	PWMPR = 99;

	//6. Enable the PWM by writing a 1 to the PWM Enable bit, PWMx_PWMCR[0], while
	//maintaining the other register bits in their previously configured state.
	mb_core_message("Start PWM\n");
	PWMCR = cr | 1;

	while (1) {
		asm volatile ("wfi");
		//mb_core_message("Hello WFI\n");
	}

	return 0;
}
