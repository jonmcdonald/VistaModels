#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/Load2_model.h"
#include "../models/SinkS_model.h"
#include "../models/PassSM_model.h"
#include "../models/FifoSS_model.h"
#include "proc.h"
#include "../models/PPong_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("Load2_0"),
Load2_0(0)
$end
$init("sink0"),
sink0(0)
$end
$init("proc0"),
proc0(0)
$end
$init("PPong0"),
PPong0(0)
$end
$init("proc1"),
proc1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("Load2_0");
Load2_0 = new Load2_pvt("Load2_0");
$end;
$create_component("sink0");
sink0 = new SinkS_pvt("sink0");
$end;
$create_component("proc0");
proc0 = new proc("proc0");
$end;
$create_component("PPong0");
PPong0 = new PPong_pvt("PPong0");
$end;
$create_component("proc1");
proc1 = new proc("proc1");
$end;
$bind("PPong0->y","sink0->d_in");
vista_bind(PPong0->y, sink0->d_in);
$end;
$bind("proc0->d_out","PPong0->d1");
vista_bind(proc0->d_out, PPong0->d1);
$end;
$bind("proc1->d_out","PPong0->d2");
vista_bind(proc1->d_out, PPong0->d2);
$end;
$bind("Load2_0->m1","proc1->d_in");
vista_bind(Load2_0->m1, proc1->d_in);
$end;
$bind("Load2_0->m0","proc0->d_in");
vista_bind(Load2_0->m0, proc0->d_in);
$end;
    $elaboration_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("Load2_0");
delete Load2_0; Load2_0 = 0;
$end;
$destruct_component("sink0");
delete sink0; sink0 = 0;
$end;
$destruct_component("proc0");
delete proc0; proc0 = 0;
$end;
$destruct_component("PPong0");
delete PPong0; PPong0 = 0;
$end;
$destruct_component("proc1");
delete proc1; proc1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("Load2_0");
Load2_pvt *Load2_0;
$end;
$component("sink0");
SinkS_pvt *sink0;
$end;
$component("proc0");
proc *proc0;
$end;
$component("PPong0");
PPong_pvt *PPong0;
$end;
$component("proc1");
proc *proc1;
$end;
  $fields_end;
};
$module_end;