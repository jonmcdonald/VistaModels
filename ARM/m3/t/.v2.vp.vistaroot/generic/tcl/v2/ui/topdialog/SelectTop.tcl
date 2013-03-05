
namespace eval ::v2::ui::topdialog {
  class SelectTop {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 220 0
      wm resizable $itk_interior 1 0

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]
      itk_component add top_combo {
        ::UI::BwidgetCombobox $top.top_combo
      } {}
      attach $itk_component(top_combo) TopName AllTopNames
      $itk_component(top_combo) configure -editable 0

      pack $itk_component(top_combo) -side top -fill x -expand 1 -anchor nw -pady 20
    }
  }    
}

