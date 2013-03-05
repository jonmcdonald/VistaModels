#tcl-mode
option add *SWidget.helpbackground yellow widgetDefault
option add *SWidget.helpforeground black widgetDefault
option add *SWidget.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::UI {
  class SWidget {
    inherit itk::Widget ::UI::DocumentOwner
    
    itk_option define -helpfont helpfont Font "*-arial-medium-r-normal-*-12-120-*" {
      DynamicHelp::configure -font $itk_option(-helpfont)
    }
    
    itk_option define -helpforeground helpforeground Helpforeground blue {
      DynamicHelp::configure -foreground $itk_option(-helpforeground)
    }

    itk_option define -helpbackground helpbackground Helpbackground white {
      DynamicHelp::configure -background $itk_option(-helpbackground)
    }
    
    constructor {_document args} {
      ::UI::DocumentOwner::constructor $_document
    } {
      eval itk_initialize $args

    }

    destructor {
    }

    public method show {} {
    }
    public method on_visible {} {
    }
    public method focus_in {args} {
    }
  }
}
