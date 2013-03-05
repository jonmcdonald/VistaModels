summit_begin_package v2:ui:profilingwindow

summit_package_require Document
summit_package_require Application
summit_package_require UI
if {[info exists ::PROFILING_USE_GNUPLOT] && $::PROFILING_USE_GNUPLOT == 1} {
  summit_package_require gnuplot
} else {
  set ::PROFILING_USE_GNUPLOT 0
}

summit_package_require v2:ui
summit_package_require v2:ui:help

summit_end_package
