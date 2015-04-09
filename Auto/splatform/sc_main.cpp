#include "systemc.h"
#include "top.h"
#include "model_builder.h"

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

 if (argc == 2) {
   sscanf(argv[1], "%d", &seconds);
   mycontrol ci("controlinst", seconds);
 } else
   mycontrol ci("controlinst");

 sc_start();

 delete inst_top;

 return 0;
}
