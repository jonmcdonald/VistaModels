
namespace eval ::v2::ui::simulationdialog {
  class BreakOnTimeDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      
      set_title "Simulation Time"
      
      wm minsize $itk_interior 300 0
      wm resizable $itk_interior 1 0
      
      draw
    }

 
    protected method create_buttons {} {
      add_ok_button
      add_button "" -text "Apply" -width 5 -underline 0 -command [code $this AddBreakCommand]
      add_common_buttons
    }

    public method AddBreakCommand {} {
      set time [$itk_component(time) get]
      set units [$document get_variable_value TimeUnits]
      set is_relative [$document get_variable_value IsBreakOnTimeRelative]
      $document run_command BreakOnTimeDialogApplyCommand
      # clear time field
      $itk_component(time) delete 0 end
    }
    
    protected method create_body {} {
      set top [get_body_frame]

      #Break on time
      label $top.label -text "Break on time:"

      frame $top.timeFrame
      itk_component add time {
        entry $top.timeFrame.time
      } {}
      attach $itk_component(time) BreakOnTimeData

      itk_component add units {
        ::UI::BwidgetCombobox $top.timeFrame.units
      } {}
      attach $itk_component(units) TimeUnits TimeUnitsList TimeUnitIndex
      [$itk_component(units) component combobox] configure -width 4
      pack $itk_component(time) -fill x -side left -expand y
      pack $itk_component(units) -side left -expand n 

      #Relative or Absolute
      itk_component add relative {
        radiobutton $top.relative -text "Relative" -value 1
      } {}
      attach $itk_component(relative) IsBreakOnTimeRelative

      itk_component add absolute {
        radiobutton $top.absolute  -text "Absolute" -value 0
      } {}
      attach $itk_component(absolute) IsBreakOnTimeRelative

      pack $top.label -side top -anchor nw -pady 5
      pack $top.timeFrame -fill x -expand y -side top -anchor nw
      pack $itk_component(relative) -side top -anchor nw -pady 5
      pack $itk_component(absolute) -side top -anchor nw 
    }

  } ;#class
} ;#namespace
