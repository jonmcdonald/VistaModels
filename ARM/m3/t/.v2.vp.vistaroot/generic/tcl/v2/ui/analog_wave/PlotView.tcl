
namespace eval ::v2::ui::analog_wave {

  class PlotView {
    inherit ::UI::SWidget

    # markers:
    ;#private variable locator_marker
    private variable zoom_marker
    private variable point_marker
    ;#private variable start_zoom_point_marker
    private variable point_mark1
    private variable point_mark2
    ;#private variable text_mark1
    private variable text_mark2
    private variable delta_x_line
    private variable delta_x_text
    private variable delta_y_line
    private variable delta_y_text
    private variable rect_line_horizontal1
    private variable rect_line_horizontal2
    private variable rect_line_vertical1
    private variable rect_line_vertical2 
    private variable measure_start_point_physical {}
    private variable measure_start_point {}
    private variable zoom_start_point {}
    private variable zoom_start_point_physical {}
    private variable zoom_x_threshold 15
    private variable zoom_y_threshold 45
    private variable enable_y_zoom 0

    private variable graph_bg #efefef
    private variable plot_pady_top 15
    private variable plot_pady_bot 1
    private variable plot_padx_left 0
    private variable plot_padx_right 15
    private variable do_configure_var

    private variable using_default_ticks 0

    private variable source_fr


    public variable tick_resolver
    public variable value_formatter
    public variable time_formatter
    public variable default_tick_resolver
    public variable default_value_formatter
    public variable default_time_formatter

    constructor {_document title args} {
      ::UI::SWidget::constructor $_document 
    } {
      set default_value_formatter [code just_return_argument]
      set default_time_formatter [code just_return_argument]
      set default_tick_resolver [code just_return_empty_list]

      set value_formatter $default_value_formatter
      set time_formatter $default_time_formatter
      set tick_resolver $default_tick_resolver

      eval itk_initialize $args
      create_view $title
      show
    }

    public method get_highest_graph_point {} {
      return [expr $plot_pady_top + 3]
    }
    public method get_graph {} {
      return $itk_component(graph)
    }
    
    private method create_view {title} {

      itk_component add graph_fr {
        frame $itk_interior.graph_fr -bg $graph_bg
      } {}

      itk_component add graph {
        blt::graph $itk_component(graph_fr).graph -plotbackground $graph_bg \
            -plotborderwidth 1 -height 150 ;# minimum height
      } {}
      $itk_component(graph) grid on
      $itk_component(graph) crosshairs on
      $itk_component(graph) legend configure -hide 1
      $itk_component(graph) configure -leftmargin 80 -topmargin 1 -plotpadx [list $plot_padx_left $plot_padx_right] \
          -plotpady [list $plot_pady_top $plot_pady_bot] -background $graph_bg
      $itk_component(graph) yaxis configure -command [code $this default_format_y_ticks] -background $graph_bg -min 0
      $itk_component(graph) xaxis configure -command [code $this format_time_ticks] -background $graph_bg

      itk_component add ybar {
        scrollbar $itk_component(graph_fr).ybar -orient vertical -highlightthickness 0 \
            -width 12 -command "$itk_interior.graph_fr.graph axis view y" -elementborderwidth 2
      } {}
      
      set source_fr [frame $itk_component(graph).source_fr -bg $graph_bg]

      itk_component add source_title_icon {
        label $source_fr.source_title_icon -background $graph_bg
      } {}
      ::UI::Button/DocumentLinkerObject attach_button_image_to_data  $source_fr.source_title_icon $document :tag:SourceIcon

      itk_component add source_title {
        label $source_fr.source_title -background $graph_bg
      } {}
      attach $source_fr.source_title SourceTitle

      itk_component add title {
        label $itk_component(graph).title -text $title -background $graph_bg
      } {}

      itk_component add buttons {
        frame $itk_component(graph).buttons
      } {}

      itk_component add hide_me {
        button $itk_component(buttons).hide_me -image [::UI::getimage hide_analysis_plot_view] -width 14 -height 14 -bd 0 \
            -cursor hand2 -background $graph_bg -highlightbackground $graph_bg -activebackground $graph_bg
      } {}
      attach $itk_component(buttons).hide_me HideMe

      if {$enable_y_zoom} {
       itk_component add zoom_in_y {
         button $itk_component(buttons).zoom_in -image [::UI::getimage zoom_in_y] -width 14 -height 14 -bd 0 \
             -cursor hand2 -background $graph_bg -highlightbackground $graph_bg -activebackground $graph_bg
       } {}
       attach $itk_component(buttons).zoom_in ZoomInY

       itk_component add zoom_out_y {
         button $itk_component(buttons).zoom_out -image [::UI::getimage zoom_out_y] -width 14 -height 14 -bd 0 \
             -cursor hand2 -background $graph_bg -highlightbackground $graph_bg -activebackground $graph_bg
       } {}
       attach $itk_component(buttons).zoom_out ZoomOutY

       itk_component add auto_zoom_y {
         button $itk_component(buttons).auto_zoom -image [::UI::getimage zoom_full] -width 14 -height 14 -bd 0 \
             -cursor hand2 -background $graph_bg -highlightbackground $graph_bg -activebackground $graph_bg
       } {}
       attach $itk_component(buttons).auto_zoom AutoZoomY

        pack $itk_component(zoom_out_y) $itk_component(zoom_in_y) $itk_component(auto_zoom_y) -side bottom
      }

      pack $itk_component(hide_me) -side bottom
     
      $itk_component(graph) axis configure y -scrollcommand [itcl::code $this on_y_scroll]
      $itk_component(graph) axis configure x -scrollcommand [itcl::code $this on_x_scroll]

      $document set_variable_value BltplotWidget $itk_component(graph)
      set [$document get_variable_name WidgetName] $itk_interior ;# ????

      ## locator marker
      ;#set locator_marker [$itk_component(graph) marker create line]
      ;#$itk_component(graph) marker configure $locator_marker -outline red

      set zoom_marker [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $zoom_marker -dashes 3

      set point_marker [$itk_component(graph) marker create text -background {} -anchor n -padx 5 -pady 5]

      ;#set start_zoom_point_marker [$itk_component(graph) marker create text]
      ;#$itk_component(graph) marker configure $start_zoom_point_marker -anchor n -background {} -padx 5 -pady 10

      ;#::UI::auto_trace_with_init variable [$document get_variable_name LongLocatorTime] \
          ;#w $itk_interior [code $this update_locator]
      ;#::UI::auto_trace_with_init variable [$document get_variable_name LongViewStartTime] \
          ;#w $itk_interior [code $this update_locator]
      ;#::UI::auto_trace_with_init variable [$document get_variable_name LongViewEndTime] \
          ;#w $itk_interior [code $this update_locator]

      set point_mark1 [$itk_component(graph) marker create text]
      $itk_component(graph) marker configure $point_mark1 -text "+" -background {}
      set point_mark2 [$itk_component(graph) marker create text]
      $itk_component(graph) marker configure $point_mark2 -text "+" -background {}

      ;#set text_mark1 [$itk_component(graph) marker create text]
      ;#$itk_component(graph) marker configure $text_mark1 -anchor n -background {} -padx 5 -pady 10

      set text_mark2 [$itk_component(graph) marker create text]
      $itk_component(graph) marker configure $text_mark2 -anchor n -background {} -padx 5 -pady 10

      set delta_x_line [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $delta_x_line -dashes 5

      set delta_y_line [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $delta_y_line -dashes 5

      set delta_x_text [$itk_component(graph) marker create text]
      $itk_component(graph) marker configure $delta_x_text -anchor n -background {} -padx 5 -pady 10

      set delta_y_text [$itk_component(graph) marker create text]
      $itk_component(graph) marker configure $delta_y_text -anchor n -background {} -padx 5 -pady 10

      set rect_line_horizontal1 [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $rect_line_horizontal1 -dashes 5

      set rect_line_horizontal2 [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $rect_line_horizontal2 -dashes 5

      set rect_line_vertical1 [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $rect_line_vertical1 -dashes 5

      set rect_line_vertical2 [$itk_component(graph) marker create line]
      $itk_component(graph) marker configure $rect_line_vertical2 -dashes 5

      bind $itk_component(graph) <ButtonPress-1> "[itcl::code $this button1_press %x %y]"
      bind $itk_component(graph) <B1-Motion> "[itcl::code $this zoom_drag %x %y]"
      bind $itk_component(graph) <ButtonRelease-1> "[itcl::code $this zoom_end %x %y]"
      
      bind $itk_component(graph) <ButtonPress-3> "[itcl::code $this measure_start %x %y]"
      bind $itk_component(graph) <B3-Motion> "[itcl::code $this measure_drag %x %y]"
      bind $itk_component(graph) <ButtonRelease-3> "[itcl::code $this measure_end %x %y]"

      bind $itk_component(graph) <Configure> "[itcl::code $this graph_schedule_configure]"
      
      ::UI::auto_trace_with_init variable [::itcl::scope do_configure_var] \
          w $itk_interior [code $this graph_configure]
    }

    public method show {} {

      blt::table $itk_component(graph_fr) \
          0,0 $itk_component(graph) -fill both

#          0,1 $itk_component(ybar) -fill y -anchor n
      
      blt::table configure $itk_component(graph_fr) c1 -resize none
      if {[$document get_variable_value HasSourceInformation]} {
        pack $source_fr -side left -anchor nw -padx 90 -pady 0
      }
      pack $itk_component(source_title_icon) -side left -anchor nw -padx 2 -pady 0
      pack $itk_component(source_title) -side left -anchor nw -padx 2 -pady 0
      pack $itk_component(buttons) $itk_component(title) -side right -anchor ne -padx 5 -pady 0

      pack $itk_component(graph_fr) -side bottom -fill both -expand 1
    }

    public method set_graph_title {title} {
      $itk_component(graph) configure -title $title
    }

    public method hide_xaxis {val} {
      $itk_component(graph) xaxis configure -hide $val
      if {$val == 1} {
        $itk_component(graph) configure -bottommargin 1
      } else {
        $itk_component(graph) configure -bottommargin 0
      }
    }

    public method has_xaxis {} {
      return [expr [$itk_component(graph) xaxis cget -hide] == 0]
    }

    proc just_return_argument {value} {
      return $value
    }

    private method call_time_formatter {value} {
      return [eval $time_formatter [list $value]]
    }
    
    private method call_value_formatter {value} {
      return [eval $value_formatter [list $value]]
    }
    
    proc just_return_empty_list {args} {
      return {}
    }

    private method call_tick_resolver {} {
      return [eval $tick_resolver [list [$itk_component(graph) yaxis limits]]]
    }
    
    private method move_marker {the_marker coords args} {
      eval [list $itk_component(graph) marker configure $the_marker -coords $coords] $args
    }

    private method banish_line_marker {the_marker args} {
      eval [list move_marker $the_marker "-1000000000 -1000000000 -1000000000 -1000000000"] $args
    }

    private method banish_text_marker {the_marker args} {
      eval [list move_marker $the_marker "-1000000000 -1000000000"] $args
    }

    ;#private method update_locator {args} {
      ;#redraw_locator
    ;#}

    ;#private method redraw_locator {} {
    ;#set time [MATH_TO_DOUBLE [$document get_variable_value LongLocatorTime]]
    ;#move_marker $locator_marker [list $time -1000000000 $time 1000000000]
    ;#}

    private method clear_measure_markers {} {
      banish_text_marker $point_mark1
      banish_text_marker $point_mark2
      ;#banish_text_marker $text_mark1 -text ""
      banish_text_marker $text_mark2 -text ""
      banish_line_marker $delta_x_line
      banish_text_marker $delta_x_text
      banish_line_marker $delta_y_line
      banish_text_marker $delta_y_text
    }

    private method clear_zoom_markers {} {
      banish_line_marker $zoom_marker
      banish_text_marker $point_marker -text ""
      ;#banish_text_marker $start_zoom_point_marker -text ""
      banish_line_marker $rect_line_horizontal1
      banish_line_marker $rect_line_horizontal2
      banish_line_marker $rect_line_vertical1
      banish_line_marker $rect_line_vertical2
    }

    private method time_for_logical_point {xy} {
      return [MATH_FLOOR [lindex $xy 0]]
    }

    private method value_for_logical_point {xy} {
      return [lindex $xy 1]
    }

    private method time_string_for_logical_point {xy} {
      return [call_time_formatter [time_for_logical_point $xy]]
    }

    private method value_string_for_logical_point {xy} {
      return [call_value_formatter [value_for_logical_point $xy]]
    }

    public method point_values_text {xy} {
      set time_string [time_string_for_logical_point $xy]
      set value_string [value_string_for_logical_point $xy]
      if {$time_string != ""} {
        if {$value_string != ""} {
          return "$time_string, $value_string"
        } else {
          return "$time_string"
        }
      } elseif {$value_string != ""} {
        return "$value_string"
      } else {
        return ""
      }
    }

    public method x_point_value_text {xy} {
      return [time_string_for_logical_point $xy]
    }

    public method y_point_value_text {xy} {
      return [value_string_for_logical_point $xy]
    }

    public method button1_press {x y} {
      clear_measure_markers
      set zoom_start_point_physical [list $x $y]
      set zoom_start_point [$itk_component(graph) invtransform $x $y]
      ;#$document set_variable_value LongLocatorTime [time_for_logical_point $zoom_start_point]
      # add start zoom point marker with value
      ;#move_marker $start_zoom_point_marker $zoom_start_point -text [point_values_text $zoom_start_point]
      set zoom_start_point [fix_negative_time $zoom_start_point]
    }

    public method zoom_drag {x y} {
      if {$zoom_start_point == {}} {
        return
      }
      set drag_point [$itk_component(graph) invtransform $x $y]
      set drag_point [fix_negative_time $drag_point]

      set plot_width [$itk_component(graph) extents plotwidth]
      set plot_height [$itk_component(graph) extents plotheight]
      if {$x >= 150 && $x < $plot_width} {
        set marker_x $x
      } else {
        if {$x < 150} {
          set marker_x [expr $x + 50]
        } else {
          set marker_x [expr $x - 50]
        }
      }
      if {$y < [expr $plot_height -25] && $y >= 25} {
        set marker_y $y
      } else {
        if {$y < 25} {
          set marker_y [expr $y + 25]
        } else {
          set marker_y [expr $y - 25]
        }
      }
      set drag_marker_text_coords [$itk_component(graph) invtransform $marker_x $marker_y]
      
      set x_zoom_start_point [lindex $zoom_start_point_physical 0]
      set y_zoom_start_point [lindex $zoom_start_point_physical 1]
      set do_x_zoom [MATH_GT [MATH_ABS [MATH_MINUS $x $x_zoom_start_point]] $zoom_x_threshold]
      set do_y_zoom [MATH_GT [MATH_ABS [MATH_MINUS $y $y_zoom_start_point]] $zoom_y_threshold]
      set physical_x_delta [MATH_ABS [MATH_MINUS $x [lindex $zoom_start_point_physical 0]]]
      set physical_y_delta [MATH_ABS [MATH_MINUS $y [lindex $zoom_start_point_physical 1]]]
      set x1 [lindex $zoom_start_point 0]
      set y1 [lindex $zoom_start_point 1]
      set x2 [lindex $drag_point 0]
      set y2 [lindex $drag_point 1]
      

      if {$do_x_zoom} {
        if {$do_y_zoom} { ;# rectangle
          banish_line_marker $zoom_marker
          move_marker $rect_line_horizontal1 [list $x1 $y1 $x2 $y1]
          move_marker $rect_line_horizontal2 [list $x1 $y2 $x2 $y2]
          move_marker $rect_line_vertical1 [list $x1 $y1 $x1 $y2]
          move_marker $rect_line_vertical2 [list $x2 $y1 $x2 $y2]
          if {$y2 > $y1} {
            set point_marker_anchor s
          } else {
            set point_marker_anchor n
          }
          move_marker $point_marker $drag_marker_text_coords -text [point_values_text $drag_point] -anchor $point_marker_anchor
        } else {
          move_marker $zoom_marker [list $x1 $y2 $x2 $y2]
          banish_line_marker $rect_line_horizontal1
          banish_line_marker $rect_line_horizontal2
          banish_line_marker $rect_line_vertical1
          banish_line_marker $rect_line_vertical2
          if {[MATH_GT $physical_x_delta 100]} {
            set point_marker_anchor s
          } else {
            set point_marker_anchor n
          }
          move_marker $point_marker $drag_marker_text_coords -text [x_point_value_text $drag_point] -anchor $point_marker_anchor
        }
      } else {
        banish_line_marker $rect_line_horizontal1
        banish_line_marker $rect_line_horizontal2
        banish_line_marker $rect_line_vertical1
        banish_line_marker $rect_line_vertical2
        if {$do_y_zoom} {
          move_marker $zoom_marker [list $x2 $y1 $x2 $y2]
          if {$y2 > $y1} {
            set point_marker_anchor s
          } else {
            set point_marker_anchor n
          }
          move_marker $point_marker $drag_marker_text_coords -text [y_point_value_text $drag_point] -anchor $point_marker_anchor
        } else {
          banish_line_marker $zoom_marker
          banish_text_marker $point_marker -text ""
        }
      }
    }

    public method zoom_end {x y} {
      clear_zoom_markers
      if {$zoom_start_point == {}} {
        return
      }
      set zoom_end_point [$itk_component(graph) invtransform $x $y]
      set zoom_end_point [fix_negative_time $zoom_end_point]

      if {[MATH_GT [MATH_ABS [MATH_MINUS $x [lindex $zoom_start_point_physical 0]]] $zoom_x_threshold]} {
        $document run_command SetZoomCommand StartTimeArg [time_for_logical_point $zoom_start_point] EndTimeArg [time_for_logical_point $zoom_end_point]
      }
      if {$enable_y_zoom} {
        if {[MATH_GT [MATH_ABS [MATH_MINUS $y [lindex $zoom_start_point_physical 1]]] $zoom_y_threshold]} {
          $document set_variable_value YAxisBounds [list [lindex $zoom_start_point 1] [lindex $zoom_end_point 1]]
        }
      }
      set zoom_start_point {}
    }

    public method measure_start {x y} {
      clear_measure_markers
      set measure_start_point_physical [list $x $y]
      set measure_start_point [$itk_component(graph) invtransform $x $y]
      # draw point1
      ;#move_marker $text_mark1 $measure_start_point -text [point_values_text $measure_start_point]
      move_marker $point_mark1 $measure_start_point
    }

    public method measure_drag {x y} {
      if {$measure_start_point == {}} {
        return
      }
      set drag_point [$itk_component(graph) invtransform $x $y]
      set drag_point [fix_negative_time $drag_point]
      # draw point2
      set physical_x_delta [MATH_ABS [MATH_MINUS $x [lindex $measure_start_point_physical 0]]]
      set physical_y_delta [MATH_ABS [MATH_MINUS $y [lindex $measure_start_point_physical 1]]]
      ;# show second point text if not too close
      if { [MATH_GT $physical_x_delta 50] || 
           [MATH_GT $physical_y_delta 30] ||
           ([MATH_GT $physical_x_delta 10] && [MATH_GT $physical_y_delta 10]) } {
        set plot_width [$itk_component(graph) extents plotwidth]
        set plot_height [$itk_component(graph) extents plotheight]
        
        if {$x >= 150 && $x < $plot_width} {
          set marker_x $x
        } else {
          if {$x < 150} {
            set marker_x [expr $x + 50]
          } else {
            set marker_x [expr $x - 50]
          }
        }
        if {$y < [expr $plot_height -25] } {
          set marker_y $y
        } else {
          set marker_y [expr $y - 25]
        }
        set drag_marker_text_coords [$itk_component(graph) invtransform $marker_x $marker_y]
        move_marker $text_mark2 $drag_marker_text_coords -text [point_values_text $drag_point]
        #move_marker $text_mark2 $drag_point -text [point_values_text $drag_point]
      } else {
        banish_text_marker $text_mark2 -text ""
      }
      move_marker $point_mark2 $drag_point
    }

    public method measure_end {x y} {
      if {$measure_start_point == {}} {
        return
      }
      set end_point [$itk_component(graph) invtransform $x $y]

      set x1 [lindex $measure_start_point 0]
      set y1 [lindex $measure_start_point 1]
      set x2 [lindex $end_point 0]
      set y2 [lindex $end_point 1]

      set delta_x [MATH_ABS [MATH_MINUS $x2 $x1]]
      set delta_y [MATH_ABS [MATH_MINUS $y2 $y1]]
      
      if {[MATH_EQ $delta_x 0] && [MATH_EQ $delta_y 0]} {
        return
      }
      
      set delta_x_point [MATH_DIV [MATH_PLUS $x1 $x2] 2]
      set delta_y_point [MATH_DIV [MATH_PLUS $y1 $y2] 2]
      move_marker $delta_x_line [list $x1 $y2 $x2 $y2]
      move_marker $delta_y_line [list $x1 $y1 $x1 $y2]
      set physical_x_delta [MATH_ABS [MATH_MINUS $x [lindex $measure_start_point_physical 0]]]
      set physical_y_delta [MATH_ABS [MATH_MINUS $y [lindex $measure_start_point_physical 1]]]
      if {[MATH_GT $physical_x_delta 10]} {
        move_marker $delta_x_text "$delta_x_point $y2" -text [format "dt=%s" [call_time_formatter $delta_x]]
      } else {
        banish_text_marker $delta_x_text -text ""
      }
      if {[MATH_GT $physical_y_delta 10]} {
        set value_str [call_value_formatter $delta_y]
        if {$value_str != ""} {
          move_marker $delta_y_text "$x1 $delta_y_point" -text " dy=$value_str"
        } else {
          banish_text_marker $delta_y_text -text ""
        }
      } else {
        banish_text_marker $delta_y_text -text ""
      }

      banish_text_marker $point_mark1
      banish_text_marker $point_mark2
      ;#banish_text_marker $text_mark1 -text ""
      banish_text_marker $text_mark2 -text ""
    }

    public method set_y_ticks_formatter {code} {
      $itk_component(graph) yaxis configure -command $code
    }

    public method get_x_pixel_logical_length {} {
      set one [$itk_component(graph) invtransform 0 0]
      set two [$itk_component(graph) invtransform 1 0]
      return [expr [lindex $two 0] - [lindex $one 0]]
    }

    public method default_format_y_ticks {w value} {
      return [call_value_formatter $value]
    }

    private method format_time_ticks {w value} {
      return [call_time_formatter $value]
    }

    public method graph_configure {args} {
      if {[winfo ismapped $itk_component(graph)]} {
        $document set_variable_value PlotWidth [$itk_component(graph) extents plotwidth]
      }
    }

    public method graph_schedule_configure {} {
      set do_configure_var 1
    }
    
    private method on_x_scroll {args} {
      set do_configure_var 1
    }

    private method update_ticks_on_y_scroll {} {
      set new_ticks [call_tick_resolver]
      if {$new_ticks == {}} {
        if {$using_default_ticks} { return }
        set using_default_ticks 1
        set minor_ticks {}
      } else {
        set using_default_ticks 0
        set minor_ticks {0}
      }
      if {![are_ticks_same [$itk_component(graph) axis cget y -majorticks] $new_ticks]} {
        after idle [list $itk_component(graph) yaxis configure -majorticks $new_ticks -minorticks $minor_ticks]
      }
    }

    private method on_y_scroll {args} {
      #update_ticks_on_y_scroll
      return [eval [list $itk_component(ybar) set] $args]
    }

    private method fix_negative_time {point} {
      set time_point [lindex $point 0]
      if {$time_point < 0} {
        return [list 0 [lindex $point 1]]
      } else {
        return $point
      }
    }

    proc are_ticks_same {ticks1 ticks2} {
      set l1 [llength $ticks1]
      set l2 [llength $ticks2]
      if {$l1 != $l2} {
        return 0
      }
      for {set i 0} {$i < $l1} {incr i} {
        if {[lindex $ticks1 $i] != [lindex $ticks2 $i]} {
          return 0
        }
      }
      return 1
    }

  } ;# class

} ;#namespace
