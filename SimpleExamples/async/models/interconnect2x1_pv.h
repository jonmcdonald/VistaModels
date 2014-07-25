
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
#include "interconnect2x1_model.h"

class interconnect2x1_pv : public interconnect2x1_base1_pv {

public:
  interconnect2x1_pv(sc_module_name module_name)
    : interconnect2x1_base1_pv(module_name) {
  }

public:
  /* the route function will return a master port index based on the
     slave port index "target_port" and the corresponding "address"
     the port index is defined as : <port_name>_idx */
  virtual unsigned route(unsigned slave_port, config::uint64 address) {
    return interconnect2x1_base1_pv::route(slave_port, address);
  }
};
