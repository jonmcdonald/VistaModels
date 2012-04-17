#ifndef _TOP_H_
#define _TOP_H_

#include "sensor.h"
#include "filterSM.h"
#include "filterSS.h"
#include "filterMM.h"
#include "sink.h"

SC_MODULE (top) {

  sensor m_sensor1;
  sensor m_sensor2;
  filterSM m_filtersm1;
  filterSM m_filtersm2;
  filterSS m_filterss;
  filterMM m_filtermm;
  sink m_sink;

  top(sc_module_name name) :
    sc_module(name),
    m_sensor1("sensor1"),
    m_sensor2("sensor2"),
    m_filtersm1("filtersm1"),
    m_filtersm2("filtersm2"),
    m_filterss("filterss"),
    m_filtermm("filtermm"),
    m_sink("sink")
  {
    m_sensor1.p(m_filtersm1);
    m_sensor2.p(m_filtersm2);
    m_filtersm1.p(m_filterss.i);
    m_filtersm2.p(m_filterss.i);
    m_filtermm.pIn(m_filterss.o);
    m_filtermm.pOut(m_sink.p);
  }

  ~top() {}

};

#endif

