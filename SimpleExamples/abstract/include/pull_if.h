#ifndef __pull_if_h__
#define __pull_if_h__

#include "systemc.h"

template <class DT, class CT>
class pull_if: virtual public sc_interface {
public:
  virtual DT * pull () = 0;
  virtual void command (CT* command) = 0;
};

#endif
