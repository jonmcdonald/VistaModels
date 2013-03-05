# Tcl package index file, version 1.0
# 
# Package index for TkX 8.3.0.
#
if {[info tclversion] < 8.4} return
package ifneeded Tkx 8.3 "package require Tclx 8.3; package require Tk 8.4; load [list $dir/../libtkx8.3.so]"


