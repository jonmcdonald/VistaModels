namespace eval ::v2::ui::projects {
  class PopupMenu {
    inherit  ::v2::ui::PopupMenu
    
    constructor {_document args} {
      set sub_document_name DocumentTypeSimulationGUI
      chain $_document
    } {
      eval itk_initialize $args
    }
  }
}
