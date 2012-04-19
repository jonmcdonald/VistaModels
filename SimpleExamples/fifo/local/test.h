#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/SinkS_model.h"
#include "../models/PassMM_model.h"
$includes_end;

$module_begin("test");
SC_MODULE(test) {
public:
  test(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("c0"),
c0(0)
$end
$init("c1"),
c1(0)
$end
$init("c2"),
c2(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("c0");
c0 = new SinkS_pvt("c0");
$end;
$create_component("c1");
c1 = new PassMM_pvt("c1");
$end;
$create_component("c2");
c2 = new SinkS_pvt("c2");
$end;
$bind("c1->d_in","c0->d_in");
c1->d_in.bind(c0->d_in);
$end;
$bind("c1->d_out","c2->d_in");
c1->d_out.bind(c2->d_in);
$end;
    $elaboration_end;
  }
  ~test() {
    $destructor_begin;
$destruct_component("c0");
delete c0; c0 = 0;
$end;
$destruct_component("c1");
delete c1; c1 = 0;
$end;
$destruct_component("c2");
delete c2; c2 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("c0");
SinkS_pvt *c0;
$end;
$component("c1");
PassMM_pvt *c1;
$end;
$component("c2");
SinkS_pvt *c2;
$end;
  $fields_end;
};
$module_end;

