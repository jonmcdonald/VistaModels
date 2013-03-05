usual Checkbutton {}

namespace eval ::UI {
  class Checkbutton {   
    inherit itk::Widget 
    
    constructor {args} {

      itk_component add checkbutton {
        checkbutton $itk_interior.check
      } {
        keep -state 
      }
      $itk_component(checkbutton) config -image [::UI::getimage class_chkbtn_unchk] \
          -selectimage [::UI::getimage class_chkbtn_chk]\
          -border 0 \
          -indicator 0 -padx 7 -pady 1 -compound left \
          -activebackground [cget -background] \
          -highlightbackground [cget -background] \
          -selectcolor [cget -background] \
          -disabledforeground {} 
  
      bind $itk_interior <FocusIn> "focus %W.check"

      eval [list configure] $args

      pack $itk_component(checkbutton) -anchor nw
    }
    
    public method  configure { args } {
      eval [list $itk_component(checkbutton) config]  $args
    }

    public method  config { args } {
      configure $args
    }

    public method cget {args } {
      return [$itk_component(checkbutton) cget $args]
    }

    public method deselect {} {
      $itk_component(checkbutton) deselect
    }

    public method flash {} {
      $itk_component(checkbutton) flash
    }

    public method invoke {} {
      $itk_component(checkbutton) invoke
    }

    public method select {} {
      $itk_component(checkbutton) select
    }

    public method toggle {} {
      $itk_component(checkbutton) toggle
    }
  };#class
};# namespace
