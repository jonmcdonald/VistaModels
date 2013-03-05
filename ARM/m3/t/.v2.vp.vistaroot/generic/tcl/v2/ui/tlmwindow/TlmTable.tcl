namespace eval ::v2::ui::tlmwindow {
  class TlmTable {
    inherit ::UI::TableWidget

    constructor {_document args} {
      ::UI::TableWidget::constructor $_document
    } {
      eval itk_initialize $args
      
      add_columns

      $itk_component(table) configure -tree [$document get_variable_name Tree] -flat 0
      set [$document get_variable_name Tree] $itk_component(table)
      
      attach $itk_interior CurrentSelection
         
      $document run_command OpenNodeCommand NodeArgument 0
    }

    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::tlmwindow::PopupMenu $itk_interior.popup_menu $document
      }
    }

    private method add_columns {} {
      set bgColor [$itk_component(table) cget -background]
      $itk_component(table) column insert 0 Time -justify right -titlebackground $bgColor
      $itk_component(table) column insert 1 Port -text "Port" \
          -justify left -titlebackground $bgColor
      $itk_component(table) column insert 2 "Method" -justify left \
          -titlebackground $bgColor
      if {[info exists ::env(TLM_TABLE_DEBUG)] && $::env(TLM_TABLE_DEBUG)} { 
        $itk_component(table) column insert 0 Position \
            -justify right -titlebackground $bgColor
      }
      $itk_component(table) column configure treeView -titlebackground $bgColor 

    }
  }
}

namespace eval ::UI {
  ::itcl::class v2/ui/tlmwindow/TlmTable/DocumentLinker {
    inherit UI/TableWidget/DocumentLinker
  }
  v2/ui/tlmwindow/TlmTable/DocumentLinker v2/ui/tlmwindow/TlmTable/DocumentLinkerObject
}
