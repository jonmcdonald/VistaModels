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

/*@tcl
set FIRST_TARGET_PORT_NAME [lindex $TARGET 0]
set NumberPorts [llength $MASTER]
*/
#include "$(CLASS_NAME).h"
#include <iostream>

using namespace sc_core;
using namespace sc_dt;
using namespace std;

$(CLASS_NAME)::$(CLASS_NAME)(sc_module_name module_name) 
  : $(PV_BASE_CLASS_NAME)(module_name), iff($(NumberPorts))
{
  SC_THREAD(thread);/*<*/
  SC_THREAD($(MASTER)_thread);/*>*/
}/*<*/

bool $(CLASS_NAME)::$(TARGET_WITH_CALLBACK)_callback_write(mb_address_type address, unsigned char* data, unsigned size) {
  mb::mb_token_ptr tokenptr = get_current_token();
  DataType *d = new DataType(address, size, tokenptr);
  pq.push(d);
  iff.put(1);
  return true;
}/*>*/

void $(CLASS_NAME)::thread() {
  DataType *d;
  while(iff.get()) {
    wait(generic_clock);// One clock delay for the start bit.
    d = pq.top();	// Take the priority message at the end of the start bit.
    pq.pop();
    // ReceiveCount used to know when data pointer can be deleted. Must be set to number of receivers.
    d->m_tokenptr->setField("ReceiveCount", $(NumberPorts));
    set_current_token(d->m_tokenptr);/*<*/
    $(MASTER)ff.put(d);/*>*/
  }
}/*<*/

void $(CLASS_NAME)::$(MASTER)_thread()
{
  DataType *d;
  while(d = $(MASTER)ff.get()) {
    $(MASTER)_write(d->m_ident, d->m_data, d->m_size);
  }
}/*>*/
