
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
//* This file contains the PV class for drive.
//* This is a template file: You may modify this file to implement the 
//* behavior of your component. 
//* 
//* Model Builder version: 3.8.0
//* Generated on: Sep. 23, 2014 09:34:54 AM, (user: jon)
//*>


#include "drive_pv.h"
#include <iostream>
#define GPIO_DATA_0 0x0
#define GPIO_DATA_1 0x8
#define GPIO_TRI_0  0x4
#define GPIO_TRI_1  0xC
#define GIER        0x11C
#define IP_IER      0x128
#define IP_ISR      0x120

//constructor
drive_pv::drive_pv(sc_module_name module_name) 
  : drive_pv_base(module_name) {
   SC_THREAD(thread);
} 

// This thread can be used to generate outgoing transactions
void drive_pv::thread() {

  // Set data 0 as output, data 1 as input
  m_write(GPIO_TRI_0, 0x0);
  m_write(GPIO_TRI_1, 0xFFFFFFFF);
  m_write(GPIO_DATA_0, 0x0);
  m_write(GIER, 0x80000000);
  m_write(IP_IER, 0x2);

/*
  wait(1, SC_SEC);
  m_write(GPIO_DATA_0, 0x1);
  wait(1, SC_SEC);
  m_write(GPIO_DATA_0, 0x2);
  wait(1, SC_SEC);
  m_write(GPIO_DATA_0, 0x4);
  wait(1, SC_SEC);
  m_write(GPIO_DATA_0, 0x8);
  wait(1, SC_SEC);
  m_write(GPIO_DATA_0, 0x0);
*/
  wait(20, SC_SEC);
}   

// callback for any change in signal: irq of type: sc_in<bool>
void drive_pv::irq_callback() {
  unsigned int i, d;
  m_read(IP_ISR, i);

  if (i & 0x2) {
    m_read(GPIO_DATA_1, d);
    m_write(GPIO_DATA_0, d);
    m_write(IP_ISR, 0x2);
  }
}

