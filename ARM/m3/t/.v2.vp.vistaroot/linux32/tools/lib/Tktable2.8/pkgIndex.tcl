if {[catch {package require Tcl 8.2}]} return
package ifneeded Tktable 2.8 \
    [list load [file join $dir libTktable2.8.so] Tktable]
