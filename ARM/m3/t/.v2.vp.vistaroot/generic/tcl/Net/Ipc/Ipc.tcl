namespace eval ::Net::Ipc {

  proc makeEstablishmentPackage {connectionName pid} {
    return "$connectionName $pid"
  }
  
  proc parseEstablishmentPackage {package pConnectionName pPid} {
    upvar $pConnectionName connectionName
    upvar $pPid pid
    if {![regexp {^(.+) (.+)$} $package all connectionName pid]} {
      error "Invalid protocol: should be 'connectionName pid'"
    }
    return ""
  }
  
  proc makeEstablishmentStatus {status errorMessageOrPid} {
    if {!$status} {
      regsub -all "\n" $errorMessageOrPid "\\n" errorMessageOrPid
      regsub -all "\r" $errorMessageOrPid "\\r" errorMessageOrPid
    }
    return "$status $errorMessageOrPid"
  }

  proc parseEstablishmentStatus {result pStatus pErrorMessageOrPid} {
    upvar $pStatus status
    upvar $pErrorMessageOrPid errorMessageOrPid
    set result [regexp {^([10]) (.+)$} $result all status errorMessageOrPid]
    if {$result} {
      if {!$status} {
        regsub -all "\\n" $errorMessageOrPid "\n" errorMessageOrPid
        regsub -all "\\r" $errorMessageOrPid "\r" errorMessageOrPid
      }
    }
    return $result
  }

}

proc isIpcDebug {} {
  set enable [expr {[info exists ::env(VIS_IPC_DEBUG)] && "$::env(VIS_IPC_DEBUG)" != "0"}]
  proc isIpcDebug {} [list return $enable]
  return $enable
}

proc ipcGetLogFileNameImpl {} {
  if {[info exists ::env(VIS_IPC_DEBUG_FILE_NAME)]} {
    set fileName $::env(VIS_IPC_DEBUG_FILE_NAME)
    if {[file writable $fileName]} {
      return $fileName
    }
  }
  set appName ""
  catch {
    set appName [::Application::getCurrentApplicationName]
  }
  if {[::Utilities::isUnix]} {
    return /tmp/ipc.debug_[set appName]_[::Utilities::getCurrentUser]
  }
  return c:/ipc.debug_[set appName]_[::Utilities::getCurrentUser]
}

proc ipcGetLogFileName {} {
  set result [ipcGetLogFileNameImpl]
  proc ipcGetLogFileName {} [list return $result]
  return $result
}

namespace eval ::Net::Ipc {
  set ipcDebugAppName ""
  set ipcDebugPID ""
}
proc ipcDebug {str {force 0}} {
  if {$force || [isIpcDebug]} {
    catch {
      set fileName [ipcGetLogFileName]
      set f [open $fileName a]
      set clicks [clock clicks]
      if {$clicks < 0} {
        set clicks "[expr {10000000000 + $clicks}]"
      }
      set clicks "[expr {10000000000 + $clicks}]"
      set time ""
      catch {
        set time [clock format [clock seconds] -format %r]
      }
      catch {
        if {$::Net::Ipc::ipcDebugAppName == ""} {
          set ::Net::Ipc::ipcDebugAppName [::Application::getCurrentApplicationName]
        }
      }
      catch {
        set pid [::Utilities::getUniqueProcessId]
        if {$pid != $::Net::Ipc::ipcDebugPID} {
          set ::Net::Ipc::ipcDebugPID $pid
          puts $f "\[[expr {$clicks - 1}] $time $::Net::Ipc::ipcDebugAppName Process $pid\]"
        }
      }
      puts $f "\[$clicks $time $::Net::Ipc::ipcDebugAppName\]=>[string map [list \n \\n] $str]"
      close $f
    }
  }
}


proc ipcDebugLevel {} {
  catch {ipcDebug [info level -1]}
}
