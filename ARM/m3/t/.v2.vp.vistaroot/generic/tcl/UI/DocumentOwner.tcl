#tcl-mode
namespace eval ::UI {
  class DocumentOwner {
    inherit ::UI::DocumentUIBuilder
    
    constructor {_document} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
    }

    destructor {
      if {[catch { 
        if {[find objects $document] != {}} {
          delete object $document 
        }
      } msg]} {
        puts $msg
      }
    }
  }
}
