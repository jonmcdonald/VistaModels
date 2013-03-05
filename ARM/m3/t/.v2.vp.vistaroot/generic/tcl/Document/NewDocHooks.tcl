namespace eval ::Document::NewDocHooks {
  proc new_doc {docID args} {
    ::Document::logNewDocument $docID
    ::Document::logAllVariableValues $docID
  }
}
