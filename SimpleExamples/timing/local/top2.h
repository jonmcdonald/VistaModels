#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/drive_y_model.h"
#include "../models/drive_io_model.h"
#include "../models/mem_model.h"
$includes_end;

$module_begin("top2");
SC_MODULE(top2) {
public:
  top2(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("c0"),
c0(0)
$end
$init("c1"),
c1(0)
$end
$init("c2"),
c2(0)
$end
$init("c3"),
c3(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("c0");
c0 = new drive_y_pvt("c0");
$end;
$create_component("c1");
c1 = new drive_io_pvt("c1");
$end;
$create_component("c2");
c2 = new mem_pvt("c2");
$end;
$create_component("c3");
c3 = new mem_pvt("c3");
$end;
$bind("c1->x","c2->slave");
vista_bind(c1->x, c2->slave);
$end;
$bind("c1->y","c3->slave");
vista_bind(c1->y, c3->slave);
$end;
$bind("c0->y","c1->t");
vista_bind(c0->y, c1->t);
$end;
    $elaboration_end;
  }
  ~top2() {
    $destructor_begin;
$destruct_component("c0");
delete c0; c0 = 0;
$end;
$destruct_component("c1");
delete c1; c1 = 0;
$end;
$destruct_component("c2");
delete c2; c2 = 0;
$end;
$destruct_component("c3");
delete c3; c3 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("c0");
drive_y_pvt *c0;
$end;
$component("c1");
drive_io_pvt *c1;
$end;
$component("c2");
mem_pvt *c2;
$end;
$component("c3");
mem_pvt *c3;
$end;
  $fields_end;
};
$module_end;

