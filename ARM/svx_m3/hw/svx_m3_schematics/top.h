#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../svx_m3_models/MEMORY_model.h"
#include "../svx_m3_models/M3_model.h"
#include "../svx_m3_models/AHB_BUS_model.h"
#include "../svx_m3_models/i_mx6_pwm_model.h"
#include "svx_models.h"
#include "../svx_m3_models/NADA_model.h"
#include "svx_generator.h"
#include "../svx_m3_models/SIGNAL_SVX_BOOL_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("pwm"),
pwm(0)
$end
$init("rom"),
rom(0)
$end
$init("ext_ram"),
ext_ram(0)
$end
$init("ram"),
ram(0)
$end
$init("bus"),
bus(0)
$end
$init("m3"),
m3(0)
$end
$init("svx"),
svx(0)
$end
$init("nada"),
nada(0)
$end
$init("svx_pwmo"),
svx_pwmo(0)
$end
$init("svx_bridge"),
svx_bridge(0)
$end
$init("pin_out"),
pin_out("pin_out")
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("pwm");
pwm = new i_mx6_pwm_pvt("pwm");
$end;
$create_component("rom");
rom = new MEMORY_pvt("rom");
$end;
$create_component("ext_ram");
ext_ram = new MEMORY_pvt("ext_ram");
$end;
$create_component("ram");
ram = new MEMORY_pvt("ram");
$end;
$create_component("bus");
bus = new AHB_BUS_pvt("bus");
$end;
$create_component("m3");
m3 = new M3_pvt("m3");
$end;
$create_component("svx");
svx = new svx_connect_pvt("svx");
$end;
$create_component("nada");
nada = new NADA_pvt("nada");
$end;
$create_component("svx_pwmo");
svx_pwmo = new svx_generator_bool("svx_pwmo");
$end;
$create_component("svx_bridge");
svx_bridge = new SIGNAL_SVX_BOOL_pvt("svx_bridge");
$end;
$bind("bus->pwm","pwm->SLAVE");
vista_bind(bus->pwm, pwm->SLAVE);
$end;
$bind("m3->dcode","bus->dcode");
vista_bind(m3->dcode, bus->dcode);
$end;
$bind("pwm->IRQ","m3->irq_0");
vista_bind(pwm->IRQ, m3->irq_0);
$end;
$bind("bus->ext_ram","ext_ram->slave");
vista_bind(bus->ext_ram, ext_ram->slave);
$end;
$bind("bus->rom","rom->slave");
vista_bind(bus->rom, rom->slave);
$end;
$bind("bus->ram","ram->slave");
vista_bind(bus->ram, ram->slave);
$end;
$bind("m3->system","bus->system");
vista_bind(m3->system, bus->system);
$end;
$bind("m3->icode","bus->icode");
vista_bind(m3->icode, bus->icode);
$end;
$bind("nada->master","svx->config");
vista_bind(nada->master, svx->config);
$end;
$bind("pwm->PWMO","svx_bridge->slave");
vista_bind(pwm->PWMO, svx_bridge->slave);
$end;
$bind("svx_bridge->pin_out","pin_out");
vista_bind(svx_bridge->pin_out, pin_out);
$end;
$bind("svx_pwmo->svx_generator_signal","pin_out");
vista_bind(svx_pwmo->svx_generator_signal, pin_out);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "svx_m3_schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("pwm");
delete pwm; pwm = 0;
$end;
$destruct_component("rom");
delete rom; rom = 0;
$end;
$destruct_component("ext_ram");
delete ext_ram; ext_ram = 0;
$end;
$destruct_component("ram");
delete ram; ram = 0;
$end;
$destruct_component("bus");
delete bus; bus = 0;
$end;
$destruct_component("m3");
delete m3; m3 = 0;
$end;
$destruct_component("svx");
delete svx; svx = 0;
$end;
$destruct_component("nada");
delete nada; nada = 0;
$end;
$destruct_component("svx_pwmo");
delete svx_pwmo; svx_pwmo = 0;
$end;
$destruct_component("svx_bridge");
delete svx_bridge; svx_bridge = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("pwm");
i_mx6_pwm_pvt *pwm;
$end;
$component("rom");
MEMORY_pvt *rom;
$end;
$component("ext_ram");
MEMORY_pvt *ext_ram;
$end;
$component("ram");
MEMORY_pvt *ram;
$end;
$component("bus");
AHB_BUS_pvt *bus;
$end;
$component("m3");
M3_pvt *m3;
$end;
$component("svx");
svx_connect_pvt *svx;
$end;
$component("nada");
NADA_pvt *nada;
$end;
$component("svx_pwmo");
svx_generator_bool *svx_pwmo;
$end;
$component("svx_bridge");
SIGNAL_SVX_BOOL_pvt *svx_bridge;
$end;
$channel("pin_out");
sc_signal< bool, SC_MANY_WRITERS > pin_out;
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