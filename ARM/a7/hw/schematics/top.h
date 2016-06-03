#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/DualCortexA7_model.h"
#include "../models/AXIBus_model.h"
#include "../models/RAM_model.h"
#include "models_catalogue.h"
#include "../models/APBBus_model.h"
#include "../models/AXIAPB_model.h"
#include "../models/PL180_model.h"
#include "../models/LAN9118_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cpu"),
cpu(0)
$end
$init("axi"),
axi(0)
$end
$init("mem"),
mem(0)
$end
$init("bridge"),
bridge(0)
$end
$init("console0"),
console0(0)
$end
$init("apb"),
apb(0)
$end
$init("uart0"),
uart0(0)
$end
$init("mci"),
mci(0)
$end
$init("eth"),
eth(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu");
cpu = new DualCortexA7_pvt("cpu");
$end;
$create_component("axi");
axi = new AXIBus_pvt("axi");
$end;
$create_component("mem");
mem = new RAM_pvt("mem");
$end;
$create_component("bridge");
bridge = new AXIAPB_pvt("bridge");
$end;
$create_component("console0");
console0 = new UART_Visualization_Middleware_pvt("console0");
$end;
$create_component("apb");
apb = new APBBus_pvt("apb");
$end;
$create_component("uart0");
uart0 = new UART_PL011_pvt("uart0");
$end;
$create_component("mci");
mci = new PL180_pvt("mci");
$end;
$create_component("eth");
eth = new LAN9118_pvt("eth");
$end;
$bind("cpu->master0","axi->cpu");
vista_bind(cpu->master0, axi->cpu);
$end;
$bind("axi->peripherals","bridge->slave");
vista_bind(axi->peripherals, bridge->slave);
$end;
$bind("apb->uart0","uart0->AMBA_APB");
vista_bind(apb->uart0, uart0->AMBA_APB);
$end;
$bind("axi->memory","mem->slave");
vista_bind(axi->memory, mem->slave);
$end;
$bind("console0->nUARTRTS","uart0->nUARTCTS");
vista_bind(console0->nUARTRTS, uart0->nUARTCTS);
$end;
$bind("uart0->UARTTXD","console0->UARTRXD");
vista_bind(uart0->UARTTXD, console0->UARTRXD);
$end;
$bind("console0->UARTTXD","uart0->UARTRXD");
vista_bind(console0->UARTTXD, uart0->UARTRXD);
$end;
$bind("uart0->nUARTRTS","console0->nUARTCTS");
vista_bind(uart0->nUARTRTS, console0->nUARTCTS);
$end;
$bind("bridge->master","apb->bridge");
vista_bind(bridge->master, apb->bridge);
$end;
$bind("apb->mci","mci->host");
vista_bind(apb->mci, mci->host);
$end;
$bind("uart0->UARTINTR","cpu->irq_5");
vista_bind(uart0->UARTINTR, cpu->irq_5);
$end;
$bind("mci->irq0","cpu->irq_9");
vista_bind(mci->irq0, cpu->irq_9);
$end;
$bind("mci->irq1","cpu->irq_10");
vista_bind(mci->irq1, cpu->irq_10);
$end;
$bind("axi->ethernet","eth->host");
vista_bind(axi->ethernet, eth->host);
$end;
$bind("eth->irq","cpu->irq_15");
vista_bind(eth->irq, cpu->irq_15);
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
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("axi");
delete axi; axi = 0;
$end;
$destruct_component("mem");
delete mem; mem = 0;
$end;
$destruct_component("bridge");
delete bridge; bridge = 0;
$end;
$destruct_component("console0");
delete console0; console0 = 0;
$end;
$destruct_component("apb");
delete apb; apb = 0;
$end;
$destruct_component("uart0");
delete uart0; uart0 = 0;
$end;
$destruct_component("mci");
delete mci; mci = 0;
$end;
$destruct_component("eth");
delete eth; eth = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu");
DualCortexA7_pvt *cpu;
$end;
$component("axi");
AXIBus_pvt *axi;
$end;
$component("mem");
RAM_pvt *mem;
$end;
$component("bridge");
AXIAPB_pvt *bridge;
$end;
$component("console0");
UART_Visualization_Middleware_pvt *console0;
$end;
$component("apb");
APBBus_pvt *apb;
$end;
$component("uart0");
UART_PL011_pvt *uart0;
$end;
$component("mci");
PL180_pvt *mci;
$end;
$component("eth");
LAN9118_pvt *eth;
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