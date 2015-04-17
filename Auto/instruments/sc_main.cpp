//v2: comments beginning with v2 are generated and used by V2
//v2: please don't remove or modify these comments

//v2: begin of includes section
#include "top.h"
#include "Instruments_pv.h"
#include "DummyDriver_pv.h"

//v2: end of includes section

int sc_main(int argc, char *argv[]) {

//v2: begin of channel declarations section
//v2: end of channel declarations section


//v2: begin of instantiations section
//v2: instance inst_top - instance number 0 of module top
top *inst_top = new top("top");
//v2: end of instantiations section


//v2: begin of ports assignment section
//v2: ports assignment for instance inst_top
//v2: end of ports assignment section

 inst_top->dummyDriver->getPV()->instruments = inst_top->instruments->getPV();

 sc_start();

//v2: begin of instantiations section
delete inst_top;
//v2: end of instantiations section

 return 0;
}
