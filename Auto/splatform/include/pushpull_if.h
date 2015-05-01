#ifndef __pushpull_if_h__
#define __pushpull_if_h__

#include "systemc.h"

template <class DT>
class pushpull_if: virtual public sc_interface {
public:
  virtual DT pull (unsigned index) = 0;
  virtual bool push (DT data) = 0;
};

#endif
