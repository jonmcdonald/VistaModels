
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


#include "ahb2apb_pv.h"
#include <iostream>



ahb2apb_pv::ahb2apb_pv(sc_module_name module_name) 
  : ahb2apb_pv_base(module_name) {
} 

ahb2apb_pv::~ahb2apb_pv() {

}


bool ahb2apb_pv::slave_1_callback_read(config::uint64 address, unsigned char* data, unsigned size) {
  
  unsigned master_port = route(slave_1_idx, address);
  switch (master_port) {
  case master_1_idx:
    return master_1_read(address, data, size);
    break;
  }
  return false;
}


bool ahb2apb_pv::slave_1_callback_write(config::uint64 address, unsigned char* data, unsigned size) {
  
  unsigned master_port = route(slave_1_idx, address);
  switch (master_port) {
  case master_1_idx:
    return master_1_write(address, data, size);
    break;
  }
  return false;
}



/* the route function will return a master port index based on the
   slave port index "target_port" and the corresponding "address" */
/* the port index is defined as : <port_name>_idx */

unsigned ahb2apb_pv::route(unsigned target_port, config::uint64 address) { 

  return master_1_idx;
}



unsigned ahb2apb_pv::slave_1_callback_read_dbg(config::uint64 address, unsigned char* data, unsigned size) {
  unsigned master_port = route(slave_1_idx, address);
  switch (master_port) {
  case master_1_idx:
    return master_1_read_dbg(address, data, size);
    break;
  }
  return 0;
}

unsigned ahb2apb_pv::slave_1_callback_write_dbg(config::uint64 address, unsigned char* data, unsigned size) {
  unsigned master_port = route(slave_1_idx, address);
  switch (master_port) {
  case master_1_idx:
    return master_1_write_dbg(address, data, size);
    break;
  }
  return 0;
}

bool ahb2apb_pv::slave_1_get_direct_memory_ptr_callback(tlm::tlm_base_protocol_types::tlm_payload_type& trans, tlm::tlm_dmi& dmiData) {
  
  unsigned master_port = route(slave_1_idx, trans.get_address());
  switch (master_port) {
  case master_1_idx:
    return master_1->get_direct_mem_ptr(trans, dmiData);
    
    break;
  }
  return false;
}

 

