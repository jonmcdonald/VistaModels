
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
//* This file contains the PV class for CEMDriver.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 4.1beta2
//* Generated on: Apr. 28, 2015 09:59:38 AM, (user: jon)
//*>



#include "CEMDriver_pv.h"
#include "MemoryMap.h"
#include <iostream>

using namespace sc_core;
using namespace sc_dt;
using namespace std;

//constructor
CEMDriver_pv::CEMDriver_pv(sc_module_name module_name) 
  : CEMDriver_pv_base(module_name) {
}    

 

// callback for any change in signal: propRXI of type: sc_in<bool>
void CEMDriver_pv::propRXI_callback() {
  unsigned s;
  unsigned id;
  unsigned char d[9];
  if (propRXI.read() == 1) {
    propB_write(CAN_ACK, 0);
    propB_read(CAN_RXSIZE, s);
    propB_read(CAN_RXIDENT, id);
    if (s > 0)
      propB_read(CAN_RXDATA, d, s);

    if (id == ACCELERATORID && s > 0) {
      bodyB_write(CAN_DATA, d, s);
      bodyB_write(CAN_SIZE, s);
      bodyB_write(CAN_IDENT, id);
      chassisB_write(CAN_DATA, d, s);
      chassisB_write(CAN_SIZE, s);
      chassisB_write(CAN_IDENT, id);
    }
  }
}

// callback for any change in signal: chassisRXI of type: sc_in<bool>
void CEMDriver_pv::chassisRXI_callback() {
  unsigned s;
  unsigned id;
  unsigned char d[9];
  if (chassisRXI.read() == 1) {
    chassisB_write(CAN_ACK, 0);
    chassisB_read(CAN_RXSIZE, s);
    chassisB_read(CAN_RXIDENT, id);
    if (s > 0)
      chassisB_read(CAN_RXDATA, d, s);

    if (id == BRAKEID && s > 0) {
      propB_write(CAN_DATA, d, s);
      propB_write(CAN_SIZE, s);
      propB_write(CAN_IDENT, id);
    }
  }
}

// callback for any change in signal: bodyRXI of type: sc_in<bool>
void CEMDriver_pv::bodyRXI_callback() {
}