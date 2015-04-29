/**************************************************************/
/*                                                            */
/*      Copyright Mentor Graphics Corporation 2006 - 2015     */
/*                  All Rights Reserved                       */
/*                                                            */
/*       THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY      */
/*         INFORMATION WHICH IS THE PROPERTY OF MENTOR        */
/*         GRAPHICS CORPORATION OR ITS LICENSORS AND IS       */
/*                 SUBJECT TO LICENSE TERMS.                  */
/*                                                            */
/**************************************************************/

#include "PropCan_pv.h"
#include <iostream>

using namespace sc_core;
using namespace sc_dt;
using namespace std;

PropCan_pv::PropCan_pv(sc_module_name module_name) 
  : PropCan_pv_base(module_name), iff(3)
{
  SC_THREAD(thread);
  SC_THREAD(RX0_thread);
  SC_THREAD(RX1_thread);
  SC_THREAD(RX2_thread);
}

bool PropCan_pv::TX0_callback_write(mb_address_type address, unsigned char* data, unsigned size) {
  mb::mb_token_ptr tokenptr = get_current_token();
  DataType *d = new DataType(address, size, tokenptr);
  pq.push(d);
  iff.put(1);
  return true;
}

bool PropCan_pv::TX1_callback_write(mb_address_type address, unsigned char* data, unsigned size) {
  mb::mb_token_ptr tokenptr = get_current_token();
  DataType *d = new DataType(address, size, tokenptr);
  pq.push(d);
  iff.put(1);
  return true;
}

bool PropCan_pv::TX2_callback_write(mb_address_type address, unsigned char* data, unsigned size) {
  mb::mb_token_ptr tokenptr = get_current_token();
  DataType *d = new DataType(address, size, tokenptr);
  pq.push(d);
  iff.put(1);
  return true;
}

void PropCan_pv::thread() {
  DataType *d;
  while(iff.get()) {
    wait(generic_clock);// One clock delay for the start bit.
    d = pq.top();	// Take the priority message at the end of the start bit.
    pq.pop();
    // ReceiveCount used to know when data pointer can be deleted. Must be set to number of receivers.
    d->m_tokenptr->setField("ReceiveCount", 3);
    set_current_token(d->m_tokenptr);
    RX0ff.put(d);
    RX1ff.put(d);
    RX2ff.put(d);
  }
}

void PropCan_pv::RX0_thread()
{
  DataType *d;
  while(d = RX0ff.get()) {
    RX0_write(d->m_ident, d->m_data, d->m_size);
  }
}

void PropCan_pv::RX1_thread()
{
  DataType *d;
  while(d = RX1ff.get()) {
    RX1_write(d->m_ident, d->m_data, d->m_size);
  }
}

void PropCan_pv::RX2_thread()
{
  DataType *d;
  while(d = RX2ff.get()) {
    RX2_write(d->m_ident, d->m_data, d->m_size);
  }
}
