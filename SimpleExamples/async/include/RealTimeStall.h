#pragma once

#include "systemc.h"

// Instantiating this sc_module in a simulation will cause the simulation to
// stall if the simulation time is passing faster than real time (wall clock time).  
// This allows the simulated time to approximate real time for simulations which run
// faster than real time.
//
// The implementation is not platform independent.  Currently this has been tested on
// linux only.
//
// Author: Jon McDonald
// Date:   April 20, 2011

class RealTimeStall: sc_module {
 public:
  
  SC_HAS_PROCESS(RealTimeStall);
  
  RealTimeStall(sc_module_name name);

  void stall();

  // RealTimeSeconds defines how long the stall will continue.  The simulation will 
  // have events at least until RealTimeSeconds of simulation time.
  unsigned RealTimeSeconds;

  // RealTimeInterval defines the frequency in seconds at which the simulation is
  // checked against the wall clock time.  RealTimeInterval can be a fraction of a second.
  double RealTimeInterval;

  // RealTimeFactor defines the correlation to realtime.  1 sets the simulation to run no
  // faster than realtime, 0.5 would allow the simulation to go 2x realtime.
  double RealTimeFactor;
};
