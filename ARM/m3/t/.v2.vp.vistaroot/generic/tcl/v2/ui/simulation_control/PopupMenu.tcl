namespace eval ::v2::ui::simulation_control {
  class PopupMenu {
    inherit  ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    destructor {}
    
    protected method fill_menu {} {
    }
  }
}
