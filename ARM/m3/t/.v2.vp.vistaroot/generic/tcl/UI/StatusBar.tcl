# tcl-mode
option add *StatusBar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *StatusBar.background \#e0e0e0 widgetDefault
option add *StatusBar.foreground black widgetDefault

namespace eval ::UI {
  class StatusBar {
    inherit itk::Widget ::UI::DocumentUIBuilder
    
    itk_option define -font font Font ""
    itk_option define -foreground foreground Foreground black

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      
      itk_component add frame {
        frame $itk_interior.fr -height 23 -bd 1 -relief raised
      } {
        keep -background
      }
      itk_component add status {
        frame $itk_interior.status -height 23 -bd 1 -relief raised
      }  {
        keep -background
      }
      itk_component add status_label {
        label $itk_component(frame).status_label -wraplength 0
      } {
        keep -background -foreground -font
      }
      
      eval itk_initialize $args
    }

    public method show {} {
      pack $itk_component(frame) -side left -fill x -expand 1 
      pack $itk_component(status) -side left 
      pack $itk_component(status_label) -side left -fill x
    }
  }
}
