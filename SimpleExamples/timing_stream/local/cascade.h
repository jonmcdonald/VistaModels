#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
#include "../models/driver_model.h"
#include "../models/sink_model.h"
#include "../models/stream_model.h"
#include "../models/streamThread_model.h"
#include "../models/streamTrans_model.h"
$includes_end;

$module_begin("cascade");
SC_MODULE(cascade) {
public:
  cascade(::sc_core::sc_module_name name):
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
$init("stream3"),
stream3(0)
$end
$init("streamThread2"),
streamThread2(0)
$end
$init("streamThread3"),
streamThread3(0)
$end
$init("streamThread4"),
streamThread4(0)
$end
$init("stream2"),
stream2(0)
$end
$init("stream4"),
stream4(0)
$end
$init("driver3"),
driver3(0)
$end
$init("sink3"),
sink3(0)
$end
$init("streamTrans2"),
streamTrans2(0)
$end
$init("streamTrans3"),
streamTrans3(0)
$end
$init("streamTrans4"),
streamTrans4(0)
$end
$init("streamTrans1"),
streamTrans1(0)
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
$create_component("stream3");
stream3 = new stream_pvt("stream3");
$end;
$create_component("streamThread2");
streamThread2 = new streamThread_pvt("streamThread2");
$end;
$create_component("streamThread3");
streamThread3 = new streamThread_pvt("streamThread3");
$end;
$create_component("streamThread4");
streamThread4 = new streamThread_pvt("streamThread4");
$end;
$create_component("stream2");
stream2 = new stream_pvt("stream2");
$end;
$create_component("stream4");
stream4 = new stream_pvt("stream4");
$end;
$create_component("driver3");
driver3 = new driver_pvt("driver3");
$end;
$create_component("sink3");
sink3 = new sink_pvt("sink3");
$end;
$create_component("streamTrans2");
streamTrans2 = new streamTrans_pvt("streamTrans2");
$end;
$create_component("streamTrans3");
streamTrans3 = new streamTrans_pvt("streamTrans3");
$end;
$create_component("streamTrans4");
streamTrans4 = new streamTrans_pvt("streamTrans4");
$end;
$create_component("streamTrans1");
streamTrans1 = new streamTrans_pvt("streamTrans1");
$end;
$bind("driver1->y","stream1->slave_a");
vista_bind(driver1->y, stream1->slave_a);
$end;
$bind("stream4->master_1","sink1->s");
vista_bind(stream4->master_1, sink1->s);
$end;
$bind("streamThread2->master_1","streamThread3->slave_a");
vista_bind(streamThread2->master_1, streamThread3->slave_a);
$end;
$bind("stream2->master_1","stream3->slave_a");
vista_bind(stream2->master_1, stream3->slave_a);
$end;
$bind("streamThread3->master_1","streamThread4->slave_a");
vista_bind(streamThread3->master_1, streamThread4->slave_a);
$end;
$bind("stream1->master_1","stream2->slave_a");
vista_bind(stream1->master_1, stream2->slave_a);
$end;
$bind("stream3->master_1","stream4->slave_a");
vista_bind(stream3->master_1, stream4->slave_a);
$end;
$bind("streamThread1->master_1","streamThread2->slave_a");
vista_bind(streamThread1->master_1, streamThread2->slave_a);
$end;
$bind("driver2->y","streamThread1->slave_a");
vista_bind(driver2->y, streamThread1->slave_a);
$end;
$bind("streamThread4->master_1","sink2->s");
vista_bind(streamThread4->master_1, sink2->s);
$end;
$bind("streamTrans3->master_1","streamTrans4->slave_a");
vista_bind(streamTrans3->master_1, streamTrans4->slave_a);
$end;
$bind("streamTrans2->master_1","streamTrans3->slave_a");
vista_bind(streamTrans2->master_1, streamTrans3->slave_a);
$end;
$bind("streamTrans4->master_1","sink3->s");
vista_bind(streamTrans4->master_1, sink3->s);
$end;
$bind("driver3->y","streamTrans1->slave_a");
vista_bind(driver3->y, streamTrans1->slave_a);
$end;
$bind("streamTrans1->master_1","streamTrans2->slave_a");
vista_bind(streamTrans1->master_1, streamTrans2->slave_a);
$end;
    $elaboration_end;
  }
  ~cascade() {
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
$destruct_component("stream3");
delete stream3; stream3 = 0;
$end;
$destruct_component("streamThread2");
delete streamThread2; streamThread2 = 0;
$end;
$destruct_component("streamThread3");
delete streamThread3; streamThread3 = 0;
$end;
$destruct_component("streamThread4");
delete streamThread4; streamThread4 = 0;
$end;
$destruct_component("stream2");
delete stream2; stream2 = 0;
$end;
$destruct_component("stream4");
delete stream4; stream4 = 0;
$end;
$destruct_component("driver3");
delete driver3; driver3 = 0;
$end;
$destruct_component("sink3");
delete sink3; sink3 = 0;
$end;
$destruct_component("streamTrans2");
delete streamTrans2; streamTrans2 = 0;
$end;
$destruct_component("streamTrans3");
delete streamTrans3; streamTrans3 = 0;
$end;
$destruct_component("streamTrans4");
delete streamTrans4; streamTrans4 = 0;
$end;
$destruct_component("streamTrans1");
delete streamTrans1; streamTrans1 = 0;
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
$component("stream3");
stream_pvt *stream3;
$end;
$component("streamThread2");
streamThread_pvt *streamThread2;
$end;
$component("streamThread3");
streamThread_pvt *streamThread3;
$end;
$component("streamThread4");
streamThread_pvt *streamThread4;
$end;
$component("stream2");
stream_pvt *stream2;
$end;
$component("stream4");
stream_pvt *stream4;
$end;
$component("driver3");
driver_pvt *driver3;
$end;
$component("sink3");
sink_pvt *sink3;
$end;
$component("streamTrans2");
streamTrans_pvt *streamTrans2;
$end;
$component("streamTrans3");
streamTrans_pvt *streamTrans3;
$end;
$component("streamTrans4");
streamTrans_pvt *streamTrans4;
$end;
$component("streamTrans1");
streamTrans_pvt *streamTrans1;
$end;
  $fields_end;
};
$module_end;
