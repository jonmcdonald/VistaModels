#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../Models/m3Bus_model.h"
#include "../Models/M3_model.h"
#include "../Models/mem_model.h"
#include "../Models/sink_model.h"
#include "../Models/rijndael_model.h"
$includes_end;

$module_begin("rijndael_tb");
SC_MODULE(rijndael_tb) {
public:
  rijndael_tb(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cpu_inst"),
cpu_inst(0)
$end
$init("mem_inst"),
mem_inst(0)
$end
$init("bus_inst"),
bus_inst(0)
$end
$init("sink_inst"),
sink_inst(0)
$end
$init("aes_inst"),
aes_inst(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu_inst");
cpu_inst = new M3_pvt("cpu_inst");
$end;
$create_component("mem_inst");
mem_inst = new mem_pvt("mem_inst");
$end;
$create_component("bus_inst");
bus_inst = new m3Bus_pvt("bus_inst");
$end;
$create_component("sink_inst");
sink_inst = new sink_pvt("sink_inst");
$end;
$create_component("aes_inst");
aes_inst = new rijndael_pvt("aes_inst");
$end;
$bind("cpu_inst->dcode","bus_inst->m1");
vista_bind(cpu_inst->dcode, bus_inst->m1);
$end;
$bind("bus_inst->s0","mem_inst->slave");
vista_bind(bus_inst->s0, mem_inst->slave);
$end;
$bind("cpu_inst->system","bus_inst->m2");
vista_bind(cpu_inst->system, bus_inst->m2);
$end;
$bind("cpu_inst->icode","bus_inst->m0");
vista_bind(cpu_inst->icode, bus_inst->m0);
$end;
$bind("bus_inst->s2","sink_inst->a");
vista_bind(bus_inst->s2, sink_inst->a);
$end;
$bind("aes_inst->m","bus_inst->m3");
vista_bind(aes_inst->m, bus_inst->m3);
$end;
$bind("bus_inst->s1","aes_inst->s");
vista_bind(bus_inst->s1, aes_inst->s);
$end;
$bind("aes_inst->irq","cpu_inst->irq_1");
vista_bind(aes_inst->irq, cpu_inst->irq_1);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "blocks_lib";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~rijndael_tb() {
    $destructor_begin;
$destruct_component("cpu_inst");
delete cpu_inst; cpu_inst = 0;
$end;
$destruct_component("mem_inst");
delete mem_inst; mem_inst = 0;
$end;
$destruct_component("bus_inst");
delete bus_inst; bus_inst = 0;
$end;
$destruct_component("sink_inst");
delete sink_inst; sink_inst = 0;
$end;
$destruct_component("aes_inst");
delete aes_inst; aes_inst = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu_inst");
M3_pvt *cpu_inst;
$end;
$component("mem_inst");
mem_pvt *mem_inst;
$end;
$component("bus_inst");
m3Bus_pvt *bus_inst;
$end;
$component("sink_inst");
sink_pvt *sink_inst;
$end;
$component("aes_inst");
rijndael_pvt *aes_inst;
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