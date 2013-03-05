namespace eval ::Utilities {
  proc grab_internal {window globalFlag} {
    if {[winfo exists $window]} {
      if {$globalFlag} {
        ::grab -global $window
      } else {
        ::grab $window
      }
    }
  }

  class GrabAction {
    private variable window
    private variable oldGrabWindow
    private variable oldGlobalFlag
    constructor {windowIn globalFlag} {
      set window $windowIn

      set oldGrabWindow [::grab current]
      if {$oldGrabWindow != ""} {
        if {[::grab status $oldGrabWindow] == "global"} {
          set oldGlobalFlag 1
        } else {
          set oldGlobalFlag 0
        }
      }

      catch {::Utilities::grab_internal $window $globalFlag}
    }
    destructor {
      if {[winfo exists $window]} {
        catch {::grab release $window}
      }
      if {$oldGrabWindow != ""} {
        catch {::Utilities::grab_internal $oldGrabWindow $oldGlobalFlag}
      }
    }
  }

  class Grabable {
    private variable grabAction {}

    private method grabMe {widget globalFlag} {
      if {$grabAction == ""} {
        set grabAction [::Utilities::objectNew ::Utilities::GrabAction $widget $globalFlag]
      }
    }

    protected method grabGlobally {widget} {
      grabMe $widget 1
    }

    protected method grabLocally {widget} {
      grabMe $widget 0
    }

    protected method ungrab {} {
      if {$grabAction != ""} {
        delete object $grabAction
        set grabAction {}
      }
    }

    destructor {
      ungrab
    }
  }

  proc with_grab_internal {window script globalFlag} {
    newLocal GrabAction $window $globalFlag
    return [uplevel $script]
  }

  proc with_grab {window script} {
    return [uplevel [list ::Utilities::with_grab_internal $window $script 0]]
  }

  proc with_global_grab {window script} {
    return [uplevel [list ::Utilities::with_grab_internal $window $script 1]]
  }
}
