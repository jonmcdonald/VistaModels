#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "AXI_BUS_model.h"
#include "MEMORY_model.h"
#include "CORTEX_A9_uni_model.h"
#include "OpenGL_Bridge_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cpu"),
cpu(0)
$end
$init("axi"),
axi(0)
$end
$init("low_mem"),
low_mem(0)
$end
$init("opengl"),
opengl(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu");
cpu = new CORTEX_A9_uni_pvt("cpu");
$end;
$create_component("axi");
axi = new AXI_BUS_pvt("axi");
$end;
$create_component("low_mem");
low_mem = new MEMORY_pvt("low_mem");
$end;
$create_component("opengl");
opengl = new OpenGL_Bridge_pvt("opengl");
$end;
$bind("cpu->data_initiator","axi->cpu_d");
vista_bind(cpu->data_initiator, axi->cpu_d);
$end;
$bind("cpu->insn_initiator","axi->cpu_i");
vista_bind(cpu->insn_initiator, axi->cpu_i);
$end;
$bind("axi->opengl","opengl->slave");
vista_bind(axi->opengl, opengl->slave);
$end;
$bind("axi->mem","low_mem->slave");
vista_bind(axi->mem, low_mem->slave);
$end;
$bind("opengl->master","axi->from_opengl");
vista_bind(opengl->master, axi->from_opengl);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "Models";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("axi");
delete axi; axi = 0;
$end;
$destruct_component("low_mem");
delete low_mem; low_mem = 0;
$end;
$destruct_component("opengl");
delete opengl; opengl = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu");
CORTEX_A9_uni_pvt *cpu;
$end;
$component("axi");
AXI_BUS_pvt *axi;
$end;
$component("low_mem");
MEMORY_pvt *low_mem;
$end;
$component("opengl");
OpenGL_Bridge_pvt *opengl;
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