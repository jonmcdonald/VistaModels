#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "AHBBUS_model.h"
#include "models_catalogue.h"
#include "AHB_APB_model.h"
#include "rgb_led_model.h"
#include "MEMORY_model.h"
#include "CORTEX_M3_model.h"
#include "APBBUS_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("ahb_bus"),
ahb_bus(0)
$end
$init("sram"),
sram(0)
$end
$init("uart"),
uart(0)
$end
$init("apb_bus"),
apb_bus(0)
$end
$init("console"),
console(0)
$end
$init("cpu"),
cpu(0)
$end
$init("led"),
led(0)
$end
$init("flash"),
flash(0)
$end
$init("ahb_apb"),
ahb_apb(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("ahb_bus");
ahb_bus = new AHBBUS_pvt("ahb_bus");
$end;
$create_component("sram");
sram = new MEMORY_pvt("sram");
$end;
$create_component("uart");
uart = new UART_PL011_pvt("uart");
$end;
$create_component("apb_bus");
apb_bus = new APBBUS_pvt("apb_bus");
$end;
$create_component("console");
console = new UART_Visualization_Middleware_pvt("console");
$end;
$create_component("cpu");
cpu = new CORTEX_M3_pvt("cpu");
$end;
$create_component("led");
led = new rgb_led_pvt("led");
$end;
$create_component("flash");
flash = new MEMORY_pvt("flash");
$end;
$create_component("ahb_apb");
ahb_apb = new AHB_APB_pvt("ahb_apb");
$end;
$bind("ahb_bus->mem_high","sram->slave");
ahb_bus->mem_high.bind(sram->slave);
$end;
$bind("uart->nUARTRTS","console->nUARTCTS");
vista_bind(uart->nUARTRTS, console->nUARTCTS);
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
$bind("cpu->dcode","ahb_bus->dcode");
vista_bind(cpu->dcode, ahb_bus->dcode);
$end;
$bind("cpu->icode","ahb_bus->icode");
vista_bind(cpu->icode, ahb_bus->icode);
$end;
$bind("cpu->system","ahb_bus->system");
vista_bind(cpu->system, ahb_bus->system);
$end;
$bind("ahb_bus->mem_low","flash->slave");
vista_bind(ahb_bus->mem_low, flash->slave);
$end;
$bind("ahb_bus->apb","ahb_apb->ahb_slave");
vista_bind(ahb_bus->apb, ahb_apb->ahb_slave);
$end;
$bind("apb_bus->uart","uart->AMBA_APB");
vista_bind(apb_bus->uart, uart->AMBA_APB);
$end;
$bind("apb_bus->led","led->ahb_slave");
vista_bind(apb_bus->led, led->ahb_slave);
$end;
$bind("ahb_apb->apb_master","apb_bus->bus_slave");
vista_bind(ahb_apb->apb_master, apb_bus->bus_slave);
$end;
$bind("uart->UARTTXINTR","cpu->irq_0");
vista_bind(uart->UARTTXINTR, cpu->irq_0);
$end;
$bind("uart->UARTRXINTR","cpu->irq_1");
vista_bind(uart->UARTRXINTR, cpu->irq_1);
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
$destruct_component("ahb_bus");
delete ahb_bus; ahb_bus = 0;
$end;
$destruct_component("sram");
delete sram; sram = 0;
$end;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("apb_bus");
delete apb_bus; apb_bus = 0;
$end;
$destruct_component("console");
delete console; console = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("led");
delete led; led = 0;
$end;
$destruct_component("flash");
delete flash; flash = 0;
$end;
$destruct_component("ahb_apb");
delete ahb_apb; ahb_apb = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("ahb_bus");
AHBBUS_pvt *ahb_bus;
$end;
$component("sram");
MEMORY_pvt *sram;
$end;
$component("uart");
UART_PL011_pvt *uart;
$end;
$component("apb_bus");
APBBUS_pvt *apb_bus;
$end;
$component("console");
UART_Visualization_Middleware_pvt *console;
$end;
$component("cpu");
CORTEX_M3_pvt *cpu;
$end;
$component("led");
rgb_led_pvt *led;
$end;
$component("flash");
MEMORY_pvt *flash;
$end;
$component("ahb_apb");
AHB_APB_pvt *ahb_apb;
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