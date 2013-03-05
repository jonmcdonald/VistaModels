#tcl-mode
option add *StatusBar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *StatusBar.background \#e0e0e0 widgetDefault
option add *StatusBar.foreground black widgetDefault

namespace eval ::v2::ui::analysis::window {
  class StatusBar {
    inherit ::UI::StatusBar 
    
    constructor {_document args} {
      chain $_document
    } {  
      eval itk_initialize $args
      attach $itk_component(status_label) StatusText
    }

    public method show {} {
      chain
    }
  }
}
