#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/FileCanData_model.h"
#include "../models/can_model.h"
$includes_end;

$module_begin("tbcan");
SC_MODULE(tbcan) {
public:
  typedef tbcan SC_CURRENT_USER_MODULE;
  tbcan(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("driver1"),
driver1(0)
$end
$init("can0"),
can0(0)
$end
$init("can1"),
can1(0)
$end
$init("driver0"),
driver0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("driver1");
driver1 = new FileCanData_pvt("driver1");
$end;
$create_component("can0");
can0 = new can_pvt("can0");
$end;
$create_component("can1");
can1 = new can_pvt("can1");
$end;
$create_component("driver0");
driver0 = new FileCanData_pvt("driver0");
$end;
$bind("can1->GI_Rx","driver1->rxi");
vista_bind(can1->GI_Rx, driver1->rxi);
$end;
$bind("can1->TX0","can0->RX0");
vista_bind(can1->TX0, can0->RX0);
$end;
$bind("driver0->m","can0->reg");
vista_bind(driver0->m, can0->reg);
$end;
$bind("driver1->m","can1->reg");
vista_bind(driver1->m, can1->reg);
$end;
$bind("can0->GI_Rx","driver0->rxi");
vista_bind(can0->GI_Rx, driver0->rxi);
$end;
$bind("can0->TX0","can1->RX0");
vista_bind(can0->TX0, can1->RX0);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "Mentor.com";
m_version = "1.0";
  $vlnv_assign_end;
  }
  ~tbcan() {
    $destructor_begin;
$destruct_component("driver1");
delete driver1; driver1 = 0;
$end;
$destruct_component("can0");
delete can0; can0 = 0;
$end;
$destruct_component("can1");
delete can1; can1 = 0;
$end;
$destruct_component("driver0");
delete driver0; driver0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("driver1");
FileCanData_pvt *driver1;
$end;
$component("can0");
can_pvt *can0;
$end;
$component("can1");
can_pvt *can1;
$end;
$component("driver0");
FileCanData_pvt *driver0;
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

