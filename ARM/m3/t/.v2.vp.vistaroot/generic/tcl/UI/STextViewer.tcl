itk::usual STextViewer {
  -cursor
}
namespace eval ::UI {
  class STextViewer {
    inherit itk::Widget ::UI::DocumentUIBuilder
    
    ::UI::ADD_VARIABLE content Content ""

    itk_option define -height height Height 100 {
      $itk_component(text) config -height $itk_option(-height)
    }

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    }  {
      construct_variable content
      
      itk_component add sw {
        ScrolledWindow $itk_interior.sw
      } {}
      
      itk_component add text {
        text [$itk_component(sw) getframe].text -height 100 -bg white -state disabled -wrap none
      } {
        keep -font
      }

      $itk_component(sw) setwidget $itk_component(text)

      eval itk_initialize $args
      show
    }
   
    destructor {
      destruct_variable content
    }
   
    private method show {} {
      pack $itk_component(sw) -fill both -expand 1
    }
  }
}

body ::UI::STextViewer::check_new_value/content {value} {
}

body ::UI::STextViewer::update_gui/content {} { 
  $itk_component(text) configure -state normal
  $itk_component(text) delete 1.0 end
  $itk_component(text) insert 1.0 $content
  $itk_component(text) configure -state disabled
}

namespace eval ::UI {
  ::itcl::class UI/STextViewer/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document Content} {
      $widget configure \
            -contentvariable [$document get_variable_name $Content]
    }
  }

  UI/STextViewer/DocumentLinker UI/STextViewer/DocumentLinkerObject
}
