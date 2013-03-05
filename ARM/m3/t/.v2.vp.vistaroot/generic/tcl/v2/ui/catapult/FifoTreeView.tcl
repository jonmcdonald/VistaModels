namespace eval ::v2::ui::catapult {
  class FifoTreeView {
    inherit ::UI::TreeTable
    
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
#      configure -withtooltip 1
      eval itk_initialize $args

      #add_columns
      
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior CurrentSelection 
      $document run_command OpenNodeCommand NodeArgument 0
    }


    public method update_title { title } {
      set bgColor [$itk_component(table) cget -background]
      $itk_component(table) column configure treeView -titlebackground $bgColor -text $title
    }

    # private method add_columns {} {
#       set bgColor [$itk_component(table) cget -background]
#       $itk_component(table) column insert 1 MaxSize -text "Maximum Size" -justify center -titlebackground $bgColor
#       $itk_component(table) column configure treeView -titlebackground $bgColor -text "FIFO Channel"
#     }

    protected method update_gui/selectedNodeIDs {}
    
  }
}
body ::v2::ui::catapult::FifoTreeView::update_gui/selectedNodeIDs {} {  
  chain

  set_variable_by_tabletag "Type" CurrentType
  set_variable_by_tabletag "File" CurrentFile
  set_variable_by_tabletag "Line" CurrentLine
  set_variable_by_tabletag "Kind" CurrentKind
}

namespace eval ::UI {
  ::itcl::class v2/ui/catapult/FifoTreeView/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/catapult/FifoTreeView/DocumentLinker v2/ui/catapult/FifoTreeView/DocumentLinkerObject
}
