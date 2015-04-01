#include "systemc.h"
#include "top.h"
#include "model_builder.h"

bool myRunning = true;

class mycontrol: public sc_core::sc_module {
 public:
  SC_HAS_PROCESS(mycontrol);
  mycontrol(sc_module_name name) : sc_module(name) {
    SC_THREAD(thread);
  }

  void thread() {
    wait(1, SC_SEC);
    myRunning = false;
  }
};

int sc_main(int argc, char *argv[]) {

 top *inst_top = new top("top");
 mycontrol ci("controlinst");

 sc_start();

 delete inst_top;

 return 0;
}
