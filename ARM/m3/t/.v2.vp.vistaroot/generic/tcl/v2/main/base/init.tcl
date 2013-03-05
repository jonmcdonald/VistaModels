summit_begin_package v2:main:base

proc bgerror {message} {
  puts stderr $message
}

set ::tcl_prompt1 {puts -nonewline "(vista) "}
set ::mgc_vista_api_interpreter [interp create]
$::mgc_vista_api_interpreter eval [list set ::tcl_prompt1 $::tcl_prompt1]

summit_package_require Utilities
summit_package_require Document
summit_package_require Application
summit_package_require v2:papoulis
summit_package_require v2:project
summit_package_require v2:types
summit_package_require v2:main:Net
summit_package_require v2:load



proc ::mgc_vista_get_api_interpreter {} {
  return $::mgc_vista_api_interpreter
}

summit_end_package
