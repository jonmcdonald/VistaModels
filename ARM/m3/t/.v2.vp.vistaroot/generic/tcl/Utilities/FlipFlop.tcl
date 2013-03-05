if {[llength [info commands ::itcl::class ]] == 0} {
NOT_SUPPORTED_ON_PURE_TCL
}

namespace eval ::Document {
  if {[info commands ::Document::disableRecording] == ""} {
    proc disableRecording {} {}
  }
  if {[info commands ::Document::enableRecording] == ""} {
    proc enableRecording {} {}
  }
  if {[info commands ::Document::disableFlipFlopDischarging] == ""} {
    proc disableFlipFlopDischarging {} {}
  }
  if {[info commands ::Document::enableFlipFlopDischarging] == ""} {
    proc enableFlipFlopDischarging {} {}
  }
}
namespace eval ::Utilities {
  proc ff_trace {option full_var_name operation user_script} {
    set trace_script [list ::Utilities::theFlipFlop scheduleScript $user_script]
    uplevel \#0  [list trace $option $full_var_name $operation $trace_script]
  }

  proc ff_is_charged {} {
    return [::Utilities::theFlipFlop isCharged]
  }

  proc ff_is_not_charged {} {
    return [expr ![ff_is_charged]]
  }

  proc ff_disable_discharging {} {
    ::Utilities::theFlipFlop disableDischarging
  }

  proc ff_enable_discharging {} {
    ::Utilities::theFlipFlop enableDischarging
  }

  proc ff_is_discharging_enabled {} {
    return [ ::Utilities::theFlipFlop isDischargingEnabled ]
  }

  proc ff_discharge {} {
    ::Utilities::theFlipFlop discharge
  }
  
  proc ff_callback_for_schedule_script {script args} {
    uplevel \#0 $script
  }

  proc ff_schedule_script {script} {
    ::Utilities::theFlipFlop scheduleScript [list ::Utilities::ff_callback_for_schedule_script $script] "" "" ""
  }
  
  proc ff_report {message} {
#    puts stderr $message
  }

  class FlipFlopImpl {
    private variable isChargedFlag 0
    private variable requests

    public method isCharged {} {
      return $isChargedFlag
    }

    public method scheduleScript {user_script full_var_name element_name operation} {
      if {!$isChargedFlag} {
        set isChargedFlag 1
        charge
      }
      set requests([list $user_script $full_var_name $element_name $operation]) 1
    }

    public method charge {} {
      after 1 [list ::Utilities::theFlipFlop discharge]
    }

    public method discharge {} {
      foreach request [array names requests] {
        unset requests($request)
        if {[catch {
          set user_script [lindex $request 0]
          set full_var_name [lindex $request 1]
          set element_name [lindex $request 2]
          set operation [lindex $request 3]
          ::Utilities::ff_report "Discharging script for $full_var_name"
          ::Utilities::ff_report "The script is $user_script"
          uplevel \#0 $user_script [list $full_var_name $element_name $operation] 
        } msg]} {
          ::Utilities::ff_report "Caught error $msg"
        }
      }
    }
  }

  class FlipFlop {
    private variable theImpl
    private variable isBeingDischarged 0
    private variable dischargingDisabledCounter 0
    private variable needsDischarge 0
    constructor {} {
      set theImpl [::Utilities::objectNew ::Utilities::FlipFlopImpl]
    }
    destructor {
      delete object $theImpl
    }
    public method scheduleScript {user_script full_var_name element_name operation} {
      ::Utilities::ff_report "Scheduling script for $full_var_name"
      ::Utilities::ff_report "The script is $user_script"
      if {![isCharged]} {
        ::Utilities::ff_report "Tcl Disables Recording"
        catch {::Document::disableRecording}
      }
      $theImpl scheduleScript $user_script $full_var_name $element_name $operation
    }
    public method discharge {} {
      if {$dischargingDisabledCounter || $isBeingDischarged} {
      ::Utilities::ff_report "Tcl FlipFlop: discharge delayed"
        set needsDischarge 1
        return
      }
      ::Utilities::ff_report "Discharging the Tcl FlipFlop"
      set isBeingDischarged 1
      set needsDischarge 0
      set oldImpl $theImpl
      set theImpl [::Utilities::objectNew ::Utilities::FlipFlopImpl]
      $oldImpl discharge
      delete object $oldImpl
      set isBeingDischarged 0
      ::Utilities::ff_report "Done Discharging the Tcl FlipFlop"
      rechargeIfNeeded
      if {![isCharged]} {
        ::Utilities::ff_report "Tcl Enables Recording"
        catch {::Document::enableRecording}
      }
    }
    public method isCharged {} {
      if {$isBeingDischarged} {
        return 1
      }
      if {[$theImpl isCharged]} {
        return 1
      }
      return 0
    }
    public method isDischargingEnabled {} {
      return [expr $dischargingDisabledCounter == 0]
    }
    public method disableDischarging {} {
      incr dischargingDisabledCounter 1
    }
    public method enableDischarging {} {
      incr dischargingDisabledCounter -1
      if {$dischargingDisabledCounter == 0} {
        rechargeIfNeeded
      }
    }
    private method rechargeIfNeeded {} {
      if {!$needsDischarge} {
        return
      }
      ::Utilities::ff_report "Recharging the Tcl FlipFlop"
      set needsDischarge 0
      $theImpl charge
    }
  }
  FlipFlop theFlipFlop

  proc DISABLE_TCL_FLIP_FLOP {} {
    uplevel [list ::Utilities::FINAL_ACTION [list ::Utilities::ff_enable_discharging]]
    ::Utilities::ff_disable_discharging
  }

  proc DISABLE_C++_FLIP_FLOP {} {
    uplevel [list ::Utilities::FINAL_ACTION [list ::Document::enableFlipFlopDischarging]]
    ::Document::disableFlipFlopDischarging
  }

  proc DISABLE_FLIP_FLOPS {} {
    uplevel ::Utilities::DISABLE_TCL_FLIP_FLOP
    uplevel ::Utilities::DISABLE_C++_FLIP_FLOP
  }

  namespace export DISABLE_TCL_FLIP_FLOP
  namespace export DISABLE_C++_FLIP_FLOP
  namespace export DISABLE_FLIP_FLOPS
  
}
