catch {wm withdraw .}

summit_package_require UI:message:batch

proc on_my_error {args} {
  puts "error: $::errorInfo"
}

#trace variable ::errorInfo w on_my_error


summit_package_require Document
summit_package_require v2:load

set ::env(V2_INIFILE) vista.ini

process_the_env ::env 1
namespace eval ::v2 {
  namespace eval ui {
    namespace eval analysis {
      proc refresh {simulation_directory} {
        $::main_doc run_command_ex RefreshAnalysisWindowCommand SimulationDirectory $simulation_directory
      }
      
      proc open_analysis_window {simulation_directory}  {
        $::main_doc run_command_ex OpenAnalysisWindowCommand SimulationDirectory $simulation_directory
      }
      proc open_analysis_reports {simulation_directory} {
        $::main_doc run_command_ex OpenAnalysisReportsCommand SimulationDirectory $simulation_directory
      }
      proc eval_command_line_arguments {args} {
        #-script
        #-c
        #1 look for script location
        Utilities::parse_arguments {
          opt -script "batch script" ""
          opt -command "command" ""
        } $args   
        
        if {$script != ""} {
          source $script;
        }
        if {$command != ""} {
          eval $command;
        }
      }
    }
  }
}


set st [catch {
  set status [catch {
    eval ::v2::ui::analysis::eval_command_line_arguments [lrange $::libc_argv 1 end]
    
  } msg]
  if { $status } {
    puts "Error: $msg"
    exit 1
  }
} msg]

if {$st} {
  #puts $msg;
}


if { [array names ::env ANALYSIS_DEBUG] != {} } {
  toplevel .t
  pack [button .t.b -text "DEBUGGER" -command show_debug_windows]
}
