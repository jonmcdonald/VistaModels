#ifndef _TOP_MBIND_H_
#define _TOP_MBIND_H_

#include "systemc.h"
#include "driver_lt.h"
#include "target_lt.h"

class top_mbind: sc_module {
public:
  driver_lt d;
  target_lt t;

  top_mbind(sc_module_name name) :
    sc_module(name),
    d("d"),
    t("t")
  {
    VISTA_BIND_VIA_MONITOR("Monitor", d.d, t.t);
  }
};

#endif
