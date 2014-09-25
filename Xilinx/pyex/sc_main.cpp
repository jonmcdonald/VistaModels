#include "top.h"
#include "RealTimeStall.h"

#define TOP top

int sc_main(int argc, char *argv[]) {
  TOP *inst_top = new TOP("TOP");
  RealTimeStall *m_stall = new RealTimeStall("stall");

  sc_start();

  delete inst_top;
  return 0;
}
