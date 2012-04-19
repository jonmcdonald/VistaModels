
#include "systemc.h"
#include "top_h.h"
#include "top.h"
#include "top2.h"
#include "model_builder.h"

int sc_main(int argc, char *argv[]) {

 //top2 *inst_top = new top2("top");
 top *inst_top = new top("top");
 //top_h *inst_top = new top_h("top");

 srand(47);

 sc_start(-1);

 delete inst_top;
 return 0;
}
