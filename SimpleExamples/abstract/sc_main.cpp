
#include "top_mb.h"
#include "top.h"

int sc_main(int argc, char *argv[]) {

 //top *inst_top = new top("top");
 top_mb *inst_top = new top_mb("top_mb");

 srand(47);

 sc_start();

 delete inst_top;
 return 0;
}
