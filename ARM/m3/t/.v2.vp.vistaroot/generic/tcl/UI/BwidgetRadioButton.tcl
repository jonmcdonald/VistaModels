
namespace eval ::UI {
  usual BwidgetRadioButton {}
  class BwidgetRadioButton {
    inherit itk::Widget 
    
    public variable value ""
    
    ::UI::ADD_VARIABLE valuedata ValueData
    
    constructor {args} {
      construct_variable valuedata
      itk_component add button {
        Button $itk_interior.bt ; #-command [code $this on_click]
      } {
        keep -image -width -height -helptext -relief -padx -pady -highlightthickness -state
        keep -background -foreground -font 
        keep -activebackground
        keep -command -takefocus
      }
      eval itk_initialize $args
      pack $itk_component(button) 
    }

    destructor {
      destruct_variable valuedata
    }

    public method on_click {} {
      configure -valuedata $value
    }
  }
}

body ::UI::BwidgetRadioButton::setup_data/valuedata {} {
  if {$value != ""} {
    if { $value == $valuedata} {
      $itk_component(button) configure -relief sunken
    } else {
      $itk_component(button) configure -relief link
    }
  }
} 

namespace eval ::UI {
  ::itcl::class BwidgetRadioButton/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document ValueData CommandName args} {
      if {$ValueData != ""} {
        $widget configure -valuedatavariable [$document get_variable_name $ValueData]
      }
      if {$CommandName != ""} {
        if {![$document is_command_name $CommandName]} {
          error "$CommandName is not a command name"
        }
        $widget configure -command "$widget on_click; [list eval [list $document run_command $CommandName] $args]"
      } else {
        $widget configure -command "$widget on_click"
      }
    }
  }
  
  BwidgetRadioButton/DocumentLinker BwidgetRadioButton/DocumentLinkerObject
}
