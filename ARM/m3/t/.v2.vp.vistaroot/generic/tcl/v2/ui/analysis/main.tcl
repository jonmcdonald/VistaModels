
wm withdraw .

proc on_my_error {args} {
  ipcDebug "error: $::errorInfo"
}

trace variable ::errorInfo w on_my_error


proc bgerror1 {message} {
  puts stderr $message
}


bgerror1 "In analysis"

summit_package_require v2:ui:analysis
summit_package_require v2:load
summit_package_require UI:message

set ::env(V2_INIFILE) vista.ini

process_the_env ::env 1
namespace eval ::v2 {
  namespace eval ui {
    namespace eval analysis {

      proc get_analysis_windows_by_simulation_directory {simulation_directory} {
        set ret ""
        foreach d [::Document::get_document_ids] {
          if {[::Document::getDocumentType $d] == "DocumentTypeAnalysisWindow"} {
            set simulationDir ""
            catch { set simulationDir [::Utilities::safeGet [::Document::getModelVariableName $d WindowSimulationDirectory]] }
            if {$simulationDir != "" && [string equal $simulationDir $simulation_directory]} {
              catch { lappend ret [::Utilities::safeGet [::Document::getModelVariableName $d AnalysisWindowTclInstance]] }
            }
          }
        }
        return $ret
      }

      proc refresh {simulation_directory} {
        $::main_doc run_command_ex RefreshAnalysisWindowCommand SimulationDirectory $simulation_directory
        foreach win [get_analysis_windows_by_simulation_directory $simulation_directory] {
          catch {$win refresh}
        }
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
          opt -sim "sim_dir" ""
          opt -reports "reports" -
          opt -type "analysis type" ""
          opt -kind "analysis kind" ""
          opt -obj "Objects" ""
          opt -gr_type "graph type" "Time"
          opt -gr_mode "graph mode" "Average"
          opt -interval_size "Interval size (deprecated)" ""
          opt -time_units "Time units" "ns"
          opt -is_compound "is compound graph" "0"
          opt -start_time "Start time" ""
          opt -end_time "End time" ""
        } $args   
        #puts "eval_command_line_arguments $script $sim"
        if {$sim != ""} {
          if {!$reports} {
            $::main_doc run_command_ex OpenAnalysisWindowCommand SimulationDirectory $sim SelectedObjects $obj AnalysisType $type AnalysisKind $kind GraphType $gr_type TimeUnits $time_units IsCompoundGraph $is_compound TimeStart $start_time TimeEnd $end_time GraphMode $gr_mode
          } else {
            $::main_doc run_command_ex OpenAnalysisReportsCommand SimulationDirectory $sim
          }
        }
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
  set slave_connection [::Net::Ipc::connectionManager peekConnection Slave]
  if {$slave_connection != ""} {

    $slave_connection call "::mgc_analysis_client_ready"
  } else {
#    ::v2::ui::analysis::open_analysis_window [lindex $::libc_argv 1]
    set status [catch {
      eval ::v2::ui::analysis::eval_command_line_arguments [lrange $::libc_argv 1 end]

    } msg]
    if { $status } {
      puts "Error: $msg"
      exit 1
    }
    #/shure/vista/install/tutorial/simple_bus_example/sim    
  }
} msg]

if {$st} {
  #puts $msg;
}

proc show_debug_windows {} {
  catch {$::main_doc run_command_ex DebugCommand}
  catch {$::main_doc run_command_ex ConsoleCommand}
}

if { [array names ::env ANALYSIS_DEBUG] != {} } {
  toplevel .t
  pack [button .t.b -text "DEBUGGER" -command show_debug_windows]
}

