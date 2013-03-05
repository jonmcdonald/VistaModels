namespace eval ::v2::ui::mainwindow {
  class PopupMenu {
    inherit  ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    destructor {}
    
  }
}
