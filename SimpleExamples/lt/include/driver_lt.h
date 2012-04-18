#ifndef _DRIVER_LT_H_
#define _DRIVER_LT_H_

#include <systemc>
#include "tlm.h"

using namespace sc_core;
using namespace std;

class driver_lt
  :public sc_module, public tlm::tlm_bw_transport_if<tlm::tlm_base_protocol_types> 
{
public:
  tlm::tlm_initiator_socket<32, tlm::tlm_base_protocol_types, 1> d;

  void driverThread() 
  {
    sc_time tDelay = SC_ZERO_TIME;
    tlm::tlm_generic_payload payload;
    sc_dt::uint64 addr(0x0);
    unsigned char data[10] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};

    payload.set_address(addr);
    payload.set_data_ptr(data);
    payload.set_data_length(4);
    payload.set_write();

    for (int i = 0; i < 10; i++) {
      wait (1, SC_NS);
      data[0] = (unsigned char) i;
      d->b_transport(payload, tDelay);
    }

    wait (100, SC_NS);
    cout << "Done" << endl;
  }

  SC_HAS_PROCESS(driver_lt);

  driver_lt (sc_module_name name) : sc_module(name)
  {
    d(*this);
    SC_THREAD(driverThread);
  }

  ~driver_lt() {}

  tlm::tlm_sync_enum 
    nb_transport_bw(tlm::tlm_generic_payload& payload, tlm::tlm_phase& ph, sc_time& t)
  {
    return tlm::TLM_COMPLETED;
  }

  void invalidate_direct_mem_ptr(sc_dt::uint64 start, sc_dt::uint64 end)
  { }

};

#endif
