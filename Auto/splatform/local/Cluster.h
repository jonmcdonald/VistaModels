#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/ClusterDriver_model.h"
#include "../models/can_model.h"
$includes_end;

$module_begin("Cluster");
SC_MODULE(Cluster) {
public:
  Cluster(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("RXLS"),
RXLS("RXLS")
$end
$init("RXHS"),
RXHS("RXHS")
$end
$init("TXLS"),
TXLS("TXLS")
$end
$init("TXHS"),
TXHS("TXHS")
$end
$init("clusterdriver0"),
clusterdriver0(0)
$end
$init("hscan"),
hscan(0)
$end
$init("lscan"),
lscan(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("clusterdriver0");
clusterdriver0 = new ClusterDriver_pvt("clusterdriver0");
$end;
$create_component("hscan");
hscan = new can_pvt("hscan");
$end;
$create_component("lscan");
lscan = new can_pvt("lscan");
$end;
$bind("RXHS","hscan->RX0");
vista_bind(RXHS, hscan->RX0);
$end;
$bind("lscan->TX0","TXLS");
vista_bind(lscan->TX0, TXLS);
$end;
$bind("clusterdriver0->hs","hscan->reg");
vista_bind(clusterdriver0->hs, hscan->reg);
$end;
$bind("hscan->TX0","TXHS");
vista_bind(hscan->TX0, TXHS);
$end;
$bind("hscan->GI_Rx","clusterdriver0->hsrx");
vista_bind(hscan->GI_Rx, clusterdriver0->hsrx);
$end;
$bind("lscan->GI_Rx","clusterdriver0->lsrx");
vista_bind(lscan->GI_Rx, clusterdriver0->lsrx);
$end;
$bind("clusterdriver0->ls","lscan->reg");
vista_bind(clusterdriver0->ls, lscan->reg);
$end;
$bind("RXLS","lscan->RX0");
vista_bind(RXLS, lscan->RX0);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~Cluster() {
    $destructor_begin;
$destruct_component("clusterdriver0");
delete clusterdriver0; clusterdriver0 = 0;
$end;
$destruct_component("hscan");
delete hscan; hscan = 0;
$end;
$destruct_component("lscan");
delete lscan; lscan = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("RXLS");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RXLS;
$end;
$socket("RXHS");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > RXHS;
$end;
$socket("TXLS");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TXLS;
$end;
$socket("TXHS");
tlm::tlm_initiator_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > TXHS;
$end;
$component("clusterdriver0");
ClusterDriver_pvt *clusterdriver0;
$end;
$component("hscan");
can_pvt *hscan;
$end;
$component("lscan");
can_pvt *lscan;
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