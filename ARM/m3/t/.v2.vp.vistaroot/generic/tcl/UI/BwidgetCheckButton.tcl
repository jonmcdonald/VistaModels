
namespace eval ::UI {
  usual BwidgetCheckButton {}
  class BwidgetCheckButton {
    inherit itk::Widget 
    
    ::UI::ADD_VARIABLE valuedata ValueData
    public variable helptextOn ""
    public variable helptextOff ""
    
    constructor {args} {
      construct_variable valuedata
      itk_component add button {
        Button $itk_interior.bt -command [code $this on_click]
      } {
        keep -image -width -height -relief -padx -pady -highlightthickness -state
        keep -borderwidth
        keep -background -foreground -font 
        keep -activebackground  -takefocus
      }
      eval itk_initialize $args
      
      if {[cget -helptextOff] == ""} {
        configure -helptextOff [cget -helptextOn]
      }
      if {[cget -relief] == "link"} {
        $itk_component(button) configure -helptext [cget -helptextOff]
      } else {
        $itk_component(button) configure -helptext [cget -helptextOn]
      }

      pack $itk_component(button) 
    }

    destructor {
      destruct_variable valuedata
    }

    public method on_click {} {
      set [cget -valuedatavariable] [expr [list ! [set [cget -valuedatavariable]]]]
    }
  }
}

body ::UI::BwidgetCheckButton::update_gui/valuedata {} {
  if {$valuedata == 1} {
    $itk_component(button) configure -relief sunken -helptext [cget -helptextOn]
  } else {
    $itk_component(button) configure -relief link -helptext [cget -helptextOff]
  }
} 

namespace eval ::UI {
  ::itcl::class BwidgetCheckButton/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document ValueData args} {
      if {$ValueData != ""} {
        $widget configure -valuedatavariable [$document get_variable_name $ValueData]
      }
    }
  }
  
  BwidgetCheckButton/DocumentLinker BwidgetCheckButton/DocumentLinkerObject
}
