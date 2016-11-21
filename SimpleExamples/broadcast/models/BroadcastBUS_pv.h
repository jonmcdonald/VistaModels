
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
#include "BroadcastBUS_model.h"

class BroadcastBUS_pv : public BroadcastBUS_base1_pv {
public:
  BroadcastBUS_pv(sc_module_name module_name)
    : BroadcastBUS_base1_pv(module_name) {
  }
};
