#include "systemc.h"
#include "top.h"
#include "model_builder.h"

int sc_main(int argc, char *argv[]) {

 top *inst_top = new top("top");

 sc_start();

 delete inst_top;

 return 0;
}
