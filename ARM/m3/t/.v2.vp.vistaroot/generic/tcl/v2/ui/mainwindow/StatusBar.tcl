#tcl-mode
option add *StatusBar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *StatusBar.background \#e0e0e0 widgetDefault
option add *StatusBar.foreground black widgetDefault

namespace eval ::v2::ui::mainwindow {
  class StatusBar {
    inherit ::UI::StatusBar 
    private variable ui_simulation_document
    constructor {_document args} {
      ::UI::StatusBar::constructor $_document
      set ui_simulation_document [$_document create_tcl_sub_document DocumentTypeSimulationGUI]
    } {
      eval itk_initialize $args
      itk_component add time_button_and_label {
        button $itk_component(status).time_button_and_label -text "Time:"
      } {
        keep -background -disabledforeground -foreground -font
      }

      $itk_component(status).time_button_and_label config \
          -disabledforeground black \
          -foreground black \
          -borderwidth 0 \
          -padx 0 -pady 0 \
          -relief flat \
          -highlightthickness 0

      attachToDocument $ui_simulation_document $itk_component(status).time_button_and_label UpdateSimulationCommand
      ::UI::Button/DocumentLinkerObject attach_button_label_to_data $itk_component(status).time_button_and_label $ui_simulation_document CurrentTimeForView
   
      itk_component add status_indicator {
        ::v2::ui::simulation::StatusIndicator $itk_component(status).status_indicator $ui_simulation_document
      } {

      }


      attachToDocument $ui_simulation_document $itk_component(status_indicator) IsGdbAlive
    }

    destructor {
      catch {
        delete object $ui_simulation_document
      }
    }

    public method show {} {
      pack $itk_component(time_button_and_label) -side left
      pack $itk_component(status_indicator) -side left -padx 3 -anchor e
      ::UI::StatusBar::show
    }
  }
}
