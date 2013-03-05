namespace eval ::Utilities {
  proc HOME {} {
    if {[info exists ::env(HOME)]} {
      return $::env(HOME)
    }
    if {[info exists ::env(LOGNAME)]} {
      return "/home/$::env(LOGNAME)"
    }
    if {[info exists ::env(USERNAME)]} {
      return "/home/$::env(USERNAME)"
    }
    return "/"
  }
  proc PWD {} {
    if {[info exists ::env(PWD)]} {
      return $::env(PWD)
    } else {
      return [::Utilities::pwd_orig]
    }
  }
}
rename pwd ::Utilities::pwd_orig
proc pwd {args} {
  return [::Utilities::PWD]
}
rename cd ::Utilities::cd_orig
proc cd {{directory ""}} {
  if {$directory == ""} {
    set directory [::Utilities::HOME]
  }
  set newdir ""
  set f [open "|\"$::env(V2_SHELL)\" -c \"cd \\\"$directory\\\" && printf %s \\\"\`$::env(V2_PWD)\`\\\"\" <[::Utilities::getNullDevice]" r]
  catch { set newdir [read $f] }
  catch { close $f }
  if {$newdir == ""} {
    error "could not change working directory to \"$directory\""
  }
  if {![file isdirectory $newdir]} {
    error "could not change working directory to \"$directory\""
  }
  set ::env(PWD) $newdir
  ::Utilities::cd_orig $::env(PWD) ;# Calls original cd
}
