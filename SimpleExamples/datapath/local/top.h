#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
#include "../models/process_model.h"
#include "../models/switch_model.h"
#include "../models/split_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("process_1"),
process_1(0)
$end
$init("sink_1"),
sink_1(0)
$end
$init("switch_1"),
switch_1(0)
$end
$init("driver_1"),
driver_1(0)
$end
$init("split_1"),
split_1(0)
$end
$init("process_2"),
process_2(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("process_1");
process_1 = new process_pvt("process_1");
$end;
$create_component("sink_1");
sink_1 = new sink_pvt("sink_1");
$end;
$create_component("switch_1");
switch_1 = new switch_pvt("switch_1");
$end;
$create_component("driver_1");
driver_1 = new driver_pvt("driver_1");
$end;
$create_component("split_1");
split_1 = new split_pvt("split_1");
$end;
$create_component("process_2");
process_2 = new process_pvt("process_2");
$end;
$bind("switch_1->master_3","process_1->slave_3");
vista_bind(switch_1->master_3, process_1->slave_3);
$end;
$bind("switch_1->master_6","process_1->slave_6");
vista_bind(switch_1->master_6, process_1->slave_6);
$end;
$bind("switch_1->master_7","process_1->slave_7");
vista_bind(switch_1->master_7, process_1->slave_7);
$end;
$bind("switch_1->master_4","process_1->slave_4");
vista_bind(switch_1->master_4, process_1->slave_4);
$end;
$bind("switch_1->master_1","process_1->slave_1");
vista_bind(switch_1->master_1, process_1->slave_1);
$end;
$bind("switch_1->master_2","process_1->slave_2");
vista_bind(switch_1->master_2, process_1->slave_2);
$end;
$bind("switch_1->master_8","process_1->slave_8");
vista_bind(switch_1->master_8, process_1->slave_8);
$end;
$bind("switch_1->master_5","process_1->slave_5");
vista_bind(switch_1->master_5, process_1->slave_5);
$end;
$bind("driver_1->master_2","switch_1->slave_2b");
vista_bind(driver_1->master_2, switch_1->slave_2b);
$end;
$bind("process_1->master_8","split_1->slave_8");
vista_bind(process_1->master_8, split_1->slave_8);
$end;
$bind("split_1->master_3a","process_2->slave_3");
vista_bind(split_1->master_3a, process_2->slave_3);
$end;
$bind("split_1->master_7a","process_2->slave_7");
vista_bind(split_1->master_7a, process_2->slave_7);
$end;
$bind("process_2->master_8","switch_1->slave_8a");
vista_bind(process_2->master_8, switch_1->slave_8a);
$end;
$bind("process_2->master_1","switch_1->slave_1a");
vista_bind(process_2->master_1, switch_1->slave_1a);
$end;
$bind("split_1->master_1b","sink_1->slave_1");
vista_bind(split_1->master_1b, sink_1->slave_1);
$end;
$bind("driver_1->master_8","switch_1->slave_8b");
vista_bind(driver_1->master_8, switch_1->slave_8b);
$end;
$bind("split_1->master_2a","process_2->slave_2");
vista_bind(split_1->master_2a, process_2->slave_2);
$end;
$bind("split_1->master_6a","process_2->slave_6");
vista_bind(split_1->master_6a, process_2->slave_6);
$end;
$bind("driver_1->master_6","switch_1->slave_6b");
vista_bind(driver_1->master_6, switch_1->slave_6b);
$end;
$bind("split_1->master_2b","sink_1->slave_2");
vista_bind(split_1->master_2b, sink_1->slave_2);
$end;
$bind("process_1->master_1","split_1->slave_1");
vista_bind(process_1->master_1, split_1->slave_1);
$end;
$bind("process_2->master_7","switch_1->slave_7a");
vista_bind(process_2->master_7, switch_1->slave_7a);
$end;
$bind("process_2->master_5","switch_1->slave_5a");
vista_bind(process_2->master_5, switch_1->slave_5a);
$end;
$bind("split_1->master_5a","process_2->slave_5");
vista_bind(split_1->master_5a, process_2->slave_5);
$end;
$bind("split_1->master_3b","sink_1->slave_3");
vista_bind(split_1->master_3b, sink_1->slave_3);
$end;
$bind("driver_1->master_7","switch_1->slave_7b");
vista_bind(driver_1->master_7, switch_1->slave_7b);
$end;
$bind("process_1->master_2","split_1->slave_2");
vista_bind(process_1->master_2, split_1->slave_2);
$end;
$bind("driver_1->master_5","switch_1->slave_5b");
vista_bind(driver_1->master_5, switch_1->slave_5b);
$end;
$bind("split_1->master_4b","sink_1->slave_4");
vista_bind(split_1->master_4b, sink_1->slave_4);
$end;
$bind("process_1->master_3","split_1->slave_3");
vista_bind(process_1->master_3, split_1->slave_3);
$end;
$bind("process_2->master_6","switch_1->slave_6a");
vista_bind(process_2->master_6, switch_1->slave_6a);
$end;
$bind("split_1->master_8a","process_2->slave_8");
vista_bind(split_1->master_8a, process_2->slave_8);
$end;
$bind("process_2->master_4","switch_1->slave_4a");
vista_bind(process_2->master_4, switch_1->slave_4a);
$end;
$bind("split_1->master_5b","sink_1->slave_5");
vista_bind(split_1->master_5b, sink_1->slave_5);
$end;
$bind("driver_1->master_4","switch_1->slave_4b");
vista_bind(driver_1->master_4, switch_1->slave_4b);
$end;
$bind("process_1->master_4","split_1->slave_4");
vista_bind(process_1->master_4, split_1->slave_4);
$end;
$bind("split_1->master_6b","sink_1->slave_6");
vista_bind(split_1->master_6b, sink_1->slave_6);
$end;
$bind("split_1->master_1a","process_2->slave_1");
vista_bind(split_1->master_1a, process_2->slave_1);
$end;
$bind("process_1->master_5","split_1->slave_5");
vista_bind(process_1->master_5, split_1->slave_5);
$end;
$bind("process_2->master_3","switch_1->slave_3a");
vista_bind(process_2->master_3, switch_1->slave_3a);
$end;
$bind("split_1->master_7b","sink_1->slave_7");
vista_bind(split_1->master_7b, sink_1->slave_7);
$end;
$bind("driver_1->master_3","switch_1->slave_3b");
vista_bind(driver_1->master_3, switch_1->slave_3b);
$end;
$bind("process_1->master_6","split_1->slave_6");
vista_bind(process_1->master_6, split_1->slave_6);
$end;
$bind("driver_1->master_1","switch_1->slave_1b");
vista_bind(driver_1->master_1, switch_1->slave_1b);
$end;
$bind("split_1->master_4a","process_2->slave_4");
vista_bind(split_1->master_4a, process_2->slave_4);
$end;
$bind("split_1->master_8b","sink_1->slave_8");
vista_bind(split_1->master_8b, sink_1->slave_8);
$end;
$bind("process_1->master_7","split_1->slave_7");
vista_bind(process_1->master_7, split_1->slave_7);
$end;
$bind("process_2->master_2","switch_1->slave_2a");
vista_bind(process_2->master_2, switch_1->slave_2a);
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
$destruct_component("process_1");
delete process_1; process_1 = 0;
$end;
$destruct_component("sink_1");
delete sink_1; sink_1 = 0;
$end;
$destruct_component("switch_1");
delete switch_1; switch_1 = 0;
$end;
$destruct_component("driver_1");
delete driver_1; driver_1 = 0;
$end;
$destruct_component("split_1");
delete split_1; split_1 = 0;
$end;
$destruct_component("process_2");
delete process_2; process_2 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("process_1");
process_pvt *process_1;
$end;
$component("sink_1");
sink_pvt *sink_1;
$end;
$component("switch_1");
switch_pvt *switch_1;
$end;
$component("driver_1");
driver_pvt *driver_1;
$end;
$component("split_1");
split_pvt *split_1;
$end;
$component("process_2");
process_pvt *process_2;
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