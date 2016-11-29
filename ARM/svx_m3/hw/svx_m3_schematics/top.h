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
#include "../svx_m3_models/SIGNAL_SVX_model.h"
#include "../svx_m3_models/ADC_model.h"
#include "svx_consumer.h"
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
$init("svx_target"),
svx_target(0)
$end
$init("nada"),
nada(0)
$end
$init("svx_pwm_pin"),
svx_pwm_pin(0)
$end
$init("svx_abstraction"),
svx_abstraction(0)
$end
$init("svx_pwm_duty_cycle"),
svx_pwm_duty_cycle(0)
$end
$init("svx_pwm_frequency"),
svx_pwm_frequency(0)
$end
$init("adc"),
adc(0)
$end
$init("svx_adc_pin"),
svx_adc_pin(0)
$end
$init("pin_out"),
pin_out("pin_out")
$end
$init("frequency"),
frequency("frequency")
$end
$init("duty_cycle"),
duty_cycle("duty_cycle")
$end
$init("svx_consumer_signal"),
svx_consumer_signal("svx_consumer_signal")
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
$create_component("svx_target");
svx_target = new svx_connect_pvt("svx_target");
$end;
$create_component("nada");
nada = new NADA_pvt("nada");
$end;
$create_component("svx_pwm_pin");
svx_pwm_pin = new svx_generator_bool("svx_pwm_pin");
$end;
$create_component("svx_abstraction");
svx_abstraction = new SIGNAL_SVX_pvt("svx_abstraction");
$end;
$create_component("svx_pwm_duty_cycle");
svx_pwm_duty_cycle = new svx_generator_double("svx_pwm_duty_cycle");
$end;
$create_component("svx_pwm_frequency");
svx_pwm_frequency = new svx_generator_unsigned("svx_pwm_frequency");
$end;
$create_component("adc");
adc = new ADC_pvt("adc");
$end;
$create_component("svx_adc_pin");
svx_adc_pin = new svx_consumer_double("svx_adc_pin");
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
$bind("nada->master","svx_target->config");
vista_bind(nada->master, svx_target->config);
$end;
$bind("svx_pwm_pin->svx_generator_signal","pin_out");
vista_bind(svx_pwm_pin->svx_generator_signal, pin_out);
$end;
$bind("svx_abstraction->pin_out","pin_out");
vista_bind(svx_abstraction->pin_out, pin_out);
$end;
$bind("pwm->PWMO","svx_abstraction->slave");
vista_bind(pwm->PWMO, svx_abstraction->slave);
$end;
$bind("svx_pwm_duty_cycle->svx_generator_signal","duty_cycle");
vista_bind(svx_pwm_duty_cycle->svx_generator_signal, duty_cycle);
$end;
$bind("svx_abstraction->frequency","frequency");
vista_bind(svx_abstraction->frequency, frequency);
$end;
$bind("svx_abstraction->duty_cycle","duty_cycle");
vista_bind(svx_abstraction->duty_cycle, duty_cycle);
$end;
$bind("svx_pwm_frequency->svx_generator_signal","frequency");
vista_bind(svx_pwm_frequency->svx_generator_signal, frequency);
$end;
$bind("bus->adc","adc->slave");
vista_bind(bus->adc, adc->slave);
$end;
$bind("adc->pin_in","svx_consumer_signal");
vista_bind(adc->pin_in, svx_consumer_signal);
$end;
$bind("adc->irq","m3->irq_1");
vista_bind(adc->irq, m3->irq_1);
$end;
$bind("svx_adc_pin->svx_consumer_signal","svx_consumer_signal");
vista_bind(svx_adc_pin->svx_consumer_signal, svx_consumer_signal);
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
$destruct_component("svx_target");
delete svx_target; svx_target = 0;
$end;
$destruct_component("nada");
delete nada; nada = 0;
$end;
$destruct_component("svx_pwm_pin");
delete svx_pwm_pin; svx_pwm_pin = 0;
$end;
$destruct_component("svx_abstraction");
delete svx_abstraction; svx_abstraction = 0;
$end;
$destruct_component("svx_pwm_duty_cycle");
delete svx_pwm_duty_cycle; svx_pwm_duty_cycle = 0;
$end;
$destruct_component("svx_pwm_frequency");
delete svx_pwm_frequency; svx_pwm_frequency = 0;
$end;
$destruct_component("adc");
delete adc; adc = 0;
$end;
$destruct_component("svx_adc_pin");
delete svx_adc_pin; svx_adc_pin = 0;
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
$component("svx_target");
svx_connect_pvt *svx_target;
$end;
$component("nada");
NADA_pvt *nada;
$end;
$component("svx_pwm_pin");
svx_generator_bool *svx_pwm_pin;
$end;
$component("svx_abstraction");
SIGNAL_SVX_pvt *svx_abstraction;
$end;
$component("svx_pwm_duty_cycle");
svx_generator_double *svx_pwm_duty_cycle;
$end;
$component("svx_pwm_frequency");
svx_generator_unsigned *svx_pwm_frequency;
$end;
$component("adc");
ADC_pvt *adc;
$end;
$component("svx_adc_pin");
svx_consumer_double *svx_adc_pin;
$end;
$channel("pin_out");
sc_signal< bool, SC_MANY_WRITERS > pin_out;
$end;
$channel("frequency");
sc_signal< uint32_t, SC_MANY_WRITERS > frequency;
$end;
$channel("duty_cycle");
sc_signal< double, SC_MANY_WRITERS > duty_cycle;
$end;
$channel("svx_consumer_signal");
sc_signal< double, SC_MANY_WRITERS > svx_consumer_signal;
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