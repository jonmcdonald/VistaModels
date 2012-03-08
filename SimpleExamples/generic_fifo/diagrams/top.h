#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/stream_fifo_model.h"
#include "../models/sink_model.h"
#include "../models/driver_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("fifo0"),
fifo0(0)
$end
$init("sink"),
sink(0)
$end
$init("c18"),
c18(0)
$end
$init("driver"),
driver(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("fifo0");
fifo0 = new stream_fifo_pvt("fifo0");
$end;
$create_component("sink");
sink = new sink_pvt("sink");
$end;
$create_component("c18");
c18 = new sink_pvt("c18");
$end;
$create_component("driver");
driver = new driver_pvt("driver");
$end;
$bind("fifo0->dout","sink->s1");
vista_bind(fifo0->dout, sink->s1);
$end;
$bind("fifo0->alert","c18->s0");
vista_bind(fifo0->alert, c18->s0);
$end;
$bind("driver->mout","fifo0->din");
vista_bind(driver->mout, fifo0->din);
$end;
    $elaboration_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("fifo0");
delete fifo0; fifo0 = 0;
$end;
$destruct_component("sink");
delete sink; sink = 0;
$end;
$destruct_component("c18");
delete c18; c18 = 0;
$end;
$destruct_component("driver");
delete driver; driver = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("fifo0");
stream_fifo_pvt *fifo0;
$end;
$component("sink");
sink_pvt *sink;
$end;
$component("c18");
sink_pvt *c18;
$end;
$component("driver");
driver_pvt *driver;
$end;
  $fields_end;
};
$module_end;