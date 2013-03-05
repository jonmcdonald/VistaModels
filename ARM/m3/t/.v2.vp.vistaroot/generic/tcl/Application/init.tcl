summit_begin_package Application

package require Tcl
package require Itcl
summit_package_require Utilities

summit_source CurrentApplication.tcl
summit_source App.tcl
summit_source AppRegistry.tcl
summit_source AppFactory.tcl
summit_source Utilities.tcl
summit_source SlaveApplication.tcl

namespace eval ::Application {
  set SHOW_LOGO 0
}

summit_end_package
