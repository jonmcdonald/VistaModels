
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

#include "ahb2apb_model.h"
#include "model_builder.h"

using namespace tlm;

class ahb2apb_pv : public ahb2apb_pv_base {

 public:
  SC_HAS_PROCESS(ahb2apb_pv);
  ahb2apb_pv(sc_module_name module_name);
  ~ahb2apb_pv();

 
 
  ///////////////////////////////
  // target read callbacks
  /////////////////////////////// 
 public: 
  virtual bool slave_1_callback_read(config::uint64 address, unsigned char* data, unsigned size);
  virtual unsigned slave_1_callback_read_dbg(config::uint64 address, unsigned char* data, unsigned size); 

  ///////////////////////////////
  // target write callbacks
  /////////////////////////////// 
 public: 
  virtual bool slave_1_callback_write(config::uint64 address, unsigned char* data, unsigned size);
  virtual unsigned slave_1_callback_write_dbg(config::uint64 address, unsigned char* data, unsigned size);
  virtual bool slave_1_get_direct_memory_ptr_callback(tlm::tlm_base_protocol_types::tlm_payload_type& trans, tlm::tlm_dmi& dmiData);


  //virtual void master_1_invalidate_direct_mem_ptr_callback(sc_dt::uint64 start_range, sc_dt::uint64 end_range);

 public:
  unsigned route(unsigned slave_port, config::uint64 address);  
};

