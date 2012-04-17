#ifndef _SENSOR_H_
#define _SENSOR_H_

#include "systemc.h"
#include "push_if.h"
#include "types.h"
//#include "esl/sc_sim/mb_distribution.h"
//#include "mb/sysc/parameters.h"
#include "model_builder.h"
#include <string>

using namespace std;

class sensor: sc_module {
public:
  sc_port<push_if<DataType, CommandType> > p;

  SC_HAS_PROCESS(sensor);

  sensor(sc_module_name name) :
    sc_module(name),
    SD_INITIALIZE_PARAMETER(pDist, (char *)"uniform 1 5 4579"),
    SD_INITIALIZE_PARAMETER(wDist, (char *)"uniform 5 20 571"),
    SD_INITIALIZE_PARAMETER(count, 10)
  { 
    SC_THREAD(stim); }

  void stim() {
    mb_distribution *pdist = mb_CreateDistribution(pDist);
    mb_distribution *wdist = mb_CreateDistribution(wDist);
    for (int i = 0; i < count; i++) {

      d = new DataType();
      d->i = pdist->getNextInt();

      cout << name() << " " << sc_time_stamp() 
           << ": Sending " << d->i << endl;
      p->push(d);
      wait (wdist->getNextInt()*10, SC_NS); 
    }
  }

private:
  DataType  *d;
  char* pDist;
  char* wDist;
  int count;
};

#endif

