namespace eval ::Document {
  set pending {}
  set pending_entry_point end
  set commandInterval 1
  proc executePending {} {
    variable pending
    variable pending_entry_point
    variable noCommandsInterval
    if {![llength $pending]} {
      set pending_entry_point end
      return
    }
    variable commandInterval
    if {![::Document::isReplayEnabled]} {
      after $commandInterval [namespace current]::executePending
      return
    }
    set currentCommand [lindex $pending 0]
    set pending [lrange $pending 1 end]
    set pending_entry_point 0
    after $commandInterval [namespace current]::executePending
    if {[catch {
      namespace eval ::Document $currentCommand
    } result]} {
#      puts $result
    }
  }

  proc addPending {args} {
    variable pending
    variable pending_entry_point
    set pending [eval [list linsert $pending $pending_entry_point] $args]
    if {$pending_entry_point != "end"} {
      incr pending_entry_point [llength $args]
    }
  }

  proc pending_code {args} {
    eval addPending $args
  }

  proc pending_if {cond ifpart {else ""} {elsepart ""}} {
    if {$else == ""} {
      addPending "if [list $cond] [list $ifpart]"
    } else {
      if {$else == "else"} {
        addPending "if [list $cond] [list $ifpart] else [list $elsepart]"
      } else {
        error "should be: pending_if ifpart (optional) else elsepart"
      }
    }
  }

  proc pending_for {init cond step script} {
    set loop loop_[::Utilities::createUniqueIdentifier]
    set ifValue "addPending [list $script] [list $step] \$$loop"
    set loopValue "if [list $cond] [list $ifValue] else {unset $loop}"
    addPending "eval [list $init];set $loop [list $loopValue]; eval \$$loop"
  }

  set hook_namespaces {}
  proc add_hook_namespace {namespace} {
    variable hook_namespaces
    lappend hook_namespaces $namespace
  }

  proc test_command_existance {candidate} {
#    puts "Looking for $candidate"
    return [lindex [info commands $candidate] 0]
  }

  proc find_hook {namespace prefix doctype tag} {
    set candidate "[set namespace]::[set doctype].[set prefix][set tag]"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "::[set namespace]::[set doctype].[set prefix][set tag]"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "[set namespace]::[set doctype].[set prefix]hook"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "::[set namespace]::[set doctype].[set prefix]hook"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "[set namespace]::[set prefix][set tag]"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "::[set namespace]::[set prefix][set tag]"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "[set namespace]::[set prefix]hook"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    set candidate "::[set namespace]::[set prefix]hook"
    if {[test_command_existance $candidate] == $candidate} {
      return $candidate
    }
    return ""
  }

  proc execute_hook {namespace prefix docID tag args} {
#    set doctype $::Document::docMap($docID) ;# temporary
    if {[catch {set doctype [::Document::getDocumentType $docID]}]} {
      return
    }
    set hook [find_hook $namespace $prefix $doctype $tag]
    if {$hook == ""} {
      return
    }
    if {[catch {
      uplevel \#0 [list $hook $::Document::docMap($docID) $tag] $args
    } result]} {
#      puts $result
    }
  }

  proc posthookReplayCommand {docID tag args} {
    variable hook_namespaces
    foreach namespace $hook_namespaces {
      eval [list ::Document::execute_hook $namespace "" $docID $tag] $args
    }
  }

  proc prehookReplayCommand {docID tag args} {
    variable hook_namespaces
    set namespaces [::List::reverse $hook_namespaces]
    foreach namespace $namespaces {
      eval [list ::Document::execute_hook $namespace "pre_" $docID $tag] $args
    }
  }
 
  proc posthookReplaySet {docID tag value} {
    variable hook_namespaces
    foreach namespace $hook_namespaces {
      ::Document::execute_hook $namespace "set_" $docID $tag $value
    }
  }

  proc prehookReplaySet {docID tag value} {
    variable hook_namespaces
    set namespaces [::List::reverse $hook_namespaces]
    foreach namespace $namespaces {
      ::Document::execute_hook $namespace "preset_" $docID $tag $value
    }
  }

  proc posthookReplayUpdateLastDocument {docID docType} {
    variable hook_namespaces
    foreach namespace $hook_namespaces {
      ::Document::execute_hook $namespace "new_" $docID $docType "doc"
    }
  }

  proc executeReplayCommand {docID tag args} {
    puts stderr [info level 0]
    if {[catch {
      puts stderr "[list ::Document::runCommand $::Document::docMap($docID) $tag] $args"
      eval [list ::Document::runCommand $::Document::docMap($docID) $tag] $args
    }]} {
      puts stderr $::errorInfo
    } else {
      puts stderr Done
    }
  }

  proc executeReplaySet {docID tag value} {
    puts stderr [info level 0]
    if {[catch {
      puts stderr "set [::Document::getModelVariableName $::Document::docMap($docID) $tag] $value"
      set [::Document::getModelVariableName $::Document::docMap($docID) $tag] $value
    }]} {
      puts stderr $::errorInfo
    } else {
      puts stderr Done
    }
  }

  proc executeReplayUpdateLastDocument {docID docType} {
    puts stderr [info level 0]
    if {[catch {
      set ::Document::docMap($docID) $::Document::lastDocument($docType)
    }]} {
      puts stderr $::errorInfo
    } else {
      puts stderr Done
    }
  }
  
  proc replayCommand {docID tag args} {
    addPending \
        [concat [list ::Document::prehookReplayCommand $docID $tag] $args] \
        [concat [list ::Document::executeReplayCommand $docID $tag] $args] \
        [concat [list ::Document::posthookReplayCommand $docID $tag] $args]
  }

  proc replaySet {docID tag value} {
    addPending \
        [list ::Document::prehookReplaySet $docID $tag $value] \
        [list ::Document::executeReplaySet $docID $tag $value] \
        [list ::Document::posthookReplaySet $docID $tag $value]
  }

  proc replayUpdateLastDocument {docID docType} {
    addPending \
        [list ::Document::executeReplayUpdateLastDocument $docID $docType] \
        [list ::Document::posthookReplayUpdateLastDocument $docID $docType]
  }
  
  proc hook {name arguments body} {
    uplevel [list proc $name $arguments] "{log \"hook $name\"; $body; log \"hook done $name\"}"
  }

  ::Utilities::Model replayEnabledModel
}

#----------------------------------------------
# Action   !  Prehook prefix ! Posthook prefix !
# ---------------------------------------------
# Command  !  "pre_"         ! ""              !
# Set      !  "preset_"      ! "set_"          !
# Document !  no hook        ! "new_"          !
#----------------------------------------------
