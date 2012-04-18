#ifndef _TARGET_LT_H_
#define _TARGET_LT_H_

#include <systemc>
#include "tlm.h"

using namespace sc_core;
using namespace std;

class target_lt
  :public sc_module, private tlm::tlm_fw_transport_if<tlm::tlm_base_protocol_types> 
{
public:
  tlm::tlm_target_socket<32, tlm::tlm_base_protocol_types, 1> t;

  target_lt (sc_module_name name) : sc_module(name)
  { 
    t(*this);
  }

  ~target_lt() {}

  void b_transport(tlm::tlm_generic_payload& payload, sc_time &t)
  {
    cout << "target_lt::b_transport called at " << sc_time_stamp() << endl;
  }

  tlm::tlm_sync_enum nb_transport_fw
	(tlm::tlm_generic_payload& payload, tlm::tlm_phase& ph, sc_time& t)
  {
    cout << "target_lt::nb_transport_fw called" << endl;
    return tlm::TLM_COMPLETED;
  }

  bool get_direct_mem_ptr(tlm::tlm_generic_payload &payload, tlm::tlm_dmi &dmi_data) 
  {
     return 0;
  }

  unsigned int transport_dbg(tlm::tlm_generic_payload &payload) {
    cout << "target_lt::transport_dbg called" << endl;
    return 0;
  }

};

#endif
