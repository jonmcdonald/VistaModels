summit_begin_package v2:systemc_editor:test
if {[catch {summit_package_require v2:systemc_editor} msg]} {
  puts $::errorInfo
  exit 1
}
summit_end_package
