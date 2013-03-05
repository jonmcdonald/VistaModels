#tcl-mode

namespace eval ::UI {
  usual ElementData {}
  class ElementData {
    inherit itk::Widget
    
    ::UI::ADD_VARIABLE totals Totals {}
    ::UI::ADD_VARIABLE threshold Threshold 100

    constructor {args} {
      construct_variable totals
      construct_variable threshold

      itk_component add label {
        label $itk_interior.label 
      } {
        keep -borderwidth -width -background -foreground -relief -font
      }
      $itk_component(label) configure -borderwidth 0 -width 12 -background white -foreground black
      pack $itk_component(label) -expand 1 -fill both

      eval itk_initialize $args
    }

    destructor {
      destruct_variable totals
      destruct_variable threshold
    }
    
    private method applyData {} {
      set hit [lindex $totals 0]
      set total [lindex $totals 1]
      if {$total > 0} {
        set percent [expr { $hit * 100 / $total } ]
        set text "$percent% $hit / $total"
      } else {
        set text "---"
      }
      $itk_component(label) configure -text $text
      updateColor
    }
    
    private method updateColor {} {
      set color "black"
      set hit [lindex $totals 0]
      set total [lindex $totals 1]
      if {$total > 0} {
        set percent [expr { $hit * 100 / $total }]
        if {$percent < $threshold} {
          set color "red"
        }
      }
      $itk_component(label) configure -foreground $color
    }
  }

  ::itcl::class UI/ElementData/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tagTotals tagThreshold args} {
      $widget configure -totalsvariable [$document get_variable_name $tagTotals]
      $widget configure -thresholdvariable [$document get_variable_name $tagThreshold]
    }
  }
  UI/ElementData/DocumentLinker UI/ElementData/DocumentLinkerObject
}

body ::UI::ElementData::clean_gui {} {
  $itk_component(label) configure -text "" -foreground black
}

body ::UI::ElementData::update_gui/totals {} {
  applyData
}

body ::UI::ElementData::update_gui/threshold {} {
  applyData
}
