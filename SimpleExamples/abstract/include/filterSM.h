#ifndef _FILTERSM_H_
#define _FILTERSM_H_

#include "systemc.h"
#include "push_if.h"
#include "pull_if.h"
#include "types.h"

using namespace std;

class filterSM: public push_if<DataType, CommandType >,
		sc_module {
public:
  sc_port<push_if< DataType, CommandType > > p;

  filterSM(sc_module_name name) :
    sc_module(name)
  { }

  void push(DataType  *data) {
      filter(data);
      p->push(data);
  }

  void command(CommandType  *cmd) { }

private:
  void filter(DataType *d) {
    d->i *= 2;
    cout << name() << " filter being applied data = " << d->i << endl;
  }
};

#endif

