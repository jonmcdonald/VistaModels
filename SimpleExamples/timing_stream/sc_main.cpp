#include "systemc.h"
#include "top.h"
#include "cascade.h"
#include "model_builder.h"

#define TOP cascade

int sc_main(int argc, char *argv[]) {

 TOP *inst_top = new TOP("top");

 sc_start();

 delete inst_top;

 return 0;
}
