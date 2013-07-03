
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

#pragma once

#include "model_builder.h"


class CORTEX_M3_pv : public ::mb::models::arm::cortex_m3 {
  
 public:
  typedef mb::tlm20::irq_target_socket<> irq_target_socket;


  mb::tlm20::irq_target_socket<>& irq_0;
  mb::tlm20::irq_target_socket<>& irq_1;

 public:
  CORTEX_M3_pv(sc_module_name name)  : 
    ::mb::models::arm::cortex_m3(name, 2)
, irq_0(irqs[0]), irq_1(irqs[1])
  {
  }
};
