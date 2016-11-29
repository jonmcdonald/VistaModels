#include "top.h"

#include <stdlib.h>
#include <stdio.h>

extern void *svx_stop_calls_func_ptr;
typedef void svx_stop_calls_type();

int sc_main(int argc, char *argv[]) {
 
 int endtime = 0;
 if(argc > 1) {
   istringstream ss(argv[1]);
   if (!(ss >> endtime))
     cerr << "Invalid end time " << argv[1] << '\n';
 }
 
 top *inst_top = new top("top");
 
 if(endtime) {
   cout << "**** Simulating for " << endtime << " seconds ****" << endl;
   sc_start(endtime, SC_SEC);
 }
 else {
   sc_start();
 }
 
 if(svx_stop_calls_func_ptr != NULL) {
   ((svx_stop_calls_type *) svx_stop_calls_func_ptr)();   
 }
 
 delete inst_top;

 return 0;
}
