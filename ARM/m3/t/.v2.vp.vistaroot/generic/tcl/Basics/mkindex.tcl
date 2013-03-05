source "$::env(V2_HOME)/tcl/Basics/init.tcl"
summit_source_file Basics/build_tclIndex.tcl
eval ::Basics::build_tclIndex $argv
