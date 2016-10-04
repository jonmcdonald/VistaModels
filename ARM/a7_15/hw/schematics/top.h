#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/AXIBus_model.h"
#include "../models/RAM_model.h"
#include "../models/APBBus_model.h"
#include "../models/AXIAPB_model.h"
#include "../models/PL180_model.h"
#include "../models/LAN9118_model.h"
#include "UARTSubSystem.h"
#include "../models/supermodel_model.h"
#include "../models/cpu.h"
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
$init("apb"),
apb(0)
$end
$init("mci"),
mci(0)
$end
$init("eth"),
eth(0)
$end
$init("serial0"),
serial0(0)
$end
$init("serial1"),
serial1(0)
$end
$init("sm"),
sm(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu");
cpu = new CPUTYPE("cpu");
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
$create_component("apb");
apb = new APBBus_pvt("apb");
$end;
$create_component("mci");
mci = new PL180_pvt("mci");
$end;
$create_component("eth");
eth = new LAN9118_pvt("eth");
$end;
$create_component("serial0");
serial0 = new UARTSubSystem("serial0");
$end;
$create_component("serial1");
serial1 = new UARTSubSystem("serial1");
$end;
$create_component("sm");
sm = new supermodel_pvt("sm");
$end;
$bind("cpu->master0","axi->cpu");
vista_bind(cpu->master0, axi->cpu);
$end;
$bind("axi->peripherals","bridge->slave");
vista_bind(axi->peripherals, bridge->slave);
$end;
$bind("axi->memory","mem->slave");
vista_bind(axi->memory, mem->slave);
$end;
$bind("bridge->master","apb->bridge");
vista_bind(bridge->master, apb->bridge);
$end;
$bind("apb->mci","mci->host");
vista_bind(apb->mci, mci->host);
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
$bind("apb->uart1","serial1->AMBA_APB");
vista_bind(apb->uart1, serial1->AMBA_APB);
$end;
$bind("apb->uart0","serial0->AMBA_APB");
vista_bind(apb->uart0, serial0->AMBA_APB);
$end;
$bind("serial1->UARTINTR","cpu->irq_6");
vista_bind(serial1->UARTINTR, cpu->irq_6);
$end;
$bind("serial0->UARTINTR","cpu->irq_5");
vista_bind(serial0->UARTINTR, cpu->irq_5);
$end;
$bind("sm->irq","cpu->irq_11");
vista_bind(sm->irq, cpu->irq_11);
$end;
$bind("axi->sm","sm->slave");
vista_bind(axi->sm, sm->slave);
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
$destruct_component("apb");
delete apb; apb = 0;
$end;
$destruct_component("mci");
delete mci; mci = 0;
$end;
$destruct_component("eth");
delete eth; eth = 0;
$end;
$destruct_component("serial0");
delete serial0; serial0 = 0;
$end;
$destruct_component("serial1");
delete serial1; serial1 = 0;
$end;
$destruct_component("sm");
delete sm; sm = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu");
CPUTYPE *cpu;
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
$component("apb");
APBBus_pvt *apb;
$end;
$component("mci");
PL180_pvt *mci;
$end;
$component("eth");
LAN9118_pvt *eth;
$end;
$component("serial0");
UARTSubSystem *serial0;
$end;
$component("serial1");
UARTSubSystem *serial1;
$end;
$component("sm");
supermodel_pvt *sm;
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
