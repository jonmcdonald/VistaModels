#pragma once

#include "model_builder.h"

struct datastruct {
  bool read;
  esl::tlm_types::Address address;
  unsigned char * data;
  unsigned size;
  unsigned throughput;
  sc_time startT;
  mb::mb_token_ptr currentToken;
  tlm::tlm_base_protocol_types::tlm_payload_type *transptr;
};

