#include "top.h"

#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "RealTimeStall.h"

void my_handler(int s){
    cout << endl << "*** Caught signal " << s << endl;
    cout << "*** Stopping Simulation " << endl;
    sc_stop();
    exit(0); 
}


int sc_main(int argc, char *argv[]) {
 
 struct sigaction sigIntHandler;
 sigIntHandler.sa_handler = my_handler;
 sigemptyset(&sigIntHandler.sa_mask);
 sigIntHandler.sa_flags = 0;
 sigaction(SIGINT, &sigIntHandler, NULL);

 RealTimeStall *stall = new RealTimeStall("stall");

 top *inst_top = new top("top");
 
 sc_start();
 
 delete inst_top;

 return 0;
}
