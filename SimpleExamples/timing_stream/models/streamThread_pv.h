
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
//* This file contains the PV class for streamThread.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.2.0RC
//* Generated on: Feb. 23, 2012 08:28:55 AM, (user: jon)
//* Automatically merged on: Feb. 25, 2012 01:05:50 PM, (user: jon)
//* Automatically merged on: Feb. 25, 2012 01:12:23 PM, (user: jon)
//* Automatically merged on: Jun. 12, 2012 08:36:49 AM, (user: jon)
//*>


#pragma once

#include "streamThread_model.h"
#include "datastruct.h"
#include <queue>

using namespace tlm;

//This class inherits from the streamThread_pv_base class
class streamThread_pv : public streamThread_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(streamThread_pv);
  streamThread_pv(sc_core::sc_module_name module_name);   

  void thread();

 protected:
  ////////////////////////////////////////
  // target ports read callbacks
  ////////////////////////////////////////  
  bool slave_a_callback_read(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned slave_a_callback_read_dbg(mb_address_type address, unsigned char* data, unsigned size);  

 protected:
  ////////////////////////////////////////
  // target ports write callbacks
  ////////////////////////////////////////  
  bool slave_a_callback_write(mb_address_type address, unsigned char* data, unsigned size);
  
  unsigned slave_a_callback_write_dbg(mb_address_type address, unsigned char* data, unsigned size);  
  bool slave_a_get_direct_memory_ptr(mb_address_type address, tlm::tlm_dmi& dmiData);   

  tlm::tlm_fifo< datastruct *> fifo;
  queue<sc_time> pipeInTimeQ;
  mb::mb_event inputDoneEv;
};

