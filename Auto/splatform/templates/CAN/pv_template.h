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

#pragma once

#include "$(BASE_CLASS_INCLUDE)"
#include <queue>
#include <vector>

using namespace tlm;

class $(CLASS_NAME) : public $(PV_BASE_CLASS_NAME) {
 public:
  typedef esl::tlm_types::Address mb_address_type;

  SC_HAS_PROCESS($(CLASS_NAME));
  $(CLASS_NAME)(sc_module_name module_name);

  void thread();/*<*/
  void $(MASTER)_thread();/*>*/

 protected:/*is_exist(TARGET_WITH_CALLBACK){*/

  ///////////////////////////////
  // target write callbacks
  /////////////////////////////// /*}*/
/*<*/
  virtual bool $(TARGET_WITH_CALLBACK)_callback_write(config::uint64 address, unsigned char* data, unsigned size);/*>*/

 private:
  class DataType {
    public:
    unsigned int m_ident;
    unsigned int m_length;
    unsigned int m_crc;
    unsigned int m_size;
    mb::mb_token_ptr m_tokenptr;
    unsigned char * m_data;

      DataType() {}

      DataType(mb_address_type address, unsigned size, mb::mb_token_ptr tokenptr)
        : m_ident(address), m_size(size)
      {
        m_tokenptr = tokenptr;
        if (m_tokenptr && m_tokenptr->hasField("CANDataPtr")) {
          m_data = (unsigned char *) m_tokenptr->getFieldAsVoidPtr("CANDataPtr");
        } else {
          cout << "Error: $(CLASS_NAME) DataType constructor.\n";
        }
      }

      bool operator() (const DataType* lhs, const DataType* rhs) const {
        return lhs->m_ident < rhs->m_ident; }
  };

  tlm_fifo<int> iff;
/*<*/  mb::mb_fifo<DataType*> $(MASTER)ff;
/*>*/  priority_queue<DataType*, vector<DataType*>, DataType> pq;
};
