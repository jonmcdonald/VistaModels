
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

#pragma once

#include "model_builder.h"
#include "M3_model.h"


class M3_pv : public ::mb::models::arm::cortex_m3,
                      public M3_pv_base_parameters {
  
 public:
  typedef mb::tlm20::irq_target_socket<> irq_target_socket;


  mb::tlm20::irq_target_socket<>& irq_0;
  mb::tlm20::irq_target_socket<>& irq_1;
  mb::tlm20::irq_target_socket<>& irq_2;
  mb::tlm20::irq_target_socket<>& irq_3;
  mb::tlm20::irq_target_socket<>& irq_4;
  mb::tlm20::irq_target_socket<>& irq_5;
  mb::tlm20::irq_target_socket<>& irq_6;
  mb::tlm20::irq_target_socket<>& irq_7;

 public:
  M3_pv(sc_module_name name)  : 
    ::mb::models::arm::cortex_m3(name, 8),
    M3_pv_base_parameters(this)
, irq_0(irqs[0]), irq_1(irqs[1]), irq_2(irqs[2]), irq_3(irqs[3]), irq_4(irqs[4]), irq_5(irqs[5]), irq_6(irqs[6]), irq_7(irqs[7])
  {
  }
};
