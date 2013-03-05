#tcl-mode
option add *PercentBar.height 15 widgetDefault
option add *PercentBar.border 2 widgetDefault
option add *PercentBar.thresholdwidth 2 widgetDefault
option add *PercentBar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *PercentBar.bordercolor \#d9d9d9 widgetDefault
option add *PercentBar.foreground black widgetDefault
option add *PercentBar.thresholdcolor black widgetDefault
option add *PercentBar.validpercentcolor green widgetDefault
option add *PercentBar.invalidpercentcolor red widgetDefault

namespace eval ::UI {
  usual PercentBar {}
  ::itcl::class PercentBar {
    inherit itk::Widget
    
    itk_option define -validpercentcolor validpercentcolor Validpercentcolor green
    itk_option define -invalidpercentcolor invalidpercentcolor InValidPercentColor red
    
    itk_option define -bindcmd bindcmd BindCommand {} {
      set length [llength $itk_option(-bindcmd)]
      if {[expr fmod($length,2)] != 0} {
        return
      }
      foreach {cmdtag cmd} $itk_option(-bindcmd) {
        foreach comp [component] {
          bind $itk_component($comp) $cmdtag $cmd
        }
      }
    }
    
    ::UI::ADD_VARIABLE percent Percent 0
    ::UI::ADD_VARIABLE threshold Threshold 100

    destructor {
      destruct_variable percent
      destruct_variable threshold
    }
    
    constructor {args} {
      construct_variable percent
      construct_variable threshold
      
      itk_component add frame_bar {
        frame  $itk_interior.frame_bar
      } {
        rename -highlightthickness -border border Border
        rename -highlightbackground -bordercolor bordercolor Bordercolor
        keep -background
      }

      itk_component add label {
        label $itk_interior.label -width 5 -anchor e
      } {
        keep -background -foreground -font
      }

      itk_component add bar {
        frame  $itk_interior.frame_bar.bar
      } {
        keep -background -height
      }

      itk_component add  threshold {
        frame  $itk_interior.frame_bar.threshold
      } {
        keep -background -height
        rename -width -thresholdwidth thresholdwidth Thresholdwidth
        rename -background -thresholdcolor thresholdcolor Thresholdcolor
      }
      
      grid $itk_component(frame_bar) -column 0 -row 0 -sticky nsew
      grid $itk_component(label) -column 1 -row 0 -sticky e
      grid columnconfigure $itk_interior 0 -weight 90
      grid columnconfigure $itk_interior 1 -weight 10
      
      eval itk_initialize $args
    }
    
    public method show {} {
      grid forget $itk_component(bar)
      grid forget $itk_component(threshold)
 
      set local_percent $percent
      if {$percent == "--"} {
        set local_percent 0
      }
      if {$local_percent < $threshold} {
        if {$percent != "--"} {
          grid $itk_component(bar) -column 0 -row 0 -sticky "nsew" 
        }
        grid $itk_component(threshold) -column 2 -row 0 -sticky "nw"
        
        set width1 [expr $threshold - $local_percent]
        set width2 [expr 100 - $threshold]
        
        grid columnconfigure $itk_component(frame_bar) 0 -weight $local_percent
        $itk_component(bar) configure -bg $itk_option(-invalidpercentcolor)

      } else {
        if {$percent != "--"} {
          grid $itk_component(bar) -column 0 -row 0 -columnspan 2 -sticky "nsew" 
        }
        grid $itk_component(threshold) -column 1 -row 0 -sticky "nw"
        
        set width1 [expr $local_percent - $threshold]
        set width2 [expr 100 - $local_percent]
        
        grid columnconfigure $itk_component(frame_bar) 0 -weight $threshold
        $itk_component(bar) configure -bg $itk_option(-validpercentcolor)
      }
      
      grid columnconfigure $itk_component(frame_bar) 1 -weight $width1
      grid columnconfigure $itk_component(frame_bar) 2 -weight $width2 
    }
    
  }
  ::itcl::class UI/PercentBar/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tagPercent tagThreshold args} {
      $widget configure -percentvariable [$document get_variable_name $tagPercent]
      $widget configure -thresholdvariable [$document get_variable_name $tagThreshold]
    }
  }
  UI/PercentBar/DocumentLinker UI/PercentBar/DocumentLinkerObject
}

body ::UI::PercentBar::update_gui {} {
  show
}

body ::UI::PercentBar::setup_data/percent {} {
  set text $percent
#  if {$text == "0"} {
#    set text "--"
#  }
  $itk_component(label) configure -text "$text %"
}

body ::UI::PercentBar::check_new_value/percent {number} {
  if {$number == "--"} {
    return
  }
  if {$number > 100} {
    error "Percent should be < 100"
  } elseif {$number < 0} {
    error "Percent should be non-negative"
  }
}

body ::UI::PercentBar::check_new_value/threshold {number} {
  if {$number > 100} {
    error "Threshold should be < 100"
  } elseif {$number < 0} {
    error "Threshold should be non-negative"
  }
}

