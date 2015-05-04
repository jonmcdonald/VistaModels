#ifndef __pushpull_if_h__
#define __pushpull_if_h__

#include "systemc.h"

template <class DT, class CT>
class pushpull_if: virtual public sc_interface {
public:
  virtual DT pull (CT command) = 0;
  virtual bool push (DT data, CT command) = 0;
};

#endif
