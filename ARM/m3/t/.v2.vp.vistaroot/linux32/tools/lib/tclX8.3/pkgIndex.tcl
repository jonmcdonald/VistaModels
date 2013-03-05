# Tcl package index file, version 1.0
# 
# Package index for TclX 8.3.0.
#
if {[info tclversion] < 8.4} return
package ifneeded Tclx 8.3 "load [list $dir/../libtclx8.3.so]"


