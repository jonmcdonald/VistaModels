namespace eval ::v2::ui {
  class SimulationMenu {
    inherit ::UI::FrameMenu ::v2::ui::SimulationInterface
    
    constructor {_document args} {
      ::UI::FrameMenu::constructor $_document
    } {
      eval itk_initialize $args
      configure -height 30
    }
    
    protected method fill_simulation_menu {} {
      set topMenu [createHeaderMenu "Simulation"]

      add_menu_item $topMenu [get_command_string OpenStartSimulationDialog] command \
          -label "Simulate" -underline 0
      add_menu_item $topMenu [get_command_string PostSimulateCommand] command \
          -label "Open Simulation" -underline 0
      add_menu_item $topMenu [get_command_string LoadSimulationCommand] command \
          -label "Load Simulation ..." -underline 0
      add_menu_item $topMenu [get_command_string OpenResimulateDialog] command \
          -label "Re-simulate" -underline 0
      add_menu_item $topMenu [get_command_string QuitCommand] command \
          -label "Quit Simulation" -underline 0
      addSeparator $topMenu

      add_menu_item $topMenu [get_command_string ContinueCommand] command \
          -label "Continue" -underline 0
      add_menu_item $topMenu [get_command_string OpenRunForDialog] command \
          -label "Run for ..." -underline 2

      add_menu_item $topMenu [get_command_string PauseCommand] command \
          -label "Pause" -underline 0
      if {[info exists ::env(NCSC_CDS_ROOT)]} {
        add_menu_item $topMenu [get_command_string SendSIGINTCommand] command \
            -label "Go to ncsim prompt" -underline 6
      }
      if {[::v2::mti::is_mti_active]} {
        add_menu_item $topMenu {DocumentTypeSimulationGUI SendSIGINTCommand} command \
            -label "Go to vsim prompt" -underline 7
      }
      if {[::v2::socd::is_socd_active]} {
        add_menu_item $topMenu {DocumentTypeSimulationGUI SendSIGINTCommand} command \
            -label "Stop in SoCD" -underline 7
      }
      addSeparator $topMenu
      
      add_menu_item $topMenu [get_command_string UntilCommand] command -label "Step Until Line" -underline 6
      add_menu_item $topMenu [get_command_string StepCommand] command -label "Step Into" -underline 5
      add_menu_item $topMenu [get_command_string NextCommand] command -label "Step Over" -underline 6
      add_menu_item $topMenu [get_command_string FinishCommand] command -label "Step Out" -underline 6
      add_menu_item $topMenu [get_command_string StepToNextProcessCommand] command \
          -label "Step to Next Process" -underline 13
      add_menu_item $topMenu [get_command_string StepToNextDeltaCycleCommand] command \
          -label "Step to Next Cycle" -underline 14
      add_menu_item $topMenu [get_command_string StepToNextTimeCommand] command \
          -label "Step to Next Time" -underline 13
      addSeparator $topMenu
      
      add_menu_item $topMenu [get_command_string StackPrintCommand] command \
          -label "Print Stack" -underline 10
      add_menu_item $topMenu [get_command_string ProcessesPrintCommand] command \
          -label "Print Processes" -underline 7 
      addSeparator $topMenu

      add_menu_item $topMenu [get_command_string OpenMemoryViewCommand] command \
          -label "Memory View..." -underline 1
      if {[::Utilities::safeGet ::env(V2_ENABLE_MEMORY_PROFILING)] == "1"} {
        add_menu_item $topMenu [get_command_string OpenProfilingCommand] command \
            -label "Memory Profiling..." -underline 13
      }
      addSeparator $topMenu
      

      add_menu_item $topMenu "ShowSmallHelp" checkbutton -label "Automatic Display of Variables"

      addSeparator $topMenu
      set radix_submenu [addSubMenu $topMenu radix_submenu -label "Radix" -underline 4]
      $radix_submenu insert end command -label "Binary" -underline 0 
      attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "b" RadixType value
      $radix_submenu insert end command -label "Octal" -underline 0 
      attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "o" RadixType value
      $radix_submenu insert end command -label "Decimal" -underline 0 
      attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "d" RadixType value
      $radix_submenu insert end command -label "Hexadecimal" -underline 0
      attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "x" RadixType value

      set array_index_submenu [addSubMenu $topMenu array_index_submenu -label "Index Radix"]
      $array_index_submenu insert end command -label "Binary" -underline 0 
      attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "b" RadixType index
      $array_index_submenu insert end command -label "Octal" -underline 0 
      attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "o" RadixType index
      $array_index_submenu insert end command -label "Decimal" -underline 0 
      attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "d" RadixType index
      $array_index_submenu insert end command -label "Hexadecimal" -underline 0
      attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "x" RadixType index

      add_menu_item $topMenu  [get_command_string OpenArrayRangeDialog] command -label "Range ..." 
      add_menu_item $topMenu  [get_command_string OpenPropertiesDialog] command -label "Radix and Range Options ..." 
        
    }
    
    protected method fill_trace_menu {} {
      set topMenu [createHeaderMenu "Trace"]
      add_menu_item $topMenu [get_command_string TraceSelectionCommand] command \
          -label "Trace"
      add_menu_item $topMenu [get_command_string UntraceSelectionCommand] command \
          -label "Untrace"
      $topMenu insert end command -label "Trace Dialog ..." -underline 11
      attach_menu_item $topMenu end [get_command_string OpenTraceDialogCommand]

      add_menu_item $topMenu TraceMode radiobutton -value "trace_socket_with_data_and_phase"  -label "Trace Socket with Data and Phase" -underline 18
      add_menu_item $topMenu TraceMode radiobutton -value "trace_socket_only" -label "Trace Socket Only" -underline 13

      add_menu_item $topMenu AccelerateAnalysis checkbutton -label "Accelerate Analysis" 
      addSeparator $topMenu

      add_menu_item $topMenu [get_command_string TransactionViewCommand] command \
          -label "Transactions View" -underline 13
      addSeparator $topMenu
      add_menu_item $topMenu [get_command_string TlmTraceSelectionCommand] command \
          -label "Trace Transactions"
      add_menu_item $topMenu [get_command_string TlmUntraceSelectionCommand] command \
          -label "Untrace Transactions"
      add_menu_item $topMenu [get_command_string OpenTraceTransactionsDialogCommand] command -label "Trace Transactions Dialog ..."
      addSeparator $topMenu

      add_menu_item $topMenu [get_command_string UntraceAllCommand] command \
          -label "Untrace All"
      addSeparator $topMenu
      add_menu_item $topMenu [get_command_string OpenNewWaveCommand] command -label "New Wave" \
          -underline 2
      add_menu_item $topMenu AcquireMode radiobutton -value "acquire_and_trace"  -label "Acquire and Trace" -underline 12
      add_menu_item $topMenu AcquireMode radiobutton -value "acquire_only" -label "Acquire Only" -underline 8

      attach $topMenu [get_command_string AcquireMenuDataList]
      add_menu_item $topMenu [get_command_string OpenAcquireDialogCommand] command -label "Acquire Dialog ..."
      addSeparator $topMenu
      add_menu_item $topMenu [get_command_string AcquireToAnalysisCommand] command -label "Acquire to Analysis"
      add_menu_item $topMenu [get_command_string OpenAcquireToAnalysisDialogCommand] command -label "Acquire to Analysis Dialog ..."
   }


    protected method fill_breakpoints_menu {} {
      set breakpoints_submenu [createHeaderMenu "Breakpoints"]
      
      add_menu_item $breakpoints_submenu [get_command_string AddBreakpointsCommand] command \
          -label "Set Breakpoint" -underline 4
      add_menu_item $breakpoints_submenu [get_command_string OpenBreakOnTimeDialog] command \
          -label "Break at Time..." -underline 9
      addSeparator $breakpoints_submenu
      
#      add_menu_item $breakpoints_submenu DummyCommand command -label "Filter Breakpoints..." -underline 0
#      addSeparator $breakpoints_submenu

      add_menu_item $breakpoints_submenu [get_command_string DisableBreakpointsCommand] command \
          -label "Disable Breakpoint" -underline 0
      add_menu_item $breakpoints_submenu [get_command_string EnableBreakpointsCommand] command \
          -label "Enable Breakpoint" -underline 0
      add_menu_item $breakpoints_submenu [get_command_string DeleteBreakpointsCommand] command \
          -label "Delete Breakpoint" -underline 8
      addSeparator $breakpoints_submenu

      add_menu_item $breakpoints_submenu [get_command_string DisableAllBreakpointsCommand] command \
          -label "Disable All Breakpoints" -underline 1
      add_menu_item $breakpoints_submenu [get_command_string EnableAllBreakpointsCommand] command \
          -label "Enable All Breakpoints" -underline 1
      add_menu_item $breakpoints_submenu [get_command_string DeleteAllBreakpointsCommand] command \
          -label "Delete All Breakpoints" -underline 15
      addSeparator $breakpoints_submenu

      add_menu_item $breakpoints_submenu [get_command_string SaveBreakpointsCommand] command \
          -label "Save Breakpoints" -underline 0
      add_menu_item $breakpoints_submenu [get_command_string LoadBreakpointsCommand] command \
          -label "Load Breakpoints" -underline 0
    }

    protected method fill_watches_menu {} {
      set watch_submenu [createHeaderMenu "Watch"]
      
      add_menu_item $watch_submenu [get_command_string OpenInspectDialog] command \
          -label "Open Inspect Dialog" -underline 0
      add_menu_item $watch_submenu [get_command_string AddWatchRootsCommand] command \
          -label "Add to Watches" -underline 0
      addSeparator $watch_submenu
      
#      add_menu_item $watch_submenu DummyCommand command -label "Filter Watches..." -underline 0
#      addSeparator $watch_submenu 
      
      add_menu_item $watch_submenu [get_command_string DeleteWatchRootsCommand] command \
          -label "Delete Watch" -underline 0 
      add_menu_item $watch_submenu [get_command_string DeleteAllWatchRootsCommand] command \
          -label "Delete All Watches" -underline 11
      addSeparator $watch_submenu 
      
      add_menu_item $watch_submenu [get_command_string SaveWatchRootsCommand] command \
          -label "Save Watches" -underline 0 

      add_menu_item $watch_submenu [get_command_string LoadWatchRootsCommand] command \
          -label "Load Watches" -underline 0 
    }
  }
}
