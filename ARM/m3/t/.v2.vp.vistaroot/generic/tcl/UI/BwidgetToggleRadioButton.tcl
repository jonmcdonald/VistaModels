
namespace eval ::UI {
  usual BwidgetToggleRadioButton {}
  class BwidgetToggleRadioButton {
    inherit BwidgetRadioButton 
    
    constructor {args} {
      eval itk_initialize $args
    }

    destructor {
    }

    public method on_click {} {
      set oldValue [set [cget -valuedatavariable]]
      if {$oldValue == $value} {
        configure -valuedata ""
      } else {
        configure -valuedata $value
      }
    }
  }
}

namespace eval ::UI {
  ::itcl::class BwidgetToggleRadioButton/DocumentLinker {
    inherit BwidgetRadioButton/DocumentLinker
  }
  
  BwidgetToggleRadioButton/DocumentLinker BwidgetToggleRadioButton/DocumentLinkerObject
}
