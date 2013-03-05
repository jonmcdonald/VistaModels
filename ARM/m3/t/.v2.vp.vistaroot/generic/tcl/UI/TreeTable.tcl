
namespace eval ::UI {
  class TreeTable {
    inherit ::UI::TreeTableBase
    
    constructor {_document args} {
      ::UI::TreeTableBase::constructor $_document
    } {
      eval itk_initialize $args
      
      create_vertical_scrollbar
    }
    
    protected method set_binding {} {
      chain
      
      ::UI::mousewheel_binding $itk_component(table)
      bind $itk_interior <FocusIn> +[code $this update_current_tree_table]
    }

    private method update_current_tree_table {args} {
      catch {$document set_variable_value CurrentTreeTable $itk_interior}
    }

    private method create_vertical_scrollbar {} {
      ### Vertical scrolling
      itk_component add vscroll {
        scrollbar $itk_interior.vsb -orient vertical -width 12 -highlightthickness 0 -takefocus 0 \
            -command [code $itk_component(table) yview]
      }
      $itk_component(table) configure -yscrollcommand [code $itk_component(vscroll) set]
      
      grid $itk_component(vscroll) -column 2 -row 1 -sticky ns
      grid columnconfigure $itk_interior 2 -weight 0
    }
  }
}
namespace eval ::UI {
  ::itcl::class UI/TreeTable/DocumentLinker {
    inherit UI/TreeTableBase/DocumentLinker
  }

  UI/TreeTable/DocumentLinker UI/TreeTable/DocumentLinkerObject
}
