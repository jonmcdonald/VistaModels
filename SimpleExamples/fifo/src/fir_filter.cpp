////////////////////////////////////////////////////////////////////////////////
// Catapult Synthesis
// 
// © 2005 Mentor Graphics Corporation
//       All Rights Reserved
// 
// This document contains information that is proprietary to Mentor Graphics  
// Corporation. The original recipient of this document may duplicate this  
// document in whole or in part for internal business purposes only, provided  
// that this entire notice appears in all copies. In duplicating any part of  
// this document, the recipient agrees to make every reasonable effort to  
// prevent the unauthorized use and distribution of the proprietary information.
////////////////////////////////////////////////////////////////////////////////
//  Source:         fir_filter.cpp
//  Description:    simple fir filter example
////////////////////////////////////////////////////////////////////////////////

#include "fir_filter.h"
#include "stdio.h"

#pragma design top
void fir_filter (ac_int<8> *input, ac_int<8> coeffs[NUM_TAPS], ac_int<8> *output ) {
  static ac_int<8> regs[NUM_TAPS];
  int temp = 0;
  int i; 
  SHIFT:for ( i = NUM_TAPS-1; i>=0; i--) {
    if ( i == 0 ) 
      regs[i] = *input;
    else 
      regs[i] = regs[i-1];
  }
  MAC:for ( i = NUM_TAPS-1; i>=0; i--) {
    temp += coeffs[i]*regs[i];
  }
  *output = temp>>7;
}
