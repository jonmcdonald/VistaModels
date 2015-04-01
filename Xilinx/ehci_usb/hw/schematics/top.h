#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "Zynq_SoC.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("Zynq_SoC_inst"),
Zynq_SoC_inst(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("Zynq_SoC_inst");
Zynq_SoC_inst = new Zynq_SoC("Zynq_SoC_inst");
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("Zynq_SoC_inst");
delete Zynq_SoC_inst; Zynq_SoC_inst = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("Zynq_SoC_inst");
Zynq_SoC *Zynq_SoC_inst;
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