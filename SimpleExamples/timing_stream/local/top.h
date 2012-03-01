#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
#include "../models/stream_model.h"
#include "../models/streamThread_model.h"
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
$init("driver1"),
driver1(0)
$end
$init("sink1"),
sink1(0)
$end
$init("stream1"),
stream1(0)
$end
$init("driver2"),
driver2(0)
$end
$init("sink2"),
sink2(0)
$end
$init("streamThread1"),
streamThread1(0)
$end
    $initialization_end
{
    $elaboration_begin;
$create_component("driver1");
driver1 = new driver_pvt("driver1");
$end;
$create_component("sink1");
sink1 = new sink_pvt("sink1");
$end;
$create_component("stream1");
stream1 = new stream_pvt("stream1");
$end;
$create_component("driver2");
driver2 = new driver_pvt("driver2");
$end;
$create_component("sink2");
sink2 = new sink_pvt("sink2");
$end;
$create_component("streamThread1");
streamThread1 = new streamThread_pvt("streamThread1");
$end;
$bind("driver1->y","stream1->slave_a");
vista_bind(driver1->y, stream1->slave_a);
$end;
$bind("stream1->master_1","sink1->s");
vista_bind(stream1->master_1, sink1->s);
$end;
$bind("driver2->y","streamThread1->slave_a");
vista_bind(driver2->y, streamThread1->slave_a);
$end;
$bind("streamThread1->master_1","sink2->s");
vista_bind(streamThread1->master_1, sink2->s);
$end;
    $elaboration_end;
  }
  ~top() {
    $destructor_begin;
$destruct_component("driver1");
delete driver1; driver1 = 0;
$end;
$destruct_component("sink1");
delete sink1; sink1 = 0;
$end;
$destruct_component("stream1");
delete stream1; stream1 = 0;
$end;
$destruct_component("driver2");
delete driver2; driver2 = 0;
$end;
$destruct_component("sink2");
delete sink2; sink2 = 0;
$end;
$destruct_component("streamThread1");
delete streamThread1; streamThread1 = 0;
$end;
    $destructor_end;
  }
public:
  $fields_begin;
$component("driver1");
driver_pvt *driver1;
$end;
$component("sink1");
sink_pvt *sink1;
$end;
$component("stream1");
stream_pvt *stream1;
$end;
$component("driver2");
driver_pvt *driver2;
$end;
$component("sink2");
sink_pvt *sink2;
$end;
$component("streamThread1");
streamThread_pvt *streamThread1;
$end;
  $fields_end;
};
$module_end;