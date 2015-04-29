#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/can_model.h"
#include "../models/CEMDriver_model.h"
$includes_end;

$module_begin("CEM");
SC_MODULE(CEM) {
public:
  CEM(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("RXprop"),
RXprop("RXprop")
$end
$init("RXchassis"),
RXchassis("RXchassis")
$end
$init("RXbody"),
RXbody("RXbody")
$end
$init("TXprop"),
TXprop("TXprop")
$end
$init("TXchassis"),
TXchassis("TXchassis")
$end
$init("TXbody"),
TXbody("TXbody")
$end
$init("cemdriver0"),
cemdriver0(0)
$end
$init("chassiscan"),
chassiscan(0)
$end
$init("propcan"),
propcan(0)
$end
$init("bodycan"),
bodycan(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cemdriver0");
cemdriver0 = new CEMDriver_pvt("cemdriver0");
$end;
$create_component("chassiscan");
chassiscan = new can_pvt("chassiscan");
$end;
$create_component("propcan");
propcan = new can_pvt("propcan");
$end;
$create_component("bodycan");
bodycan = new can_pvt("bodycan");
$end;
$bind("RXchassis","chassiscan->RX0");
vista_bind(RXchassis, chassiscan->RX0);
$end;
$bind("propcan->TX0","TXprop");
vista_bind(propcan->TX0, TXprop);
$end;
$bind("chassiscan->TX0","TXchassis");
vista_bind(chassiscan->TX0, TXchassis);
$end;
$bind("RXprop","propcan->RX0");
vista_bind(RXprop, propcan->RX0);
$end;
$bind("cemdriver0->chassisB","chassiscan->reg");
vista_bind(cemdriver0->chassisB, chassiscan->reg);
$end;
$bind("RXbody","bodycan->RX0");
vista_bind(RXbody, bodycan->RX0);
$end;
$bind("chassiscan->GI_Rx","cemdriver0->chassisRXI");
vista_bind(chassiscan->GI_Rx, cemdriver0->chassisRXI);
$end;
$bind("cemdriver0->bodyB","bodycan->reg");
vista_bind(cemdriver0->bodyB, bodycan->reg);
$end;
$bind("bodycan->GI_Rx","cemdriver0->bodyRXI");
vista_bind(bodycan->GI_Rx, cemdriver0->bodyRXI);
$end;
$bind("cemdriver0->propB","propcan->reg");
vista_bind(cemdriver0->propB, propcan->reg);
$end;
$bind("bodycan->TX0","TXbody");
vista_bind(bodycan->TX0, TXbody);
$end;
$bind("propcan->GI_Rx","cemdriver0->propRXI");
vista_bind(propcan->GI_Rx, cemdriver0->propRXI);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~CEM() {
    $destructor_begin;
$destruct_component("cemdriver0");
delete cemdriver0; cemdriver0 = 0;
$end;
$destruct_component("chassiscan");
delete chassiscan; chassiscan = 0;
$end;
$destruct_component("propcan");
delete propcan; propcan = 0;
$end;
$destruct_component("bodycan");
delete bodycan; bodycan = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("RXprop");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RXprop;
$end;
$socket("RXchassis");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RXchassis;
$end;
$socket("RXbody");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RXbody;
$end;
$socket("TXprop");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TXprop;
$end;
$socket("TXchassis");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TXchassis;
$end;
$socket("TXbody");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TXbody;
$end;
$component("cemdriver0");
CEMDriver_pvt *cemdriver0;
$end;
$component("chassiscan");
can_pvt *chassiscan;
$end;
$component("propcan");
can_pvt *propcan;
$end;
$component("bodycan");
can_pvt *bodycan;
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