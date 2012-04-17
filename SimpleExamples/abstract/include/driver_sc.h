#ifndef _DRIVER_SC_H_
#define _DRIVER_SC_H_

#include "systemc.h"
#include "custom_if.h"
#include "types.h"
#include "esl/sc_sim/mb_distribution.h"
#include <string>

using namespace std;

class driver_sc: sc_module {
public:
  sc_port<custom_if<int> > p;

  SC_HAS_PROCESS(driver_sc);

  driver_sc(sc_module_name name, 
            char * pDist = "uniform 1 5 2489",
            char * wDist = "uniform 5 20 47") :
    sc_module(name),
    pDist(pDist),
    wDist(wDist)
  { 
    SC_THREAD(stim); }

  void stim() {
    int count = 1;
    mb_distribution *pdist = mb_CreateDistribution(pDist);
    mb_distribution *wdist = mb_CreateDistribution(wDist);
    for (;;) {

      d = pdist->getNextInt());

      cout << name() << " " << sc_time_stamp() 
           << ": Sending " << d << endl;
      p->send(&d);
      wait (wdist->getNextInt()*10, SC_NS); 
    }
  }

private:
  dataT  d;
  char* pDist;
  char* wDist;
};

#endif

