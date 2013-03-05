namespace eval ::v2::ui::simulation_control {
  class Notebook {
    inherit ::UI::Notebook
    
    constructor {_document args} {
      ::UI::Notebook::constructor $_document
    } {
      eval itk_initialize $args
      
      create_tabs
      set_binding
      create_popup_menu "::v2::ui::simulation_control::PopupMenu"
    }
    
    public method show {} {
      pack $itk_component(tabs) -side top -fill both -expand 1 -anchor nw
    }
  
    private method create_tabs {} {
      add_tab ::v2::ui::processes::ProcessesView processesview Processes \
          [$document create_tcl_sub_document DocumentTypeProcessesView]
      add_tab ::v2::ui::breakpoints::BreakpointsView breakpointsview Breakpoints \
          [$document create_tcl_sub_document DocumentTypeBreakpointsView]
      add_tab ::v2::ui::watches::WatchesView watchesview Watch [$document create_tcl_sub_document DocumentTypeWatchesView]
      add_tab ::v2::ui::memory::MemoryView memoryview Memory [$document create_tcl_sub_document DocumentTypeMemoryView]
      if {[info exists ::env(VISTA_WITH_CATAPULT)] && $::env(VISTA_WITH_CATAPULT) != ""} {
        add_tab ::v2::ui::catapult::CatapultView catapultview "FIFO Debugging" \
            [$document create_tcl_sub_document DocumentTypeCatapultView]
      }
    }

    protected method tab_select_command {args} {
      chain

      set select_index [$itk_component(tabs) index select]
      set current_tab_name [lindex [$itk_component(tabs) tab names] $select_index] 
      $itk_component($current_tab_name) focus_in table
    }
  }
}

namespace eval ::UI {
  ::itcl::class v2/ui/simulation_control/Notebook/DocumentLinker {
    inherit UI/Notebook/DocumentLinker
  }

  v2/ui/simulation_control/Notebook/DocumentLinker v2/ui/simulation_control/Notebook/DocumentLinkerObject
}
