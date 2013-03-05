
namespace eval ::v2::ui::licensedialog {
  class LicenseDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set top $itk_interior
      set text [frame $top.text]

      pack [label $top.label] -side top -anchor nw -pady 5 -padx 5
      attach $top.label BriefDescription
      pack [set buttons [frame $top.mybuttons_frame]] -side top -pady 5 -padx 5 -fill x
      attach [button $buttons.check] CheckCommand
      ::UI::Button/DocumentLinkerObject attach_button_label_to_data $buttons.check $document CheckButtonTitle
      pack $buttons.check -side left
      attach [button $buttons.detach] DetachCommand
      ::UI::Button/DocumentLinkerObject attach_button_label_to_data $buttons.detach $document DetachButtonTitle
      pack $buttons.detach -side left
      attach [button $buttons.help -text "Help"] HelpCommand
      pack $buttons.help -side left
      button $buttons.details -text "Show Details >>>" \
          -command \
          "[list pack $text  -side bottom -anchor sw -pady 5 -expand yes -fill both];\
           [list pack forget $buttons.details]; \
           [list pack $buttons.less_details -side left]"
      pack $buttons.details -side left
      button $buttons.less_details -text "Hide Details <<<" \
          -command \
          "[list pack forget $text];\
           [list pack forget $buttons.less_details]; \
           [list pack $buttons.details -side left]"

      text $text.text -relief sunken -bd 2 -yscrollcommand "$text.scroll set" \
       -height 30 -autosep 1
      scrollbar $text.scroll -command "$text.text yview"
      pack $text.scroll -side right -fill y
      pack $text.text -expand yes -fill both

      attach $text.text LicenseProblem
      $text.text configure -state disabled

      eval itk_initialize $args
      
      wm minsize $itk_interior 300 0
      wm resizable $itk_interior 1 1
    }
  }
}
