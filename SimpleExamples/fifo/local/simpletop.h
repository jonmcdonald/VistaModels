#pragma once
$includes_begin;
#include <systemc.h>
#include "../models/CPU_model.h"
#include "../models/SinkS_model.h"
$includes_end;

$module_begin("simpletop");
SC_MODULE(simpletop) {
public:
  simpletop(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("c0"),
c0(0)
$end
$init("c1"),
c1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("c0");
c0 = new CPU_pvt("c0");
$end;
$create_component("c1");
c1 = new SinkS_pvt("c1");
$end;
$bind("c0->cpu_master","c1->d_in");
c0->cpu_master.bind(c1->d_in);
$end;
    $elaboration_end;
  }
  ~simpletop() {
    $destructor_begin;
$destruct_component("c0");
delete c0; c0 = 0;
$end;
$destruct_component("c1");
delete c1; c1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("c0");
CPU_pvt *c0;
$end;
$component("c1");
SinkS_pvt *c1;
$end;
  $fields_end;
};
$module_end;