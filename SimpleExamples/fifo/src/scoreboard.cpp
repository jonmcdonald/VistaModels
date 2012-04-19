#include "fir_filter.h"
#include <iostream>

using namespace std;

void scoreboard (ac_int<8> coeffs[NUM_TAPS], ac_int<8> output[NUM_TAPS])
{
	for (int i=0; i<NUM_TAPS; i++)
	{
    if ( output[i] != coeffs[i]>>1 ) 
      cout << "Error on output " << i << ", Output = " << output << ", Expected = " << (coeffs[i]>>1) << endl;
    else
      cout << "Output " << i << " is correct" << endl;
  }
}
