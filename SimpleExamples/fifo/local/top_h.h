#pragma once

#include "mgc_vista_schematics.h"

$includes_begin;
#include <systemc.h>
#include "../models/SinkS_model.h"
#include "proc.h"
#include "../models/Load2_model.h"
#include "../models/mem_model.h"
#include "../models/pingpong_model.h"
$includes_end;

$module_begin("top_h");
SC_MODULE(top_h) {
public:
  top_h(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("path0_i"),
path0_i(0)
$end
$init("load_i"),
load_i(0)
$end
$init("path1_i"),
path1_i(0)
$end
$init("mem1"),
mem1(0)
$end
$init("mem2"),
mem2(0)
$end
$init("sink0"),
sink0(0)
$end
$init("pingpong0"),
pingpong0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("path0_i");
path0_i = new proc("path0_i");
$end;
$create_component("load_i");
load_i = new Load2_pvt("load_i");
$end;
$create_component("path1_i");
path1_i = new proc("path1_i");
$end;
$create_component("mem1");
mem1 = new mem_pvt("mem1");
$end;
$create_component("mem2");
mem2 = new mem_pvt("mem2");
$end;
$create_component("sink0");
sink0 = new SinkS_pvt("sink0");
$end;
$create_component("pingpong0");
pingpong0 = new pingpong_pvt("pingpong0");
$end;
$bind("load_i->m1","path1_i->d_in");
load_i->m1.bind(path1_i->d_in);
$end;
$bind("load_i->m0","path0_i->d_in");
load_i->m0.bind(path0_i->d_in);
$end;
$bind("path1_i->d_out","pingpong0->d2");
vista_bind(path1_i->d_out, pingpong0->d2);
$end;
$bind("pingpong0->y","sink0->d_in");
vista_bind(pingpong0->y, sink0->d_in);
$end;
$bind("pingpong0->m1","mem1->slave");
vista_bind(pingpong0->m1, mem1->slave);
$end;
$bind("path0_i->d_out","pingpong0->d1");
vista_bind(path0_i->d_out, pingpong0->d1);
$end;
$bind("pingpong0->m2","mem2->slave");
vista_bind(pingpong0->m2, mem2->slave);
$end;
    $elaboration_end;
  }
  ~top_h() {
    $destructor_begin;
$destruct_component("path0_i");
delete path0_i; path0_i = 0;
$end;
$destruct_component("load_i");
delete load_i; load_i = 0;
$end;
$destruct_component("path1_i");
delete path1_i; path1_i = 0;
$end;
$destruct_component("mem1");
delete mem1; mem1 = 0;
$end;
$destruct_component("mem2");
delete mem2; mem2 = 0;
$end;
$destruct_component("sink0");
delete sink0; sink0 = 0;
$end;
$destruct_component("pingpong0");
delete pingpong0; pingpong0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("path0_i");
proc *path0_i;
$end;
$component("load_i");
Load2_pvt *load_i;
$end;
$component("path1_i");
proc *path1_i;
$end;
$component("mem1");
mem_pvt *mem1;
$end;
$component("mem2");
mem_pvt *mem2;
$end;
$component("sink0");
SinkS_pvt *sink0;
$end;
$component("pingpong0");
pingpong_pvt *pingpong0;
$end;
  $fields_end;
};
$module_end;