#include "systemc.h"
#include "top.h"
#include "model_builder.h"
#include "FileCanData_pv.h"
#include "Instruments_model.h"
#include "Instruments_pv.h"
#include "RealTimeStall.h"

bool myRunning = true;

class mycontrol: public sc_core::sc_module {
 public:
  SC_HAS_PROCESS(mycontrol);
  mycontrol(sc_module_name name, int seconds = 1) : sc_module(name), seconds(seconds) {
    SC_THREAD(thread);
  }

  void thread() {
    wait(seconds, SC_SEC);
    myRunning = false;
  }

  int seconds;
};

int sc_main(int argc, char *argv[]) {

 int seconds;

 top *inst_top = new top("top");
 Instruments_pvt *instruments = new Instruments_pvt("Instruments");
 RealTimeStall *stall = new RealTimeStall("stall");

 if (argc == 2) {
   sscanf(argv[1], "%d", &seconds);
   mycontrol ci("controlinst", seconds);
 } else
   mycontrol ci("controlinst");

 inst_top->brake0->brakedriver0->getPV()->inff = &(instruments->getPV()->brakeFifo);

 sc_start();

 delete inst_top;
 delete instruments;
 delete stall;

 return 0;
}
