#include "top.h"

#ifndef WIN32
#include <signal.h>
#include <unistd.h>
#endif

#include <stdlib.h>
#include <stdio.h>
#include "RealTimeStall.h"

#ifndef WIN32
void my_handler(int s){
    cout << endl << "*** Caught signal " << s << endl;
    cout << "*** Stopping Simulation " << endl;
    sc_stop();
    exit(0); 
}
#endif

int sc_main(int argc, char *argv[]) {
 
#ifndef WIN32
 struct sigaction sigIntHandler;
 sigIntHandler.sa_handler = my_handler;
 sigemptyset(&sigIntHandler.sa_mask);
 sigIntHandler.sa_flags = 0;
 sigaction(SIGINT, &sigIntHandler, NULL);
#endif

 int endtime = 0;
 if(argc > 1) {
   istringstream ss(argv[1]);
   if (!(ss >> endtime))
     cerr << "Invalid end time " << argv[1] << '\n';
 }
 
 RealTimeStall *stall = new RealTimeStall("stall");

 top *inst_top = new top("top");
 
 if(endtime) {
   cout << "**** Simulating for " << endtime << " seconds ****" << endl;
   sc_start(endtime, SC_SEC);
 }
 else {
   sc_start();
 }
 
 delete inst_top;

 return 0;
}
