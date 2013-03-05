namespace eval ::v2::ui::profilingwindow {
  class Notebook {
    inherit ::UI::Notebook
    
    constructor {_document args} {
      ::UI::Notebook::constructor $_document
    } {
      eval itk_initialize $args
      
      create_tabs
      set_binding
      create_popup_menu "::v2::ui::profilingwindow::PopupMenu"
    }
    
    public method show {} {
      pack $itk_component(tabs) -side top -fill both -expand 1 -anchor nw
    }
  
    private method create_tabs {} {
      add_tab ::v2::ui::profilingwindow::TableView tableview  "Memory Statistics Table"\
          $document
      add_tab ::v2::ui::profilingwindow::PlotView plotview "Memory Statistics Plot" \
          [$document create_tcl_sub_document DocumentTypePlot]
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
  ::itcl::class v2/ui/profilingwindow/Notebook/DocumentLinker {
    inherit UI/Notebook/DocumentLinker
  }

  v2/ui/profilingwindow/Notebook/DocumentLinker v2/ui/profilingwindow/Notebook/DocumentLinkerObject
}


