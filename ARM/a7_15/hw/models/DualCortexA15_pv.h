
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
#include "DualCortexA15_model.h"


class DualCortexA15_pv : public ::mb::models::arm::cortex_a15mp<64>,
                      public DualCortexA15_pv_base_parameters {

 public:
  typedef ::mb::models::arm::cortex_a15mp<64> base_class;
  
  mb::tlm20::signal_in_socket<>& n_irq_0;
  mb::tlm20::signal_in_socket<>& n_fiq_0;
  mb::tlm20::signal_in_socket<>& n_reset_0;
  mb::tlm20::signal_in_socket<>& eventi_0;
  mb::tlm20::signal_in_socket<>& n_irq_1;
  mb::tlm20::signal_in_socket<>& n_fiq_1;
  mb::tlm20::signal_in_socket<>& n_reset_1;
  mb::tlm20::signal_in_socket<>& eventi_1;
  mb::tlm20::signal_in_socket<>& irq_0;
  mb::tlm20::signal_in_socket<>& irq_1;
  mb::tlm20::signal_in_socket<>& irq_2;
  mb::tlm20::signal_in_socket<>& irq_3;
  mb::tlm20::signal_in_socket<>& irq_4;
  mb::tlm20::signal_in_socket<>& irq_5;
  mb::tlm20::signal_in_socket<>& irq_6;
  mb::tlm20::signal_in_socket<>& irq_7;
  mb::tlm20::signal_in_socket<>& irq_8;
  mb::tlm20::signal_in_socket<>& irq_9;
  mb::tlm20::signal_in_socket<>& irq_10;
  mb::tlm20::signal_in_socket<>& irq_11;
  mb::tlm20::signal_in_socket<>& irq_12;
  mb::tlm20::signal_in_socket<>& irq_13;
  mb::tlm20::signal_in_socket<>& irq_14;
  mb::tlm20::signal_in_socket<>& irq_15;
  mb::tlm20::signal_in_socket<>& irq_16;
  mb::tlm20::signal_in_socket<>& irq_17;
  mb::tlm20::signal_in_socket<>& irq_18;
  mb::tlm20::signal_in_socket<>& irq_19;
  mb::tlm20::signal_in_socket<>& irq_20;
  mb::tlm20::signal_in_socket<>& irq_21;
  mb::tlm20::signal_in_socket<>& irq_22;
  mb::tlm20::signal_in_socket<>& irq_23;
  mb::tlm20::signal_in_socket<>& irq_24;
  mb::tlm20::signal_in_socket<>& irq_25;
  mb::tlm20::signal_in_socket<>& irq_26;
  mb::tlm20::signal_in_socket<>& irq_27;
  mb::tlm20::signal_in_socket<>& irq_28;
  mb::tlm20::signal_in_socket<>& irq_29;
  mb::tlm20::signal_in_socket<>& irq_30;
  mb::tlm20::signal_in_socket<>& irq_31;
  mb::tlm20::signal_out_socket<>& pmu_irq_0;
  mb::tlm20::signal_out_socket<>& standbywfi_0;
  mb::tlm20::signal_out_socket<>& standbywfe_0;
  mb::tlm20::signal_out_socket<>& evento_0;
  mb::tlm20::signal_out_socket<>& pmu_irq_1;
  mb::tlm20::signal_out_socket<>& standbywfi_1;
  mb::tlm20::signal_out_socket<>& standbywfe_1;
  mb::tlm20::signal_out_socket<>& evento_1;

 public:
  DualCortexA15_pv(sc_module_name module_name) 
    : ::mb::models::arm::cortex_a15mp<64>(module_name, 2, 32,
                                                  1, 1, 0),
    DualCortexA15_pv_base_parameters(this),
    n_irq_0(n_irq[0]),
    n_fiq_0(n_fiq[0]),
    n_reset_0(n_reset[0]),
    eventi_0(eventi[0]),
    n_irq_1(n_irq[1]),
    n_fiq_1(n_fiq[1]),
    n_reset_1(n_reset[1]),
    eventi_1(eventi[1]),
    irq_0(irq[0]),
    irq_1(irq[1]),
    irq_2(irq[2]),
    irq_3(irq[3]),
    irq_4(irq[4]),
    irq_5(irq[5]),
    irq_6(irq[6]),
    irq_7(irq[7]),
    irq_8(irq[8]),
    irq_9(irq[9]),
    irq_10(irq[10]),
    irq_11(irq[11]),
    irq_12(irq[12]),
    irq_13(irq[13]),
    irq_14(irq[14]),
    irq_15(irq[15]),
    irq_16(irq[16]),
    irq_17(irq[17]),
    irq_18(irq[18]),
    irq_19(irq[19]),
    irq_20(irq[20]),
    irq_21(irq[21]),
    irq_22(irq[22]),
    irq_23(irq[23]),
    irq_24(irq[24]),
    irq_25(irq[25]),
    irq_26(irq[26]),
    irq_27(irq[27]),
    irq_28(irq[28]),
    irq_29(irq[29]),
    irq_30(irq[30]),
    irq_31(irq[31]),
    pmu_irq_0(pmu_irq[0]),
    standbywfi_0(standbywfi[0]),
    standbywfe_0(standbywfe[0]),
    evento_0(evento[0]),
    pmu_irq_1(pmu_irq[1]),
    standbywfi_1(standbywfi[1]),
    standbywfe_1(standbywfe[1]),
    evento_1(evento[1])
  {
  }

};
