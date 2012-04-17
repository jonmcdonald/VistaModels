#ifndef __push_if_h__
#define __push_if_h__

#include "systemc.h"

template <class DT, class CT>
class push_if: virtual public sc_interface {
public:
  virtual void push (DT* data) = 0;
  virtual void command (CT* command) = 0;
};

#endif
