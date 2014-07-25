#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("sink0"),
sink0(0)
$end
$init("driver0"),
driver0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("sink0");
sink0 = new sink_pvt("sink0");
$end;
$create_component("driver0");
driver0 = new driver_pvt("driver0");
$end;
$bind("driver0->y","sink0->a");
vista_bind(driver0->y, sink0->a);
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
$destruct_component("sink0");
delete sink0; sink0 = 0;
$end;
$destruct_component("driver0");
delete driver0; driver0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("sink0");
sink_pvt *sink0;
$end;
$component("driver0");
driver_pvt *driver0;
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
