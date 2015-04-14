#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "models_catalogue.h"
#include "../cluster_models/APB_model.h"
$includes_end;

$module_begin("uart_with_console");
SC_MODULE(uart_with_console) {
public:
  uart_with_console(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("slave"),
slave("slave")
$end
$init("irq"),
irq("irq")
$end
$init("console"),
console(0)
$end
$init("uart"),
uart(0)
$end
$init("apb"),
apb(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("console");
console = new UART_Visualization_Middleware_pvt("console");
$end;
$create_component("uart");
uart = new UART_PL011_pvt("uart");
$end;
$create_component("apb");
apb = new APB_pvt("apb");
$end;
$bind("console->nUARTRTS","uart->nUARTCTS");
vista_bind(console->nUARTRTS, uart->nUARTCTS);
$end;
$bind("uart->UARTTXD","console->UARTRXD");
vista_bind(uart->UARTTXD, console->UARTRXD);
$end;
$bind("console->UARTTXD","uart->UARTRXD");
vista_bind(console->UARTTXD, uart->UARTRXD);
$end;
$bind("uart->nUARTRTS","console->nUARTCTS");
vista_bind(uart->nUARTRTS, console->nUARTCTS);
$end;
$bind("apb->uart0_master","uart->AMBA_APB");
vista_bind(apb->uart0_master, uart->AMBA_APB);
$end;
$bind("slave","apb->bus_slave");
vista_bind(slave, apb->bus_slave);
$end;
$bind("uart->UARTINTR","irq");
vista_bind(uart->UARTINTR, irq);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "cluster_local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~uart_with_console() {
    $destructor_begin;
$destruct_component("console");
delete console; console = 0;
$end;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("apb");
delete apb; apb = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("slave");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > slave;
$end;
$socket("irq");
tlm::tlm_initiator_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > irq;
$end;
$component("console");
UART_Visualization_Middleware_pvt *console;
$end;
$component("uart");
UART_PL011_pvt *uart;
$end;
$component("apb");
APB_pvt *apb;
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