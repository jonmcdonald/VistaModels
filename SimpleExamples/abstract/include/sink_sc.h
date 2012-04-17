#ifndef _SINK_SC_H_
#define _SINK_SC_H_

#include "systemc.h"
#include "custom_if.h"
#include "types.h"
#include <iostream>

class sink_sc: public custom_if<dataT>, sc_module {
public:

  sink_sc(sc_module_name name) :
    sc_module(name)
  { }

  void send(data) {
     cout << name() << " " << sc_time_stamp() 
          << ": Received " << data << endl;
  }
private:
};

#endif

