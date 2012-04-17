#ifndef _FILTERSS_H_
#define _FILTERSS_H_

#include "systemc.h"
#include "push_if.h"
#include "pull_if.h"
#include "types.h"
#include "queue"

using namespace std;

class filterSS: sc_module {
public:
  sc_export<push_if<DataType, CommandType> > i;
  sc_export<pull_if<DataType, CommandType> > o;

  filterSS(sc_module_name name) :
    sc_module(name),
    mytarget("target")
  { 
    i(mytarget);
    o(mytarget);
  }

private:

  class target: public push_if<DataType, CommandType >,
		public pull_if<DataType, CommandType >,
		sc_channel 
  {
  public:
    SC_CTOR(target) {}

    void push(DataType  *data) {
        filter(data);
        m_fifo.push(data);
        if (m_fifo.size() == 1) data_ev.notify();
    }

    DataType * pull() {
      if (m_fifo.size() == 0 ) wait(data_ev);
      DataType *data = m_fifo.front();
      m_fifo.pop();
      return data;
    }

    void command(CommandType  *cmd) { }

  private:
    void filter(DataType *d) {
      d->i -= 1;
      cout << name() << " filter being applied data = " << d->i << endl;
    }

    queue<DataType *> m_fifo;
    sc_event data_ev;
  } mytarget;
};

#endif

