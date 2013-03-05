# sccsid = "@(#)sccs get -r2.1 /net/springfield/disk1/hdldraw/sccs/Virtual/tcl/UI/s.BalloonWidget.tcl" 
option add *TkBalloon.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *TkBalloon.background \#ffffe7 widgetDefault
option add *TkBalloon.balloonborderwidth 1 widgetDefault
option add *TkBalloon.relief solid widgetDefault

namespace eval ::UI {
  class TkBalloon {
    inherit itk::Toplevel ::Utilities::Grabable

    itk_option define -balloonborderwidth balloonBorderWidth BalloonBorderWidth 1 {
      if {[winfo exist $itk_component(message)]} {
        $itk_component(message) configure -borderwidth $itk_option(-balloonborderwidth)
      }
    }

    constructor {args } {
      wm overrideredirect $itk_interior 1
      wm withdraw $itk_interior
      
      itk_component add message {
        label $itk_interior.label 
      }  {
        keep -text -background -font -relief
      }
      
      pack $itk_component(message)
      
      eval itk_initialize $args
    }

    public method show {widget x y text} {
      if {$text != ""} {
        grabGlobally $widget
        $itk_component(message) conf -text $text
        wm geometry $itk_component(hull)  +$x+$y 
        wm deiconify $itk_component(hull)  
        raise $itk_component(hull) 
      }
    }
    
    public method hide {} {
      ungrab
      wm withdraw $itk_component(hull)
    } 
  }
}
