#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
#include "../models/process_model.h"
#include "../models/switch_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("fpga_source"),
fpga_source(0)
$end
$init("block1"),
block1(0)
$end
$init("out_serdes"),
out_serdes(0)
$end
$init("analysis"),
analysis(0)
$end
$init("switch1"),
switch1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("fpga_source");
fpga_source = new driver_pvt("fpga_source");
$end;
$create_component("block1");
block1 = new process_pvt("block1");
$end;
$create_component("out_serdes");
out_serdes = new sink_pvt("out_serdes");
$end;
$create_component("analysis");
analysis = new driver_pvt("analysis");
$end;
$create_component("switch1");
switch1 = new switch_pvt("switch1");
$end;
$bind("block1->master_1","out_serdes->slave_1");
vista_bind(block1->master_1, out_serdes->slave_1);
$end;
$bind("fpga_source->master_1","switch1->slave_1b");
vista_bind(fpga_source->master_1, switch1->slave_1b);
$end;
$bind("analysis->master_1","switch1->slave_1a");
vista_bind(analysis->master_1, switch1->slave_1a);
$end;
$bind("switch1->master_1","block1->slave_1");
vista_bind(switch1->master_1, block1->slave_1);
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
$destruct_component("fpga_source");
delete fpga_source; fpga_source = 0;
$end;
$destruct_component("block1");
delete block1; block1 = 0;
$end;
$destruct_component("out_serdes");
delete out_serdes; out_serdes = 0;
$end;
$destruct_component("analysis");
delete analysis; analysis = 0;
$end;
$destruct_component("switch1");
delete switch1; switch1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("fpga_source");
driver_pvt *fpga_source;
$end;
$component("block1");
process_pvt *block1;
$end;
$component("out_serdes");
sink_pvt *out_serdes;
$end;
$component("analysis");
driver_pvt *analysis;
$end;
$component("switch1");
switch_pvt *switch1;
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