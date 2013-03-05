summit_begin_package v2:ui:workwindow

summit_package_require v2:ui:projects
summit_package_require UI:console

namespace eval ::v2::ui::workwindow {
  proc find_projects_workwindow {} {
    foreach doc_id [::Document::getDocumentIDs] {
      if {![string equal [::Document::getDocumentType $doc_id] DocumentTypeWorkWindow]} { 
        continue
      }
      set workWindowID [set [::Document::getModelVariableName $doc_id WorkWindowID]]
      if {$workWindowID == "Projects"} {
        return $doc_id
      }
    }
    return ""
  }

  proc get_Projects_tree_document {} {
    set doc_id [find_projects_workwindow]
    if {$doc_id == ""} {
      return ""
    }
    return [::Document::getSubdocument $doc_id DocumentTypeProjectsTree]
  }

  proc refresh_Projects_tree {} {
    catch {
      set doc_id [get_Projects_tree_document]
      if {$doc_id != ""} {
        ::Document::runCommand $doc_id UpdateTreeCommand
      }
    }
  }
}

summit_end_package
