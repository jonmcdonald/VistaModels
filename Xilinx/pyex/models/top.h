#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "CustomPeripheral_model.h"
#include "AXI_GPIO_model.h"
#include "drive_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("periph0"),
periph0(0)
$end
$init("axi_gpio0"),
axi_gpio0(0)
$end
$init("drive0"),
drive0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("periph0");
periph0 = new CustomPeripheral_pvt("periph0");
$end;
$create_component("axi_gpio0");
axi_gpio0 = new AXI_GPIO_pvt("axi_gpio0");
$end;
$create_component("drive0");
drive0 = new drive_pvt("drive0");
$end;
$bind("axi_gpio0->GPOUT0","periph0->slave");
vista_bind(axi_gpio0->GPOUT0, periph0->slave);
$end;
$bind("periph0->master","axi_gpio0->GPIN0");
vista_bind(periph0->master, axi_gpio0->GPIN0);
$end;
$bind("axi_gpio0->IRQ","drive0->irq");
vista_bind(axi_gpio0->IRQ, drive0->irq);
$end;
$bind("drive0->m","axi_gpio0->AXI");
vista_bind(drive0->m, axi_gpio0->AXI);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "models";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("periph0");
delete periph0; periph0 = 0;
$end;
$destruct_component("axi_gpio0");
delete axi_gpio0; axi_gpio0 = 0;
$end;
$destruct_component("drive0");
delete drive0; drive0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("periph0");
CustomPeripheral_pvt *periph0;
$end;
$component("axi_gpio0");
AXI_GPIO_pvt *axi_gpio0;
$end;
$component("drive0");
drive_pvt *drive0;
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
