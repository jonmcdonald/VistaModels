namespace eval ::Utilities {
  
  # print the debug message to stderr ( if module is located in debugList )
  # example : dbg net "debug string" => *** debug <net> <debug string>
  proc dbg {module str} {
    global debugList
    if {[info exist debugList] && ([lsearch $debugList "all"] !=-1 || [lsearch $debugList $module] !=-1) } {
      puts stderr "*** debug <$module> <$str>"
      flush stderr
    }
  }
  
  # add module (s) to debugList
  # if args == all, then all the debug messages will be printed
  proc debug {args} {
    global debugList
    if {![info exist debugList]} {
      set debugList {}
    }
    foreach i $args {
      set debugList [uniqlinsert $debugList end $i]
    }
  }
  
  # remove module (s) from debugList
  proc undebug {args} {
    global debugList
    if {![info exist debugList]} {
      set debugList {}
    }
    if {[lsearch $args "all"] !=-1} {
      set debugList {}
      return 
    }
    foreach i $args {
      set ind [lsearch $debugList $i]
      if {$ind != -1} {
        set debugList [lreplace $debugList $ind $ind]
      }
    }
  }

  proc printFocus {} {
    after 5000 {puts [focus]}
  }

  namespace export *
}
