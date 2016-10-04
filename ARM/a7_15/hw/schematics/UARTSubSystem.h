#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "models_catalogue.h"
$includes_end;

$module_begin("UARTSubSystem");
SC_MODULE(UARTSubSystem) {
public:
  typedef UARTSubSystem SC_CURRENT_USER_MODULE;
  UARTSubSystem(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("AMBA_APB"),
AMBA_APB("AMBA_APB")
$end
$init("UARTINTR"),
UARTINTR("UARTINTR")
$end
$init("uart"),
uart(0)
$end
$init("console"),
console(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("uart");
uart = new UART_PL011_pvt("uart");
$end;
$create_component("console");
console = new UART_Visualization_Middleware_pvt("console");
$end;
$bind("uart->UARTTXD","console->UARTRXD");
vista_bind(uart->UARTTXD, console->UARTRXD);
$end;
$bind("console->nUARTRTS","uart->nUARTCTS");
vista_bind(console->nUARTRTS, uart->nUARTCTS);
$end;
$bind("AMBA_APB","uart->AMBA_APB");
vista_bind(AMBA_APB, uart->AMBA_APB);
$end;
$bind("uart->nUARTRTS","console->nUARTCTS");
vista_bind(uart->nUARTRTS, console->nUARTCTS);
$end;
$bind("uart->UARTINTR","UARTINTR");
vista_bind(uart->UARTINTR, UARTINTR);
$end;
$bind("console->UARTTXD","uart->UARTRXD");
vista_bind(console->UARTTXD, uart->UARTRXD);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "schematics";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~UARTSubSystem() {
    $destructor_begin;
$destruct_component("uart");
delete uart; uart = 0;
$end;
$destruct_component("console");
delete console; console = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("AMBA_APB");
tlm::tlm_target_socket< 16U,tlm::tlm_base_protocol_types,1,sc_core::SC_ONE_OR_MORE_BOUND > AMBA_APB;
$end;
$socket("UARTINTR");
tlm::tlm_initiator_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > UARTINTR;
$end;
$component("uart");
UART_PL011_pvt *uart;
$end;
$component("console");
UART_Visualization_Middleware_pvt *console;
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