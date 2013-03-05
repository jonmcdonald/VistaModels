Namespace eval ::Utilities {
  doc objectNew {
    {Description "Creates a new instance of the itcl object."}
    {Arguments {
      {className "Name of the object class."}
      {args "Constructor arguments."}
    }}
    {Results "Pointer to the object."}
    {Comments
      "When no longer required, the object should be deleted using 'delete object' construction."
    }
    {Example {}}
  }
  
  doc newLocal {
    {Description "Creates a new, local instance of the itcl object."}
    {Arguments {
      {className "Name of the object class."}
      {args "Constructor arguments."}
    }}
    {Results "Pointer to the object."}
    {Comments
      "The object should not be deleted. It will be deleted when the caller exits from the calling frame."
    }
    {Example {}}
  }
  
  Proc objectNew { className args } {
    set v [ uplevel [list $className [set className]_[createUniqueIdentifier] ] $args ]
    return [ uplevel namespace orig $v]
  }
  
  Proc newLocal {className args} {
    set obj [ uplevel [list ::Utilities::objectNew $className] $args ]
    uplevel [ list ::Utilities::switchToLocal $obj ]
    return $obj
  }
  
  doc switchToLocal {
    {Description "Converts a regular object pointer to the local one."}
    {Arguments {
      {className "Name of the object class."}
      {args "Constructor arguments."}
    }}
    {Results "Pointer to the object."}
    {Comments
      "After conversion, the object will be deleted when the caller exits from the calling frame."
    }
    {Example {}}
  }
  
  Proc switchToLocal { obj } {
    set varName __delete_object[createUniqueIdentifier]
    uplevel [list set $varName 0]
    uplevel [list trace variable $varName u [list [namespace current]::_deleteObjectCallback $obj]]
    return $obj
  }
  
  proc _deleteObjectCallback {obj args} {
    if {$obj == ""} {
      return
    }
    if {[find objects $obj] != {}} {
      delete object $obj
    }
  }
  
  proc tkObjectNewInit { className args } {
    uplevel [list ::Utilities::basicObjectNewInit $className "."] $args
  }

  proc objectNewInit { className args } {
    uplevel [list ::Utilities::basicObjectNewInit $className ""] $args
  }
  proc basicObjectNewInit { className prefix args } {
    append prefix \#auto
    set v [ uplevel [list $className $prefix] $args ]
    set obj [ uplevel namespace orig $v]
    if {[$obj info function postInit -protection] == "public"} {
      eval {$obj postInit} $args
    }
    return $obj
  }
  
  proc objectDelete { object } {
    if {[find objects $object] != {}}  {
      delete object $object
    }
  }
  
  doc objectExists {
    {Description "Checks whether the object exists."}
    {Arguments {
      {object "Pointer to the object to be checked."}
    }}
    {Results "(1|0)"}
    {Comments
      "Returns 1 if the object still exists."
    }
    {Example {}}
  }
  
  Proc objectExists { object } {
    if {$object == ""} {
      return 0
    }
    if {[catch {
      expr {([uplevel [list ::itcl::find object $object]] != "") ||
            ([uplevel [list ::itcl::find object [uplevel [list namespace origin $object]]]] != "")}
    } result]} {
      return 0
    }
    return $result
  }
  
  Proc classExists { class } {
    if {[catch {
      expr {([uplevel [list ::itcl::find class $class]] != "") ||
            ([uplevel [list ::itcl::find class [uplevel [list namespace origin $class]]]] != "")}
    } result]} {
      return 0
    }
    return $result
  }
  
  proc catchNotify { script } {
    set catchStatus [ catch { uplevel $script } result ]
    if {$catchStatus} {
      ::Message::addMessage "bug" $result $::errorInfo[::Utilities::dumpStack] $::errorCode
    }
    return $result
  }
  
  ;# PC porting
  set ::_un_count_ 0
  ;# PC Porting
  proc createUniqueIdentifier { { prefix "" } } {
    incr ::_un_count_
    return "$prefix[clock seconds]_$::_un_count_"
  }
  
  proc isProcExist { namespaceName procName {commandArgs ""} } {
    if {[info command [set namespaceName]::$procName] != ""} {
      return 1 ;# the arguments are not considered yet
    }
    return 0
  }
  
  ;# Syntax operator declaration follows.
  ;# Syntax form ---
  ;#  foreach_pair key_variable_name value_variable_name array_variable_name body
  ;# Semantic ---
  ;#  All semantic agreements of "foreach" are in progress
  ;# Example ---
  ;#  array set ar ""
  ;#  set ar(1) a; set ar(2) b
  ;#  foreach_pair key value ar {
  ;#    puts "$key + $value"
  ;#  }
  ;# Will output ---
  ;#  1 + a
  ;#  2 + b
  ;# (End of description)
  proc foreach_pair { keyVarName valueVarName arrayVarName body } {
    set keyVarExists [ uplevel "info exists $keyVarName" ]
    set valueVarExists [ uplevel "info exists $valueVarName" ]
    if { $keyVarExists } {
      set keyVarValue [ uplevel "set $keyVarName" ]
    } else {
      uplevel "set $keyVarName {}"
    }
    if { $valueVarExists } {
      set valueVarValue [ uplevel "set $valueVarName" ]
    } else {
      uplevel "set $valueVarName {}"
    }
    upvar $keyVarName keyVar
    upvar $valueVarName valueVar
    upvar $arrayVarName arrayVar
    foreach keyVar [array names arrayVar] {
      set valueVar $arrayVar($keyVar)
      uplevel "$body"
    }
    if { $keyVarExists } {
      uplevel "set $keyVarName $keyVarValue"
    } else {
      uplevel "unset $keyVarName"
    }
    if { $valueVarExists } {
      uplevel "set $valueVarName $valueVarValue"
    } else {
      uplevel "unset $valueVarName"
    }
  }
  
  proc getStack {{decrement 1}} {
    set level [expr [info level] -$decrement]
    set dump ""
    for {} {$level > 0} {incr level -1} {
      set infoLevel [info level $level]
      #	set fullProc [ uplevel \#$level {namespace current} ]::[namespace tail [lindex $infoLevel 0]]
      set fullProc [ uplevel \#$level [list namespace which [lindex $infoLevel 0]]]
      lappend dump "($level)$fullProc [lrange $infoLevel 1 end]"
    }
    return $dump
  }

  set dontDisplayErrors 0
  set printing_errors_now 0
  proc print_errors_callback {args} { 
    if {$::Utilities::printing_errors_now == "1"} {
      return
    }
    set ::Utilities::printing_errors_now 1
    if {[catch {
      if {$::Utilities::dontDisplayErrors == "1"} {
        return
      }
      if {$::errorInfo == ""} {
        return
      }
      if {![info exists ::env(UTL_TCL_TCLOBJECT_REPORT_ERRORS)]} {
        return
      }
      if {$::env(UTL_TCL_TCLOBJECT_REPORT_ERRORS) != 1} {
        return
      }
      puts "\n\nERROR = "
      puts $::errorInfo
      puts [::Utilities::dumpStack]
      set ::Utilities::printing_errors_now 0
    }]} {
      catch {set ::errorInfo ""}
      set ::Utilities::printing_errors_now 0
    }
  }
  
  proc findObjectsInNamespaces {startNamespace {namespacePattern *} {objectPattern *}} {
    set record ""
    if {[string match $namespacePattern $startNamespace]} {
      set objects [::List::ldeleteList [namespace inscope $startNamespace find objects $objectPattern] *::*]
      if {$objects != ""} {
        set record [list [list $startNamespace $objects]]
      } else {
        set record ""
      }
    }
    foreach ns [namespace children $startNamespace] {
      set found [findObjectsInNamespaces $ns $namespacePattern $objectPattern]
      set record [concat $record $found]
    }
    return $record
  }
  
  proc dumpStack {} {
    return [join [getStack 2] "\n"]
  }
  
  proc _evalStackFinallyAction {action args} {
    uplevel $action
  }
  
  proc addStackFinallyAction {action} {
    set varName _stackFinallyAction_[createUniqueIdentifier]
    uplevel [list set $varName 0]
    uplevel [list trace variable $varName u [list [namespace current]::_evalStackFinallyAction $action]]
  }

  proc findVariable {varName storeIn} {
    for {set level [expr {[info level] - 1}]} {$level >= 0} {incr level -1} {
      upvar \#$level $varName var
      if {[info exists var]} {
        upvar $storeIn value
        set value $var
        return 1
      }
    }
    return 0
  }
  #-------------------------------------------------------
  # safeUnset - Like "unset," but checks to see if the 
  # variable (or array) exists before attempting to delete it.
  #-------------------------------------------------------
  proc safeUnset args {
    foreach var $args {
      if {[uplevel [list info exists $var]]} {
        uplevel [list unset $var]
      }
    }
  }

  #-------------------------------------------------------
  # fpIncr - Like "incr," but allows for floating-point increments
  #-------------------------------------------------------
  proc fpIncr {var {increment 1}} {
    uplevel [list set $var [ uplevel [list expr [ uplevel set $var] + $increment] ]]
  }

  proc safeGet {varName {default_value ""}} {
    if {[uplevel [list info exists $varName]]} {
      return [uplevel [list set $varName]]
    } else {
      return $default_value
    }
  }

  proc doNotOverride {varName value} {
    if {![uplevel [list info exists $varName]]} {
      return [uplevel [list set $varName $value]]
    }
    return [uplevel [list set $varName]]
  }

  # proc ::itcl::parser::timeMethod {name arguments args} {
  #   if {[llength $args]} {
  #     set scr {
  #       if {![info exists timeOut]} {
  #         findVariable timeOut timeOut
  #       }
  #     }
  #     uplevel [list method $name $arguments "$scr\n[lindex $args 0]"]
  #   } else {
  #     uplevel [list method $name $arguments]
  #   }
  # }
  
  # proc ::timeProc {name arguments body} {
  #   set scr {
  #     if {![info exists timeOut]} {
  #       findVariable timeOut timeOut
  #     }
  #   }
  #   uplevel [list proc $name $arguments "$scr\n$body"]
  # }
  
  # set timeOut 0x7fffffff ;# default timeOut
  namespace export *

  proc tkInitialized {} {
    return [expr [llength [info commands toplevel]] != 0]
  }

  proc correct_interval {interval_ms} {
    if {$interval_ms < 0} {
      return 1
    }
    return $interval_ms
  }

  proc eval_when {condition script {break_condition ""} {interval_ms 1}} {
    if {$break_condition != ""} {
      set catchStatus [catch {
        expr [uplevel \#0 $break_condition] != 0
      } result]
      if {$catchStatus} {
        return
      }
      if {$result} {
        return
      }
    }
    set catchStatus [catch {
      expr [uplevel \#0 $condition] != 0
    } result]
    if {$catchStatus} {
      return
    }
    if {$result} {
      if {[catch {uplevel \#0 $script} msg]} {
        puts stderr $msg
      }
      return
    }
    set interval_ms [correct_interval $interval_ms]
    after $interval_ms [list [namespace current]::eval_when $condition $script $break_condition [expr 2 * $interval_ms]]
  }

  proc TRY_EVAL {script {final {}}} {
    NOT_SUPPORTED_ON_PURE_TCL
    uplevel [list try_eval $script { error $errorResult $errorCode $errorInfo } [list catch $final]]
  }
  namespace export TRY_EVAL

  proc eval_list_of_scripts {list_of_scripts} {
    foreach script $list_of_scripts {
      catch {
        ::uplevel \#0 $script
      }
    }
    return ""
  }
  
}
