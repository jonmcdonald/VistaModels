
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
//* This file contains the PV class for rijndael.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.5.1
//* Generated on: Feb. 13, 2013 01:45:51 PM, (user: jon)
//*>


#pragma once

#include "rijndael_model.h"
#include "Rijndael.h"

using namespace tlm;

//This class inherits from the rijndael_pv_base class
class rijndael_pv : public rijndael_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(rijndael_pv);
  rijndael_pv(sc_core::sc_module_name module_name); 

  void thread();

 protected:
  ////////////////////////////////////////
  // read callbacks of registers
  ////////////////////////////////////////// 
  unsigned int cb_read_status();
  unsigned int cb_read_clrIRQ(); 
  
 protected:
  /////////////////////////////////////////
  // write callbacks of registers
  ////////////////////////////////////////// 
  void cb_write_status(unsigned int newValue);
  void cb_write_clrIRQ(unsigned int newValue); 

 protected:
  ////////////////////////////////////////
  // target ports read callbacks
  //////////////////////////////////////// 
  bool s_callback_read(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned s_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size); 

 protected:
  ////////////////////////////////////////
  // target ports write callbacks
  //////////////////////////////////////// 
  bool s_callback_write(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned s_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size); 
  bool s_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData);   
  CRijndael oRijndael;

  sc_event status_e;
};

