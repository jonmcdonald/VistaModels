
#include "systemc.h"
#include "model_builder.h"
#include "top.h"		// top level with one sink and one driver
#include "top2.h"		// top level with one sink and two independent drivers
#include "RealTimeStall.h"

#define TOP top		// select which top level to use.  Should be top or top2

int sc_main(int argc, char *argv[]) {

 TOP *inst_top = new TOP("TOP");
 RealTimeStall *m_stall = new RealTimeStall("stall");	// Slow simulation time to realtime.

 sc_start();

 delete inst_top;
 return 0;
}
