#include "top.h"

int sc_main(int argc, char *argv[]) {
 
  if(argc > 1) {
     int num_cpu = atoi(argv[1]);
     if (num_cpu >= 1 && num_cpu <= 2) {
        printf("Setting number of active CPU: %d\n", num_cpu);
        mb::sysc::set_parameter("num_cpu", num_cpu);
     } else {
        printf("Number of CPU should be 1 to 2.\n");
        return -1;
     }
   }

   top *inst_top = new top("top");

   sc_start();

   delete inst_top;

 return 0;
}
