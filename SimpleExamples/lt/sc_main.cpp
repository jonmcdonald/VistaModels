#include "systemc.h"
#include "top_manual.h"
#include "model_builder.h"

#define INSTANCE_NAME top_manual

int sc_main(int argc, char *argv[]) {

 INSTANCE_NAME *inst_top = new INSTANCE_NAME("top");

 sc_start();

 delete inst_top;

 return 0;
}
