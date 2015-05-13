#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "SystemBridge_model.h"
#include "AHB_model.h"
#include "LinuxFrameBufferDisplay_model.h"
#include "SystemControl_model.h"
#include "MicroMEMORY_model.h"
#include "PL180_MCI_model.h"
#include "M4_model.h"
#include "A9x2_model.h"
#include "AXI_APB_model.h"
#include "LAN9118_model.h"
#include "AXI_model.h"
#include "MEMORY_model.h"
#include "uart_with_console.h"
$includes_end;

$module_begin("cluster");
SC_MODULE(cluster) {
public:
  typedef cluster SC_CURRENT_USER_MODULE;
  cluster(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("M4_IRQ_0"),
M4_IRQ_0("M4_IRQ_0")
$end
$init("M4_Bus_Extension"),
M4_Bus_Extension("M4_Bus_Extension")
$end
$init("a9x2"),
a9x2(0)
$end
$init("sdcard"),
sdcard(0)
$end
$init("ethernet"),
ethernet(0)
$end
$init("a9ctrl"),
a9ctrl(0)
$end
$init("a9_bus"),
a9_bus(0)
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
$init("m4_ram"),
m4_ram(0)
$end
$init("m4_bus"),
m4_bus(0)
$end
$init("m4"),
m4(0)
$end
$init("sysbridge"),
sysbridge(0)
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
$create_component("a9ctrl");
a9ctrl = new SystemControl_pvt("a9ctrl");
$end;
$create_component("a9_bus");
a9_bus = new AXI_pvt("a9_bus");
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
$create_component("m4_ram");
m4_ram = new MicroMEMORY_pvt("m4_ram");
$end;
$create_component("m4_bus");
m4_bus = new AHB_pvt("m4_bus");
$end;
$create_component("m4");
m4 = new M4_pvt("m4");
$end;
$create_component("sysbridge");
sysbridge = new SystemBridge_pvt("sysbridge");
$end;
$bind("sdcard->irq0","a9x2->irq_1");
vista_bind(sdcard->irq0, a9x2->irq_1);
$end;
$bind("sdcard->irq1","a9x2->irq_2");
vista_bind(sdcard->irq1, a9x2->irq_2);
$end;
$bind("ethernet->irq","a9x2->irq_0");
vista_bind(ethernet->irq, a9x2->irq_0);
$end;
$bind("a9_bus->ethernet","ethernet->host");
vista_bind(a9_bus->ethernet, ethernet->host);
$end;
$bind("a9_bus->system","a9ctrl->slave");
vista_bind(a9_bus->system, a9ctrl->slave);
$end;
$bind("a9_bus->sd","sdcard->host");
vista_bind(a9_bus->sd, sdcard->host);
$end;
$bind("a9x2->master0","a9_bus->a9");
vista_bind(a9x2->master0, a9_bus->a9);
$end;
$bind("a9_bus->ram","a9_ram->slave");
vista_bind(a9_bus->ram, a9_ram->slave);
$end;
$bind("a9_bus->fb","fb->from_bus");
vista_bind(a9_bus->fb, fb->from_bus);
$end;
$bind("a9_bus->bridge","sysbridge->a9_slave");
vista_bind(a9_bus->bridge, sysbridge->a9_slave);
$end;
$bind("a9_bus->apb","axi_apb->slave");
vista_bind(a9_bus->apb, axi_apb->slave);
$end;
$bind("m4_bus->ram","m4_ram->slave");
vista_bind(m4_bus->ram, m4_ram->slave);
$end;
$bind("m4->dcode","m4_bus->dcode");
vista_bind(m4->dcode, m4_bus->dcode);
$end;
$bind("m4->system","m4_bus->system");
vista_bind(m4->system, m4_bus->system);
$end;
$bind("m4->icode","m4_bus->icode");
vista_bind(m4->icode, m4_bus->icode);
$end;
$bind("m4_bus->bridge","sysbridge->m4_slave");
vista_bind(m4_bus->bridge, sysbridge->m4_slave);
$end;
$bind("axi_apb->master","a9_uart->slave");
vista_bind(axi_apb->master, a9_uart->slave);
$end;
$bind("a9_uart->irq","a9x2->irq_3");
vista_bind(a9_uart->irq, a9x2->irq_3);
$end;
$bind("M4_IRQ_0","m4->irq_0");
vista_bind(M4_IRQ_0, m4->irq_0);
$end;
$bind("m4_bus->extension_port","M4_Bus_Extension");
vista_bind(m4_bus->extension_port, M4_Bus_Extension);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "cluster_models";
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
$destruct_component("a9ctrl");
delete a9ctrl; a9ctrl = 0;
$end;
$destruct_component("a9_bus");
delete a9_bus; a9_bus = 0;
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
$destruct_component("m4_ram");
delete m4_ram; m4_ram = 0;
$end;
$destruct_component("m4_bus");
delete m4_bus; m4_bus = 0;
$end;
$destruct_component("m4");
delete m4; m4 = 0;
$end;
$destruct_component("sysbridge");
delete sysbridge; sysbridge = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("M4_IRQ_0");
tlm::tlm_target_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > M4_IRQ_0;
$end;
$socket("M4_Bus_Extension");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > M4_Bus_Extension;
$end;
$component("a9x2");
A9x2_pvt *a9x2;
$end;
$component("sdcard");
PL180_MCI_pvt *sdcard;
$end;
$component("ethernet");
LAN9118_pvt *ethernet;
$end;
$component("a9ctrl");
SystemControl_pvt *a9ctrl;
$end;
$component("a9_bus");
AXI_pvt *a9_bus;
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
$component("m4_ram");
MicroMEMORY_pvt *m4_ram;
$end;
$component("m4_bus");
AHB_pvt *m4_bus;
$end;
$component("m4");
M4_pvt *m4;
$end;
$component("sysbridge");
SystemBridge_pvt *sysbridge;
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