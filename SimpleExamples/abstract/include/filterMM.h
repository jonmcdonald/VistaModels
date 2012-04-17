#ifndef _FILTERMM_H_
#define _FILTERMM_H_

#include "systemc.h"
#include "pull_if.h"
#include "push_if.h"
#include "types.h"

using namespace std;

class filterMM: sc_module {
public:
  sc_port<pull_if<DataType, CommandType > > pIn;
  sc_port<push_if<DataType, CommandType > > pOut;

  SC_HAS_PROCESS(filterMM);

  filterMM(sc_module_name name) :
    sc_module(name)
  { 
    SC_THREAD(thread);
  }

  void thread() {
    for (;;) { 
      d = pIn->pull();
      filter(d);
      pOut->push(d);
    }
  }

private:

  DataType *d;  

  void  filter(DataType *d) {
    d->i += 5;
    cout << name() << " filter being applied data = " << d->i << endl;
  }
};

#endif

