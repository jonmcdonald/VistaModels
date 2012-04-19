#include "fir_filter.h"

void driver (ac_int<8> input[NUM_TAPS], ac_int<8> coeffs[NUM_TAPS])
{
  ac_int<8> coeffs_table[NUM_TAPS] = {10,20,30,40,40,30,20,10};
  // Test Impulse
  int i;
  for ( i = 0; i < NUM_TAPS; i++ ) {
    if ( i == 0 ) 
			input[i] = 1 << 6;
    else 
			input[i] = 0;
		
		coeffs[i] = coeffs_table[i];
	}
}
