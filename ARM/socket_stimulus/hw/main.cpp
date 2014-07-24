
#include "top.h"

int sc_main(int argc, char *argv[]) {

 top *inst_top = new top("top");
 sc_start(-1);
 delete inst_top;

 return 0;
}
