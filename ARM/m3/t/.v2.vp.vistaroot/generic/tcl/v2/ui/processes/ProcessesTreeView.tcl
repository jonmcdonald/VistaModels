namespace eval ::v2::ui::processes {
  class ProcessesTreeView {
    inherit ::UI::TreeTable
    
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      configure -withtooltip 1
      eval itk_initialize $args
      add_columns

      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior CurrentSelection 
      
      ::UI::auto_trace_with_init variable [$document get_variable_name FlatProcessTree] \
          w $itk_interior [::itcl::code $this set_flat]
    }

    private method set_flat {args} {
      set flat [$document get_variable_value FlatProcessTree]
      $itk_component(table) configure -flat $flat -flatname $flat
      if {!$flat} {
        open_tree 0 3
      }
    }

    protected method on_double_click {} {
      catch {
        set current [$itk_component(table) index current]
        
        if {[$itk_component(table) entry cget $current -button] == 1 && \
                [$itk_component(table) entry isopen $current] == 0} {
          $itk_component(table) open $current
        }
      } 
      $document run_command SwitchToProcessCommand
    }

    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::PopupMenu $itk_interior.popup_menu $document
      }
    }

    private method add_columns {} {
      set bgColor [$itk_component(table) cget -background]
      $itk_component(table) column insert 1 "Path" -justify left -titlebackground $bgColor
      $itk_component(table) column configure treeView -title "Process"
    }

    private method open_tree {node open_level} {
      if {$open_level < 1} {
        return
      }
      $document run_command OpenNodeCommand NodeArgument $node
      foreach child [$itk_component(table) entry children $node] {
        if {[$itk_component(table) entry ishidden $child] == 0} {
          open_tree $child [expr {$open_level - 1}]
        }
      }
    }
    protected method update_gui/selectedNodeIDs {}
  }
    
}

body ::v2::ui::processes::ProcessesTreeView::update_gui/selectedNodeIDs {} {  
  chain

  set_variable_by_tabletag "Type" CurrentType
  set_variable_by_tabletag "File" CurrentFile
  set_variable_by_tabletag "Line" CurrentLine
  set_variable_by_tabletag "Kind" CurrentKind
}

namespace eval ::UI {
  ::itcl::class v2/ui/processes/ProcessesTreeView/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/processes/ProcessesTreeView/DocumentLinker v2/ui/processes/ProcessesTreeView/DocumentLinkerObject
}
