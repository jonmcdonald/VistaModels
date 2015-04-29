#ifndef _SENSOR_H_
#define _SENSOR_H_

#include "systemc.h"
#include "tlm.h"
#include "pull_if.h"

using namespace std;

class sensor: sc_module {
public:
  sc_export<pull_if<unsigned int> > p;

  sensor(sc_module_name name) : sc_module(name), mytarget("target", this), inff(NULL)
  { 
    p(mytarget);
  }

private:
  class target: public pull_if<unsigned int >,
                sc_channel
  {
  public:
    target(sc_module_name name, sensor *parent) : 
      sc_module(name),
      parent(parent)
    {}

    unsigned int pull() {
      unsigned d = lastdata;
      if (parent->inff != NULL) {
        while (parent->inff->nb_can_get()) d = parent->inff->get();
        lastdata = d;
        return d;
      } else {
        return (unsigned int) rand();
      }
    }

  private:
    sc_event data_ev;
    sensor *parent;
    unsigned lastdata;
  } mytarget;

public:
  tlm::tlm_fifo<unsigned> *inff;

};

#endif

