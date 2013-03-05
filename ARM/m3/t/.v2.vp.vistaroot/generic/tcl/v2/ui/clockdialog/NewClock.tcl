
namespace eval ::v2::ui::clockdialog {
  class NewClock {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args
      
      wm minsize $itk_interior 280 0
      wm resizable $itk_interior 1 0

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      label $top.name -text "Clock Name:"
      itk_component add name_entry {
        entry $top.name_entry
      } {}
      attach $itk_component(name_entry) ClockName

      label $top.period -text "Period:"
      itk_component add period_entry {
        entry $top.period_entry
      } {}
      attach $itk_component(period_entry) Period

      label $top.timeunit -text "Time Unit:"
      itk_component add timeunit_combo {
        ::UI::BwidgetCombobox $top.timeunit_combo -editable 0
      } {}
      attach $itk_component(timeunit_combo) TimeUnit AllTimeUnits

      label $top.dutycycle -text "Duty Cycle:"
      itk_component add dutycycle_entry {
        entry $top.dutycycle_entry
      } {}
      attach $itk_component(dutycycle_entry) DutyCycle

      label $top.edgetime -text "First Edge Time:"
      itk_component add edgetime_entry {
        entry $top.edgetime_entry
      } {}
      attach $itk_component(edgetime_entry) FirstEdgeTime

      label $top.edgevalue -text "First Edge Value:"
      itk_component add edgevalue_combo {
        ::UI::BwidgetCombobox $top.edgevalue_combo -editable 0
      } {}
      attach $itk_component(edgevalue_combo) FirstEdgeValue AllValues

      grid $top.name                       -row 0 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(name_entry)      -row 0 -column 1 -padx 5 -pady 5 -sticky ew
      grid $top.period                     -row 1 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(period_entry)    -row 1 -column 1 -padx 5 -pady 5 -sticky ew
      grid $top.timeunit                   -row 2 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(timeunit_combo)  -row 2 -column 1 -padx 5 -pady 5 -sticky ew
      grid $top.dutycycle                  -row 3 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(dutycycle_entry) -row 3 -column 1 -padx 5 -pady 5 -sticky ew
      grid $top.edgetime                   -row 4 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(edgetime_entry)  -row 4 -column 1 -padx 5 -pady 5 -sticky ew
      grid $top.edgevalue                  -row 5 -column 0 -padx 5 -pady 5 -sticky w
      grid $itk_component(edgevalue_combo) -row 5 -column 1 -padx 5 -pady 5 -sticky ew
      grid columnconfigure $top 0 -weight 0 
      grid columnconfigure $top 1 -weight 1 
    }
  }
}

