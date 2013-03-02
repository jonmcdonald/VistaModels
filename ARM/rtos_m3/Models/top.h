#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "AHBBUS_model.h"
#include "High_MEM_model.h"
#include "Low_MEM_model.h"
#include "APB32_16_model.h"
#include "models_catalogue.h"
#include "AHB_APB_model.h"
#include "MC_CM3_model.h"
#include "rgb_led_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("ahbbus"),
ahbbus(0)
$end
$init("sram"),
sram(0)
$end
$init("flash"),
flash(0)
$end
$init("uart"),
uart(0)
$end
$init("ahb_apb"),
ahb_apb(0)
$end
$init("console"),
console(0)
$end
$init("apb32_16"),
apb32_16(0)
$end
$init("cpu"),
cpu(0)
$end
$init("led"),
led(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("ahbbus");
ahbbus = new AHBBUS_pvt("ahbbus");
$end;
$create_component("sram");
sram = new High_MEM_pvt("sram");
$end;
$create_component("flash");
flash = new Low_MEM_pvt("flash");
$end;
$create_component("uart");
uart = new UART_PL011_pvt("uart");
$end;
$create_component("ahb_apb");
ahb_apb = new AHB_APB_pvt("ahb_apb");
$end;
$create_component("console");
console = new UART_Visualization_Middleware_pvt("console");
$end;
$create_component("apb32_16");
apb32_16 = new APB32_16_pvt("apb32_16");
$end;
$create_component("cpu");
cpu = new MC_CM3_pvt("cpu");
$end;
$create_component("led");
led = new rgb_led_pvt("led");
$end;
$bind("ahbbus->mem_high","sram->slave");
ahbbus->mem_high.bind(sram->slave);
$end;
$bind("ahbbus->mem_low","flash->slave");
ahbbus->mem_low.bind(flash->slave);
$end;
$bind("ahbbus->uart","ahb_apb->ahb_slave");
vista_bind(ahbbus->uart, ahb_apb->ahb_slave);
$end;
$bind("uart->nUARTRTS","console->nUARTCTS");
vista_bind(uart->nUARTRTS, console->nUARTCTS);
$end;
$bind("apb32_16->apb_master","uart->AMBA_APB");
vista_bind(apb32_16->apb_master, uart->AMBA_APB);
$end;
$bind("ahb_apb->apb_master","apb32_16->apb_slave");
vista_bind(ahb_apb->apb_master, apb32_16->apb_slave);
$end;
$bind("console->nUARTRTS","uart->nUARTCTS");
vista_bind(console->nUARTRTS, uart->nUARTCTS);
$end;
$bind("console->UARTTXD","uart->UARTRXD");
vista_bind(console->UARTTXD, uart->UARTRXD);
$end;
$bind("uart->UARTTXD","console->UARTRXD");
vista_bind(uart->UARTTXD, console->UARTRXD);
$end;
$bind("cpu->dcode","ahbbus->dcode");
vista_bind(cpu->dcode, ahbbus->dcode);
$end;
$bind("cpu->icode","ahbbus->icode");
vista_bind(cpu->icode, ahbbus->icode);
$end;
$bind("cpu->system","ahbbus->system");
vista_bind(cpu->system, ahbbus->system);
$end;
$bind("ahbbus->rgb_led","led->ahb_slave");
vista_bind(ahbbus->rgb_led, led->ahb_slave);
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
$destruct_component("ahbbus");
delete ahbbus; ahbbus = 0;
$end;
$destruct_component("sram");
delete sram; sram = 0;
$end;
$destruct_component("flash");
delete flash; flash = 0;
$end;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("ahb_apb");
delete ahb_apb; ahb_apb = 0;
$end;
$destruct_component("console");
delete console; console = 0;
$end;
$destruct_component("apb32_16");
delete apb32_16; apb32_16 = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("led");
delete led; led = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("ahbbus");
AHBBUS_pvt *ahbbus;
$end;
$component("sram");
High_MEM_pvt *sram;
$end;
$component("flash");
Low_MEM_pvt *flash;
$end;
$component("uart");
UART_PL011_pvt *uart;
$end;
$component("ahb_apb");
AHB_APB_pvt *ahb_apb;
$end;
$component("console");
UART_Visualization_Middleware_pvt *console;
$end;
$component("apb32_16");
APB32_16_pvt *apb32_16;
$end;
$component("cpu");
MC_CM3_pvt *cpu;
$end;
$component("led");
rgb_led_pvt *led;
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