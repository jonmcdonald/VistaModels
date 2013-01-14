#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "models_catalogue.h"
#include "../models/apb_bus_model.h"
#include "../models/fake_cpu_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("uart_visualization"),
uart_visualization(0)
$end
$init("uart"),
uart(0)
$end
$init("cpu"),
cpu(0)
$end
$init("bus"),
bus(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("uart_visualization");
uart_visualization = new UART_Visualization_Middleware_pvt("uart_visualization");
$end;
$create_component("uart");
uart = new UART_PL011_pvt("uart");
$end;
$create_component("cpu");
cpu = new fake_cpu_pvt("cpu");
$end;
$create_component("bus");
bus = new apb_bus_pvt("bus");
$end;
$bind("uart->nUARTRTS","uart_visualization->nUARTCTS");
vista_bind(uart->nUARTRTS, uart_visualization->nUARTCTS);
$end;
$bind("uart_visualization->UARTTXD","uart->UARTRXD");
vista_bind(uart_visualization->UARTTXD, uart->UARTRXD);
$end;
$bind("uart_visualization->nUARTRTS","uart->nUARTCTS");
vista_bind(uart_visualization->nUARTRTS, uart->nUARTCTS);
$end;
$bind("cpu->cpu_master","bus->bus_slave");
vista_bind(cpu->cpu_master, bus->bus_slave);
$end;
$bind("bus->bus_master","uart->AMBA_APB");
vista_bind(bus->bus_master, uart->AMBA_APB);
$end;
$bind("uart->UARTTXD","uart_visualization->UARTRXD");
vista_bind(uart->UARTTXD, uart_visualization->UARTRXD);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "diagrams";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("uart_visualization");
delete uart_visualization; uart_visualization = 0;
$end;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("cpu");
delete cpu; cpu = 0;
$end;
$destruct_component("bus");
delete bus; bus = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("uart_visualization");
UART_Visualization_Middleware_pvt *uart_visualization;
$end;
$component("uart");
UART_PL011_pvt *uart;
$end;
$component("cpu");
fake_cpu_pvt *cpu;
$end;
$component("bus");
apb_bus_pvt *bus;
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
