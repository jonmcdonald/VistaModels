#tcl-mode
option add *RatioLabel.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *RatioLabel.background \#e0e0e0 widgetDefault
option add *RatioLabel.foreground black widgetDefault

namespace eval ::UI {
  usual RatioLabel {
  }
  ::itcl::class RatioLabel {
    inherit ::itk::Widget
    ::UI::ADD_VARIABLE hit Hit 0
    ::UI::ADD_VARIABLE total Total 100
     
    itk_option define -bindcmd bindcmd BindCommand {} {
      set length [llength $itk_option(-bindcmd)]
      if {[expr fmod($length,2)] != 0} {
        error "Bad number of the arguments"
      }
      foreach {cmdtag cmd} $itk_option(-bindcmd) {
        foreach comp [component] {
          bind $itk_component($comp) $cmdtag $cmd
        }
      }
    }
    
    
    destructor {
      destruct_variable hit
      destruct_variable total
    }
    
    constructor {args} {
      construct_variable hit
      construct_variable total
      
      itk_component add label {
        label $itk_interior.label
      } {
        keep -background -font -foreground
      }
      eval itk_initialize $args 
      pack $itk_component(label) -expand 1 -fill both
      update_gui
    }
  }

  ::itcl::class UI/RatioLabel/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tagHit tagTotal args} {
      $widget configure -hitvariable [$document get_variable_name $tagHit]
      $widget configure -totalvariable [$document get_variable_name $tagTotal]
    }
  }
  UI/RatioLabel/DocumentLinker UI/RatioLabel/DocumentLinkerObject
  
}

body ::UI::RatioLabel::update_gui {} {
  $itk_component(label) configure -text "$hit / $total"
}

