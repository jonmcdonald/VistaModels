namespace eval ::v2::ui::breakpoints {
  class PopupMenu {
    inherit  ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    destructor {
    }

    public method fill_menu {} {

      $itk_component(menu) insert end command -label "Set Breakpoint"
      attach_menu_item  $itk_component(menu) end  {DocumentTypeSimulationGUI AddBreakpointsCommand}
      
      $itk_component(menu) insert end command -label "Delete Breakpoints"
      attach_menu_item  $itk_component(menu) end  {DocumentTypeSimulationGUI DeleteBreakpointsCommand}
      
      $itk_component(menu) insert end command -label "Enable Breakpoint"
      attach_menu_item  $itk_component(menu) end  \
          {DocumentTypeSimulationGUI EnableBreakpointsCommand}

      $itk_component(menu) insert end command -label "Disable Breakpoint"
      attach_menu_item  $itk_component(menu) end  \
          {DocumentTypeSimulationGUI DisableBreakpointsCommand}
      
      $itk_component(menu) insert end command -label "Enable All Breakpoints"
      attach_menu_item  $itk_component(menu) end  \
          {DocumentTypeSimulationGUI EnableAllBreakpointsCommand}

      $itk_component(menu) insert end command -label "Disable All Breakpoints"
      attach_menu_item  $itk_component(menu) end  \
          {DocumentTypeSimulationGUI DisableAllBreakpointsCommand}
    }
  }
}
