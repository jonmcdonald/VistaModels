namespace eval ::v2::socd {

  proc is_socd_active {} {
    if {[info exists ::env(MAXSIM_HOME)]} {
      return 1
    }
    return 0
  }
}
