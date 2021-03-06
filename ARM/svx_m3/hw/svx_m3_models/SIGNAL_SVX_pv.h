
/**************************************************************/
/*                                                            */
/*      Copyright Mentor Graphics Corporation 2006 - 2015     */
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
//* This file contains the PV class for SIGNAL_SVX.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 4.2.1
//* Generated on: Nov. 18, 2016 03:22:15 PM, (user: markca)
//*>


#pragma once

#include "SIGNAL_SVX_model.h"

using namespace tlm;

//This class inherits from the SIGNAL_SVX_pv_base class
class SIGNAL_SVX_pv : public SIGNAL_SVX_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(SIGNAL_SVX_pv);
  SIGNAL_SVX_pv(sc_core::sc_module_name module_name);        

 protected:
  ////////////////////////////////////////
  // signals callbacks
  //////////////////////////////////////// 
  void slave_callback(); 

  bool cycle;
  sc_time last_on;
  sc_time last_off;
  sc_time freq_t;
  double dc;
  uint32_t freq;
};

