namespace eval ::UI {
  class Bltplot {
    inherit ::UI::SWidget
    private variable graph ""

    public variable withtooltip 1

    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {

      create_bltplot_view $itk_interior
      eval itk_initialize $args
      set [$document get_variable_name BltplotWidget] $itk_interior.plot 
    }

    destructor {
       if {$withtooltip} {
        catch {after cancel $show_tooltip_request}
        catch { destroy $itk_component(tooltip) }
      }
    }

    public method get_graph {} {
      return $graph
    }
    #static
    public proc zoomIn { graphWidget} {
      set cmd {}
      foreach axis { x y} {
        #saving old settings for previous zoom
        set min [$graphWidget axis cget $axis -min] 
        set max [$graphWidget axis cget $axis -max]
        set c [list $graphWidget axis configure $axis -min $min -max $max]
        append cmd "$c\n"

        set limits [$graphWidget axis limits $axis]
        set min [lindex $limits 0]
        set max [lindex $limits 1]
        set delta [expr ($max - $min)/5]
        set min [expr $min + $delta]
        set max [expr $max - $delta]
        $graphWidget axis configure $axis -min $min -max $max 
      }
      set ::zoomInfo($graphWidget,stack) [linsert $::zoomInfo($graphWidget,stack) 0 $cmd]
    }

    public proc zoomOut { graphWidget} {
      set cmd {}
      foreach axis { x y} {
        #saving old settings for previous zoom
        set min [$graphWidget axis cget $axis -min] 
        set max [$graphWidget axis cget $axis -max]
        set c [list $graphWidget axis configure $axis -min $min -max $max]
        append cmd "$c\n"

        set limits [$graphWidget axis limits $axis]
        set min [lindex $limits 0]
        set max [lindex $limits 1]
        set delta [expr ($max - $min)/4]
        set min [expr $min - $delta]
        if {$min < 0} {
          set min 0
        }
        set max [expr $max + $delta]
        $graphWidget axis configure $axis -min $min -max $max 
      }
      set ::zoomInfo($graphWidget,stack) [linsert $::zoomInfo($graphWidget,stack) 0 $cmd]
    }
    
    public proc scroll {graphWidget direction} {
      set axis y
      if {$direction == "left" || $direction == "right"} {
        set axis x
      }

      set limits [$graphWidget axis limits $axis]
      set min [lindex $limits 0]
      set max [lindex $limits 1]

      if {[expr $min <= 0] && ($direction ==  "left" || $direction ==  "down")} {
        return
      }
      set delta [expr ($max - $min)/5]
      if {$direction == "up" || $direction == "right"} {
        set min [expr $min + $delta]
        set max [expr $max + $delta]
      } else {
        set min [expr $min - $delta]
        set max [expr $max - $delta]
      }
      if {[expr $min < 0]} {
        set min 0
      } 
      $graphWidget axis configure $axis -min $min -max $max 
    }

    private method create_bltplot_view {frame} {
      set graph $frame.plot
      blt::graph $graph

#       scrollbar $frame.xbar \
#           -command [list $graph axis view x ] \
#           -orient horizontal -relief flat \
#           -highlightthickness 0 -elementborderwidth 2 -bd 0
      
#       scrollbar $frame.ybar \
#           -command [list $graph axis view y ] \
#           -orient vertical -relief flat  -highlightthickness 0 -elementborderwidth 2
      
      blt::table $frame \
          1,0 $graph  -fill both -cspan 3 -rspan 3 
#          2,3 $frame.ybar -fill y  -padx 0 -pady 0 
#          4,1 $frame.xbar -fill x

      #check this!!!
      blt::table configure $frame c3 r0 r4 r5 -resize none
      
      $graph axis configure x -titlecolor black -titlefont {Helvetica 12 bold} -linewidth 2 -minorticks {0.25 0.5 0.75} -max 100
      $graph axis configure y -titlecolor black -titlefont {Helvetica 12 bold} -linewidth 2 -minorticks {0.25 0.5 0.75} -max 100


#       $graph axis configure x \
#           -scrollcommand [list $frame.xbar set ] \
#       -scrollmin {}
      
#       $graph axis configure y \
#           -scrollcommand [list $frame.ybar set ] \
#           -scrollmin {}
      
      $graph legend configure \
          -activerelief sunken \
          -activeborderwidth 2  \
          -position top -anchor ne -activebackground khaki2 -activeforeground blue -relief groove -background white
      $graph configure  -plotbackground white -font {Helvetica 12 bold} -foreground blue
      $graph pen configure activeLine -showvalues none -symbol "" -color blue -fill blue -valuecolor blue -valuefont  {Helvetica 10 bold} -valueanchor se



      $graph element bind all <Enter> {
        %W legend activate [%W element get current]
        
      }
      
      $graph element bind all <Leave> {
        %W legend deactivate [%W element get current]
      }

      if {$withtooltip} {
        create_tooltip $graph
      }

      set left_varname [$document get_free_variable_name]
      $graph configure -leftvariable $left_varname 
      trace variable $left_varname w [code $this on_left_variable_changed $frame $graph]

      option add *Graph.Element.LineWidth 2
      option add *Graph.Element.Smooth linear
      option add *Graph.Element.Symbol none

      Blt_ZoomStack $graph
      Blt_Crosshairs $graph
      Blt_ActiveLegend $graph
      Blt_ClosestPoint $graph

      $graph legend bind all <ButtonPress-1> "[code $this on_legend_single_select  $graph];break"
      $graph legend bind all <Control-ButtonPress-1> [code $this on_legend_multiple_select $graph]
      $graph legend bind all <Shift-ButtonPress-1> [code $this on_legend_multiple_select $graph]
      
    }
    
    private method on_left_variable_changed { frame graph p1 p2 how } {
#      puts "on_left_variable_changed: leftmargin = [$graph extents leftmargin] rightmargin=[$graph extents rightmargin] 
#topmargin= [$graph extents topmargin] bottommargin=[$graph extents bottommargin] plotwidth=[$graph extents plotwidth] 
#    plotheight=[$graph extents plotheight]"

      blt::table configure $frame c0 -width [$graph extents leftmargin]
      blt::table configure $frame c2 -width [$graph extents rightmargin]
      blt::table configure $frame r1 -height [$graph extents topmargin]
      blt::table configure $frame r3 -height [$graph extents bottommargin]
    }

    private method on_legend_single_select {graph} {
      set current_element [$graph legend get current]
      set elements [$graph element names]
      foreach element $elements {
        set relief [$graph element cget $element -labelrelief]
        if { $relief == "flat" && ![string compare $element $current_element] } {
          $graph element configure $element -labelrelief raised
          $graph element activate $element
        } else {
          $graph element configure $element -labelrelief flat
          $graph element deactivate $element
        }
      }
    }
    private method on_legend_multiple_select {graph} {
      set current_element [$graph legend get current]
      set relief [$graph element cget $current_element -labelrelief]
      if { $relief == "flat" } {
        $graph element configure $current_element -labelrelief raised
        $graph element activate $current_element
      } else {
        $graph element configure $current_element -labelrelief flat
        $graph element deactivate $current_element
      }
    }

    protected method create_tooltip {graph} {
      itk_component add tooltip {
        toplevel $itk_interior.tooltip -bd 1 -bg black
      }
      wm overrideredirect $itk_component(tooltip) 1
      pack [label $itk_component(tooltip).label -bg lightyellow -fg black -justify left]
      wm withdraw $itk_interior.tooltip
      wm withdraw $itk_interior.tooltip      
      
      $graph element bind all <Enter> "+[code $this request_show_tooltip %x %y %X %Y]"
      $graph element bind all <Motion> "+[code $this request_show_tooltip %x %y %X %Y]"
      $graph element bind all <Leave> "+[code $this hide_tooltip]"
      bind $graph <FocusOut> "+[code $this hide_tooltip]"
    }

    private variable show_tooltip_request ""
    
    private method request_show_tooltip {x y X Y} {
      catch {after cancel $show_tooltip_request}
      set show_tooltip_request [after 500 [code $this show_tooltip $x $y $X $Y]]
    }
    
    private method show_tooltip {x y X Y} {
      set catchStatus  [catch { 
        $graph element closest $x $y resArray -interpolate yes
        set xValue [expr wide($resArray(x))]
        set yValue [expr wide($resArray(y))]
        set elementName $resArray(name)
      }]
      if {$catchStatus} {
        return
      }
      #convert
      foreach axis {x y} {
        set convert_$axis\_command [$graph axis cget $axis -command]

        if { [set convert_$axis\_command] != ""} {
          catch {
            if {$axis == "x"} {
              set $axis\Value [eval [set convert_$axis\_command] $graph [set $axis\Value] $elementName]
            } else {
              set $axis\Value [eval [set convert_$axis\_command] $graph [set $axis\Value]]
            }
          }
        }
      }
      if {$yValue == "" && $xValue == ""} {
        return;
      }
      $itk_component(tooltip).label configure -text "$yValue $xValue"
      
      set width [winfo reqwidth $itk_component(tooltip).label]
      set height [winfo reqheight $itk_component(tooltip).label]


      #wm geometry $itk_component(tooltip) [format "%sx%s+%s+%s" $width $height $x [expr $y + 50]]
      wm geometry $itk_component(tooltip) [format "%sx%s+%s+%s" $width $height [expr $X + 10] [expr $Y - $height - 10]]

      wm deiconify $itk_component(tooltip)
      raise $itk_component(tooltip)
    }

    private method hide_tooltip {} {
      catch {after cancel $show_tooltip_request}
    if {[winfo viewable $itk_interior.tooltip] == 0} {
      return
    }
      wm withdraw $itk_interior.tooltip
    }
  }
}
