
namespace eval ::v2::ui::quitsimulationdialog {

  class TheDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args
      draw
    }

    protected method create_body {} {
      set top [get_body_frame]



      frame $top.pn -bd 2 -relief groove
      pack $top.pn -fill both -expand yes -side left
      
      label $top.pn.txt -text "Quit simulation ?" \
          -font {Helvetica -16 bold} -padx 10 -pady 10
      pack $top.pn.txt
      
      ::UI::Checkbutton $top.pn.ch1 -text "Keep simulation data on disk"
      ::UI::Checkbutton $top.pn.ch2 -text "Keep waves windows open"

#      frame $top.pn.pad -bg red
      
      pack $top.pn.ch1 -anchor w -padx 10
      pack $top.pn.ch2 -anchor w -padx 10
#      pack $top.pn.pad 
      
      attach $top.pn.ch1.frame.check KeepSimulationData
      attach $top.pn.ch2.frame.check KeepWavesOpen
    }
  }
}

