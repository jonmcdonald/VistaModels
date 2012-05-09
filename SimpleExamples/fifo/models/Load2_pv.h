
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
//* This file contains the PV class for Load2.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.0.1.beta1
//* Generated on: Mar. 26, 2010 09:17:47 AM, (user: jon)
//* Automatically merged on: Jul. 02, 2010 02:43:32 PM, (user: jon)
//* Automatically merged on: Feb. 03, 2011 04:11:51 PM, (user: jon)
//* Automatically merged on: Mar. 07, 2011 10:05:21 AM, (user: jon)
//* Automatically merged on: Jan. 24, 2012 07:43:18 AM, (user: jon)
//*>


#pragma once
#include "Load2_model.h"
#include "datastruct.h"

using namespace tlm;

//This class inherits from the Load2_pv_base class
class Load2_pv : public Load2_pv_base {

 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(Load2_pv);
  Load2_pv(sc_module_name module_name);

 protected:
  // SC_THREAD created for CPU
  void thread();    
  void threadP0();    
  void threadP1();    

  sc_event SentEv, P0DataEv, P1DataEv;
  unsigned int Count;
  sc_time lastSentTime, dtime;
  tlm::tlm_fifo< datastruct * > P0, P1 ;

  datastruct *data0, *data1;

  mb::mb_token_ptr token0;
  mb::mb_token_ptr token1;
};

