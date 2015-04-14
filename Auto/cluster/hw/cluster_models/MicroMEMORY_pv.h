
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
#include "MicroMEMORY_model.h"

class MicroMEMORY_pv : public MicroMEMORY_base1_pv {
public:
  MicroMEMORY_pv(sc_module_name module_name)
    : MicroMEMORY_base1_pv(module_name) {
  }
};
