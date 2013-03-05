namespace eval ::v2::ui::breakpoints {
  class BreakpointsView {
    inherit ::UI::TreeTable
    
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args
      
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)
      
      attach $itk_interior CurrentSelection 
      
      $document run_command OpenNodeCommand NodeArgument 0
    }
    
    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::PopupMenu $itk_interior.popup_menu $document
      }
    }
    protected method update_gui/selectedNodeIDs {}   
  }
}

body ::v2::ui::breakpoints::BreakpointsView::update_gui/selectedNodeIDs {} {
  chain
  
  set_variable_by_tabletag "Type" CurrentType
  set_variable_by_tabletag "File" CurrentFile
  set_variable_by_tabletag "Line" CurrentLine
  set_variable_by_tabletag "Kind" CurrentKind 
}

namespace eval ::UI {
  ::itcl::class v2/ui/breakpoints/BreakpointsView/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/breakpoints/BreakpointsView/DocumentLinker v2/ui/breakpoints/BreakpointsView/DocumentLinkerObject
}
