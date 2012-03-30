#include "systemc.h"
#include "top.h"
#include "top2.h"
#include "OutOrderTB.h"
#include "model_builder.h"

#define TOP OutOrderTB

int sc_main(int argc, char *argv[]) {

 TOP *inst_top = new TOP("top");

 sc_start();

 delete inst_top;

 return 0;
}
