#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../Models/SuperFIFO_model.h"
#include "../Models/m3Bus_model.h"
#include "../Models/M3_model.h"
#include "../Models/mem_model.h"
#include "../Models/sink_model.h"
#include "../Models/extIn_model.h"
$includes_end;

$module_begin("simple");
SC_MODULE(simple) {
public:
  simple(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cpu_inst"),
cpu_inst(0)
$end
$init("mem_inst"),
mem_inst(0)
$end
$init("superfifo"),
superfifo(0)
$end
$init("bus_inst"),
bus_inst(0)
$end
$init("sink_inst"),
sink_inst(0)
$end
$init("extIn_inst"),
extIn_inst(0)
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
$create_component("superfifo");
superfifo = new SuperFIFO_pvt("superfifo");
$end;
$create_component("bus_inst");
bus_inst = new m3Bus_pvt("bus_inst");
$end;
$create_component("sink_inst");
sink_inst = new sink_pvt("sink_inst");
$end;
$create_component("extIn_inst");
extIn_inst = new extIn_pvt("extIn_inst");
$end;
$bind("cpu_inst->dcode","bus_inst->m1");
vista_bind(cpu_inst->dcode, bus_inst->m1);
$end;
$bind("bus_inst->s0","mem_inst->slave");
vista_bind(bus_inst->s0, mem_inst->slave);
$end;
$bind("bus_inst->s1","superfifo->s");
vista_bind(bus_inst->s1, superfifo->s);
$end;
$bind("cpu_inst->system","bus_inst->m2");
vista_bind(cpu_inst->system, bus_inst->m2);
$end;
$bind("cpu_inst->icode","bus_inst->m0");
vista_bind(cpu_inst->icode, bus_inst->m0);
$end;
$bind("superfifo->irq","cpu_inst->irq_1");
vista_bind(superfifo->irq, cpu_inst->irq_1);
$end;
$bind("extIn_inst->y","bus_inst->m3");
vista_bind(extIn_inst->y, bus_inst->m3);
$end;
$bind("bus_inst->s2","sink_inst->a");
vista_bind(bus_inst->s2, sink_inst->a);
$end;
$bind("bus_inst->s3","extIn_inst->a");
vista_bind(bus_inst->s3, extIn_inst->a);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "blocks_lib";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~simple() {
    $destructor_begin;
$destruct_component("cpu_inst");
delete cpu_inst; cpu_inst = 0;
$end;
$destruct_component("mem_inst");
delete mem_inst; mem_inst = 0;
$end;
$destruct_component("superfifo");
delete superfifo; superfifo = 0;
$end;
$destruct_component("bus_inst");
delete bus_inst; bus_inst = 0;
$end;
$destruct_component("sink_inst");
delete sink_inst; sink_inst = 0;
$end;
$destruct_component("extIn_inst");
delete extIn_inst; extIn_inst = 0;
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
$component("superfifo");
SuperFIFO_pvt *superfifo;
$end;
$component("bus_inst");
m3Bus_pvt *bus_inst;
$end;
$component("sink_inst");
sink_pvt *sink_inst;
$end;
$component("extIn_inst");
extIn_pvt *extIn_inst;
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