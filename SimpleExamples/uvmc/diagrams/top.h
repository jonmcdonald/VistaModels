#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/axi_bus_model.h"
#include "../models/cpu_model.h"
#include "../models/ip_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("axi_bus"),
axi_bus(0)
$end
$init("cpu"),
cpu(0)
$end
$init("ip"),
ip(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("axi_bus");
axi_bus = new axi_bus_pvt("axi_bus");
$end;
$create_component("cpu");
cpu = new cpu_pvt("cpu");
$end;
$create_component("ip");
ip = new ip_pvt("ip");
$end;
$bind("cpu->cpu_master","axi_bus->bus_slave");
vista_bind(cpu->cpu_master, axi_bus->bus_slave);
$end;
$bind("axi_bus->bus_master","ip->ip_slave");
vista_bind(axi_bus->bus_master, ip->ip_slave);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "diagrams";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("axi_bus");
delete axi_bus; axi_bus = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("ip");
delete ip; ip = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("axi_bus");
axi_bus_pvt *axi_bus;
$end;
$component("cpu");
cpu_pvt *cpu;
$end;
$component("ip");
ip_pvt *ip;
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