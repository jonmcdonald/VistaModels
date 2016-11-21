#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/BroadcastBUS_model.h"
#include "../models/Device_model.h"
#include "../models/AbstractCPU_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("d3"),
d3(0)
$end
$init("cpu"),
cpu(0)
$end
$init("d1"),
d1(0)
$end
$init("d2"),
d2(0)
$end
$init("bus"),
bus(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("d3");
d3 = new Device_pvt("d3");
$end;
$create_component("cpu");
cpu = new AbstractCPU_pvt("cpu");
$end;
$create_component("d1");
d1 = new Device_pvt("d1");
$end;
$create_component("d2");
d2 = new Device_pvt("d2");
$end;
$create_component("bus");
bus = new BroadcastBUS_pvt("bus");
$end;
$bind("bus->device2_master","d2->slave");
vista_bind(bus->device2_master, d2->slave);
$end;
$bind("bus->device3_master","d3->slave");
vista_bind(bus->device3_master, d3->slave);
$end;
$bind("cpu->cpu_master","bus->cpu_slave");
vista_bind(cpu->cpu_master, bus->cpu_slave);
$end;
$bind("bus->device1_master","d1->slave");
vista_bind(bus->device1_master, d1->slave);
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
$destruct_component("d3");
delete d3; d3 = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("d1");
delete d1; d1 = 0;
$end;
$destruct_component("d2");
delete d2; d2 = 0;
$end;
$destruct_component("bus");
delete bus; bus = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("d3");
Device_pvt *d3;
$end;
$component("cpu");
AbstractCPU_pvt *cpu;
$end;
$component("d1");
Device_pvt *d1;
$end;
$component("d2");
Device_pvt *d2;
$end;
$component("bus");
BroadcastBUS_pvt *bus;
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
