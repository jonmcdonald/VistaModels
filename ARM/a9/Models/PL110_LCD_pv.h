
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

class PL110_LCD_pv : public mb::models::arm::pl11x {

 public:
  PL110_LCD_pv(sc_module_name module_name)
    : ::mb::models::arm::pl11x(module_name)
  {
  }
};
