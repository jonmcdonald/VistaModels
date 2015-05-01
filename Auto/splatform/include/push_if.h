#ifndef __push_if_h__
#define __push_if_h__

#include "systemc.h"

template <class DT>
class push_if: virtual public sc_interface {
public:
  virtual bool push (DT data) = 0;
};

#endif
