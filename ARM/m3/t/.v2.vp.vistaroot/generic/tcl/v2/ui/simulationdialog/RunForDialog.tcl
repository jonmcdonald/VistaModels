
namespace eval ::v2::ui::simulationdialog {
  class RunForDialog {
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
      add_ok_button Go
      add_common_buttons
    }

    protected method create_body {} {
      set top [get_body_frame]

      #Break on time
      label $top.label -text "Run for:"

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

      pack $top.label -side top -anchor nw -pady 5
      pack $top.timeFrame -fill x -expand y -side top -anchor nw
    }

  } ;#class
} ;#namespace
