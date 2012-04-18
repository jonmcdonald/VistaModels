
#pragma once

#include <systemc>
#include <string>
#include "tlm.h"

using namespace std;
using namespace tlm;
using namespace sc_core;
using namespace sc_dt;

#define XBAR_LT_NUMBER 2

// Prevent warning message for thread with non-unique name
#define SC_THREAD_NAME(func, name)                   \
    declare_thread_process( func ## _handle,         \
                            name,                    \
                            SC_CURRENT_USER_MODULE,  \
                            func )

template <unsigned int BUSWIDTH = 32>
class xbar_lt : public sc_module {
 public:

  tlm_target_socket<BUSWIDTH> i0;
  tlm_target_socket<BUSWIDTH> i1;
  tlm_initiator_socket<BUSWIDTH> o0;
  tlm_initiator_socket<BUSWIDTH> o1;

  SC_HAS_PROCESS(xbar_lt);
  xbar_lt(sc_module_name name):
    sc_module(name), 
    my_id(0), o_id(0), i_id(0)
  {
    ostringstream ostr;
    fifo_fw = new tlm_fifo<xbarObjT*>[XBAR_LT_NUMBER];
    fifo_bw = new tlm_fifo<tlm_generic_payload*>[XBAR_LT_NUMBER];

    in_sockets[0]  = &i0;
    in_sockets[1]  = &i1;
    out_sockets[0] = &o0;
    out_sockets[1] = &o1;

    in_if_obj  = new fw_if_i* [XBAR_LT_NUMBER];
    out_if_obj = new bw_if_o* [XBAR_LT_NUMBER];

    for (int i=0; i<XBAR_LT_NUMBER; i++) {
      ostr.str(""); ostr << "thread_" << i;
      SC_THREAD_NAME(thread, ostr.str().c_str());

      fifo_fw[i].nb_expand(XBAR_LT_NUMBER-1);

      in_if_obj[i] = new fw_if_i(this, i);
      out_if_obj[i] = new bw_if_o(this, i);

      in_sockets[i]->bind(*in_if_obj[i]);
      out_sockets[i]->bind(*out_if_obj[i]);
    }
  }

  void thread() {
    int myId = my_id++;
    tlm_base_protocol_types::tlm_payload_type trans;
    sc_time t;

    for(;;) {
      xbarObjT *obj = fifo_fw[myId].get();
      trans.deep_copy_from(*(obj->trans));
    
      if (trans.get_address() == uint64(0x0))
         (*out_sockets[0])->b_transport(trans, t);
      else
         (*out_sockets[1])->b_transport(trans, t);

      obj->trans->update_original_from(trans);
      fifo_bw[obj->bwId].put(obj->trans);
    }

  }

 private:
  int my_id, o_id, i_id;

  typedef struct {
      int bwId; 
      tlm_base_protocol_types::tlm_payload_type* trans;
  } xbarObjT;

  class bw_if_o: public tlm_bw_transport_if<tlm_base_protocol_types> {
   public:
    bw_if_o(xbar_lt *p, int id) : parent(p), id(id) {}
    tlm_sync_enum nb_transport_bw(tlm_generic_payload &payload, tlm_phase &ph, sc_time &t) {
      return TLM_COMPLETED;
    }

    void invalidate_direct_mem_ptr(uint64 start, uint64 end) {}

   private:
    xbar_lt *parent;
    int id;
  } **out_if_obj;

  class fw_if_i: public tlm_fw_transport_if<tlm_base_protocol_types> {
   public:
    fw_if_i(xbar_lt *p, int id): parent(p), id(id) {}

    void b_transport(tlm_generic_payload &payload, sc_time &t) {
      cout << "xbar_lt::fw_i::b_transport called at " << sc_time_stamp() << endl;
      xbarObjT *objptr;
      objptr = new xbarObjT;
      objptr->bwId = id;
      objptr->trans = &payload;
      if      (id == 0) {
        parent->fifo_fw[0].put(objptr); 
        parent->fifo_bw[id].get();}
      else if (id == 1) {
        parent->fifo_fw[1].put(objptr);
        parent->fifo_bw[id].get();}
    }

    tlm_sync_enum nb_transport_fw(tlm_generic_payload &payload, tlm_phase &ph, sc_time &t) {
      return TLM_COMPLETED;
    }

    bool get_direct_mem_ptr(tlm_generic_payload &payload, tlm_dmi &dmi_data) {
      return false;
    }

    unsigned int transport_dbg(tlm::tlm_generic_payload &payload) {
      cout << "target_lt::transport_dbg called" << endl;
      return 0;
    }

    xbar_lt *parent;
    int id;
  } **in_if_obj;

  tlm_target_socket<BUSWIDTH>* in_sockets[XBAR_LT_NUMBER];
  tlm_initiator_socket<BUSWIDTH>* out_sockets[XBAR_LT_NUMBER];

  tlm_fifo<xbarObjT*> *fifo_fw;
  tlm_fifo<tlm_generic_payload*> *fifo_bw;

  typedef bool (xbar_lt::*fptrType)(tlm_base_protocol_types::tlm_payload_type&);
  fptrType *fptrs;

  void in2out(tlm_base_protocol_types::tlm_payload_type& trans, int inId);
};

