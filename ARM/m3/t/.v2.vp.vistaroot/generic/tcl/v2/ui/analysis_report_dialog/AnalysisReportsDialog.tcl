
namespace import -force ::itcl::*

namespace eval ::v2::ui::analysis_report_dialog {

  class AnalysisReportsDialog {
    inherit ::UI::BaseDialog

    private variable simDir

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
#      puts "Reports window id is [$_document get_ID]"
#      puts "document=$document"

#      puts "name = [$document get_variable_name ReportsSimulationDirectory]"
      
      set simDir [$document get_variable_value ReportsSimulationDirectory]
      ::UI::auto_trace variable [$document get_variable_name ReportsSimulationDirectory] w $itk_interior [::itcl::code $this on_change_simulation_directory]

      create_body
      create_buttons
      eval itk_initialize $args
      draw
    }

    public method ReportsOKCommand {}
    public method ReportsApplyCommand {}
    public method on_change_simulation_directory {}
    
    protected method create_body {}
    protected method create_buttons {}
    protected method set_geometry {}

    private method create_dump_events_part {}
    private method set_dump_events_dialog {}
    private method set_instance_activity_dialog {}
    private method reportTypeChanged {}
    private method selectInstanceChanged {}

  } ;#class

  body AnalysisReportsDialog::create_body {} {

    set main_fr [get_body_frame]

    labelframe $main_fr.l_type -labelanchor nw -text  "Report type"

    itk_component add dump_events {
      radiobutton $main_fr.l_type.dump_events -text "Transaction Report" \
          -value dump_events -command [code $this reportTypeChanged]
    } {}
    
    itk_component add instance_activity {
      radiobutton $main_fr.l_type.instance_activity -text "Summary Report" \
          -value instance_activity -command [code $this reportTypeChanged]
    } {}

    attach $itk_component(dump_events) ReportType
    attach $itk_component(instance_activity) ReportType

    pack $itk_component(dump_events) $itk_component(instance_activity) -side left -anchor w -padx 5 -pady 5
    pack $main_fr.l_type -side top -anchor w -fill x -pady 5

    labelframe $main_fr.l_dir -labelanchor nw -text "Simulation Directory"

    itk_component add dir_path {
      ::UI::FileChooser $main_fr.l_dir.dir_path \
          -browsetype directory \
          -initialdir $simDir \
          -dialogtitle "Select Simulation Directory" \
          -filenamevariable [$document get_variable_name ReportsSimulationDirectory]
    } {}
    
    pack $itk_component(dir_path) -side top -anchor w -padx 5 -pady 5 -fill x
    pack $main_fr.l_dir -side top -anchor w -fill x -pady 5

    labelframe $main_fr.l_file -labelanchor nw -text "File path"

    itk_component add file_path {
      ::UI::FileChooser $main_fr.l_file.file_path \
          -buttoncmdtype savefile \
          -dialogtitle "Select Report Results File" \
          -filenamevariable [$document get_variable_name ReportFilePath]
    } {}
    
    pack $itk_component(file_path) -side top -anchor w -padx 5 -pady 5 -fill x
    pack $main_fr.l_file -side top -anchor w -fill x -pady 5
    
    itk_component add instance_fr {
      frame $main_fr.instance_fr
    } {}

    ####
    itk_component add dump_inst_fr {
      labelframe $itk_component(instance_fr).l_dump -labelanchor nw -text "Select instance"
    } {}
    
    itk_component add radio_fr {
      frame $itk_component(dump_inst_fr).radio_fr
    } {}
    
    itk_component add all_instances {
      radiobutton $itk_component(radio_fr).all_instances -text "All instances" -value 0 \
          -command [code $this selectInstanceChanged]
    } {}
    attach $itk_component(all_instances) IsDumpInstance

    itk_component add select_instance {
      radiobutton $itk_component(radio_fr).select_instance -text "Selected instance" -value 1 \
          -command [code $this selectInstanceChanged]
    } {}
    attach $itk_component(select_instance) IsDumpInstance
    
    set inst_chooser_fr [frame $itk_component(dump_inst_fr).inst_chooser_fr -relief sunken -bd 1] 

    itk_component add instance_chooser {
      v2::ui::analysis_report_dialog::DesignInstanceChooser $itk_component(dump_inst_fr).instance \
          -instancevariable [$document get_variable_name InstancePath] \
          -parent_document $document \
          -simulation_dir $simDir
    } {}

    attach $itk_component(instance_chooser) InstancePath
    
    pack $itk_component(select_instance) $itk_component(all_instances) -side left -padx 5
    pack $itk_component(radio_fr)         -side top   -anchor w  -pady 5
    pack $itk_component(instance_chooser) -side top   -anchor w  -padx 5 -pady 5 -fill x
    ####
    pack $itk_component(dump_inst_fr) -side top -anchor w -pady 5 -fill x
    pack $itk_component(instance_fr) -side top -anchor w -fill x -pady 5

    create_dump_events_part 
    reportTypeChanged
  }

  body AnalysisReportsDialog::create_buttons {} {
    add_button "" -text "OK" -width 5 -underline 0 -command [code $this ReportsOKCommand]
    add_button "" -text "Apply" -width 5 -underline 0 -command [code $this ReportsApplyCommand]
    add_common_buttons
  }

  body AnalysisReportsDialog::set_geometry {} {
    wm minsize $itk_interior 500 0
    wm resizable $itk_interior 1 1
  }

  body AnalysisReportsDialog::create_dump_events_part {} {
    
    itk_component add options_fr {
      labelframe $itk_component(instance_fr).l_options -labelanchor nw -text "Options"
    } {}

    itk_component add is_tlm {
      ::UI::Checkbutton $itk_component(options_fr).is_tlm -text "Transactions"
    } {}
    attach $itk_component(is_tlm) IsTransactions
    
     itk_component add is_variable {
       ::UI::Checkbutton $itk_component(options_fr).is_var -text "Attributes"
     } {}
    attach $itk_component(is_variable) IsVariables

    label $itk_component(options_fr).time_s -text "Start time"
    label $itk_component(options_fr).time_f -text "Finish time"
    
    itk_component add start_time {
      entry $itk_component(options_fr).start_time
    } {}
    attach $itk_component(start_time) StartTime

    itk_component add finish_time {
      entry $itk_component(options_fr).finish_time
    } {}
    attach $itk_component(finish_time) FinishTime

    itk_component add time_units {
      ::UI::BwidgetCombobox $itk_component(options_fr).time_units -editable 0
    } {}
    [$itk_component(time_units) component combobox] configure -width 4
    attach $itk_component(time_units) TimeUnits TimeUnitsList TimeUnitIndex
#     setBwidgetComboboxBindings $itk_component(time_units) TimeUnits

    label $itk_component(options_fr).time_units_label -text [$document get_variable_value TimeUnits]
    attach $itk_component(options_fr).time_units_label TimeUnits

    grid $itk_component(is_tlm) -row 0 -column 0 -sticky nw -padx 1 -pady 3
    grid $itk_component(is_variable) -row 0 -column 1 -sticky nw -padx 1 -pady 3
    grid $itk_component(options_fr).time_s -row 1 -column 0 -sticky nw -padx 10 -pady 3
    grid $itk_component(start_time) -row 1 -column 1 -sticky ew -padx 10 -pady 2
    grid $itk_component(time_units) -row 1 -column 2 -sticky nw -padx 3 -pady 3
    grid $itk_component(options_fr).time_f -row 2 -column 0 -sticky nw -padx 10 -pady 3
    grid $itk_component(finish_time) -row 2 -column 1 -sticky ew -padx 10 -pady 2
    grid $itk_component(options_fr).time_units_label -row 2 -column 2 -sticky nw -padx 3 -pady 3

    grid rowconfig $itk_component(options_fr) 0 -weight 1
    grid columnconfig $itk_component(options_fr) 1 -weight 1
    
  }

  body AnalysisReportsDialog::set_dump_events_dialog {} {
    pack $itk_component(options_fr) -side bottom -anchor w -pady 5 -fill x
    selectInstanceChanged
  }

  body AnalysisReportsDialog::set_instance_activity_dialog {} {
    pack forget $itk_component(options_fr)
    selectInstanceChanged
  }

  body AnalysisReportsDialog::reportTypeChanged {} {
    
    if {[$document get_variable_value ReportType] == "dump_events"} {
      set_dump_events_dialog  
    } else {
      set_instance_activity_dialog
    }
  }

  body AnalysisReportsDialog::selectInstanceChanged {} {
    if {[$document get_variable_value IsDumpInstance] == 1} {
      $itk_component(instance_chooser) enable
    } else {
      $itk_component(instance_chooser) disable
      $document set_variable_value InstancePath ""
    }
  }

  body AnalysisReportsDialog::ReportsOKCommand {} {
    $document run_command OKCommand
  }

  body AnalysisReportsDialog::ReportsApplyCommand {} {
    $document run_command ApplyCommand
  }
  
  body AnalysisReportsDialog::on_change_simulation_directory {} {
    $itk_component(instance_chooser) config -simulation_dir [$document get_variable_value ReportsSimulationDirectory]
  }


} ;#namespace
