
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
#include "CORTEX_A9_uni_model.h"



class CORTEX_A9_uni_pv : public ::mb::models::arm::cortex_a9up<64>,
                      public CORTEX_A9_uni_pv_base_parameters{
  
 public:
  CORTEX_A9_uni_pv(sc_module_name module_name) 
    : ::mb::models::arm::cortex_a9up<64>(module_name),
    CORTEX_A9_uni_pv_base_parameters(this) {
  }
};
