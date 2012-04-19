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
//  Source:         fir_filter.c
//  Description:    simple fir filter example
////////////////////////////////////////////////////////////////////////////////

#ifndef _FIR_FILTER_H
#define _FIR_FILTER_H

#include "ac_int.h"
#define NUM_TAPS 8
extern void driver (ac_int<8> input[NUM_TAPS], ac_int<8> coeffs[NUM_TAPS]);
extern void fir_filter (ac_int<8> *input, ac_int<8> coeffs[NUM_TAPS], ac_int<8> *output );
extern void scoreboard (ac_int<8> coeffs[NUM_TAPS], ac_int<8> output[NUM_TAPS]);
#endif
