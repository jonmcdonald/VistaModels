# sccsid = "%Z%sccs get -r%I% %P%"

namespace eval ::FunctionDoc {

  proc isAlias {procName} {
    return [expr {[info exists ::doc($procName)] && [readLink $::doc($procName) linkContent]}]
  }

  proc readLink {content linkContent} {
    upvar $linkContent linkData
    return [regexp {^=>(.*)$} $content all linkData]
  }
  
  proc getCanonicalName {fullProcName} {
    if {[info exists ::doc($fullProcName)]} {
      set cont $::doc($fullProcName)
      if {[readLink $::doc($fullProcName) linkContent]} {
        return [getCanonicalName $linkContent]
      }
    }
    return $fullProcName
  }

  proc getVariable {fullProcName} {
    set canonicalName [getCanonicalName $fullProcName]
    return ::doc($canonicalName)
  }

  proc getDocumentedProcedures {{pattern *}} {
    return [array names ::doc $pattern]
  }

  proc getDocumentedProceduresAsArray {pArray {pattern *}} {
    upvar $pArray varArray
    set procList [array names ::doc $pattern]
    foreach varName $procList {
      set canonicalName [getCanonicalName $varName]
      if {[string compare $canonicalName $varName]} {
        lappend varArray($canonicalName) $varName
      } else {
        if {![info exist varArray($canonicalName)]} {
          set varArray($canonicalName) {}
        }
      }
    }
    return $procList
  }

  proc getDocumentation {fullProcName} {
    set varName [getVariable $fullProcName]
    if {[info exists $varName]} {
      return [set $varName]
    } else {
      return ""
    }
  }
  
  proc getKeys {fullProcName {key ""}} {
    set varName [getVariable $fullProcName]
    return [::Utilities::KeyList:keys [set $varName] $key]
  }
  
  proc getValue {fullProcName key} {
    return [::Utilities::KeyList:getIfExist [set [getVariable $fullProcName]] $key]
  }
  
  proc getDescriptionSection {fullProcName} {
    return [getValue $fullProcName Description]
  }
  
  proc getArgumentsSection {fullProcName {argumentPath ""}} {
    if {$argumentPath != ""} {
      set argumentPath .$argumentPath
    }
    return [getValue $fullProcName Arguments$argumentPath]
  }
  
  proc getArguments {fullProcName {argumentPath ""}} {
    if {$argumentPath != ""} {
      set argumentPath .$argumentPath
    }
    return [getKeys $fullProcName Arguments$argumentPath]
  }
  
  proc getArgumentDescription {fullProcName {argumentPath ""}} {
    if {$argumentPath != ""} {
      set argumentPath .$argumentPath
    }
    return [getValue $fullProcName Arguments$argumentPath]
  }
  
  
  proc getResultSection {fullProcName} {
    return [getValue $fullProcName Results]
  }
  
  proc getCommentsSection {fullProcName} {
    return [getValue $fullProcName Comments]
  }
  
  proc getExampleSection {fullProcName} {
    return [getValue $fullProcName Example]
  }
  
  proc truncate_string {str {max 10}} {
    set length [string length $str]
    if {$length > $max} {
      set str [string range $str 0 $max]...
    }
    return $str
  }

  proc print_procedures_to_file {filename {pattern *}} {
    file mkdir [file dirname $filename]
    set f [open $filename w]
    catch {
      foreach p [lsort [uplevel [list info vars $pattern]]] {
        catch {
          if {[array exists $p]} {
            puts -nonewline $f "ARRAY $p"
            if {[catch {puts $f " [truncate_string [array names $p]]"}]} {
              puts $f ""
          }
          } else {
            puts -nonewline $f "GLOBAL $p"
            if {[catch {puts $f " [truncate_string [set $value]]"}]} {
              puts $f ""
            }
          }
        }
      }
      
      foreach p [lsort [uplevel [list info commands $pattern]]] {
        catch {
          set def [getFullProcedureDefinition $p 1]
          if {[string length $def]} {
            puts $f $def\n
          }
        }
      }
    }
    close $f
  }


  proc ::__print_all_functions_internal__ {directory namespace_name} {
    if {$namespace_name == ""} {
      set namespace_name ::
    }
    set filename [regsub -all :: [set namespace_name].tcl %%]
    set filename [regsub ^%% $filename ""]
    
    if {$filename == ".tcl"} {
      set filename "%%.tcl"
    }
    ::FunctionDoc::print_procedures_to_file [set directory]/$filename [set namespace_name]::*
    foreach ns [namespace children $namespace_name] {
      ::__print_all_functions_internal__ $directory $ns
    }
  }

  proc print_all {directory {namespace_name ""}} {
    ::__print_all_functions_internal__  $directory $namespace_name
  }

  proc getFullProcedureDefinition {procName {even_if_not_proc 0}} {
    set procName [uplevel namespace which $procName]
    set ns [namespace qualifiers $procName]
    if {[namespace inscope ::$ns [list info proc [namespace tail $procName]]]==""} {
      if {$even_if_not_proc == 0} {
        return ""
      }
      set is_tk_window 0
      catch {
        set is_tk_window [winfo exists [regsub {^::} $procName ""]]
        
      }
      if {$is_tk_window} {
        return ""
      }
      return "native $procName"
    }
    return "proc $procName [list [getFullInfoArgs $procName]] \{[info body $procName]\}"
  }
  
  proc getFullInfoArgs {procName} {
    set procName [uplevel namespace which $procName]
    set argList [info args $procName]
    set fullArgList ""
    foreach arg $argList {
      if {[info default $procName $arg default]} {
        lappend fullArgList [list $arg $default]
      } else {
        lappend fullArgList $arg
      }
    }
    return $fullArgList
  }
  
  proc getMandatoryAndOptionalArgs {procName} {
    set procName [uplevel namespace which $procName]
    set argList [info args $procName]
    set optionalArgs {}
    set optionalDefaults {}
    set mandatoryArgs {}
    set count 0
    set len [llength $argList]
    foreach arg $argList {
      incr count
      if {[info default $procName $arg default]} {
        lappend optionalArgs $arg
        lappend optionalDefaults $default
      } else {
        if {"$arg" == "args" && $count == $len} {
          lappend optionalArgs args
          lappend optionalDefaults ""
        } else {
          lappend mandatoryArgs $arg
        }
      }
    }
    return [list $mandatoryArgs $optionalArgs $optionalDefaults]
  }

  namespace export *
  
}

