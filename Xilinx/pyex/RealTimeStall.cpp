
#include "RealTimeStall.h"

#include <sys/time.h>
#include <iostream>
#include "model_builder.h"

using namespace std;

RealTimeStall::RealTimeStall(sc_module_name name) :
    sc_module(name),
    SD_INITIALIZE_PARAMETER(RealTimeSeconds,0),
    SD_INITIALIZE_PARAMETER(RealTimeInterval,1.0),
    SD_INITIALIZE_PARAMETER(RealTimeFactor,1.0)
{
  SC_THREAD(stall);
}

void RealTimeStall::stall()
{
  sc_time simInterval = sc_time(1, SC_MS) * static_cast<int>(RealTimeInterval * 1000.0); 
  double simSeconds, clockSeconds, simLead;
  unsigned usecs;
  unsigned maxIntervals = RealTimeSeconds / RealTimeInterval;

  struct timeval start, end;
  long mtime, seconds, useconds;
  gettimeofday(&start, NULL);

  // RealTimeSeconds and RealTimeInterval are use to defing the maxInterval.  This
  // controls how long in real time the simulation will run at a minimum.
  // If the simulation is slower than real time this loop will have no effects.
  for(int i = 0;i < maxIntervals;i++) {
     wait(simInterval);

     simSeconds = sc_time_stamp().to_seconds();  // Current simulated seconds

     gettimeofday(&end, NULL);
     seconds = end.tv_sec - start.tv_sec;
     useconds = end.tv_usec - start.tv_usec;
     mtime = ((seconds) * 1000 + useconds/1000.0);
     clockSeconds = mtime / (double)1000.0; 	// Elapsed realtime seconds since sim started

     // Calculate simulation lead time.  RealTimeFactor is used to allow the simulation
     // to run some amount faster than realtime.  
     simLead = (simSeconds * RealTimeFactor) - clockSeconds;

     // Check to see if the simulation is ahead of realtime by more than 0.1 seconds
     if (simLead > 0.1) {	
        usecs = simLead * 1000000;
        // sleep for appropriate useconds to synchronize with realtime
        usleep(usecs);			
     }
  }
}
