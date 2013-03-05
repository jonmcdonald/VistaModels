#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::memory {
  
  class Toolbar {
    inherit ::UI::Toolbar
    
    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30
    
      ### Buttons
      fill_toolbar

      eval itk_initialize $args
      
    }

    private method fill_toolbar {} {
      
    }
  }
}
