#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
#include "../models/process_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
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
c0 = new driver_pvt("c0");
$end;
$create_component("c1");
c1 = new process_pvt("c1");
$end;
$create_component("c2");
c2 = new sink_pvt("c2");
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
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
driver_pvt *c0;
$end;
$component("c1");
process_pvt *c1;
$end;
$component("c2");
sink_pvt *c2;
$end;
  $fields_end;
  $vlnv_decl_begin;
public:
const char* m_library;
const char* m_vendor;
const char* m_version;
  $vlnv_decl_end;
};
$module_end;
