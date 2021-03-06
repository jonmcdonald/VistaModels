
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
//* This file contains the PV class for RadioDriver.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.9.0
//* Generated on: Mar. 31, 2015 03:10:09 PM, (user: jon)
//* Automatically merged on: May. 07, 2015 01:44:00 PM, (user: markca)
//* Automatically merged on: May. 07, 2015 03:27:52 PM, (user: markca)
//*>


#pragma once

#include "RadioDriver_model.h"

using namespace tlm;

//This class inherits from the RadioDriver_pv_base class
class RadioDriver_pv : public RadioDriver_pv_base {
 public:
  typedef esl::tlm_types::Address mb_address_type;
 public:
  // Constructor
  // Do not add parameters here.
  // To add parameters - use the Model Builder form (under PV->Parameters tab)
  SC_HAS_PROCESS(RadioDriver_pv);
  RadioDriver_pv(sc_core::sc_module_name module_name);       

 protected:
  ////////////////////////////////////////
  // signals callbacks
  //////////////////////////////////////// 
  void rxi_callback(); 
};

