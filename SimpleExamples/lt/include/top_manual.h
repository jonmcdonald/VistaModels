#ifndef _TOP_MANUAL_H_
#define _TOP_MANUAL_H_

#include "systemc.h"
#include "driver_lt.h"
#include "target_lt.h"
#include "xbar_lt.h"

class top_manual: sc_module {
public:
  driver_lt d0;
  driver_lt d1;
  xbar_lt<> xbar1;
  target_lt t0;
  target_lt t1;

  top_manual(sc_module_name name) :
    sc_module(name),
    d0("d0"),
    d1("d1"),
    xbar1("xbar1"),
    t0("t0"),
    t1("t1")
  {
    d0.d(xbar1.i0);
    d1.d(xbar1.i1);
    xbar1.o0(t0.t);
    xbar1.o1(t1.t);
  }
};

#endif
