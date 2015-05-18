#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "DummyCluster.h"
#include "TestBench_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  typedef top SC_CURRENT_USER_MODULE;
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("cluster1"),
cluster1(0)
$end
$init("tb"),
tb(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("cluster1");
cluster1 = new DummyCluster("cluster1");
$end;
$create_component("tb");
tb = new TestBench_pvt("tb");
$end;
$bind("tb->irq","cluster1->dummy_M4_IRQ_0");
vista_bind(tb->irq, cluster1->dummy_M4_IRQ_0);
$end;
$bind("cluster1->dummy_M4_Bus_Extension","tb->slave");
vista_bind(cluster1->dummy_M4_Bus_Extension, tb->slave);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "cluster_local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("cluster1");
delete cluster1; cluster1 = 0;
$end;
$destruct_component("tb");
delete tb; tb = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("cluster1");
DummyCluster *cluster1;
$end;
$component("tb");
TestBench_pvt *tb;
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