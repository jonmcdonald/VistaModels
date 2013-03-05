namespace eval ::v2::ui {
  
  class AcquireModePopupMenu {
    usual AcquireModePopupMenu {}
    inherit ::UI::PopupMenu
    
    constructor {_document args} {
      ::UI::PopupMenu::constructor $_document
    } {
      eval itk_initialize $args
    }
    
    public method fill_menu {} {
      add_menu_item $itk_component(menu) AcquireMode radiobutton -value "acquire_and_trace"  -label "Acquire and Trace" -underline 12
      add_menu_item $itk_component(menu) AcquireMode radiobutton -value "acquire_only" -label "Acquire Only" -underline 8
    }
  }


  class TraceModePopupMenu {
    usual TraceModePopupMenu {}
    inherit ::UI::PopupMenu
    
    constructor {_document args} {
      ::UI::PopupMenu::constructor $_document
    } {
      eval itk_initialize $args
    }
    
    public method fill_menu {} {
      add_menu_item $itk_component(menu) TraceMode radiobutton -value "trace_socket_with_data_and_phase"  -label "Trace Socket with Data and Phase" -underline 18
      add_menu_item $itk_component(menu) TraceMode radiobutton -value "trace_socket_only" -label "Trace Socket Only" -underline 13
    }
  }


  


    
  class SimulationToolbar {
    inherit ::UI::Toolbar ::v2::ui::SimulationInterface
    
    protected variable sim_buttons

    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30
      eval itk_initialize $args
    }

        
    public method hide_simulation_toolbar {} {
      if {[info exists sim_buttons] && [winfo manager $sim_buttons] != ""} {
        pack forget $sim_buttons
      }
    }

    public method show_simulation_toolbar {} {
      pack $sim_buttons -side top -anchor w -fill x
    }

    public method create_sim_buttons {} {
      set sim_buttons [frame [get_frame].sim_buts -bg $itk_option(-background)]
    }
    
    public method fill_common_simulation_toolbar {} {
      addCommandMenuButton $sim_buttons acquire ":tag:AcquireMode" \
          [get_command_string AcquireFromToolbarCommand] "Acquire" \
          [get_command_string AcquireMenuDataList]
      addArrowWithMenuToButton $sim_buttons acquire ::v2::ui::AcquireModePopupMenu "Change Acquire Mode"
      
      #analyze
      addButton $sim_buttons acquire_analysis "acquire_analysis" \
          [get_command_string AcquireToAnalysisCommand] "Acquire to Analysis" 


      #trace
      #addButton $sim_buttons trace "trace" [get_command_string TraceSelectionCommand] "Trace" 
      
      addCommandMenuButton $sim_buttons trace ":tag:TraceMode" \
          [get_command_string TraceSelectionCommand] "Trace" 

      addArrowWithMenuToButton $sim_buttons trace ::v2::ui::TraceModePopupMenu "Change Trace Socket Mode"
      
      

      addButton $sim_buttons untrace "untrace" \
          [get_command_string UntraceSelectionCommand] "Untrace" 

      addButton $sim_buttons view_transaction "view_transaction" \
          [get_command_string TransactionViewCommand] "Transactions View"

      addButton $sim_buttons trace_transaction "trace_transaction" \
          [get_command_string TlmTraceSelectionCommand] "Trace Transactions" 
      
      addButton $sim_buttons untrace_transaction "untrace_transaction" \
          [get_command_string TlmUntraceSelectionCommand] "Untrace Transactions" 
      
      if {[info exists ::env(V2_LOG_ZOOMS)]} {
        addButton $sim_buttons.zoom "trace" [get_command_string RunZooms] "Test Zoom"
      }
      addButton $sim_buttons continue "continue" [get_command_string ContinueCommand] "Continue"
      addButton $sim_buttons runfor "runfor" [get_command_string OpenRunForDialog] "Run for ..."
      addButton $sim_buttons resimulate "resimulate" \
          [get_command_string OpenResimulateDialog] "Re-simulate"
      addButton $sim_buttons abort "pause" [get_command_string PauseCommand] "Pause"
      if {[info exists ::env(NCSC_CDS_ROOT)]} {
        addButton $sim_buttons ncprompt "ncprompt" [get_command_string SendSIGINTCommand] "Go to ncsim prompt"
      }

      if {[::v2::mti::is_mti_active]} {
        addButton $sim_buttons mti_prompt "mti_prompt" {DocumentTypeSimulationGUI SendSIGINTCommand} "Go to vsim prompt"
      }
      if {[::v2::socd::is_socd_active]} {
        addButton $sim_buttons socd_prompt "socd_prompt" {DocumentTypeSimulationGUI SendSIGINTCommand} "Stop in SoCD"
      }

      addButton $sim_buttons quit "quit" [get_command_string QuitCommand] "Quit"
      addSeparator $sim_buttons sim_sep1 

      addButton $sim_buttons watch "watch" [get_command_string AddWatchRootsCommand] "Add to Watch"
      addButton $sim_buttons openInspect "inspect" [get_command_string OpenInspectDialog] "Open Inspect Dialog"
      addButton $sim_buttons break "break" [get_command_string AddBreakpointsCommand] "Break"
      addButton $sim_buttons bp_on_time "bp_on_time" \
          [get_command_string OpenBreakOnTimeDialog] "Break on time"
      addButton $sim_buttons delete_bp "delete_bp" \
          [get_command_string DeleteBreakpointsCommand] "Delete Breakpoints"
      addButton $sim_buttons until "until" [get_command_string UntilCommand] "Step Until Line"
      addButton $sim_buttons step_in "step_in" [get_command_string StepCommand] "Step Into"
      addButton $sim_buttons step_over "step_over" [get_command_string NextCommand] "Step Over" 
      addButton $sim_buttons step_out "step_out" [get_command_string FinishCommand] "Step Out" 
      addButton $sim_buttons next_process "next_process" \
          [get_command_string StepToNextProcessCommand] "Step to Next Process"
      addButton $sim_buttons next_cycle "next_cycle" \
          [get_command_string StepToNextDeltaCycleCommand] "Step to Next Cycle"
      addButton $sim_buttons next_time "next_time" \
          [get_command_string StepToNextTimeCommand] "Step to Next Time"
      addButton $sim_buttons next_software_instruction "until_software" \
          [get_command_string GoToNextSoftwareInstructionCommand] "Next Software Instruction"
      pack_left $sim_buttons \
          acquire acquire_analysis trace untrace view_transaction trace_transaction untrace_transaction continue runfor resimulate \
          abort

      if {[info exists ::env(NCSC_CDS_ROOT)]} {
        pack_left $sim_buttons ncprompt
      }
      if {[::v2::mti::is_mti_active]} {
        ::v2::ui::get_mti_prompt_image
        pack_left $sim_buttons mti_prompt
      }
      if {[::v2::socd::is_socd_active]} {
        ::v2::ui::get_socd_prompt_image
        pack_left $sim_buttons socd_prompt
      }

      pack_left $sim_buttons \
          quit sim_sep1 \
          watch openInspect break bp_on_time delete_bp until step_in step_over step_out next_process next_cycle next_time

      pack_left $sim_buttons next_software_instruction 

      if {[info exists ::env(V2_LOG_ZOOMS)]} {
        pack_left $sim_buttons zoom
      }
    }
  }
}

