
namespace eval ::v2::ui::editdialog {
  class GoToLineDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      
      wm minsize $itk_interior 250 0
      wm resizable $itk_interior 1 0
      
      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      label $top.label -text "Go to line:"
      itk_component add line {
        entry $top.line
      } {}
      attach $itk_component(line) GoToLineNumber
      
      pack $top.label -side top -padx 6 -pady 6 -anchor w
      pack $itk_component(line) -side top -padx 6 -pady 6 -fill x  -anchor w

    }
    
  };#class
};#namespace
