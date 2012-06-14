#pragma once

#include "model_builder.h"

struct datastruct {
  esl::tlm_types::Address address;
  unsigned char *data;
  unsigned int size;
  sc_time startT;
  mb::mb_token_ptr currentToken;
};

