#ifndef _FILTERSM_SC_H_
#define _FILTERSM_SC_H_

#include "systemc.h"
#include "push_if.h"
#include "pull_if.h"
#include "types.h"

using namespace std;

class filterSM_sc: public push_if<DataType, CommandType >, 
		   sc_module {
public:
  sc_port<custom_if<dataT > > p;

  filterSM_sc(sc_module_name name) :
    sc_module(name)
  { }

  void push(DataType  *data) {
      filter(DataType *data);
      p->push(data);
  }

  void command(CommandType  *cmd) { }

private:
  void filter(DataType *d) {
    d->i *= 2;
  }
};

#endif

