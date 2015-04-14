#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../cluster_models/A9x2_model.h"
#include "../cluster_models/PL180_MCI_model.h"
#include "../cluster_models/LinuxFrameBufferDisplay_model.h"
#include "../cluster_models/LAN9118_model.h"
#include "../cluster_models/SystemControl_model.h"
#include "../cluster_models/MEMORY_model.h"
#include "../cluster_models/AXI_model.h"
#include "uart_with_console.h"
#include "../cluster_models/AXI_APB_model.h"
$includes_end;

$module_begin("cluster");
SC_MODULE(cluster) {
public:
  typedef cluster SC_CURRENT_USER_MODULE;
  cluster(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("a9x2"),
a9x2(0)
$end
$init("sdcard"),
sdcard(0)
$end
$init("ethernet"),
ethernet(0)
$end
$init("sysctrl"),
sysctrl(0)
$end
$init("axi_bus"),
axi_bus(0)
$end
$init("a9_ram"),
a9_ram(0)
$end
$init("fb"),
fb(0)
$end
$init("a9_uart"),
a9_uart(0)
$end
$init("axi_apb"),
axi_apb(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("a9x2");
a9x2 = new A9x2_pvt("a9x2");
$end;
$create_component("sdcard");
sdcard = new PL180_MCI_pvt("sdcard");
$end;
$create_component("ethernet");
ethernet = new LAN9118_pvt("ethernet");
$end;
$create_component("sysctrl");
sysctrl = new SystemControl_pvt("sysctrl");
$end;
$create_component("axi_bus");
axi_bus = new AXI_pvt("axi_bus");
$end;
$create_component("a9_ram");
a9_ram = new MEMORY_pvt("a9_ram");
$end;
$create_component("fb");
fb = new LinuxFrameBufferDisplay_pvt("fb");
$end;
$create_component("a9_uart");
a9_uart = new uart_with_console("a9_uart");
$end;
$create_component("axi_apb");
axi_apb = new AXI_APB_pvt("axi_apb");
$end;
$bind("sdcard->irq0","a9x2->irq_1");
vista_bind(sdcard->irq0, a9x2->irq_1);
$end;
$bind("axi_bus->system_master","sysctrl->slave");
vista_bind(axi_bus->system_master, sysctrl->slave);
$end;
$bind("sdcard->irq1","a9x2->irq_2");
vista_bind(sdcard->irq1, a9x2->irq_2);
$end;
$bind("axi_bus->ram_master","a9_ram->slave");
vista_bind(axi_bus->ram_master, a9_ram->slave);
$end;
$bind("a9x2->master0","axi_bus->a9_slave");
vista_bind(a9x2->master0, axi_bus->a9_slave);
$end;
$bind("axi_bus->ethernet_master","ethernet->host");
vista_bind(axi_bus->ethernet_master, ethernet->host);
$end;
$bind("axi_bus->sd_master","sdcard->host");
vista_bind(axi_bus->sd_master, sdcard->host);
$end;
$bind("axi_bus->fb_master","fb->from_bus");
vista_bind(axi_bus->fb_master, fb->from_bus);
$end;
$bind("ethernet->irq","a9x2->irq_0");
vista_bind(ethernet->irq, a9x2->irq_0);
$end;
$bind("axi_bus->bridge_master","axi_apb->slave");
vista_bind(axi_bus->bridge_master, axi_apb->slave);
$end;
$bind("a9_uart->irq","a9x2->irq_3");
vista_bind(a9_uart->irq, a9x2->irq_3);
$end;
$bind("axi_apb->master","a9_uart->slave");
vista_bind(axi_apb->master, a9_uart->slave);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "cluster_local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~cluster() {
    $destructor_begin;
$destruct_component("a9x2");
delete a9x2; a9x2 = 0;
$end;
$destruct_component("sdcard");
delete sdcard; sdcard = 0;
$end;
$destruct_component("ethernet");
delete ethernet; ethernet = 0;
$end;
$destruct_component("sysctrl");
delete sysctrl; sysctrl = 0;
$end;
$destruct_component("axi_bus");
delete axi_bus; axi_bus = 0;
$end;
$destruct_component("a9_ram");
delete a9_ram; a9_ram = 0;
$end;
$destruct_component("fb");
delete fb; fb = 0;
$end;
$destruct_component("a9_uart");
delete a9_uart; a9_uart = 0;
$end;
$destruct_component("axi_apb");
delete axi_apb; axi_apb = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("a9x2");
A9x2_pvt *a9x2;
$end;
$component("sdcard");
PL180_MCI_pvt *sdcard;
$end;
$component("ethernet");
LAN9118_pvt *ethernet;
$end;
$component("sysctrl");
SystemControl_pvt *sysctrl;
$end;
$component("axi_bus");
AXI_pvt *axi_bus;
$end;
$component("a9_ram");
MEMORY_pvt *a9_ram;
$end;
$component("fb");
LinuxFrameBufferDisplay_pvt *fb;
$end;
$component("a9_uart");
uart_with_console *a9_uart;
$end;
$component("axi_apb");
AXI_APB_pvt *axi_apb;
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