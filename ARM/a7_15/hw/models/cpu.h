#pragma once

#include <systemc.h>

#ifdef A15
  #include "../models/DualCortexA15_model.h"
  typedef DualCortexA15_pvt CPUTYPE; 
#else
  #include "../models/DualCortexA7_model.h"
  typedef DualCortexA7_pvt CPUTYPE;
#endif

