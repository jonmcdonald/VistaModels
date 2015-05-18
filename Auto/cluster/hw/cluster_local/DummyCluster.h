#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../cluster_models/cluster.h"
$includes_end;

$module_begin("DummyCluster");
SC_MODULE(DummyCluster) {
public:
  typedef DummyCluster SC_CURRENT_USER_MODULE;
  DummyCluster(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("dummy_M4_IRQ_0"),
dummy_M4_IRQ_0("dummy_M4_IRQ_0")
$end
$init("dummy_M4_Bus_Extension"),
dummy_M4_Bus_Extension("dummy_M4_Bus_Extension")
$end
$init("clusterdriver0"),
clusterdriver0(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("clusterdriver0");
clusterdriver0 = new cluster("clusterdriver0");
$end;
$bind("clusterdriver0->M4_Bus_Extension","dummy_M4_Bus_Extension");
vista_bind(clusterdriver0->M4_Bus_Extension, dummy_M4_Bus_Extension);
$end;
$bind("dummy_M4_IRQ_0","clusterdriver0->m4_irq0");
vista_bind(dummy_M4_IRQ_0, clusterdriver0->m4_irq0);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "cluster_local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~DummyCluster() {
    $destructor_begin;
$destruct_component("clusterdriver0");
delete clusterdriver0; clusterdriver0 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$socket("dummy_M4_IRQ_0");
tlm::tlm_target_socket< 8U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dummy_M4_IRQ_0;
$end;
$socket("dummy_M4_Bus_Extension");
tlm::tlm_initiator_socket< 32U,tlm::tlm_base_protocol_types,1,sc_core::SC_ZERO_OR_MORE_BOUND > dummy_M4_Bus_Extension;
$end;
$component("clusterdriver0");
cluster *clusterdriver0;
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