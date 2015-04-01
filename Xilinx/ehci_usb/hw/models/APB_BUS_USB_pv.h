
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
#include "APB_BUS_USB_model.h"

class APB_BUS_USB_pv : public APB_BUS_USB_base1_pv {
public:
  APB_BUS_USB_pv(sc_module_name module_name)
    : APB_BUS_USB_base1_pv(module_name) {
  }
};
