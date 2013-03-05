wm withdraw .
summit_package_require v2:ui:analysis:window
summit_package_require Utilities

namespace eval ::v2::ui::analysis::window {

  proc open_analysis_window {args}  {
    set args_list [lindex $args 0]
    set simulation_directory ""
    set second_sim ""
    set session ""
    ::Utilities::getArgument $args_list 0 simulation_directory
    ::Utilities::getArgument $args_list 1 second_sim
    ::Utilities::getOption $args_list -session session
    $::main_doc run_command_ex OpenNewAnalysisWindowCommand SimulationDirectory $simulation_directory IsStandAloneArg 1 SavedSessionPath $session SecondSimulationDirectory $second_sim
  }

}

set st [catch {
  set slave_connection [::Net::Ipc::connectionManager peekConnection Slave]
  if {$slave_connection != ""} {
    $slave_connection call "::mgc_analysis_client_ready"
  } else {
    if {[llength $::libc_argv] == 1} {
      $::main_doc run_command_ex OpenNewAnalysisWindowCommand IsStandAloneArg 1
    } else {
      ::v2::ui::analysis::window::open_analysis_window [lrange $::libc_argv 1 end]
    }
  }
} msg]

if {$st} {
  #puts stderr $msg
}
