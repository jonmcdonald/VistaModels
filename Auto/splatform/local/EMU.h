#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/EMUDriver_model.h"
#include "../models/can_model.h"
#include "pull_if.h"
$includes_end;

$module_begin("EMU");
SC_MODULE(EMU) {
public:
  typedef EMU SC_CURRENT_USER_MODULE;
  EMU(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("RX0"),
RX0("RX0")
$end
$init("TX0"),
TX0("TX0")
$end
$init("s"),
s("s")
$end
$init("e"),
e("e")
$end
$init("CanIF"),
CanIF(0)
$end
$init("emudriver0"),
emudriver0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("CanIF");
CanIF = new can_pvt("CanIF");
$end;
$create_component("emudriver0");
emudriver0 = new EMUDriver_pvt("emudriver0");
$end;
$bind("CanIF->GI_Rx","emudriver0->rxi");
vista_bind(CanIF->GI_Rx, emudriver0->rxi);
$end;
$bind("CanIF->TX0","TX0");
vista_bind(CanIF->TX0, TX0);
$end;
$bind("RX0","CanIF->RX0");
vista_bind(RX0, CanIF->RX0);
$end;
$bind("emudriver0->m","CanIF->reg");
vista_bind(emudriver0->m, CanIF->reg);
$end;
$bind("emudriver0->s","s");
vista_bind(emudriver0->s, s);
$end;
$bind("emudriver0->e","e");
vista_bind(emudriver0->e, e);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~EMU() {
    $destructor_begin;
$destruct_component("CanIF");
delete CanIF; CanIF = 0;
$end;
$destruct_component("emudriver0");
delete emudriver0; emudriver0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("RX0");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RX0;
$end;
$socket("TX0");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TX0;
$end;
$port("s");
sc_port<pull_if<unsigned int> > s;
$end;
$port("e");
sc_port<pushpull_if<unsigned,unsigned> > e;
$end;
$component("CanIF");
can_pvt *CanIF;
$end;
$component("emudriver0");
EMUDriver_pvt *emudriver0;
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