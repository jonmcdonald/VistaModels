
//Test.cpp

#include "Rijndael.h"
#include <iostream>
#include <string.h>

using namespace std;

#include "nvic.h"

#define hw_addr(x)	(volatile unsigned long*)(x)
#define hw_read(x)	*hw_addr(x)
#define hw_write(x,y)	*hw_addr(x)=(y)

#define AES		0x40000000
#define AESSOURCE	(AES+0x0)
#define AESDESTINATION	(AES+0x4)
#define AESSIZE 	(AES+0x8)
#define AESSTATUS 	(AES+0x10)
#define AESCLRIRQ 	(AES+0x14)

int AESdone;

//Function to convert unsigned char to string of length 2
void Char2Hex(unsigned char ch, char* szHex)
{
	unsigned char byte[2];
	byte[0] = ch/16;
	byte[1] = ch%16;
	for(int i=0; i<2; i++)
	{
		if(byte[i] >= 0 && byte[i] <= 9)
			szHex[i] = '0' + byte[i];
		else
			szHex[i] = 'A' + byte[i] - 10;
	}
	szHex[2] = 0;
}

//Function to convert string of length 2 to unsigned char
void Hex2Char(char const* szHex, unsigned char& rch)
{
	rch = 0;
	for(int i=0; i<2; i++)
	{
		if(*(szHex + i) >='0' && *(szHex + i) <= '9')
			rch = (rch << 4) + (*(szHex + i) - '0');
		else if(*(szHex + i) >='A' && *(szHex + i) <= 'F')
			rch = (rch << 4) + (*(szHex + i) - 'A' + 10);
		else
			break;
	}
}    

//Function to convert string of unsigned chars to string of chars
void CharStr2HexStr(unsigned char const* pucCharStr, char* pszHexStr, int iSize)
{
	int i;
	char szHex[3];
	pszHexStr[0] = 0;
	for(i=0; i<iSize; i++)
	{
		Char2Hex(pucCharStr[i], szHex);
		strcat(pszHexStr, szHex);
	}
}

//Function to convert string of chars to string of unsigned chars
void HexStr2CharStr(char const* pszHexStr, unsigned char* pucCharStr, int iSize)
{
	int i;
	unsigned char ch;
	for(i=0; i<iSize; i++)
	{
		Hex2Char(pszHexStr+2*i, ch);
		pucCharStr[i] = ch;
	}
}

int main()
{
	NVIC_EnableIRQ(1);
	char szHex[4097];
	//One block testing
	CRijndael oRijndael;
	char szDataIn[2048] = "To be, or not to be, that is the question: Whether 'tis nobler in the mind to suffer The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them? To die, to sleep,  No more; and by a sleep to say we end The heartache, and the thousand natural shocks That flesh is heir to, 'tis a consummation Devoutly to be wish'd. To die, to sleep;  To sleep! perchance to dream: ay, there's the rub; For in that sleep of death what dreams may come, When we have shuffled off this mortal coil, Must give us pause: there's the respect That makes calamity of so long life; For who would bear the whips and scorns of time, The oppressor's wrong, the proud man's contumely, The pangs of despis'd love, the law's delay, The insolence of office, and the spurns That patient merit of the unworthy takes, When he himself might his quietus make With a bare bodkin? who would these fardels bear, To grunt and sweat under a weary life, But that the dread of something after death,  The undiscover'd country, from whose bourn No traveller returns, puzzles the will, And makes us rather bear those ills we have Than fly to others that we know not of? Thus conscience does make cowards of us all; And thus the native hue of resolution Is sicklied o'er with the pale cast of thought; And enterprises of great pith and moment, With this regard, their currents turn awry, And lose the name of action. Soft you now! The fair Ophelia! Nymph, in thy orisons Be all my sins remember'd.";
        for (int i=strlen(szDataIn);i<=2048;szDataIn[i++]='\0');

	char szDataOut[2048]; for(int i=0;i<=2048;szDataOut[i++]='\0');
	char szDataT[2048]; for(int i=0;i<=2048;szDataT[i++]='\0');

	cout << "Input:" << endl << szDataIn << endl;
        AESdone = 0;
	hw_write(AESSOURCE, szDataIn);
	hw_write(AESDESTINATION, szDataOut);
	hw_write(AESSIZE, 2048);
	hw_write(AESSTATUS, 1);

        while (!AESdone)
	    asm volatile("wfi");

        CharStr2HexStr((unsigned char const *)szDataOut, szHex, 2048);
        cout << "Encrypted:" << endl << szHex << endl;

        AESdone = 0;
	hw_write(AESSOURCE, szDataOut);
	hw_write(AESDESTINATION, szDataT);
	hw_write(AESSTATUS, 2);

        while (!AESdone)
	    asm volatile("wfi");

	cout << "Output:" << endl << szDataT << endl;

	return 0;
}

void __attribute__ ((interrupt)) __cs3_isr_external_1(void) {
    AESdone = 1;
    hw_write(AESCLRIRQ, 0);
    //printf ("        Called isr 1\n");
}
