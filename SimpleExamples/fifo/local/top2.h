#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/Load2_model.h"
#include "../models/SinkS_model.h"
#include "proc.h"
$includes_end;

$module_begin("top2");
SC_MODULE(top2) {
public:
  top2(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("load_i"),
load_i(0)
$end
$init("sink0"),
sink0(0)
$end
$init("sink1"),
sink1(0)
$end
$init("path0_i"),
path0_i(0)
$end
$init("path1_i"),
path1_i(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("load_i");
load_i = new Load2_pvt("load_i");
$end;
$create_component("sink0");
sink0 = new SinkS_pvt("sink0");
$end;
$create_component("sink1");
sink1 = new SinkS_pvt("sink1");
$end;
$create_component("path0_i");
path0_i = new proc("path0_i");
$end;
$create_component("path1_i");
path1_i = new proc("path1_i");
$end;
$bind("load_i->m1","path1_i->d_in");
vista_bind(load_i->m1, path1_i->d_in);
$end;
$bind("load_i->m0","path0_i->d_in");
vista_bind(load_i->m0, path0_i->d_in);
$end;
$bind("path1_i->d_out","sink1->d_in");
vista_bind(path1_i->d_out, sink1->d_in);
$end;
$bind("path0_i->d_out","sink0->d_in");
vista_bind(path0_i->d_out, sink0->d_in);
$end;
    $elaboration_end;
  }
  ~top2() {
    $destructor_begin;
$destruct_component("load_i");
delete load_i; load_i = 0;
$end;
$destruct_component("sink0");
delete sink0; sink0 = 0;
$end;
$destruct_component("sink1");
delete sink1; sink1 = 0;
$end;
$destruct_component("path0_i");
delete path0_i; path0_i = 0;
$end;
$destruct_component("path1_i");
delete path1_i; path1_i = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("load_i");
Load2_pvt *load_i;
$end;
$component("sink0");
SinkS_pvt *sink0;
$end;
$component("sink1");
SinkS_pvt *sink1;
$end;
$component("path0_i");
proc *path0_i;
$end;
$component("path1_i");
proc *path1_i;
$end;
  $fields_end;
};
$module_end;

