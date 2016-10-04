
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
#include "e5500_model.h"

class e5500_pv : public ::mb::models::ppc::e5500<32>,
                      public e5500_pv_base_parameters {

 public:
  e5500_pv(sc_module_name module_name) 
    : ::mb::models::ppc::e5500<32>(module_name),
    e5500_pv_base_parameters(this)
  {
  }
};
