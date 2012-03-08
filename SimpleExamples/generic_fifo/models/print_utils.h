//
// Helpful Catapult defines
//

#pragma once


//---------------------
// Printing Macro's
//---------------------
#define PVARI(x)         printf("%14s= %4d  ",    #x, (unsigned)x)    // print integer
#define PVARX(x)         printf("%14s= 0x%8x  ",    #x, (unsigned)x)    // print hex
#define PVARF(x)         printf("%14s= %9.4f  " , #x, (unsigned)x)    // print float
#define PRET             printf("\n")                                 // carriage return
#define RET              printf("\n")                                 // carriage return

#define PARRAYF(x,s)     printf("%10s=\t", #x); prtArrayF(x,s);      // print as floating
#define PARRAYFL(x,s,l)  printf("%10s=\t", #x); prtArrayF(x,s,l);    // print as floating, specify elements per line

#define PARRAYX(x,s)     printf("%10s=\t", #x); prtArrayX(x,s);      // print as hex
#define PARRAYXL(x,s,l)  printf("%10s=\t", #x); prtArrayX(x,s,l);    // print as hex, specify elements per line


//----------------------
// print array functions
//----------------------
template <class T>
void prtArrayX (T array, int size)
{
	int plen = 6;
	for (int i = 0; i<size; i++) {
		if (i%plen==0 && i!=0) 
			printf("\n\t\t"); 
		printf(" %9x ",(array[i]) );
	}
	printf("\n");
}
template <class T>
void prtArrayX (T array, int size, int plen)
{
	for (int i = 0; i<size; i++) {
		if (i%plen==0 && i!=0) 
			printf("\n\t\t"); 
		printf(" %9x ",(array[i]) );
	}
	printf("\n");
}
template <class T>
void prtArrayF (T array, int size)
{
	int plen = 6;
	for (int i = 0; i<size; i++) {
		if (i%plen==0 && i!=0) 
			printf("\n\t\t"); 
		printf(" %9.4f ",(array[i]) );
	}
	printf("\n");
}
template <class T>
void prtArrayF (T array, int size, int plen)
{
	for (int i = 0; i<size; i++) {
		if (i%plen==0 && i!=0) 
			printf("\n\t\t"); 
		printf(" %9.4f ",(array[i]) );
	}
	printf("\n");
}
