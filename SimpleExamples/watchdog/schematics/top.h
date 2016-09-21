#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/FakeCPU_model.h"
#include "../models/WD_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("wd"),
wd(0)
$end
$init("cpu"),
cpu(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("wd");
wd = new WD_pvt("wd");
$end;
$create_component("cpu");
cpu = new FakeCPU_pvt("cpu");
$end;
$bind("wd->irq","cpu->int_source");
vista_bind(wd->irq, cpu->int_source);
$end;
$bind("cpu->cpu_master","wd->slave");
vista_bind(cpu->cpu_master, wd->slave);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "Mentor.com";
m_version = "1.0";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("wd");
delete wd; wd = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("wd");
WD_pvt *wd;
$end;
$component("cpu");
FakeCPU_pvt *cpu;
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

