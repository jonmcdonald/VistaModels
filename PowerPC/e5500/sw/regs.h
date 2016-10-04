
#ifndef __regs_h__
#define __regs_h__


typedef volatile unsigned char vuint8_t;
typedef volatile unsigned int  vuint32_t;
/****************************************************************************/
/*          MODULE : MPIC                                                   */
/****************************************************************************/
struct MPIC_tag {

	vuint32_t MPIC_reserved1[40]; //not used by me 0x00-0xA0
	union {
		vuint32_t R;
		struct {
			vuint32_t:16;
			vuint32_t VECTOR:16;
		} B;
	}IACK;

	vuint32_t MPIC_reserved2[3]; //not used by me 0x0A4-0xB0
	union {
		vuint32_t R;
		struct {
			vuint32_t:28;
			vuint32_t EOI_CODE:4;
		} B;
	}EOI;

	vuint32_t MPIC_reserved3[16339]; //not used by me 0x4_00B4-0x5_0000
	vuint32_t MPIC_EXTERNAL_INTERRUPTS[128]; //not used by me 0x5_0000-0x5_0200/4
	//interrupt used for uart linux is 37  5_06A0
	vuint32_t MPIC_INTERNAL_INTERRUPTS[296]; //not used by me 0x5_0200-0x5_06A0/4  =  (0x20/4 )*(number_of_interrupts) = (0x20)*(37+16)/4
	//p5020 p.1840
	union {
		vuint32_t R;
		struct {
			vuint32_t MSK:1;
			vuint32_t Activity:1;
			vuint32_t:6;
			vuint32_t Polarity:1;
			vuint32_t:3;
			vuint32_t PRIORITY:4;
			vuint32_t VECTOR:16;
		} B;
	} IIVPR_37;
	vuint32_t cak[7];
	union {
		vuint32_t R;
		struct {
			vuint32_t MSK:1;
			vuint32_t Activity:1;
			vuint32_t:6;
			vuint32_t Polarity:1;
			vuint32_t:3;
			vuint32_t PRIORITY:4;
			vuint32_t VECTOR:16;
		} B;
	} IIVPR_38;
	//0x5_06A4
	//   vuint32_t MPIC_reserved4[16375];
	vuint32_t MPIC_reserved4[15983];
	//0x6_0080
	union {
		vuint32_t R;
		struct {
			vuint32_t:28;
			vuint32_t TASKP:4;
		} B;
	} CPU0_CTPR;

	//    vuint8_t MPIC_reserved6[16315]; /* Reserved 16315 (Base+0x044-0x3FFF) */

}; /* end of MPIC_tag */


/****************************************************************************/
/*          MODULE : UART                                                   */
/****************************************************************************/
struct UART_tag {

	union {
		vuint8_t R;
		struct {
			vuint8_t RECEIVER_BUFFER_REGISTER;
		} RX;

		struct {
			vuint8_t TRANSMITER_HOLDING_REGISTER;
		} TX;
		//DLABULCR[DLAB] = 1)
		struct {
			vuint8_t DEVISOR_LEAST_SIGNIFICANT_BYTE_REG;
		} DEV;
	}FIRST_BYTE;

	union {

		//DLABULCR[DLAB] = 1)
		vuint8_t R;
		struct {
			vuint8_t DEVISOR_MOST_SIGNIFICANT_BYTE_REG;
		} DEV;

		struct {
			vuint8_t:4;
			vuint8_t EMSI:1;
			vuint8_t ERLSI:1;
			vuint8_t ETHREI:1;//TX- Enable transmitter holding register empty interrupt.
			vuint8_t ERDAI:1; //RX- Enable received data available interrupt.

		} IER;

	}SECOND_BYTE;


	union {
		vuint8_t R;
		struct {
			vuint8_t FE:2;
			vuint8_t:2;
			vuint8_t IID3:1;
			vuint8_t IID2:1;
			vuint8_t IID1:1;
			vuint8_t IID0:1;
		} INTERRUPT_ID_REGISTER;

		struct {
			vuint8_t RTL:2;
			vuint8_t:2;
			vuint8_t DMS:1;
			vuint8_t TFR:1;//transmit fifo reset
			vuint8_t RFR:1;//receive fifo reset
			vuint8_t FEN:1;//fifo enable register
		} FIFO_CONTROL_REGISTER;

		//DLABULCR[DLAB] = 1)
		struct {
			vuint8_t:6;
			vuint8_t BO:1;
			vuint8_t CW:1;
		} ALTERNATE_FUNCTION_REGISTER;
	}THIRD_BYTE;

	vuint8_t FOURTH_BYTE;

	union {
		vuint8_t R;
		struct {
			vuint8_t:7;
			vuint8_t DR:1;
		} LINE_STATUS_REGISTER;
	} FIFTH_BYTE;

	union {
		vuint8_t R;
		struct {
			vuint8_t DCTS:1;
			vuint8_t DDSR:1;
			vuint8_t TERI:1;
			vuint8_t DDCD:1;
			vuint8_t CTS:1;
			vuint8_t DSR:1;
			vuint8_t RI:1;
			vuint8_t DCD:1;
		} MODEM_STATUS_REGISTER;
	} SIXTH_BYTE;
	vuint8_t UART_reserved1[10]; /* Reserved 16315 (Base+0x503-0x510) */

}; /* end of UART_tag */


#define UART1       (*(volatile struct UART_tag *)         0xFE11C500UL)
#define MPIC        (*(volatile struct MPIC_tag *)         0xFE040000UL)
//return (SEMA4.RSTGT_R.R)
#endif

