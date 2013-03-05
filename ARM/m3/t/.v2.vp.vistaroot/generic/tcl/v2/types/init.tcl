summit_begin_package v2:types
summit_source Filter.tcl
foreach i {
  ::v2::types::global_variables_filter
  ::v2::types::functions_filter
} {
  namespace import -force $i
}
summit_end_package
