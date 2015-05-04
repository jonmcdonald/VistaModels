#ifndef _POWERTRAIN_H_
#define _POWERTRAIN_H_

#include <cmath>
#include "systemc.h"
#include "tlm.h"
#include "pull_if.h"
#include "push_if.h"
#include "pushpull_if.h"

using namespace std;

class powertrain: sc_module {
public:
  sc_export<pushpull_if<unsigned,unsigned> > eng;
  sc_export<push_if<unsigned> > brk;
  sc_export<pull_if<unsigned> > wfl;
  sc_export<pull_if<unsigned> > wfr;
  sc_export<pull_if<unsigned> > wbl;
  sc_export<pull_if<unsigned> > wbr;

  powertrain(sc_module_name name) : 
    sc_module(name), 
    tfl("tfl", this, 0),
    tfr("tfr", this, 1),
    tbl("tbl", this, 2),
    tbr("tbr", this, 3),
    teng("teng", this, 1),
    tbrk("tbrk", this, 0),
    throttleposition(0),
    lastcalc(SC_ZERO_TIME),
    lastSpeed(0)
  { 
    wfl(tfl);
    wfr(tfr);
    wbl(tbl);
    wbr(tbr);
    eng(teng);
    brk(tbrk);
  }

private:
  // pull_if interface support class
  class targetpull: public pull_if<unsigned>, sc_channel {
  public:
    targetpull(sc_module_name name, powertrain *parent, int wheel) : 
      sc_module(name), parent(parent), wheel(wheel) {}

    unsigned int pull() {
      return parent->processWheelSpeedReq(wheel); }

  private:
    sc_event data_ev;
    powertrain *parent;
    int wheel;
  } tfl, tfr, tbl, tbr;

  // push_if interface support class
  class targetpushpull: public pushpull_if<unsigned,unsigned>, public push_if<unsigned>,  sc_channel {
  public:
    targetpushpull(sc_module_name name, powertrain *parent, int f) : 
      sc_module(name), parent(parent), function(f) {}

    bool push(unsigned int val) {
      if (function == 1)
        parent->processThrottle(val);
      else
        parent->processBreak(val);
      return true;
    }

    // Implement to push different types of values
    bool push(unsigned val, unsigned index=0) {
      parent->processThrottle(val);
      return true;
    }

    // Index allows function to return different types of data
    unsigned pull(unsigned index=0) {
      return parent->processEngineInfo(index); }

  private:
    sc_event data_ev;
    powertrain *parent;
    int function;
  } teng, tbrk;

  
  unsigned processEngineInfo(unsigned index) {
    updateToCurrent();
    if (lastSpeed < 2) return (unsigned) 1000;
    if (lastSpeed < 10) return (unsigned) round(lastSpeed * 400);
    if (lastSpeed < 20) return (unsigned) round(lastSpeed * 200);
    if (lastSpeed < 35) return (unsigned) round(lastSpeed * 100);
    if (lastSpeed < 75) return (unsigned) round(lastSpeed * 50);
    if (lastSpeed < 125) return (unsigned) round(lastSpeed *  30);
    return (unsigned) round(lastSpeed *  20);
  }

  unsigned processWheelSpeedReq(int wheel) {
    updateToCurrent();
    return (unsigned) round(lastSpeed);
  }

  void processThrottle(int val) {
    updateToCurrent();
    throttleposition = val;
  }

  void processBreak(int val) {
    updateToCurrent();
    brakeposition = val;
  }

  void updateToCurrent() {
    sc_time elapsed = sc_time_stamp() - lastcalc;
    lastcalc = sc_time_stamp();
    double newSpeed;
    // Assumes linear relationship between throttleposition and speed
    double steadyStateSpeed = throttleposition * 1.5;
    // Assumes linear relationship to brake position and brake deceleration
    double brakingAcceleration = -1.0 * brakeposition * (15.0/100.0);

    double throttleAcceleration;
    throttleAcceleration = (steadyStateSpeed >= lastSpeed) ? 12.0 :  -0.5;

    newSpeed = lastSpeed + ((elapsed / sc_time(1, SC_SEC)) * (throttleAcceleration + brakingAcceleration));

    if (newSpeed > steadyStateSpeed && throttleAcceleration > 0) newSpeed = steadyStateSpeed;
    if (newSpeed < steadyStateSpeed && throttleAcceleration < 0) newSpeed = steadyStateSpeed;
    if (newSpeed < 0) newSpeed = 0;

    lastSpeed = newSpeed;
  }

  unsigned throttleposition;
  unsigned brakeposition;
  sc_time lastcalc;
  double lastSpeed;
  
};

#endif

