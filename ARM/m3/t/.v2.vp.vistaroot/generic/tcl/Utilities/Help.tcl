# sccsid = "%Z%sccs get -r%I% %P%"

namespace eval ::Help {
  
  proc isPattern {str} {
    return [regexp {[\{*?]|\[} $str all]
  }
  
  proc _generateSection {sectionName content} {
    set docStr ""
    if {$content != ""} {
      append docStr "\n$sectionName\n"
      append docStr "  $content\n"
    }
    return $docStr
  }
  proc getDisplayProcName {procName} {
    if {[namespace qualifiers $procName] == ""} {
      return [namespace tail $procName]
    }
    return $procName
  }
  
  proc _generateBreafDescriptions {pattern} {
    ::FunctionDoc::getDocumentedProceduresAsArray procArray $pattern
    set canonicalNames [array names procArray]
    set docStr ""
    foreach canonicalName $canonicalNames {
      append docStr "[getDisplayProcName $canonicalName] "
      set aliasList $procArray($canonicalName)
      if {[llength $aliasList]} {
        append docStr "( "
        foreach alias $aliasList {
          append docStr "[getDisplayProcName $alias] "
        }
        append docStr ")"
      }
      append docStr " - [::FunctionDoc::getDescriptionSection $canonicalName]\n"
    }
    return $docStr
  }
  
  
  namespace export *
}


procd {help h} {args} {
  set len [llength $args]
  if {$len == 0} {
    return [::Help::_generateBreafDescriptions *]
  }
  if {$len == 1} {
    set procName [lindex $args 0]
    if {[::Help::isPattern $procName]} {
      return [::Help::_generateBreafDescriptions $procName]
    }
    if {![catch { set fullProcName [uplevel [list namespace origin $procName]]}]} {
      set documentation ""
      foreach docName [list $procName [uplevel [list namespace which $procName]] $fullProcName] {
        set documentation [::FunctionDoc::getDocumentation $docName]
        if {$documentation != ""} {
          break
        }
      }
      if {$documentation != ""} {
        append docStr "Name\n"
        append docStr "   $procName - [::FunctionDoc::getDescriptionSection $docName]\n"
        append docStr "\nSynopsys\n"
        append docStr "   $procName { [::FunctionDoc::getFullInfoArgs $fullProcName] }\n"
        set arguments [::FunctionDoc::getArguments $docName]
        if {[llength $arguments]} {
          append docStr "\nArguments\n"
          foreach argument $arguments {
            append docStr "  $argument - [::FunctionDoc::getArgumentDescription $docName $argument]\n"
          }
        }
        append docStr [::Help::_generateSection "Return Value" [::FunctionDoc::getResultSection $docName]]
        append docStr [::Help::_generateSection "Description" [::FunctionDoc::getCommentsSection $docName]]
        append docStr [::Help::_generateSection "Example" [::FunctionDoc::getExampleSection $docName]]
        return $docStr
      }
    }
    error "Documentation of $procName not found" 
  }
  error [help help]
  
} {
  {Description "Find and display documentation for function"}
  {Arguments {
    {args  "pattern or functionName. Defaults to *"}
  }}
  {Results "If pattern is passed, prints out breaf descriptions of all the documented functions, 
              according with the specified pattern.
              If args is a function name, returns documentation of this function. 
              An error will generate, if the function is not documented"}
  {Comments ""}
  {Example
    "help - returns all the documented functions
       help ::Visual::* - returns all the documented functions from namespace ::Visual
       help next - returns documentation of command 'next'."
  }
}
