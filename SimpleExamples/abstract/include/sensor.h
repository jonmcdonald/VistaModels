#ifndef _SENSOR_H_
#define _SENSOR_H_

#include "systemc.h"
#include "push_if.h"
#include "types.h"
//#include "esl/sc_sim/mb_distribution.h"
//#include "mb/sysc/parameters.h"
#include <string>

using namespace std;

class sensor: sc_module {
public:
  sc_port<push_if<DataType, CommandType> > p;

  SC_HAS_PROCESS(sensor);

  sensor(sc_module_name name) :
    sc_module(name)
  { 
    SC_THREAD(stim); }

  void stim() {
    srand(47);

    for (int i = 0; i < 10; i++) {

      d = new DataType();
      d->i = rand();

      cout << name() << " " << sc_time_stamp() 
           << ": Sending " << d->i << endl;
      p->push(d);
      wait (int(rand()*10), SC_NS); 
    }
  }

private:
  DataType  *d;
  char* pDist;
  char* wDist;
  int count;
};

#endif

