#ifndef ___home_jon_work_fifo_local_proc_h__
#define ___home_jon_work_fifo_local_proc_h__

$includes_begin;
#include <systemc.h>
#include "../models/PassSM_model.h"
#include "../models/FifoSS_model.h"
#include "../models/PassMM_model.h"
$includes_end;

$module_begin("proc");
SC_MODULE(proc) {
public:
  proc(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("d_in"),
d_in("d_in")
$end
$init("d_out"),
d_out("d_out")
$end
$init("pass2_P0"),
pass2_P0(0)
$end
$init("fifo_P0"),
fifo_P0(0)
$end
$init("pass1_P0"),
pass1_P0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("pass2_P0");
pass2_P0 = new PassMM_pvt("pass2_P0");
$end;
$create_component("fifo_P0");
fifo_P0 = new FifoSS_pvt("fifo_P0");
$end;
$create_component("pass1_P0");
pass1_P0 = new PassSM_pvt("pass1_P0");
$end;
$bind("pass2_P0->d_in","fifo_P0->d_out");
pass2_P0->d_in.bind(fifo_P0->d_out);
$end;
$bind("pass1_P0->d_out","fifo_P0->d_in");
pass1_P0->d_out.bind(fifo_P0->d_in);
$end;
$bind("d_in","pass1_P0->d_in");
d_in.bind(pass1_P0->d_in);
$end;
$bind("pass2_P0->d_out","d_out");
pass2_P0->d_out.bind(d_out);
$end;
    $elaboration_end;
  }
  ~proc() {
    $destructor_begin;
$destruct_component("pass2_P0");
delete pass2_P0; pass2_P0 = 0;
$end;
$destruct_component("fifo_P0");
delete fifo_P0; fifo_P0 = 0;
$end;
$destruct_component("pass1_P0");
delete pass1_P0; pass1_P0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("d_in");
tlm::tlm_target_socket< 32u,tlm::tlm_base_protocol_types > d_in;
$end;
$socket("d_out");
tlm::tlm_initiator_socket< 32u,tlm::tlm_base_protocol_types > d_out;
$end;
$component("pass2_P0");
PassMM_pvt *pass2_P0;
$end;
$component("fifo_P0");
FifoSS_pvt *fifo_P0;
$end;
$component("pass1_P0");
PassSM_pvt *pass1_P0;
$end;
  $fields_end;
};
$module_end;

#endif
