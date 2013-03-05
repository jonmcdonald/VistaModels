namespace eval ::Utilities {
  proc isUnix {} {
    global tcl_platform
    return [expr {$tcl_platform(platform) == "unix"}]
  }

  proc isHostAddrValid {addr} {
    return [expr {[regexp {([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)} $addr all d1 d2 d3 d4] && 
                  "$addr" != "127.0.0.1"}]
  }

  proc getValidHostAddrByHostName {hostName} {
    foreach addr [host_info addresses $hostName] {
      if {[isHostAddrValid $addr]} {
        return $addr
      }
    }
    return ""
  }

  # This function may be useful on some platforms (PC?).
  proc getCurrentHostAddrOld {} {
    set hostName [info host]
    set address [getValidHostAddrByHostName $hostName]
    if {$address == ""} {
      if {[isUnix]} {
        catch {
          set domainName [exec /bin/domainname]
          set fullHostName "$hostName.$domainName"
          set address [getValidHostAddrByHostName $fullHostName]
        }
      }
      if {$address == ""} {
        set address $hostName
      }
    }
    return $address
  }

  proc getCurrentHostAddr {} {
    if { [info exists ::env(CURRENT_HOST_ADDR)] && $::env(CURRENT_HOST_ADDR) != "" } {
      set address $::env(CURRENT_HOST_ADDR)
    } else {
      set address localhost
    }
    proc ::Utilities::getCurrentHostAddr {} [list return $address]
    return $address
  }

  proc isFullPath {path} {
    set is_unix 0
    set is_windows 0
    if {[is_cygwin] || [is_mingw]} {
      set is_unix 1
      set is_windows 1
    } else {
      if [isUnix] {
        set is_unix 1
      } else {
        set is_windows 1
      }
    }
    
    if {$is_unix && [string range $path 0 0] == "/"} {
      return 1
    }
    if {$is_windows && ([string range $path 1 1] == ":" || [string range $path 0 0] == "\\")} {
      return 1
    }
    return 0
  }

  proc signal_with_restart {action signalID {command ""}} {
    if {[infox have_signal_restart]} {
      if {$command == ""} {
	signal -restart $action $signalID
      } else {
        signal -restart $action $signalID $command
      }
    } else {
      if {$command == ""} {
        signal $action $signalID
      } else {
        signal $action $signalID $command
      }
    }
  }

}
