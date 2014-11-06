#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../../pyex/models/AXI_GPIO_model.h"
#include "../../pyex/models/CustomPeripheral_model.h"
#include "zynq_schematics/Zynq_SoC.h"
$includes_end;

$module_begin("vptop");
SC_MODULE(vptop) {
public:
  typedef vptop SC_CURRENT_USER_MODULE;
  vptop(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("Zynq_SoC_inst"),
Zynq_SoC_inst(0)
$end
$init("axi_gpio0"),
axi_gpio0(0)
$end
$init("customperipheral0"),
customperipheral0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("Zynq_SoC_inst");
Zynq_SoC_inst = new Zynq_SoC("Zynq_SoC_inst");
$end;
$create_component("axi_gpio0");
axi_gpio0 = new AXI_GPIO_pvt("axi_gpio0");
$end;
$create_component("customperipheral0");
customperipheral0 = new CustomPeripheral_pvt("customperipheral0");
$end;
$bind("axi_gpio0->GPOUT0","customperipheral0->slave");
vista_bind(axi_gpio0->GPOUT0, customperipheral0->slave);
$end;
$bind("customperipheral0->master","axi_gpio0->GPIN0");
vista_bind(customperipheral0->master, axi_gpio0->GPIN0);
$end;
$bind("axi_gpio0->IRQ","Zynq_SoC_inst->PL0_IRQ");
vista_bind(axi_gpio0->IRQ, Zynq_SoC_inst->PL0_IRQ);
$end;
$bind("Zynq_SoC_inst->M_AXI_GP0","axi_gpio0->AXI");
vista_bind(Zynq_SoC_inst->M_AXI_GP0, axi_gpio0->AXI);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~vptop() {
    $destructor_begin;
$destruct_component("Zynq_SoC_inst");
delete Zynq_SoC_inst; Zynq_SoC_inst = 0;
$end;
$destruct_component("axi_gpio0");
delete axi_gpio0; axi_gpio0 = 0;
$end;
$destruct_component("customperipheral0");
delete customperipheral0; customperipheral0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("Zynq_SoC_inst");
Zynq_SoC *Zynq_SoC_inst;
$end;
$component("axi_gpio0");
AXI_GPIO_pvt *axi_gpio0;
$end;
$component("customperipheral0");
CustomPeripheral_pvt *customperipheral0;
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