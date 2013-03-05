# builds connection to XEmacs

namespace eval ::v2::xemacs {

  class V2XEmacsConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder
    
    private method is_executable {exe} {
      if {[file executable $exe] && ![file isdirectory $exe]} {
        return 1
      }
      if {[is_cygwin] || [is_mingw]} {
        if {[file executable $exe.exe] && ![file isdirectory $exe.exe]} {
          return 1
        }
      }
      return 0
    }

    private method which {exe} {
      if {[Utilities::isFullPath $exe]} {
        if {[is_executable $exe]} {
          return $exe
        }
        return ""
      }
      if {[catch {
        exec which $exe
      } found] == 0} {
        if {[info exists ::errorInfo]} {
          set ::errorInfo ""
        }
        if {[is_executable $found]} {
          return $found
        }
      }
      return ""
    }

    private method getXEmacsExe {} {
      set varname "V2_XEMACS_EXE"
      if {[info exists ::env($varname)]} {
        set exe $::env($varname)
      } else {
        set exe "xemacs"
      }
      if {[is_cygwin] || [is_mingw]} {
        foreach candidate [list $exe "xemacs"] {
          set full [which $candidate]
          if {$full != ""} {
            return $full
          }
        }
      }
      return $exe
    }

    public method build {} {
      set exe [getXEmacsExe]
      if {[is_cygwin] || [is_mingw]} {
        set args [list -l [set ::env(V2_XEMACS_START_SCRIPT)] -no-init-file]
      } else {
        set args [list -name vista_editor -l [set ::env(V2_XEMACS_START_SCRIPT)] -no-init-file -iconic]
        #-font "*-arial-medium-r-normal-*-12-120-*"
      }
      return [::Application::run_and_wait_for_connection_interactive "XEmacs" $exe $args]
    }

    private method checkIfExists {} {
      if {[::Net::Ipc::connectionManager peekConnectionFromGroup "XEmacs" 1] != ""} {
        error "Connection XEmacs is already exist"
      }
    }
    
    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      checkIfExists
      set connection [ objectNew ::Net::TcpIp::ConnectionWithRpc $connectionName $application]
      set socket [lindex $arguments 0]
      set host [lindex $arguments 1]
      set port [lindex $arguments 2]
      $connection initByRemoteRequest $socket $host $port
      return $connection
    }
  }
  
  V2XEmacsConnectionBuilder v2XEmacsConnectionBuilder
  
}


