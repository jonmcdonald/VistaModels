#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../include/filterSM.h"
#include "../include/filterMM.h"
#include "../include/sink.h"
//#include "../include/sensor.h"
#include "../include/sensor_vista.h"
#include "../include/filterSS.h"
$includes_end;

$module_begin("top_mb");
SC_MODULE(top_mb) {
public:
  top_mb(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("filter1"),
filter1(0)
$end
$init("compress"),
compress(0)
$end
$init("downlink"),
downlink(0)
$end
$init("sensori1"),
sensori1(0)
$end
$init("multiplex"),
multiplex(0)
$end
$init("sensori2"),
sensori2(0)
$end
$init("filter2"),
filter2(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("filter1");
filter1 = new filterSM("filter1");
$end;
$create_component("compress");
compress = new filterMM("compress");
$end;
$create_component("downlink");
downlink = new sink("downlink");
$end;
$create_component("sensori1");
sensori1 = new sensor("sensori1");
$end;
$create_component("multiplex");
multiplex = new filterSS("multiplex");
$end;
$create_component("sensori2");
sensori2 = new sensor("sensori2");
$end;
$create_component("filter2");
filter2 = new filterSM("filter2");
$end;
$bind("sensori1->p","*filter1");
sensori1->p.bind(*filter1);
$end;
$bind("compress->pOut","downlink->p");
compress->pOut.bind(downlink->p);
$end;
$bind("compress->pIn","multiplex->o");
compress->pIn.bind(multiplex->o);
$end;
$bind("filter1->p","multiplex->i");
filter1->p.bind(multiplex->i);
$end;
$bind("sensori2->p","*filter2");
sensori2->p.bind(*filter2);
$end;
$bind("filter2->p","multiplex->i");
filter2->p.bind(multiplex->i);
$end;
    $elaboration_end;
  $vlnv_assign_begin;
m_library = "local";
m_vendor = "";
m_version = "";
  $vlnv_assign_end;
  }
  ~top_mb() {
    $destructor_begin;
$destruct_component("filter1");
delete filter1; filter1 = 0;
$end;
$destruct_component("compress");
delete compress; compress = 0;
$end;
$destruct_component("downlink");
delete downlink; downlink = 0;
$end;
$destruct_component("sensori1");
delete sensori1; sensori1 = 0;
$end;
$destruct_component("multiplex");
delete multiplex; multiplex = 0;
$end;
$destruct_component("sensori2");
delete sensori2; sensori2 = 0;
$end;
$destruct_component("filter2");
delete filter2; filter2 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("filter1");
filterSM *filter1;
$end;
$component("compress");
filterMM *compress;
$end;
$component("downlink");
sink *downlink;
$end;
$component("sensori1");
sensor *sensori1;
$end;
$component("multiplex");
filterSS *multiplex;
$end;
$component("sensori2");
sensor *sensori2;
$end;
$component("filter2");
filterSM *filter2;
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