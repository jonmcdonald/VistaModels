#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "AXI_BUS_model.h"
#include "MEMORY_model.h"
#include "PL110_LCD_model.h"
#include "CUSTOM_GPU_model.h"
#include "A9x1_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cpu"),
cpu(0)
$end
$init("axi"),
axi(0)
$end
$init("lcd"),
lcd(0)
$end
$init("gpu"),
gpu(0)
$end
$init("sram"),
sram(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu");
cpu = new A9x1_pvt("cpu");
$end;
$create_component("axi");
axi = new AXI_BUS_pvt("axi");
$end;
$create_component("lcd");
lcd = new PL110_LCD_pvt("lcd");
$end;
$create_component("gpu");
gpu = new CUSTOM_GPU_pvt("gpu");
$end;
$create_component("sram");
sram = new MEMORY_pvt("sram");
$end;
$bind("lcd->master","axi->from_lcd");
vista_bind(lcd->master, axi->from_lcd);
$end;
$bind("axi->to_lcd","lcd->ctrl_slave");
vista_bind(axi->to_lcd, lcd->ctrl_slave);
$end;
$bind("axi->to_gpu","gpu->reg_access");
vista_bind(axi->to_gpu, gpu->reg_access);
$end;
$bind("gpu->mem_access","axi->from_gpu");
vista_bind(gpu->mem_access, axi->from_gpu);
$end;
$bind("axi->to_sram","sram->slave");
vista_bind(axi->to_sram, sram->slave);
$end;
$bind("cpu->master1","axi->cpu_1");
vista_bind(cpu->master1, axi->cpu_1);
$end;
$bind("cpu->master0","axi->cpu_0");
vista_bind(cpu->master0, axi->cpu_0);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "Models";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("axi");
delete axi; axi = 0;
$end;
$destruct_component("lcd");
delete lcd; lcd = 0;
$end;
$destruct_component("gpu");
delete gpu; gpu = 0;
$end;
$destruct_component("sram");
delete sram; sram = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu");
A9x1_pvt *cpu;
$end;
$component("axi");
AXI_BUS_pvt *axi;
$end;
$component("lcd");
PL110_LCD_pvt *lcd;
$end;
$component("gpu");
CUSTOM_GPU_pvt *gpu;
$end;
$component("sram");
MEMORY_pvt *sram;
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