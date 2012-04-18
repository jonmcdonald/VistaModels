#pragma once
#include "mgc_vista_schematics.h"
$includes_begin;
#include <systemc.h>
$includes_end;

$module_begin("top");
SC_MODULE(top) {
public:
  top(::sc_core::sc_module_name name):
    ::sc_core::sc_module(name)
    $initialization_begin
    $initialization_end
{
    $elaboration_begin;
    $elaboration_end;
  }
  ~top() {
    $destructor_begin;
    $destructor_end;
  }
public:
  $fields_begin;
  $fields_end;
};
$module_end;

