#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::analysis::window {

  
  class Toolbar {
    inherit ::UI::Toolbar

    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30

      ### Buttons
      fill_toolbar

      eval itk_initialize $args

      ::UI::auto_trace_with_init variable [$document get_variable_name IsDirty] \
          w $itk_interior [code $this set_save_icon]
      
    }

#     public method update_browser_view_button {} {
#       set makeFlat [$document get_variable_value IsFlatTree]
#       if {$makeFlat == 0} {
#         set image [::UI::getimage design_view]
#       } else {
#         set image [::UI::getimage process_list]
#       }
#       $itk_component(toggle_tree_view) configure -image $image
#     }

    private method fill_toolbar {} {
      
      set buttons [frame [get_frame].buts -bg $itk_option(-background)]

      # show/hide panes
      addCheckButton $buttons browser_view "add_analysis_browser" 1 ShowDesignTree "Browser Pane"
      addCheckButton $buttons graph_view "add_graph" 1 ShowGraphsView "Graph Pane"
      addCheckButton $buttons report_view "add_report" 1  ShowReportView "Report Pane"
      addSeparator $buttons sep_views

      set itk_component(save_button) [addButton $buttons save "saveu" SaveCommand "Save analysis session"]

      addButton $buttons dupl "copy_window" DuplicateWindowCommand "Duplicate window"

      addSeparator $buttons sep1

#       set itk_component(toggle_tree_view) \
#         [$this addButton $buttons toggle_tree_view "design_view" ToggleBrowserViewCommand "Toggle tree/list view"]
      addButton $buttons refresh "refresh" RefreshCommand "Refresh"
      addSeparator $buttons sep_refresh
      addButton $buttons acquire "acquire_analysis" AddObjectsCommand "Add objects"
      #[addButton $buttons acquire_all "acquire_analysis_all" AddAllObjectsCommand "Add all objects"] configure -width 25
      [addButton $buttons remove_objects "analysis_remove" RemoveObjectsCommand "Remove objects"] configure -width 23
      [addButton $buttons remove_all_objects "analysis_remove_all" RemoveAllObjectsCommand "Remove all objects"] configure -width 25

      addSeparator $buttons sep2

      pack_left $buttons save dupl sep1
      pack_left $buttons browser_view graph_view report_view sep_views
      pack_left $buttons refresh sep_refresh
      pack_left $buttons acquire remove_objects remove_all_objects sep2

      
      set time_buttons [frame [get_frame].time_btns -bg $itk_option(-background)]
      
      label $time_buttons.l_interval_time -text "Sampling Interval:"

      set f $time_buttons.f
      frame $f
      pack $time_buttons.l_interval_time $f -padx 3 -side left
      $f configure -bd 1 -relief sunken
#      label $f.e
      ::UI::FlushEntry $f.e -background white -width 15

      set fb [frame $f.f]
      button $fb.b_increase_interval
      button $fb.b_reduce_interval
      attach $fb.b_increase_interval IncreaseIntervalCommand
      attach $fb.b_reduce_interval ReduceIntervalCommand
      $f.e configure -borderwidth 0 -relief flat -highlightthickness 0 -width 15
      $fb.b_increase_interval con -padx 0 -bd 1 -pady 0 -highlightthickness 0 -image [::UI::getimage small_up]
      $fb.b_reduce_interval con -pady 0 -padx 0 -bd 1 -pady 0 -highlightthickness 0 -image [::UI::getimage small_down]
      pack $f.e -side left 
      pack $fb  -side left -fill both
      pack $fb.b_increase_interval $fb.b_reduce_interval -side top

      
      attach $f.e ViewIntervalTimeStr
      
      pack $f -side left -anchor w -padx 3


      addButton $time_buttons zoom_in "zoom_in" ZoomInCommand "Zoom In"
      addButton $time_buttons zoom_out "zoom_out" ZoomOutCommand "Zoom Out"
      addButton $time_buttons zoom_full "zoom_full" FullZoomCommand "Full Zoom"
      addButton $time_buttons zoom_prev "zoom_prev" PrevZoomCommand "Previous Zoom"
      addSeparator $time_buttons zoom_sep
      addButton $time_buttons sync_time "sync_time" SyncTimeCommand "Sync Views"
      addSeparator $time_buttons sync_sep
      pack_left $time_buttons zoom_in zoom_out zoom_full zoom_prev zoom_sep sync_time sync_sep
      
      itk_component add l_start_time {
        label $time_buttons.l_start_time -text "Start:"
      } {}
      
      itk_component add start_time {
        ::UI::FlushEntry $time_buttons.start_time -background white -width 15
      } {}
      attach $itk_component(start_time) ViewStartTimeStr
      
      ;#itk_component add l_time {
      ;#label $time_buttons.l_time -text "Locator:"
      ;#} {}
      
      ;#itk_component add locator_time {
      ;#::UI::FlushEntry $time_buttons.locator_fr.locator_time -background white -width 15
      ;#} {}
      ;#attach $itk_component(locator_time) LocatorTimeStr
      ;#pack $itk_component(locator_time) -padx 1 -pady 1 ;# to see the red border frame
      
      itk_component add l_end_time {
        label $time_buttons.l_end_time -text "End:"
      } {}
      
      itk_component add end_time {
        ::UI::FlushEntry $time_buttons.end_time -background white -width 15
      } {}
      attach $itk_component(end_time) ViewEndTimeStr
      
      bind [$itk_component(start_time) component entry] [list <Control-c> <Control-C>] [$document run_command CopyCommand]
      ;#bind [$itk_component(locator_time) component entry] [list <Control-c> <Control-C>] [$document run_command CopyCommand]
      bind [$itk_component(end_time) component entry] [list <Control-c> <Control-C>] [$document run_command CopyCommand]

      label $time_buttons.l_runtime -text "Runtime:"
      itk_component add runtime {
        label $time_buttons.runtime
      } {}
      attach $itk_component(runtime) TotalRuntimeStr

      pack \
          $itk_component(l_start_time) $itk_component(start_time) \
          $itk_component(l_end_time) $itk_component(end_time) \
          $time_buttons.l_runtime $itk_component(runtime) \
          -side left -anchor w -padx 3

      addSeparator $time_buttons scroll_sep

      [addButton $time_buttons scroll_left_end "left_end" "" "Scroll to 0"] configure -command [code $this scroll left_end]
      [addButton $time_buttons scroll_left_fast "left_fast" "" "Scroll 20% left"] configure -command [code $this scroll left_fast]
      [addButton $time_buttons scroll_left "left" "" "Scroll 10% left"] configure -command [code $this scroll left]
      [addButton $time_buttons scroll_right "right" "" "Scroll 10% right"] configure -command [code $this scroll right]
      [addButton $time_buttons scroll_right_fast "right_fast" "" "Scroll 20% right"] configure -command [code $this scroll right_fast]
      [addButton $time_buttons scroll_right_end "right_end" "" "Scroll to end"] configure -command [code $this scroll right_end]

      pack_left $time_buttons scroll_sep scroll_left_end scroll_left_fast scroll_left scroll_right scroll_right_fast scroll_right_end
      
      pack $buttons -side left -anchor w
      pack $time_buttons -side right -anchor e
    }

    private method scroll {direction} {
      $document run_command ScrollCommand ScrollDirection $direction
    }

    private method set_save_icon {args} {
      if {[$document get_variable_value IsDirty] == 1} {
        set image [::UI::getimage save]
      } else {
        set image [::UI::getimage saveu]
      }
      $itk_component(save_button) configure -image $image
    }
 
  }
}
