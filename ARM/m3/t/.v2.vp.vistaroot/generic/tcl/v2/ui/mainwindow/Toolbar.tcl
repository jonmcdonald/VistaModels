#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::mainwindow {
  
  class Toolbar {
    inherit ::v2::ui::SimulationToolbar

    private variable ui_simulation_document

    constructor {_document args} {
      ::v2::ui::SimulationToolbar::constructor $_document
      set ui_simulation_document [$_document create_tcl_sub_document DocumentTypeSimulationGUI]
    } {
      set sub_document_name DocumentTypeSimulationGUI
      eval itk_initialize $args
      fill_toolbar
    }

    destructor {
      catch {
        if {[find objects $ui_simulation_document] != {}} {
          delete object $ui_simulation_document
        }
      }
    }
    
    private method fill_toolbar {} {
      set buttons [frame [get_frame].buts -bg $itk_option(-background)] 
      
      create_left $buttons
      create_right $buttons
      
      pack $buttons -side top -anchor w -fill both -expand 1
    }
    
    private method create_left {buttons} {
      ### Buttons
      # types view
      addCheckButton $buttons project_view "add_browser" 1 ShowTreeView "Browser Pane"
      addCheckButton $buttons design_view "add_editor" 1  ShowTextualView "Text Pane"
      addCheckButton $buttons code_view "add_msg" 1  ShowCompilationView "Messages Pane"
#      addCheckButton $buttons mbconsole_view "add_msg" 1  ShowMBConsoleView "Modeling Console"
      addSeparator $buttons sep_views

      pack_left $buttons project_view design_view code_view sep_views

      addButton $buttons newtext "new_text" OpenFileDialogCommand "New Text File"      
      addButton $buttons block_diagram "block_diagram" CreateNewBlockDiagramCommand "New Schematic"
      addButton $buttons new_model "model-template" CreateNewPapoulisModelCommand "New Model" 

      addButtonWithMenuButton $buttons create_top "create_top" OpenScMainFileDialogCommand "New sc_main.." \
          "::v2::ui::mainwindow::CreateTopButtonMenu"

      addButton $buttons build "build" EmacsBuildCommand \
          "Build Project" Target "prepare all"
#      addButton $buttons rebuild "rebuild" EmacsBuildCommand "Rebuild Project" Target  "clean prepare all"
#      addButton $buttons build_design "build_design" EmacsBuildExecutableCommand "Build Executable" BuildTypeArgument build
#      addButton $buttons build_tree "build_tree" EmacsBuildCommand "Build Tree" Target full
#      addButton $buttons rebuild_tree "rebuild_tree" EmacsBuildCommand   "Rebuild Tree" Target full_rebuild
      
      addButton $buttons simulate "simulate" \
          {DocumentTypeSimulationGUI OpenStartSimulationDialog} "Simulate Top"

      addSeparator $buttons sep_flow
      pack_left $buttons newtext new_model  block_diagram build create_top simulate 
      
      if {[::Utilities::safeGet ::env(V2_DISABLE_ANALYSIS)] != "1"} {
        addButton $buttons analyze "analysis_results" OpenAnalysisCommand "Open Analysis ..."
      }

      if {[::Utilities::safeGet ::env(V2_DISABLE_ANALYSIS)] != "1"} {
        pack_left $buttons analyze 
      }
      addButton $buttons virtual_prototype "virtual_prototype" OpenVPDialogCommand "Create Virtual Prototype"

      pack_left $buttons virtual_prototype sep_flow

      # addButton $buttons model_builder "vista_pwr" OpenVistaPowerCommand "Open Vista Power ..."
#       addSeparator $buttons sep_model_builder

      #pack_left $buttons model_builder sep_model_builder

      addButton $buttons catapult "catapult" OpenCatapultCommand "Open Catapult ..."
      addSeparator $buttons sep_catapult

      pack_left $buttons catapult sep_catapult

      pack $buttons -side top -anchor w


      # compilation and simulation commands
      # addButton $buttons compile  "compile" EmacsCompileProjectCommand \
#           "Compile"
#       addButton $buttons kill_compile  "kill_compile" EmacsKillCompilationCommand \
#           "Abort Compilation"
#       addButton $buttons validate  "validate" ValidateDesignCommand \
#           "Validate"

    }
    
    private method create_right {buttons} {
    }

    public method create_simulation_toolbar {} {
      create_sim_buttons
      
      addHorizontalSeparator $sim_buttons horiz_sep
      pack $sim_buttons.horiz_sep -side top -anchor w -fill x
      
      fill_common_simulation_toolbar

      addSeparator $sim_buttons sim_sep_mw

      # simulation control
      addButton $sim_buttons simulation_control "simulation_control" \
          OpenSimulationControlCommand "Open Simulation Control..."
      addSeparator $sim_buttons sim_sc


      #memory_profiling
       if {[::Utilities::safeGet ::env(V2_ENABLE_MEMORY_PROFILING)] == "1"} {
        addButton $sim_buttons memory_profiling "add_to_plot" {DocumentTypeSimulationGUI OpenProfilingCommand} "Open Memory Profiling ..."
        addSeparator $sim_buttons profiling_sep
      }

      # memory view
      addButton $sim_buttons memory_view "memory_view" \
          OpenMemoryViewCommand "Open Memory View..."
      addSeparator $sim_buttons mem_sep

      # stack
      label $sim_buttons.lbl_stk -text "Stack:"
      ::UI::BwidgetCombobox $sim_buttons.stack -editable 0
      attachToDocument $ui_simulation_document $sim_buttons.stack CurrentStackFrameData \
          CurrentStackForView CurrentStackLevel
      addButton $sim_buttons print_stack "print_stack" \
          {DocumentTypeSimulationGUI StackPrintCommand} "Print Stack"
      
      # Processes 
      label $sim_buttons.lbl_proc -text "Processes: "

      ::UI::BwidgetCombobox $sim_buttons.processes -editable 0 
      attachToDocument $ui_simulation_document $sim_buttons.processes CurrentProcessFrameData \
          ProcessVisibleNameList CurrentProcessIndex
      addButton $sim_buttons print_processes "print_stack" \
         {DocumentTypeSimulationGUI ProcessesPrintCommand} "Print Processes"


      pack $sim_buttons.sim_sep_mw  -side left -anchor w
      pack $sim_buttons.simulation_control -side left -anchor w
      pack $sim_buttons.sim_sc  -side left -anchor w
      pack $sim_buttons.memory_view -side left -anchor w
      if {[::Utilities::safeGet ::env(V2_ENABLE_MEMORY_PROFILING)] == "1"} {
        pack $sim_buttons.memory_profiling -side left -anchor w
        pack $sim_buttons.profiling_sep  -side left -anchor w
      }
      pack $sim_buttons.mem_sep  -side left -anchor w
      pack $sim_buttons.lbl_stk -side left -anchor w
      pack $sim_buttons.stack -side left -anchor w  -fill x -expand y
      pack $sim_buttons.print_stack -side left -anchor w
      pack $sim_buttons.lbl_proc -side left -anchor w
      pack $sim_buttons.processes -side left -anchor w -fill x -expand y
      pack $sim_buttons.print_processes -side left -anchor w
    }
  }
}
