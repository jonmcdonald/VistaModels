namespace eval ::Document::VariableChangeHooks {
  namespace import -force ::Document::*
  proc saveVariableValues {docID} {
    variable variableValues
    if {[info exists variableValues]} {
      unset variableValues
    }
    set ifs [::Document::getInterfaceNames $docID]
    foreach tag $ifs {
      if {![::Document::isModelName $docID $tag]} {
        continue
      }
      set variableValues($tag) [set [::Document::getModelVariableName $docID $tag]]
    }
  }

  proc printChangedVariables {docID} {
    variable variableValues
    set ifs [::Document::getInterfaceNames $docID]
    foreach tag $ifs {
      if {![::Document::isModelName $docID $tag]} {
        continue
      }
      if {![info exists variableValues($tag)]} {
        ::Document::logVariableValue $docID $tag
        continue
      }
      if {$variableValues($tag) != [set [::Document::getModelVariableName $docID $tag]]} {
        ::Document::logVariableValue $docID $tag
      }
    }
  }
  
  # command posthook
  proc hook {docID tag args} {
    eval [list ::Document::logCommand $docID $tag] $args
    printChangedVariables $docID
  }

  # command prehook
  proc pre_hook {docID tag args} {
    saveVariableValues $docID
  }

  # set posthook
  proc set_hook {docID tag value} {
    ::Document::logSetValue $docID $tag $value
    printChangedVariables $docID
  }

  # set posthook
  proc preset_hook {docID tag value} {
    saveVariableValues $docID
  }

  add_hook_namespace [namespace current]

}
