#include "systemc.h"

struct thread_safe_event_if : sc_core::sc_interface
{
  virtual void notify(sc_core::sc_time delay = SC_ZERO_TIME) = 0;
  virtual const sc_core::sc_event& default_event(void) const = 0;
 protected:
  virtual void update(void) = 0;
};

struct thread_safe_event : sc_core::sc_prim_channel, thread_safe_event_if
{
  thread_safe_event(const char* name) {}

  // The following may be safely called from outside the SystemC OS thread
  void notify(sc_core::sc_time delay = SC_ZERO_TIME) {
    m_delay = delay;
    async_request_update(); }

  const sc_core::sc_event& default_event(void) const { 
    return m_event; }

 protected:
  virtual void update(void) { 
    m_event.notify(m_delay); }

 private:
  sc_core::sc_event m_event;
  sc_core::sc_time m_delay;
};

