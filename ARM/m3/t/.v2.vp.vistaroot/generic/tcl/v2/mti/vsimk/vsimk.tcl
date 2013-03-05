# this file should be loaded by kernel(vsimk) and not by vish
if {[info exists ::v2_mti_vsimk_loaded]} {
  return
}
set ::v2_mti_vsimk_loaded 1

namespace eval ::v2::mti::vsimk {

  proc reuse_gdb_for_simulation_session_if_needed {} {
    variable reuse_gdb_called
    if {![info exists reuse_gdb_called]} {
      set reuse_gdb_called 1
      # do nothing first time
      return
    }
    catch {
      $::gdb_connection call [list ::v2::gdb::v2_call ::v2::reuse_gdb_for_simulation_session $::env(V2SimulationInvocationId)]
    }
  }

  proc on_status_changed {is_running} {
    if [catch {$::gdb_connection call "::v2::gdb::MtiSimulator::mti_status_changed $is_running"}] {
      puts stderr "error ($msg) when $::gdb_connection call \"::v2::gdb::MtiSimulator::mti_status_changed $is_running\""
    }
    return ""
  }
  if {[catch {
    $::gdb_connection call "::v2::gdb::vsimk_connected"
  } msg ]} {
    puts stderr "Error during Modelsim-Vista initialization:$msg"
  }

}
