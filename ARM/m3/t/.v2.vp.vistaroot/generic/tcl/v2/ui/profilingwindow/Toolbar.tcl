#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::profilingwindow {

  variable delta_cycles_button
  
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


      #Refresh
      addButton $buttons refresh "refresh" RefreshCommand "Refresh"
      addSeparator $buttons sep1
      #View combobox
      label $buttons.view_label -text "Plot:"
      ::UI::BwidgetCombobox $buttons.view -editable 0 -width 30 
      set cb [$buttons.view component combobox]
      set modify_cmd [$cb cget -modifycmd]
      $cb configure -modifycmd "$modify_cmd; [code $document set_variable_value IsSortedByName 0]"
      
      attachToDocument $document $buttons.view ProfilingView ProfilingViewOptions ProfilingViewLevel
      #Add to plot
      addButton $buttons add_to_plot "add_to_plot" AddToPlotCommand "Add Process to Plot"
      #Delta cycles
      #add disable if needed !!!
      set ::v2::ui::profilingwindow::delta_cycles_button  [addCheckButton  $buttons delta_cycle "delta_cycle" 0 ShowDeltaCycles "View Delta Cycles"]
      addSeparator $buttons sep2
      #Zoom
      addButton $buttons zoom_in "zoom_in" ZoomInCommand "Zoom In"
      addButton $buttons zoom_out "zoom_out" ZoomOutCommand "Zoom Out"
      addButton $buttons zoom_prev "zoom_prev" ZoomPreviousCommand "Previous Zoom"
      addButton $buttons zoom_full "zoom_full" ZoomFullCommand "Full Zoom"
      #pack
      pack_left $buttons refresh sep1 add_to_plot
      pack $buttons.view_label -side left -anchor w -padx 10 
      pack_left $buttons  view delta_cycle sep2 zoom_in zoom_out zoom_full zoom_prev
      pack $buttons -side top -anchor w

    }
  }
}
