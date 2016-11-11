#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/Process_model.h"
#include "../models/Sink_model.h"
#include "../models/Driver_model.h"
#include "../models/PowerCtl_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("process"),
process(0)
$end
$init("sink"),
sink(0)
$end
$init("driver"),
driver(0)
$end
$init("powerCtl"),
powerCtl(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("process");
process = new Process_pvt("process");
$end;
$create_component("sink");
sink = new Sink_pvt("sink");
$end;
$create_component("driver");
driver = new Driver_pvt("driver");
$end;
$create_component("powerCtl");
powerCtl = new PowerCtl_pvt("powerCtl");
$end;
$bind("driver->master","process->slave");
vista_bind(driver->master, process->slave);
$end;
$bind("process->master","sink->slave");
vista_bind(process->master, sink->slave);
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
$destruct_component("process");
delete process; process = 0;
$end;
$destruct_component("sink");
delete sink; sink = 0;
$end;
$destruct_component("driver");
delete driver; driver = 0;
$end;
$destruct_component("powerCtl");
delete powerCtl; powerCtl = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("process");
Process_pvt *process;
$end;
$component("sink");
Sink_pvt *sink;
$end;
$component("driver");
Driver_pvt *driver;
$end;
$component("powerCtl");
PowerCtl_pvt *powerCtl;
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