summit_begin_package v2:ui:simulation
namespace eval :: {
  set zoomIteration 0
  proc doZooms {zooms} {
    if {[llength $zooms] == 0} {
      return
    }
    incr ::zoomIteration
    puts stderr "Iteration $::zoomIteration ::zoomTest ::w1 [lindex $zooms 0] [lindex $zooms 1]"
    ::zoomTest ::w1 [lindex $zooms 0] [lindex $zooms 1]
    after 200 [list ::doZooms [lreplace $zooms 0 1]]
  }
}
summit_end_package
