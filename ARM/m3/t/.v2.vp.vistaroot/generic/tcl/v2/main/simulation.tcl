namespace eval ::v2 {}

proc ::v2::get_ui_simulation_document {} {
  foreach doc_id [::Document::getDocumentIDs] {
    if {[string equal [::Document::getDocumentType $doc_id] DocumentTypeSimulationGUI]} { 
      return $doc_id
    }
  }
  return ""
}

proc ::v2::attach_to_simulation_session {pid simulation_invocation_id} {
  set ui_simulation_doc [::v2::get_ui_simulation_document]
  if {$ui_simulation_doc == ""} {
    error "Unable to attach to simulation session"
  }
  ::Document::runCommand $ui_simulation_doc ResimulateCommand "AttachMode" "attach" "AttachingPid" $pid "AttachingSimulationInvocationID" $simulation_invocation_id
  return $::v2::last_gdb_server_port
}

proc ::v2::reuse_gdb_for_simulation_session {simulation_invocation_id} {
  set ui_simulation_doc [::v2::get_ui_simulation_document]
  if {$ui_simulation_doc == ""} {
    error "Unable to attach to simulation session"
  }
  ::Document::runCommand $ui_simulation_doc ResimulateCommand "AttachMode" "reuse" "AttachingSimulationInvocationID" $simulation_invocation_id
  return $::v2::last_gdb_server_port
}
