#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::tlmwindow {
  
  class Toolbar {
    inherit ::UI::Toolbar
    
    private variable sim_buttons
    
    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30
    
      ### Buttons
      fill_toolbar

      eval itk_initialize $args
      
    }

    private method fill_toolbar {} {
      create_left
    }
    private method create_left {} {
      set buttons [frame [get_frame].buts -bg $itk_option(-background)]
      set sepCounter 1
      addButton $buttons refresh "refresh" ForceRefreshCommand "Refresh"
      addSeparator $buttons sep[incr sepCounter]
      pack_left $buttons refresh sep[set sepCounter]

#      addCheckButton $buttons filter_activated "filter" 1  IsFilterSet "Show All" "Use Filter"
      addBwidgetRadioButton $buttons filter_not_activated "filter" 1  IsFilterSet "" "Use Filter"
      addBwidgetRadioButton $buttons filter_activated "viewall" 0  IsFilterSet "" "View All"
      addButton $buttons edit_filter "tsv_edit_filter" EditFilterCommand "Edit Filter ..."
      addSeparator $buttons sep[incr sepCounter]
      pack_left $buttons filter_not_activated filter_activated edit_filter sep[set sepCounter]


      pack $buttons -side top -anchor w

    }



  }
}
