#proc ONERR {args} {puts $::errorInfo}; trace variable ::errorInfo w ONERR


summit_begin_package v2:load

summit_package_require Utilities
summit_package_require Utilities:ns_tree
summit_package_require Document
summit_package_require UI:message

proc view_graphics {{withError 0}} {
  if {$withError == 1} {
    trace variable ::errorInfo w ::Utilities::print_errors_callback
  }
  $::main_doc run_command_ex OpenMainViewCommand
  update
}


proc onTraceErrorInfo {args} {
  if {[regexp "^package .* is not present" $::errorInfo]} {
    return
  }
  if {[regexp {^can\'t unset \"(path(mod|opt)|itemList)\": no such variable} $::errorInfo]} {
    return
  }
  if {[regexp {^can\'t unset \"((DynamicHelp::)?_registered|tkFocus(In|Out))\(.*: no such} $::errorInfo]} {
    return
  }
  if {[regexp {^unknown option \"-state\"} $::errorInfo]} {
    return
  }
  if {[regexp {^couldn\'t open socket: address already in use} $::errorInfo]} {
    return
  }
  if {[regexp {^can\'t unset \"data\((selected|rect|list)\)\": no such element in array} $::errorInfo]} {
    return
  }
  if {[regexp {^no embedded image at index} $::errorInfo]} {
    return
  }
  puts stderr errorInfo
  puts stderr $::errorInfo
}

##
# Processes environments from the manager.
# Returns 1 if it is OK to procede (open Totals etc.),
# otherwise 0.
##
proc process_the_env {theenv {batchMode 0}} {
  upvar $theenv envarray

  if { [info exists envarray(V2_TRACE_ERRORS)] } {
    trace variable ::errorInfo w ::onTraceErrorInfo
  }
  if { [info exists envarray(V2_REPLAY_LOG)] } {
    set ::Document::replayLog $envarray(V2_REPLAY_LOG)
  }
  if { [info exists envarray(V2_REPLAY_INTERVAL)] } {
    set ::Document::commandInterval [expr $envarray(V2_REPLAY_INTERVAL) / 3]
    if {[expr $::Document::commandInterval < 1]} {
      set ::Document::commandInterval 1
    }
  }
  if { [info exists envarray(V2_HOOK)] } {
    if {[catch {
      uplevel \#0 $envarray(V2_HOOK)
    } result]} {
      puts stderr $result
      exit 1
    }
  }
  if { [info exists envarray(V2_RECORD_FILE)] } {
    ::Document::setRecordMode;
    ::Document::startRecording $envarray(V2_RECORD_FILE)
  }
  if { [info exists envarray(V2_GENHOOK_DIR)]} {
    if {[info exists envarray(V2_GENHOOK_NAMESPACE)]} {
      set hookNamespace $envarray(V2_GENHOOK_NAMESPACE)
    } else {
      set hookNamespace "::StandardHooks";
    }
    ::Document::startHookGenerator $envarray(V2_GENHOOK_DIR) $hookNamespace
  }
  if { [info exists envarray(V2_WORKING_DIRECTORY)] } {
    $::main_doc set_variable_value WorkspaceWorkingDirectory [file normalize $envarray(V2_WORKING_DIRECTORY)]
    if {!$batchMode} {
      update
    }
  }
  
  if { [info exists envarray(V2_INIFILE)] } {
    set global_vistaini $envarray(VISTA_ROOT)/.vistaini
    if {[file readable $global_vistaini]} {
      $::main_doc set_variable_value DocumentFile $global_vistaini
      if {!$batchMode} {
        update
      }
      $::main_doc run_command ReadDocumentCommand 
      #this update is needed also in batch
      update
    }

    $::main_doc set_variable_value DocumentFile $envarray(V2_INIFILE)
    if {!$batchMode} {
      update
    }
    $::main_doc run_command ReadDocumentCommand 
    #this update is needed also in batch
    update
    if {[file exists $envarray(V2_INIFILE)] && ![file readable $envarray(V2_INIFILE)]} {
      ::UI::Message::errorMessage "Cannot load environment from file $envarray(V2_INIFILE) - there is no read permission.";
      if {!$batchMode} {
        update
      }
    }
  }
  if { [info exists envarray(V2_LOAD_PROJECT)] } {
    foreach project $envarray(V2_LOAD_PROJECT) {
      $::main_doc run_command LoadProjectCommand ProjectFile $project
      if {!$batchMode} {
        update
      }
    }

    if { [info exists envarray(V2_ADD_FILES_TO_PROJECT)] } {
      $::main_doc run_command AddFilesToProjectCommand ProjectFile $envarray(V2_LOAD_PROJECT) FilesAndModelsList $envarray(V2_ADD_FILES_TO_PROJECT)
      if {!$batchMode} {
        update
      }
    }
  }

  if { [info exists envarray(V2_REPLAY)] } {
    if {[catch {
      if {![info exists envarray(V2_SPECIAL_REPLAY)] || $envarray(V2_SPECIAL_REPLAY) == 0} {
        ::Document::setReplayMode;
      }
      ::Document::replayUpdateLastDocument [$::main_doc get_ID] [$::main_doc get_type]
      namespace eval ::Document $envarray(V2_REPLAY)
      ::Document::executePending
    } result]} {
      puts stderr $result
      exit 1
    }
    return 0
  } else {
    if { ![info exists envarray(V2_NO_SPLASH_SCREEN)] && !$batchMode } {
      ::UI::HelpAbout .starting_logo 0
      wm title .starting_logo $::env(THIS_PRODUCT_NAME_AND_VERSION)
#      wm overrideredirect [.starting_logo getTop] 1
    }
    if {!$batchMode} {
      view_graphics
    }
  }
  return 1
}

proc load_simulations_if_needed {theenv} {
  upvar $theenv envarray
  catch {
    if {[info exists envarray(V2_LOAD_SIMULATION_DIRECTORIES)] && [string trim $envarray(V2_LOAD_SIMULATION_DIRECTORIES)] != "" } {
      set ui_simulation_doc [::v2::get_ui_simulation_document]
      foreach directory $envarray(V2_LOAD_SIMULATION_DIRECTORIES) {
        catch {
          ::Document::runCommand $ui_simulation_doc LoadSimulationCommand Directory $directory
          update
        }
      }
    }
  }
}

proc run_exec_simulation_command_if_needed {theenv} {
  upvar $theenv envarray
  if {[::Utilities::safeGet envarray(V2_SIMULATION_EXECUTABLE)] != "" || [::Utilities::safeGet envarray(V2_SIMULATION_PROJECT)] != ""} {
    mgc_vista_open_simulation_dialog
  }
}

proc mgc_get_simulation_document_by_simulation_directory {simulation_directory} {
  foreach id [::Document::getDocumentIDs] {
    if {[::Document::getDocumentType $id] == "DocumentTypeSimulation" && \
            [set [::Document::getModelVariableName $id "SimulationDirectory"]] == "$simulation_directory"} {
      return $id
    }
  }
  return ""
}

    
summit_end_package
