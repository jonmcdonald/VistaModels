namespace eval ::v2::ui::mainwindow {
  class CreateTopButtonMenu {
    usual CreateTopButtonMenu {}
    inherit ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }
    
    public method fill_menu {} {
       add_menu_item $itk_component(menu) OpenScMainFileDialogCommand \
           command -label "New sc_main..."
      add_menu_item $itk_component(menu) OpenClockDialogCommand \
           command -label "Add Clock..."
      add_menu_item $itk_component(menu) OpenTopDialogCommand \
           command -label "Add sc_module/s..."
    }
  }
}
