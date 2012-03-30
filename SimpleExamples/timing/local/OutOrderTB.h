#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/mem_model.h"
#include "../models/OutOrder_model.h"
$includes_end;

$module_begin("OutOrderTB");
SC_MODULE(OutOrderTB) {
public:
  OutOrderTB(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("mem2"),
mem2(0)
$end
$init("OutOrder1"),
OutOrder1(0)
$end
$init("mem1"),
mem1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("mem2");
mem2 = new mem_pvt("mem2");
$end;
$create_component("OutOrder1");
OutOrder1 = new OutOrder_pvt("OutOrder1");
$end;
$create_component("mem1");
mem1 = new mem_pvt("mem1");
$end;
$bind("OutOrder1->x","mem1->slave");
vista_bind(OutOrder1->x, mem1->slave);
$end;
$bind("OutOrder1->y","mem2->slave");
vista_bind(OutOrder1->y, mem2->slave);
$end;
    $elaboration_end;
  }
  ~OutOrderTB() {
    $destructor_begin;
$destruct_component("mem2");
delete mem2; mem2 = 0;
$end;
$destruct_component("OutOrder1");
delete OutOrder1; OutOrder1 = 0;
$end;
$destruct_component("mem1");
delete mem1; mem1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("mem2");
mem_pvt *mem2;
$end;
$component("OutOrder1");
OutOrder_pvt *OutOrder1;
$end;
$component("mem1");
mem_pvt *mem1;
$end;
  $fields_end;
};
$module_end;

