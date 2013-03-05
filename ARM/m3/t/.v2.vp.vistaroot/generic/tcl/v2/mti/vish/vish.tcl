# this file should be loaded by vish and NOT by kernel(vsimk)

if {[info exists ::v2_mti_vish_loaded]} {
  return
}
set ::v2_mti_vish_loaded 1
source $::env(V2_HOME)/tcl/Net/SimpleClient/SimpleClient.tcl


namespace eval ::v2::mti::vish {
  set gdb_connection ""
  proc on_gdb_connection_closed {event args} {
    if {$event == "socket_closed"} {
      catch {::v2::mti::vish::quick_exit}
    }
  }

  proc ::v2::mti::vish::connect_to_gdb {} {
    variable gdb_connection
    set gdb_connection [::Net::SimpleClient::create_connection Vish $::env(GDB_MASTER_SERVER_HOST) $::env(GDB_MASTER_SERVER_PORT)]
    $gdb_connection enable_fileevents
    $gdb_connection add_listener ::v2::mti::vish::on_gdb_connection_closed
    return ""
  }

  proc ::v2::mti::vish::call_gdb {str} {
    variable gdb_connection
    set result ""
    catch {
      set result [$gdb_connection call $str]
    }
    return $result
  }

  proc ::v2::mti::vish::is_idle {} {
    set status [runStatus]
    if {$status == "ready" || $status == "break" || $status == "error" || $status == "nodesign"} {
      return 1
    }
    return 0
  }

  proc ::v2::mti::vish::is_busy {} {
    return [expr ![is_idle]]
  }

  proc ::v2::mti::vish::is_ready {} {
    set status [runStatus]
    if {$status == "ready" || $status == "break" || $status == "error"} {
      return 1
    }
    return 0
  }

  proc ::v2::mti::vish::run_cmd {args} {
    if {[is_ready]} {
      return [uplevel \#0 ::transcribeNext run $args]
    }
    return ""
  }
  
  proc ::v2::mti::vish::schedule_script {script} {
    variable state_scripts
    lappend state_scripts $script
  }

  proc ::v2::mti::vish::evaluate_state_scripts {args} {
    variable state_scripts
    set copy $state_scripts
    set state_scripts {}
    set remain_scripts {}
    foreach script $copy {
      set remove_it 0
      catch {
        if {[string equal [uplevel \#0 $script] "done"]} {
          set remove_it 1
        }
      }
      if {!$remove_it} {
        lappend remain_scripts $script
      }
    }
    set state_scripts [concat $remain_scripts $state_scripts]
    return ""
  }

  proc ::v2::mti::vish::evaluate_if_ready {script} {
    if {[is_ready]} {
      catch {uplevel $script}
      return "done"
    }
    return ""
  }

  proc ::v2::mti::vish::evaluate_if_idle {script} {
    if {[is_idle]} {
      catch {uplevel $script}
      return "done"
    }
    return ""
  }

  proc ::v2::mti::vish::evaluate_if_nodesign {script} {
    if {[runStatus] == "nodesign"} {
      catch {uplevel $script}
      return "done"
    }
    return ""
  }

  proc ::v2::mti::vish::stop_and_eval {script} {
    if {[is_idle]} {
      catch {uplevel $script}
      return ""
    }
    catch {vsim_break}
    if {[is_idle]} {
      catch {uplevel $script}
      return ""
    }
    schedule_script [list [namespace current]::evaluate_if_idle $script]
    return ""
  }

  proc ::v2::mti::vish::quit_and_eval {script} {
    if {[runStatus] == "nodesign"} {
      catch {uplevel $script}
      return ""
    }
    catch {quit -sim}
    if {[runStatus] == "nodesign"} {
      catch {uplevel $script}
      return ""
    }
    schedule_script [list [namespace current]::evaluate_if_nodesign $script]
    return ""
  }

  proc ::v2::mti::vish::continue_cmd {} {
    ::run $::RunLength
  }

  proc ::v2::mti::vish::normalize_arguments {arguments} {
    set a {\1}
    regsub -all {([^\\])\"} $arguments {\1\"}  arguments
    regsub -all {([^\\])'} $arguments "$a\""  arguments
    return $arguments
  }


  proc ::v2::mti::vish::getCurrentStartupArgs {} {
    #warning: usage of internal function
    set result {}
    catch {
      if {[llength [info command ::StartupGetArgs]]} {
        set result [::StartupGetArgs]
      }
    }
    return $result
  }

  proc ::v2::mti::vish::compare_startup_args {args1 args2} {
    if {[string equal $args1 $args2]} {
      return 1
    }
    set sorted_args1 [lsort $args1]
    set sorted_args2 [lsort $args2]
    if {[string equal $sorted_args1 $sorted_args2]} {
      return 1
    }
    
    if {[llength $sorted_args1] != [llength $sorted_args2]} {
      return 0
    }
    foreach a1 $sorted_args1 a2 $sorted_args2 {
      if {![string equal $a1 $a2]} {
        return 0
      }
    }
    return 1
  }

  proc ::v2::mti::vish::restart_if_idle {} {
    if {[is_idle]} {
      after idle [list ::transcribe ::restart -force]
      return
    }
    quit_and_eval [list [namespace current]::run_vsim]
  }

  proc ::v2::mti::vish::run_vsim {} {
    variable vista_vsim_args
    after idle [list uplevel \#0 vsim $vista_vsim_args]
  }

  proc ::v2::mti::vish::restart_cmd {arguments} {
    variable vista_vsim_args
#    set arguments [normalize_arguments $arguments]
    if {[runStatus] != "nodesign"} {
      #warning "used internal variable"
      set current_startup_args [getCurrentStartupArgs]
      if {[string match *Vista_Mti_Init* $current_startup_args]} {
        stop_and_eval [list [namespace current]::restart_if_idle]
        return
      }
    }
    quit_and_eval [list [namespace current]::run_vsim]
  }

  proc ::v2::mti::vish::quick_exit {} {
    catch {vlmExit}
    catch {texit}
  }

  proc ::v2::mti::vish::quit_cmd {{how kindly}} {
    if {$how == "kindly"} {
      ::quit -force
      return
    }
    ::v2::mti::vish::quick_exit
  }

  proc ::v2::mti::vish::vish_init {} {

    rename ::vsim ::v2::mti::vish::vsim.original
    proc ::vsim {args} {
      if {![string match *Vista_Mti_Init* $args]} {
        lappend args -foreign "Vista_Mti_Init $::env(V2_SYSTEMC_LIB_PIC_DIRECTORY)/libvista_runtime.so"
      }
      set ::v2::mti::vish::vista_vsim_args $args
      uplevel ::v2::mti::vish::vsim.original $args
    }
    
    rename ::open ::v2::mti::vish::open.original
    proc ::open {args} {
      if {[string match -nocase *gdb*annotate* $args]} {
        error "CDebug functionality is not supported with Vista"
      }
      set filename [lindex $args 0]
      set a {\1}
      set sccom_wrapper $::env(V2_BIN_DIRECTORY)/sccom
      if {![regsub {^\|\".*sccom\"( .*)$} $filename "|\"$sccom_wrapper\"$a" filename]} {
        regsub {^\|.*sccom( .*)$} $filename "|\"$sccom_wrapper\"$a" filename
      }
      uplevel ::v2::mti::vish::open.original [concat [list $filename] [lrange $args 1 end]]
    }

    proc ::vista_sccom {args} {
      uplevel ::sccom $args
    }

    proc ::vista_vsim {args} {
      uplevel ::vsim $args
    }

    proc ::vista_vlog {args} {
      uplevel ::vlog $args
    }


    connect_to_gdb
    trace variable ::vsimPriv(state)  w [list [namespace current]::evaluate_state_scripts]
    catch {::cdbg quit}
    return ""
  }


  set ::v2::mti::vish::vista_vsim_args [getCurrentStartupArgs]
  set ::v2::mti::vish::state_scripts {}

}



proc gdb {args} {
  variable gdb_connection
  if {[llength $args] == 0} {
    ::v2::mti::vish::call_gdb "summit_gdb_stop"
    return
  }
  after idle [list ::v2::mti::vish::call_gdb [list ::v2::gdb::stop_and_eval_and_continue [list ::v2::gdb::puts_gdb_cmd $args]]]
  return ""
}

::v2::mti::vish::vish_init


#proc cdbg {args} {
#  if {$args == "quit"} {
#    return
#  }
#  error "CDebug functionality is not supported with Vista"
#}



#toplevel .t
#pack [entry .t.e -textvar v2_vish_command_variable] -fill x
#pack [button .t.b -text eval -command {uplevel \#0 $v2_vish_command_variable}]
