namespace eval ::v2::ui::simulation {
  
  class StatusIndicator {
    inherit ::UI::SWidget
    private variable status_changed_scheduled 0
    ::UI::ADD_VARIABLE isBusy IsBusy
    ::UI::ADD_VARIABLE isAlive IsAlive
    ::UI::ADD_VARIABLE isTargetAlive IsTargetAlive
    ::UI::ADD_VARIABLE isStarting IsStarting
    ::UI::ADD_VARIABLE lastEventTime LastEventTime
    ::UI::ADD_VARIABLE currentTimingModel CurrentTimingModel
    ::UI::ADD_VARIABLE workWindowWidgetName WorkWindowWidgetName

    private variable counter_busy 0
    private common points

    private method addButton {name image command helptext} {
      set button_width 14
      set button_height 12
      itk_component add $name {
        Button $itk_interior.$name \
            -relief flat -overrelief raised \
            -padx 0 -pady 0 -highlightthickness 0 \
            -width $button_width \
            -height $button_height \
            -borderwidth 1 \
            -helptext $helptext \
            -image [::UI::getimage $image 0] 
      } {
        keep -background -foreground -font 
      }
      bind $itk_interior.$name <Enter> [list $itk_interior.$name configure -relief raised]
      bind $itk_interior.$name <Leave> [list $itk_interior.$name configure -relief flat]
      $itk_interior.$name configure -activebackground [$itk_interior.$name cget -background]
#      puts $itk_interior.$name
      attach $itk_interior.$name $command
    }

    private method addRadioButton {name label value model {helptext ""}} {
      set button_width 0
      set button_height 0
      itk_component add $name {
        radiobutton $itk_interior.$name \
            -value $value \
            -text $label \
            -relief flat -overrelief raised \
            -padx 0 -pady 0 \
            -width $button_width \
            -height $button_height \
            -borderwidth 1
      } {
        keep -background -foreground -font 
      }
      attach $itk_interior.$name $model
    }

    private method hideButtons {} {
      pack forget $itk_component(pause)
      pack forget $itk_component(continue)
      pack forget $itk_component(resimulate)
    }

    public method shouldShowTimingModelSwitcher {} {
      set timing_model ""
      catch {
        set timing_model [$document get_variable_value CurrentTimingModel]
      }
      if {![string equal $timing_model "AT"] && ![string equal $timing_model "LT"]} {
        return 0
      }
      if {$workWindowWidgetName == ""} {
        return 1
      }
      set workWindowDocument ""
      catch {
        set workWindowDocument [[set $workWindowWidgetName] get_document]
      }
      if {$workWindowDocument == ""} {
        return 1
      }
      set workWindowID ""
      catch {
        set workWindowID [$workWindowDocument get_variable_value WorkWindowID]
      }
      if {![string equal $workWindowID "Projects"]} {
        return 1
      }
      return 0
    }
    private method packTimingModelSwitcher {} {
      pack $itk_component(timing_model_at) -side left
      pack $itk_component(timing_model_lt) -side left
      if {![shouldShowTimingModelSwitcher]} {
        pack forget $itk_component(timing_model_at)
        pack forget $itk_component(timing_model_lt)
      }
    }

    private method showButton {name} {
      if {$name != "pause"} {
        pack forget $itk_component(pause)
      }
      if {$name != "continue"} {
        pack forget $itk_component(continue)
      }
      if {$name != "resimulate"} {
        pack forget $itk_component(resimulate)
      }
      pack $itk_component($name) -side right
      packTimingModelSwitcher

    }

    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args

      set points(0) ".  "
      set points(1) ".. "
      set points(2) "..."

      itk_component add label {
        label $itk_interior.label -text "" -font fixed
      } {
        keep -background -foreground -font
      }
      pack $itk_component(label) -side left

      addRadioButton timing_model_at "AT" "AT" CurrentTimingModel
      addRadioButton timing_model_lt "LT" "LT" CurrentTimingModel
#      packTimingModelSwitcher
      addButton pause pause PauseCommand  "Pause"
      addButton continue continue ContinueCommand "Continue"
      addButton resimulate resimulate OpenResimulateDialog "Re-simulate"
    }
    destructor {
      destruct_variable isBusy
      destruct_variable isAlive
      destruct_variable isTargetAlive
      destruct_variable isStarting
      destruct_variable lastEventTime
      destruct_variable currentTimingModel
      destruct_variable workWindowWidgetName
    }
    protected method status_changed {} {}
    private method schedule_status_changed {} {
      if {$status_changed_scheduled == 1} {
        return
      }
      set status_changed_scheduled 1
      after idle [code $this status_changed]
    }
  }

  namespace eval ::UI {
    ::itcl::class v2/ui/simulation/StatusIndicator/DocumentLinker {
      inherit ::UI::DataDocumentLinker
      protected method attach_to_data {widget document tag args} {
        $widget configure -isBusyvariable [$document get_variable_name IsGdbBusy]
        $widget configure -isAlivevariable [$document get_variable_name IsGdbAlive]
        $widget configure -isTargetAlivevariable [$document get_variable_name IsGdbTargetAlive]
        $widget configure -isStartingvariable [$document get_variable_name IsStarting]
        $widget configure -lastEventTimevariable [$document get_variable_name LastEventTimeForView]
        $widget configure -currentTimingModelvariable [$document get_variable_name CurrentTimingModel]
        $widget configure -workWindowWidgetNamevariable [$document get_variable_name WorkWindowWidgetName]
      }
    }
    v2/ui/simulation/StatusIndicator/DocumentLinker v2/ui/simulation/StatusIndicator/DocumentLinkerObject
  }
}

itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/isBusy {} {
  schedule_status_changed
}

itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/isAlive {} {
  schedule_status_changed
}


itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/isTargetAlive {} {
  schedule_status_changed
}

itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/isStarting {} {
  schedule_status_changed
}
itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/lastEventTime {} {
  schedule_status_changed
}
itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/currentTimingModel {} {
  schedule_status_changed
}
itcl::body ::v2::ui::simulation::StatusIndicator::setup_data/workWindowWidgetName {} {
  schedule_status_changed
}

itcl::body ::v2::ui::simulation::StatusIndicator::status_changed {} {
  set status_changed_scheduled 0

  set ext [set points([expr [incr counter_busy] % 3])]

  set lastEventText ""
  if { $lastEventTime !=  "" && $lastEventTime != "0"} {
    set lastEventText "Last event at $lastEventTime"
  }
  if {$isAlive == "" || $isTargetAlive == "" || !$isAlive || !$isTargetAlive} {
    if {$isStarting == "" || !$isStarting} {
      $itk_component(label) configure -text "$lastEventText Not running  "  -fg brown -bg grey
    } else {
      $itk_component(label) configure -text "Starting  "  -fg black -bg green
    }
    showButton resimulate
    return
  }

  if {$isBusy != "" && $isBusy} {
    if {[$itk_component(label) cget -bg] != "green"} {
      $itk_component(label) configure -text "Running$ext"  -fg black -bg green
    } else {
      catch {$itk_component(label) configure -text "Running$ext"  -fg black -bg lightgreen}
    }
    showButton pause
#    after 200 [list catch [code $this status_changed]]
    return
  }


  $itk_component(label) configure -text "$lastEventText Stopped   " -fg red  -bg grey
  showButton continue
}

