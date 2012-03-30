#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/mem_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("driver1"),
driver1(0)
$end
$init("mem2"),
mem2(0)
$end
$init("mem1"),
mem1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("driver1");
driver1 = new driver_pvt("driver1");
$end;
$create_component("mem2");
mem2 = new mem_pvt("mem2");
$end;
$create_component("mem1");
mem1 = new mem_pvt("mem1");
$end;
$bind("driver1->e","mem2->slave");
vista_bind(driver1->e, mem2->slave);
$end;
$bind("driver1->d","mem1->slave");
vista_bind(driver1->d, mem1->slave);
$end;
    $elaboration_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("driver1");
delete driver1; driver1 = 0;
$end;
$destruct_component("mem2");
delete mem2; mem2 = 0;
$end;
$destruct_component("mem1");
delete mem1; mem1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("driver1");
driver_pvt *driver1;
$end;
$component("mem2");
mem_pvt *mem2;
$end;
$component("mem1");
mem_pvt *mem1;
$end;
  $fields_end;
};
$module_end;

