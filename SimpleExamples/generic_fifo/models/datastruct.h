#pragma once

#include "model_builder.h"

typedef struct packet {
  unsigned iaddr;
  unsigned char * data;
  unsigned dataSize;
  sc_time startT;
} packet_t;

