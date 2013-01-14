
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
//* This file contains the PV class for SuperFIFO.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.5.0_RedSeaDemo
//* Generated on: Sep. 26, 2012 01:26:54 PM, (user: jon)
//* Automatically merged on: Oct. 02, 2012 12:27:12 PM, (user: jon)
//* Automatically merged on: Jan. 03, 2013 02:41:39 PM, (user: jon)
//* Automatically merged on: Jan. 04, 2013 12:29:30 PM, (user: jon)
//*>


#pragma once

#include "SuperFIFO_model.h"
#include <queue>

using namespace tlm;

//This class inherits from the SuperFIFO_pv_base class
class SuperFIFO_pv : public SuperFIFO_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(SuperFIFO_pv);
  SuperFIFO_pv(sc_core::sc_module_name module_name); 

 protected:
  ////////////////////////////////////////
  // read callbacks of registers
  ////////////////////////////////////////// 
  unsigned int cb_read_d();
  unsigned int cb_read_status();
  unsigned int cb_read_clrIRQ(); 
  
 protected:
  /////////////////////////////////////////
  // write callbacks of registers
  ////////////////////////////////////////// 
  void cb_write_d(unsigned int newValue);
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

  queue<unsigned int> m_fifo;
};

