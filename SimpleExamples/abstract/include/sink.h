#ifndef _SINK_H_
#define _SINK_H_

#include "systemc.h"
#include "push_if.h"
#include "types.h"
#include <iostream>

class sink: public sc_module {
public:
  sc_export<push_if<DataType, CommandType> > p;

  sink(sc_module_name name) :
    sc_module(name),
    mytarget("target")
  { 
    p(mytarget); 
  }

private:
  class target: public push_if<DataType, CommandType>, sc_channel {
  public:
    SC_CTOR(target) {}

    void push(DataType *data) {
       cout << name() << " " << sc_time_stamp() 
            << ": Received " << data->i << endl;
       delete data;
    }

    void command(CommandType *cmd) {}
  } mytarget;

};

#endif
