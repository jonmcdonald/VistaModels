
/**************************************************************/
/*                                                            */
/*      Copyright Mentor Graphics Corporation 2006 - 2012     */
/*                  All Rights Reserved                       */
/*                                                            */
/*       THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY      */
/*         INFORMATION WHICH IS THE PROPERTY OF MENTOR        */
/*         GRAPHICS CORPORATION OR ITS LICENSORS AND IS       */
/*                 SUBJECT TO LICENSE TERMS.                  */
/*                                                            */
/**************************************************************/

//*<
//* Generated By Model Builder, Mentor Graphics Computer Systems, Inc.
//*
//* This file contains the PV class for sink.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.2.0
//* Generated on: Feb. 24, 2012 05:06:56 PM, (user: mbradley)
//* Automatically merged on: Feb. 27, 2012 12:35:58 PM, (user: mbradley)
//*>


#pragma once

#include "sink_model.h"
#include "cb_throuple.h"

using namespace tlm;

//This class inherits from the sink_pv_base class
class sink_pv : public sink_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(sink_pv);
  sink_pv(sc_core::sc_module_name module_name);   
  ~sink_pv();

 protected:
  ////////////////////////////////////////
  // target ports read callbacks
  //////////////////////////////////////// 
  bool s0_callback_read(mb_address_type address, unsigned char* data, unsigned size);
  bool s1_callback_read(mb_address_type address, unsigned char* data, unsigned size);
  bool s2_callback_read(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned s0_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size);
  unsigned s1_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size); 
  unsigned s2_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size); 

 protected:
  ////////////////////////////////////////
  // target ports write callbacks
  //////////////////////////////////////// 
  
  unsigned s0_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size);
  bool s0_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData); 
  bool s0_callback_write(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned s1_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size);
  bool s1_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData); 
  bool s1_callback_write(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned s2_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size);
  bool s2_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData);   
  bool s2_callback_write(mb_address_type address, unsigned char* data, unsigned size);

  unsigned startCompare;
  transQuple_t storeTrans;
  int compare(sc_time t0, mb_address_type a0, unsigned char* d0, unsigned s0, sc_time t1, mb_address_type a1, unsigned char* d1, unsigned s1);
  int err;

};

