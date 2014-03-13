
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
#include "A9x1_model.h"


class A9x1_pv : public ::mb::models::arm::cortex_a9mp<64>,
                      public A9x1_pv_base_parameters {

 public:

  mb::tlm20::signal_in_socket<>& n_irq_0;
  mb::tlm20::signal_in_socket<>& n_fiq_0;
  mb::tlm20::signal_in_socket<>& n_reset_0;
  mb::tlm20::signal_in_socket<>& n_wd_reset_0;
  mb::tlm20::signal_in_socket<>& eventi_0;
  mb::tlm20::signal_in_socket<>& irq_0;
  mb::tlm20::signal_in_socket<>& irq_1;
  mb::tlm20::signal_in_socket<>& irq_2;
  mb::tlm20::signal_in_socket<>& irq_3;
  mb::tlm20::signal_in_socket<>& irq_4;
  mb::tlm20::signal_in_socket<>& irq_5;
  mb::tlm20::signal_in_socket<>& irq_6;
  mb::tlm20::signal_in_socket<>& irq_7;
  mb::tlm20::signal_out_socket<>& wd_reset_req_0;
  mb::tlm20::signal_out_socket<>& pmu_irq_0;
  mb::tlm20::signal_out_socket<>& standbywfi_0;
  mb::tlm20::signal_out_socket<>& standbywfe_0;
  mb::tlm20::signal_out_socket<>& evento_0;
  
 public:
  A9x1_pv(sc_module_name module_name) 
    : ::mb::models::arm::cortex_a9mp<64>(module_name, 1, 8, 1),
    A9x1_pv_base_parameters(this),
    n_irq_0(n_irq[0]),
    n_fiq_0(n_fiq[0]),
    n_reset_0(n_reset[0]),
    n_wd_reset_0(n_wd_reset[0]),
    eventi_0(eventi[0]),
    irq_0(irq[0]),
    irq_1(irq[1]),
    irq_2(irq[2]),
    irq_3(irq[3]),
    irq_4(irq[4]),
    irq_5(irq[5]),
    irq_6(irq[6]),
    irq_7(irq[7]),
    wd_reset_req_0(wd_reset_req[0]),
    pmu_irq_0(pmu_irq[0]),
    standbywfi_0(standbywfi[0]),
    standbywfe_0(standbywfe[0]),
    evento_0(evento[0])
  {
  }

};
