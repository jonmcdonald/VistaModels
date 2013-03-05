namespace eval ::v2::ui::profilingwindow {
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
      add_menu_item $itk_component(menu) RefreshCommand command -label "Refresh"
      addSeparator $itk_component(menu)
      add_menu_item $itk_component(menu) AddToPlotCommand command -label "Add to Plot"
      add_menu_item $itk_component(menu) ClearPlotCommand command -label "Clear All From Plot"
      
    }
  }
}
