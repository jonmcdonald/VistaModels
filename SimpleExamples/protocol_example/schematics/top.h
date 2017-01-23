#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/AXI_MASTER_model.h"
#include "../models/AXI_SLAVE_model.h"
#include "../models/APB_MASTER_model.h"
#include "../models/APB_SLAVE_model.h"
#include "../models/DummyCPU_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("axi_slave"),
axi_slave(0)
$end
$init("axi_master"),
axi_master(0)
$end
$init("apb_slave"),
apb_slave(0)
$end
$init("apb_master"),
apb_master(0)
$end
$init("dummy"),
dummy(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("axi_slave");
axi_slave = new AXI_SLAVE_pvt("axi_slave");
$end;
$create_component("axi_master");
axi_master = new AXI_MASTER_pvt("axi_master");
$end;
$create_component("apb_slave");
apb_slave = new APB_SLAVE_pvt("apb_slave");
$end;
$create_component("apb_master");
apb_master = new APB_MASTER_pvt("apb_master");
$end;
$create_component("dummy");
dummy = new DummyCPU_pvt("dummy");
$end;
$bind("axi_master->master","axi_slave->slave");
vista_bind(axi_master->master, axi_slave->slave);
$end;
$bind("apb_master->master","apb_slave->slave");
vista_bind(apb_master->master, apb_slave->slave);
$end;
$bind("dummy->master","apb_master->input");
vista_bind(dummy->master, apb_master->input);
$end;
$bind("dummy->master2","axi_master->input");
vista_bind(dummy->master2, axi_master->input);
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
$destruct_component("axi_slave");
delete axi_slave; axi_slave = 0;
$end;
$destruct_component("axi_master");
delete axi_master; axi_master = 0;
$end;
$destruct_component("apb_slave");
delete apb_slave; apb_slave = 0;
$end;
$destruct_component("apb_master");
delete apb_master; apb_master = 0;
$end;
$destruct_component("dummy");
delete dummy; dummy = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("axi_slave");
AXI_SLAVE_pvt *axi_slave;
$end;
$component("axi_master");
AXI_MASTER_pvt *axi_master;
$end;
$component("apb_slave");
APB_SLAVE_pvt *apb_slave;
$end;
$component("apb_master");
APB_MASTER_pvt *apb_master;
$end;
$component("dummy");
DummyCPU_pvt *dummy;
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