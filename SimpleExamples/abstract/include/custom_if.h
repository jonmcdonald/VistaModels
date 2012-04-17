#ifndef __custom_if_h__
#define __custom_if_h__

#include "systemc.h"

template <class T>
class custom_if: virtual public sc_interface {
public:
  virtual void send (T* input) = 0;
};

#endif
