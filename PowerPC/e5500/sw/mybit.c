#include "cs3.h"
CS3_STACK(2 * 4096);
#include "regs.h"
#include "mb/sw/control.h"

#define FPGA_CTL (*((volatile unsigned long *)    0x80000000))
#define FPGA_ADR (*((volatile unsigned long *)    0x80000004))

unsigned char buf[100];
unsigned int character_received = 0;

int  move_from_epr(){
	int retval = 0;
	__asm__ __volatile__ ("mfspr %0, %1" : "=r"(retval) : "i"(702));
	return retval;
}

void int_0_isr(){
	int interrupt_type = (UART1.THIRD_BYTE.R >> 1) & 0x7;
	if ( interrupt_type == 0x2) {
		while(UART1.SIXTH_BYTE.MODEM_STATUS_REGISTER.DCD) {
			buf[character_received++] = UART1.FIRST_BYTE.RX.RECEIVER_BUFFER_REGISTER;
		}
	}
	else if (interrupt_type == 0x1) {
		UART1.SECOND_BYTE.IER.ETHREI = 0;
	}
}

void int_1_isr(){
	mb_core_message("FPGA Completed\n");
	mb_core_print( *((unsigned int *) FPGA_ADR));
	FPGA_CTL = 0x0;
}

void int_isr(){
	int intr_routine = 0;
	intr_routine = move_from_epr();
	intr_routine |= (((unsigned int)&int_isr) & 0xFFFF0000);
	((void (*)(void))intr_routine)();
	MPIC.EOI.R = 0;
}

void init_mpic()
{
	MPIC.IIVPR_37.R = MPIC.IIVPR_37.R | ((unsigned int) &(int_0_isr) & 0xFFFF);
	MPIC.IIVPR_37.R = MPIC.IIVPR_37.R | (0x8<<16);
	MPIC.IIVPR_38.R = MPIC.IIVPR_38.R | ((unsigned int) &(int_1_isr) & 0xFFFF);
	MPIC.IIVPR_38.R = MPIC.IIVPR_38.R | (0x8<<16);
	MPIC.CPU0_CTPR.R = 0;
}

int main () {
	int buf_index = 0;

	init_mpic();

	UART1.SECOND_BYTE.IER.ERDAI = 1;
	UART1.SECOND_BYTE.IER.ETHREI = 0;
	UART1.THIRD_BYTE.FIFO_CONTROL_REGISTER.FEN = 0x1;

	while(1) {
		mb_core_message("Software is waiting...\n");
		__asm__(" wait ");

		if(character_received) {
			for (buf_index = 0; buf_index < character_received; buf_index++){
				//write to console.
				//0xfe11C500
				UART1.FIRST_BYTE.TX.TRANSMITER_HOLDING_REGISTER = buf[buf_index];

				if(buf[buf_index] == 'f') {
					FPGA_ADR = 0x30000008;
					FPGA_CTL = 0x1;
				}
			}
			character_received = 0;
			UART1.SECOND_BYTE.IER.ETHREI = 1;
		}
	}

	return 0;
}
