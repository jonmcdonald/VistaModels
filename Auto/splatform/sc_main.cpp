#include "systemc.h"
#include "model_builder.h"
#include "RealTimeStall.h"
#include "splatform.h"
#include "FileCanData_pv.h"
#include "Instruments_pv.h"

#define TOP splatform

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

 TOP *inst_top = new TOP("top");
 Instruments_pvt *instruments = new Instruments_pvt("Instruments");
 RealTimeStall *stall = new RealTimeStall("stall");

 if (argc == 2) {
   sscanf(argv[1], "%d", &seconds);
   mycontrol ci("controlinst", seconds);
 } else
   mycontrol ci("controlinst");

 inst_top->brakesensor->inff = &(instruments->getPV()->brakeFifo);
 inst_top->accelsensor->inff = &(instruments->getPV()->acceleratorFifo);

 srand(47);

 sc_start();

 delete inst_top;
 delete instruments;
 delete stall;

 return 0;
}
