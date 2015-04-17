#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../instruments_models/Instruments_model.h"
#include "DummyDriver_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("instruments"),
instruments(0)
$end
$init("dummyDriver"),
dummyDriver(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("instruments");
instruments = new Instruments_pvt("instruments");
$end;
$create_component("dummyDriver");
dummyDriver = new DummyDriver_pvt("dummyDriver");
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "instruments_local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("instruments");
delete instruments; instruments = 0;
$end;
$destruct_component("dummyDriver");
delete dummyDriver; dummyDriver = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("instruments");
Instruments_pvt *instruments;
$end;
$component("dummyDriver");
DummyDriver_pvt *dummyDriver;
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
