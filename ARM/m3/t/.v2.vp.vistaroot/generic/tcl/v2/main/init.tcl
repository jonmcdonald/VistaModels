summit_begin_package v2:main

catch {wm withdraw .}

summit_package_require Utilities
if {![::Utilities::isUnix]} {
  wm iconbitmap . -default "$::env(V2_HOME)/gif/top.ico"
}

summit_package_require v2:main:base
summit_package_require v2
summit_package_require v2:systemc_editor
summit_package_require v2:ui:factory
summit_package_require v2:ui:help

summit_end_package
