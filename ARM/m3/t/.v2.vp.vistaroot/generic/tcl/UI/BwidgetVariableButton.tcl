
namespace eval ::UI {
  usual BwidgetVariableButton {}
  class BwidgetVariableButton {
    inherit itk::Widget 
    
    ::UI::ADD_VARIABLE valuedata ValueData
    
    constructor {args} {
      construct_variable valuedata
      itk_component add button {
        Button $itk_interior.bt -command [code $this on_click]
      } {
        keep -image -width -height -helptext -relief -padx -pady -highlightthickness -state
        keep -background -foreground -font 
        keep -activebackground -takefocus
      }
  
      eval itk_initialize $args
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

namespace eval ::UI {
  ::itcl::class BwidgetVariableButton/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document ValueData args} {
      if {$ValueData != ""} {
        $widget configure -valuedatavariable [$document get_variable_name $ValueData]
      }
    }
  }
  
  BwidgetVariableButton/DocumentLinker BwidgetVariableButton/DocumentLinkerObject
}
