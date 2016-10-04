#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/e5500_model.h"
#include "models_catalogue.h"
#include "../models/IC_model.h"
#include "../models/MEMORY_model.h"
#include "../models/BUS_model.h"
#include "../models/FPGA_model.h"
#include "../models/FAULT_model.h"
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
$init("ic"),
ic(0)
$end
$init("bus"),
bus(0)
$end
$init("uart"),
uart(0)
$end
$init("mem"),
mem(0)
$end
$init("console"),
console(0)
$end
$init("fabric"),
fabric(0)
$end
$init("fault"),
fault(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cpu");
cpu = new e5500_pvt("cpu");
$end;
$create_component("ic");
ic = new IC_pvt("ic");
$end;
$create_component("bus");
bus = new BUS_pvt("bus");
$end;
$create_component("uart");
uart = new UART_16550_pvt("uart");
$end;
$create_component("mem");
mem = new MEMORY_pvt("mem");
$end;
$create_component("console");
console = new CONSOLE_pvt("console");
$end;
$create_component("fabric");
fabric = new FPGA_pvt("fabric");
$end;
$create_component("fault");
fault = new FAULT_pvt("fault");
$end;
$bind("cpu->data_rw_initiator","bus->data_rw");
vista_bind(cpu->data_rw_initiator, bus->data_rw);
$end;
$bind("cpu->intc_if","ic->IACK_read");
vista_bind(cpu->intc_if, ic->IACK_read);
$end;
$bind("ic->mcp_n","cpu->mcp_n");
vista_bind(ic->mcp_n, cpu->mcp_n);
$end;
$bind("bus->ram","mem->slave");
vista_bind(bus->ram, mem->slave);
$end;
$bind("cpu->insn_initiator","bus->insn");
vista_bind(cpu->insn_initiator, bus->insn);
$end;
$bind("uart->irq","ic->Internal0");
vista_bind(uart->irq, ic->Internal0);
$end;
$bind("bus->ic","ic->bus_slave");
vista_bind(bus->ic, ic->bus_slave);
$end;
$bind("ic->reset_n","cpu->reset_n");
vista_bind(ic->reset_n, cpu->reset_n);
$end;
$bind("ic->int_n","cpu->int_n");
vista_bind(ic->int_n, cpu->int_n);
$end;
$bind("ic->cint_n","cpu->cint_n");
vista_bind(ic->cint_n, cpu->cint_n);
$end;
$bind("uart->transmit","console->RX");
vista_bind(uart->transmit, console->RX);
$end;
$bind("console->TX","uart->receive");
vista_bind(console->TX, uart->receive);
$end;
$bind("bus->fpga","fabric->slave");
vista_bind(bus->fpga, fabric->slave);
$end;
$bind("fabric->irq","ic->Internal1");
vista_bind(fabric->irq, ic->Internal1);
$end;
$bind("bus->uart","uart->slave");
vista_bind(bus->uart, uart->slave);
$end;
$bind("fabric->master","bus->from_fpga");
vista_bind(fabric->master, bus->from_fpga);
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
$destruct_component("ic");
delete ic; ic = 0;
$end;
$destruct_component("bus");
delete bus; bus = 0;
$end;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("mem");
delete mem; mem = 0;
$end;
$destruct_component("console");
delete console; console = 0;
$end;
$destruct_component("fabric");
delete fabric; fabric = 0;
$end;
$destruct_component("fault");
delete fault; fault = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cpu");
e5500_pvt *cpu;
$end;
$component("ic");
IC_pvt *ic;
$end;
$component("bus");
BUS_pvt *bus;
$end;
$component("uart");
UART_16550_pvt *uart;
$end;
$component("mem");
MEMORY_pvt *mem;
$end;
$component("console");
CONSOLE_pvt *console;
$end;
$component("fabric");
FPGA_pvt *fabric;
$end;
$component("fault");
FAULT_pvt *fault;
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