namespace eval ::Document {
  proc getLogHandle {} {
    variable replayLogHandle
    if {[info exists replayLogHandle]} {
      return $replayLogHandle
    }
    variable replayLog
    if {![info exists replayLog]} {
      return ""
    }
    set replayLogHandle [open $replayLog "a"]
    return $replayLogHandle
  }

  proc log {value} {
    set h [getLogHandle]
    if {$h != ""} {
      puts $h $value
      flush $h
    }
  }

  proc logVariableValue {docID tag} {
    if {![::Document::isModelName $docID $tag]} {
      return
    }
    log [list value "[::Document::getDocumentType $docID]::$tag" [set [::Document::getModelVariableName $docID $tag]]]
  }

  proc logAllVariableValues {docID} {
    set ifs [::Document::getInterfaceNames $docID]
    foreach tag $ifs {
      logVariableValue $docID $tag
    }
  }

  proc logCommand {docID tag args} {
    log [concat [list command "[::Document::getDocumentType $docID]::$tag"] $args]
  }

  proc logSetValue {docID tag value} {
    log [list set "[::Document::getDocumentType $docID]::$tag" $value]
  }

  proc logNewDocument {docID} {
    log [list new_doc [::Document::getDocumentType $docID]]
  }

  namespace export *
}
