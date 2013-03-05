namespace eval ::Utilities {

  proc getTempDir {} {

    global tcl_platform env
    set tmpDirectory ""

    if {[info exists ::env(TMPDIR)]} {
      set tmpDirectory $::env(TMPDIR)
    } else {
      #obsolete
      if {$tcl_platform(platform) == "unix"} {
        set tmpDirectory /tmp
        if {![file writable $tmpDirectory]} {
          set tmpDirectory [pwd]
        }
      } else {
        if {[info exist env(TMP)]} {
          set tmpDirectory $env(TMP)
        } elseif {[info exist env(TEMP)]} {
          set tmpDirectory $env(TEMP)
        } else {
          set tmpDirectory [pwd]
        }
        set tmpDirectory [::Utilities::pathWin2Unix $tmpDirectory]
      }
    }
    if {![file exists $tmpDirectory]} {
      file mkdir $tmpDirectory
    }
    proc getTempDir {} [list return $tmpDirectory]
    return $tmpDirectory
  }
  
  proc getTempFile {} {
    return "[getTempDir]/[getCurrentUser][getUniqueProcessId][createUniqueIdentifier].tmp"
  }

}
