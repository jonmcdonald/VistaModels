namespace eval ::v2::ui::tlmwindow {
  class PopupMenu {
    inherit  ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    public method fill_menu {} {
      
    }
    public method update_menu {} {
      $itk_component(menu) delete 0 end
      add_menu_item $itk_component(menu) ForceRefreshCommand command -label "Refresh"
      addSeparator $itk_component(menu)
      add_menu_item $itk_component(menu) IsFilterSet radiobutton -value 1 -label "Use Filter"
      add_menu_item $itk_component(menu) IsFilterSet radiobutton -value 0 -label "View All"
      addSeparator $itk_component(menu)
      add_menu_item $itk_component(menu) HidePortsCommand command -label "Hide Selected Ports ..."
      add_menu_item $itk_component(menu) HideMethodsCommand command -label "Hide Selected Methods ..."
      add_menu_item $itk_component(menu) ShowOnlySelectedPortsCommand command -label "Show Only Selected Ports ..."
      add_menu_item $itk_component(menu) ShowOnlySelectedMethodsCommand command -label "Show Only Selected Methods ..."
      addSeparator $itk_component(menu)
      add_menu_item $itk_component(menu) EditFilterCommand command -label "Edit Filter ..."
    }
  }
}
