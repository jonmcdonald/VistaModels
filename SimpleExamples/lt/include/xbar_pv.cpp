
#include "xbar_lt.h"
#include <iostream>

using namespace std;

// Prevent warning message for thread with non-unique name
#define SC_THREAD_NAME(func, name)                   \
    declare_thread_process( func ## _handle,         \
                            name,                    \
                            SC_CURRENT_USER_MODULE,  \
                            func )

//constructor
xbar_lt::xbar_lt(sc_module_name module_name) 
  : xbar_lt(module_name), m_id(0)
{
  ostringstream ostr;
  fifo_fw = new tlm_fifo<transDT*>[WIDTH];
  fifo_bw = new tlm_fifo<tlm_generic_payload*>[WIDTH];

  for (int i=0; i<WIDTH; i++) {
    ostr.str(""); ostr << "thread_" << i;
    SC_THREAD_NAME(thread, ostr.str().c_str());
    fifo_fw[i].nb_expand(WIDTH-1);
  }
  fptr = &xbar_lt::o0_transport;

  fptrs = new fptrType[WIDTH];
  fptrs[0] = &xbar_lt::o0_transport;
}    

void xbar_lt::thread() {
  int myId = m_id++;

  for(;;) {
    transDT *transdtobj = fifo_fw[myId].get();
    //tlm::tlm_base_protocol_types::tlm_payload_type *trans = \
    //      new tlm::tlm_base_protocol_types::tlm_payload_type;
    //trans->deep_copy_from(*(transdtobj->trans));
    //(*this.*(fptrs[myId]))(*trans);
    //(*this.*(fptrs[myId]))(*trans);

    tlm::tlm_generic_payload* trans = mb::tlm20::get_object_pull().new_payload();
    //trans->deep_copy_from(*(transdtobj->trans));
    trans->set_streaming_width(0);
    
    mb::tlm20::do_b_transport(*o0[0], *trans, transdtobj->trans->get_command(),
                                          transdtobj->trans->get_address(),
                                          transdtobj->trans->get_data_ptr(), 
                                          transdtobj->trans->get_data_length());

    transdtobj->trans->update_original_from(*trans);
    fifo_bw[transdtobj->bwId].put(transdtobj->trans);
    trans->release();
  }
}

void xbar_lt::in2out(tlm::tlm_base_protocol_types::tlm_payload_type& trans, int inId) {
  sc_dt::uint64 address = trans.get_address();
  int targetId = (address >> 8) % WIDTH;
  transDT transdtobj;
  transdtobj.bwId = inId;
  transdtobj.trans = &trans;
  fifo_fw[targetId].put(&transdtobj);
  fifo_bw[inId].get();  
}

#define I_CALLBACK(callback, number)                                            \
  void xbar_lt::callback(tlm::tlm_base_protocol_types::tlm_payload_type& trans, \
                          sc_core::sc_time& t) {                                \
       in2out(trans, number); }                                                 \

I_CALLBACK(i0_callback, 0)
I_CALLBACK(i1_callback, 1)
I_CALLBACK(i2_callback, 2)
I_CALLBACK(i3_callback, 3)
I_CALLBACK(i4_callback, 4)
I_CALLBACK(i5_callback, 5)
I_CALLBACK(i6_callback, 6)
I_CALLBACK(i7_callback, 7)
I_CALLBACK(i8_callback, 8)
I_CALLBACK(i9_callback, 9)
I_CALLBACK(i10_callback, 10)
I_CALLBACK(i11_callback, 11)
I_CALLBACK(i12_callback, 12)
I_CALLBACK(i13_callback, 13)
I_CALLBACK(i14_callback, 14)
I_CALLBACK(i15_callback, 15)
I_CALLBACK(i16_callback, 16)
I_CALLBACK(i17_callback, 17)
I_CALLBACK(i18_callback, 18)
I_CALLBACK(i19_callback, 19)
I_CALLBACK(i20_callback, 20)
I_CALLBACK(i21_callback, 21)
I_CALLBACK(i22_callback, 22)
I_CALLBACK(i23_callback, 23)
I_CALLBACK(i24_callback, 24)
I_CALLBACK(i25_callback, 25)
I_CALLBACK(i26_callback, 26)
I_CALLBACK(i27_callback, 27)
I_CALLBACK(i28_callback, 28)
I_CALLBACK(i29_callback, 29)
I_CALLBACK(i30_callback, 30)
I_CALLBACK(i31_callback, 31)
