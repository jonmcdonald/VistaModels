#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "models_catalogue.h"
#include "../Models/ahb2apb_model.h"
#include "../Models/DriveEn_model.h"
$includes_end;

$module_begin("Uart");
SC_MODULE(Uart) {
public:
  Uart(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("slave_1"),
slave_1("slave_1")
$end
$init("UARTTXINTR"),
UARTTXINTR("UARTTXINTR")
$end
$init("UARTRXINTR"),
UARTRXINTR("UARTRXINTR")
$end
$init("uarti"),
uarti(0)
$end
$init("consolei"),
consolei(0)
$end
$init("bridge0"),
bridge0(0)
$end
$init("c3"),
c3(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("uarti");
uarti = new UART_PL011_pvt("uarti");
$end;
$create_component("consolei");
consolei = new UART_Visualization_Middleware_pvt("consolei");
$end;
$create_component("bridge0");
bridge0 = new ahb2apb_pvt("bridge0");
$end;
$create_component("c3");
c3 = new DriveEn_pvt("c3");
$end;
$bind("uarti->UARTRXINTR","UARTRXINTR");
vista_bind(uarti->UARTRXINTR, UARTRXINTR);
$end;
$bind("uarti->UARTTXINTR","UARTTXINTR");
vista_bind(uarti->UARTTXINTR, UARTTXINTR);
$end;
$bind("consolei->UARTTXD","uarti->UARTRXD");
vista_bind(consolei->UARTTXD, uarti->UARTRXD);
$end;
$bind("uarti->UARTTXD","consolei->UARTRXD");
vista_bind(uarti->UARTTXD, consolei->UARTRXD);
$end;
$bind("bridge0->master_1","uarti->AMBA_APB");
vista_bind(bridge0->master_1, uarti->AMBA_APB);
$end;
$bind("slave_1","bridge0->slave_1");
vista_bind(slave_1, bridge0->slave_1);
$end;
$bind("uarti->nUARTRTS","consolei->nUARTCTS");
vista_bind(uarti->nUARTRTS, consolei->nUARTCTS);
$end;
$bind("consolei->nUARTRTS","uarti->nUARTCTS");
vista_bind(consolei->nUARTRTS, uarti->nUARTCTS);
$end;
$bind("c3->en","consolei->UARTEN");
vista_bind(c3->en, consolei->UARTEN);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "blocks_lib";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~Uart() {
    $destructor_begin;
$destruct_component("uarti");
delete uarti; uarti = 0;
$end;
$destruct_component("consolei");
delete consolei; consolei = 0;
$end;
$destruct_component("bridge0");
delete bridge0; bridge0 = 0;
$end;
$destruct_component("c3");
delete c3; c3 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("slave_1");
tlm::tlm_target_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ONE_OR_MORE_BOUND > slave_1;
$end;
$socket("UARTTXINTR");
tlm::tlm_initiator_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > UARTTXINTR;
$end;
$socket("UARTRXINTR");
tlm::tlm_initiator_socket< 1U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > UARTRXINTR;
$end;
$component("uarti");
UART_PL011_pvt *uarti;
$end;
$component("consolei");
UART_Visualization_Middleware_pvt *consolei;
$end;
$component("bridge0");
ahb2apb_pvt *bridge0;
$end;
$component("c3");
DriveEn_pvt *c3;
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