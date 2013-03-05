
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


class MC_CM3_pv : public ::mb::models::arm::cortex_m3 {
  
 public:
  typedef mb::tlm20::irq_target_socket<> irq_target_socket;



 public:
  MC_CM3_pv(sc_module_name name)  : 
    ::mb::models::arm::cortex_m3(name, 0)

  {
  }
};
