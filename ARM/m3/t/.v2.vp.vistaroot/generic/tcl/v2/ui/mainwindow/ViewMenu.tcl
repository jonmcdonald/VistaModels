### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::mainwindow {
  class ViewMenu {
    inherit ::v2::ui::SimulationMenu
    
    constructor {_document args} {
      ::v2::ui::SimulationMenu::constructor $_document
    } {
      eval itk_initialize $args
      set sub_document_name DocumentTypeSimulationGUI
      fill_menu
    }
    
    protected method fill_menu {} {
      fill_file_menu
      fill_edit_menu
      fill_view_menu
#      fill_library_menu
      fill_project_menu
      fill_build_menu
      fill_model_builder_menu
      fill_tools_menu
      fill_simulation_menu
      fill_breakpoints_menu
      fill_trace_menu
      fill_watches_menu
#      fill_version_menu
      fill_window_menu 
      fill_help_menu

    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu OpenLibraryManagerDialog command -label "Open Library Manager ..."  -underline 0
      addSeparator $topMenu
#      add_menu_item $topMenu OpenFileDialogCommand command -label "New File"  -underline 0
      $topMenu insert end command -label "New File..." -underline 0 -accelerator "Ctrl+N"
      attach_menu_item $topMenu end OpenFileDialogCommand IsAddToProject 1
      add_menu_item $topMenu CreateNewPapoulisModelCommand command -label "New Model"  -underline 0
      add_menu_item $topMenu CreateNewPapoulisModelCommand command -label "New RTL impl Model" -underline 4
      attach_menu_item $topMenu end CreateNewPapoulisModelCommand ImplKindArgument rtl
      add_menu_item $topMenu CreateNewBlockDiagramCommand command -label "New Schematic"  -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu CreateNewGraphicalSymbolCommand command -label "New Graphical Symbol"  -underline 0
      addSeparator $topMenu

#      $topMenu insert end command -label "New..." -underline 0 -accelerator "Ctrl+N"
#      attach_menu_item $topMenu end OpenFileDialogCommand IsAddToProject 1
      
      add_menu_item $topMenu EmacsOpenFileCommand command -label "Open..." \
          -underline 0 -accelerator "F2"
      bind $toplevel_widget <KeyRelease-F2>  [code $document run_command EmacsOpenFileCommand]
      
      add_menu_item $topMenu EmacsCloseBufferCommand command -label "Close" -underline 0
      addSeparator $topMenu

      if {[info exists ::env(VISTA_EXTERNAL_EDITOR)] && $::env(VISTA_EXTERNAL_EDITOR) != ""} {
        add_menu_item $topMenu EmacsInvokeExternalEditorCommand command -label "Invoke External Editor"  -underline 0
        addSeparator $topMenu
      }
      
      add_menu_item $topMenu EmacsSaveBufferCommand command -label "Save" -underline 0 -accelerator "F3"
      bind $toplevel_widget <KeyRelease-F3>  [code $document run_command EmacsSaveBufferCommand]
      add_menu_item $topMenu EmacsSaveAsFileCommand command -label "Save As..." -underline 5
      add_menu_item $topMenu EmacsSaveAllCommand command -label "Save All" -underline 6
      addSeparator $topMenu

      add_menu_item $topMenu ReadDocumentDialog command -label "Load Environment..." \
          -underline 5
      addSeparator $topMenu

      add_menu_item $topMenu EmacsPrintBufferCommand command -label "Print..." \
          -underline 0 -accelerator "Ctrl+P"
      add_binding $toplevel_widget [list <Control-P> <Control-p>] \
          "[code $document run_command EmacsPrintBufferCommand]"
      addSeparator $topMenu
      
      add_close_exit_menu $topMenu
    }
    
    private method fill_edit_menu {} {
      set topMenu [createHeaderMenu "Edit"]

      add_menu_item $topMenu EmacsUndoCommand command -label "Undo"  -underline 0 -accelerator "Ctrl+Z"
      add_binding $toplevel_widget [list <Control-Z> <Control-z>] \
                                        "[code $document run_command UndoCommand]"
      add_menu_item $topMenu EmacsRedoCommand command -label "Redo"  -underline 0
      addSeparator $topMenu

      $topMenu insert end command -label "Cut"  -underline 2 -accelerator "Ctrl+X"
      attach_menu_item $topMenu end CutOrCopyCommand IsCutID 1 
      add_binding $toplevel_widget [list <Control-X> <Control-x>] \
          "[code $document run_command CutOrCopyCommand IsCutID 1]"

      $topMenu insert end command  -label "Copy"  -underline 0 -accelerator "Ctrl+C"
      attach_menu_item $topMenu end CutOrCopyCommand IsCutID 0
      add_binding $toplevel_widget [list <Control-C> <Control-c>] \
          "[code $document run_command CutOrCopyCommand IsCutID 0]"
      
      add_menu_item $topMenu PasteCommand command -label "Paste"  \
          -underline 0 -accelerator "Ctrl+V"
      add_binding $toplevel_widget [list <Control-V> <Control-v>] \
          "[code $document run_command PasteCommand]"
      
      add_menu_item $topMenu DeleteCommand command -label "Delete"  \
          -underline 0  -accelerator "Del"
      bind $toplevel_widget <KeyRelease-Delete>  [code $document run_command DeleteCommand]
      addSeparator $topMenu
      
      add_menu_item $topMenu EmacsSelectAllBufferCommand command -label "Select All"  -underline 0 \
          -accelerator "Ctrl+A"
      add_binding $toplevel_widget [list <Control-A> <Control-a>] EmacsSelectAllBufferCommand
      addSeparator $topMenu
      
      $topMenu insert end command  -label "Find..."  -underline 0 -accelerator "Ctrl+F"
      attach_menu_item $topMenu end EmacsFindCommand IsFindNext 0
      add_binding $toplevel_widget [list <Control-F> <Control-f>] \
          "[code $document run_command EmacsFindCommand IsFindNext 0]"
      
      $topMenu insert end command  -label "Find Next"  -underline 5
      attach_menu_item $topMenu end EmacsFindCommand IsFindNext 1

      add_menu_item $topMenu EmacsReplaceCommand command -label "Replace..."  -underline 1 
      addSeparator $topMenu
      
      add_menu_item $topMenu OpenGoToLineDialog command -label "Go To Line..."  -underline 0 
    }

    private method fill_view_menu {} {
      set topMenu [createHeaderMenu "View"]
      
      foreach name {"TreeView" "TextualView" "CompilationView"} \
          label {"Browser Pane" "Text Pane" "Message Pane"} {
            add_menu_item $topMenu "Show$name" checkbutton -label "Show $label" \
                -underline 5 
          }
      addSeparator $topMenu

      add_menu_item $topMenu "ShowFilteringView" checkbutton -label "Show Options Pane" \
                -underline 5 
      addSeparator $topMenu

      add_menu_item $topMenu EmacsToggleMenuBarCommand command -label "Toggle XEmacs Menu"  -underline 14

    }
    
    private method fill_library_menu {} {
      return
      set topMenu [createHeaderMenu "Library"]
      add_menu_item $topMenu OpenLibraryManagerDialog command -label "Open Library Manager ..."  -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu OpenFileDialogCommand command -label "New File"  -underline 0
      add_menu_item $topMenu CreateNewPapoulisModelCommand command -label "New Model"  -underline 0
      add_menu_item $topMenu CreateNewBlockDiagramCommand command -label "New Schematic"  -underline 0
      add_menu_item $topMenu CreateNewGraphicalSymbolCommand command -label "New Graphical"  -underline 0
    }

    private method fill_project_menu {} {

      set topMenu [createHeaderMenu "Project"]
      
      $topMenu insert end command -label "New Project..." -underline 0
      attach_menu_item $topMenu end OpenNewProjectDialog PageIndex 0

      add_menu_item $topMenu LoadProjectCommand command -label "Open Project..." -underline 0
      addSeparator $topMenu
      
      add_project_submenu $topMenu
      addSeparator $topMenu
      
      $topMenu insert end command -label "Settings..." -underline 0 -accelerator "Ctrl+F8"
      attach_menu_item $topMenu end OpenProjectDialog IsSubProject 0
      bind $toplevel_widget <Control-KeyRelease-F8> [code $document run_command OpenProjectDialog]
      addSeparator $topMenu

      add_menu_item $topMenu OpenImportDialog command -label "Import Makefile..." \
          -underline 0
      add_menu_item $topMenu OpenExportDialog command -label "Export Project..." \
          -underline 0
    }  

    private method fill_build_menu {} {
      set topMenu [createHeaderMenu "Build"]

      add_menu_item $topMenu EmacsCompileProjectCommand command \
          -label "Compile" -underline 0
      add_menu_item $topMenu EmacsKillCompilationCommand command \
          -label "Abort Compilation" -underline 0
      
      #project
      $topMenu insert end command -label "Build Project" -underline 0
      attach_menu_item $topMenu end EmacsBuildCommand Target "prepare all"
      $topMenu insert end command -label "Rebuild Project" -underline 0
      attach_menu_item $topMenu end EmacsBuildCommand Target "clean prepare all"
      addSeparator $topMenu
      #executable
      $topMenu insert end command -label "Build Executable" -underline 6
      attach_menu_item $topMenu end EmacsBuildExecutableCommand BuildTypeArgument build 
      $topMenu insert end command -label "Relink Executable" -underline 2
      attach_menu_item $topMenu end  EmacsBuildExecutableCommand BuildTypeArgument relink
      addSeparator $topMenu
      #tree
      $topMenu insert end command -label "Build Tree" -underline 6
      attach_menu_item $topMenu end EmacsBuildCommand Target full
      $topMenu insert end command -label "Rebuild Tree" -underline 1
      attach_menu_item $topMenu end EmacsBuildCommand Target full_rebuild
      if {[info exists ::env(ACHOME)]} {
        addSeparator $topMenu
        $topMenu insert end command -label "Validate" -underline 0
        attach_menu_item $topMenu end ValidateDesignCommand
      }
      #vp
      #addSeparator $topMenu
      #$topMenu insert end command -label "Build Virtual Prototype" -underline 6
      #attach_menu_item $topMenu end EmacsBuildCommand Target full_vp
      #$topMenu insert end command -label "Rebuild Virtual Prototype" -underline 1
      #attach_menu_item $topMenu end EmacsBuildCommand Target full_rebuild_vp
      #vp
      #addSeparator $topMenu
      #$topMenu insert end command -label "Build Virtual Prototype for Windows" -underline 6
      #attach_menu_item $topMenu end EmacsBuildCommand Target full_vp Flags V2_MODEL=wine32
      #$topMenu insert end command -label "Rebuild Virtual Prototype for Windows" -underline 1
      #attach_menu_item $topMenu end EmacsBuildCommand Target full_rebuild_vp Flags V2_MODEL=wine32
    }
    private method fill_model_builder_menu {} {

      set topMenu [createHeaderMenu "Modeling"]

      add_menu_item $topMenu CreateNewPapoulisModelCommand command \
          -label "Create New Model ..." -underline 0
      add_menu_item $topMenu CreateNewPapoulisModelCommand command \
          -label "Create New RTL impl Model ..." -underline 11
      attach_menu_item $topMenu end CreateNewPapoulisModelCommand ImplKindArgument rtl
      add_menu_item $topMenu RemovePapoulisVFSItemsCommand command \
          -label "Delete" -underline 0
      add_menu_item $topMenu OpenPapoulisVFSItemsCommand command \
          -label "Open" -underline 0
      add_menu_item $topMenu RunMBFilesCommand command \
          -label "Load Model Files(s)" -underline 0
      add_menu_item $topMenu GeneratePapoulisModelCommand command \
          -label "Generate Code" -underline 0
      add_menu_item $topMenu AddModelFilesToProjectCommand command \
          -label "Add to Project..." -underline 0
      add_menu_item $topMenu OpenReadVcdDialogCommand command \
          -label "Read VCD..." -underline 5
      add_menu_item $topMenu OpenLearnDialogCommand command \
          -label "Learn..." -underline 1
      add_menu_item $topMenu InvokeGetMostActiveSignalsCommand command \
          -label "Get most active signals..." -underline 4
      add_menu_item $topMenu InvokeLearnPowerHdlCommand command \
          -label "Learn Power HDL..." -underline 6
      addSeparator $topMenu
      add_menu_item $topMenu CompilePapoulisProtocolsCommand command \
          -label "Compile Protocol" -underline 8
      add_menu_item $topMenu OpenProtocolStateMachineCommand command \
          -label "Show State Machine" -underline 0

      #project
      
      if {0 == 1} {
        $topMenu insert end command -label "Show State Macthine" -underline 4
        attach_menu_item $topMenu end ShowPapoulisStateMachineCommand
        addSeparator $topMenu
        #executable
      }
    }

    
    private method fill_tools_menu {} {
      set topMenu [createHeaderMenu "Tools"]
      
      add_menu_item $topMenu OpenVPDialogCommand command \
          -label "Create Virtual Prototype" -underline 7
      addSeparator $topMenu

      add_menu_item $topMenu OpenScMainFileDialogCommand command -label "New sc_main..." -underline 4
      add_menu_item $topMenu OpenClockDialogCommand command \
          -label "Add Clock..." -underline 4
      add_menu_item $topMenu OpenTopDialogCommand  command -label "Add sc_module/s to sc_main..." \
          -underline 7
      addSeparator $topMenu
      
      add_menu_item $topMenu ConfigFromIpXactCommand command \
          -label "Configure from IP-XACT..." -underline 15
      add_menu_item $topMenu GenerateLibraryCommand command \
          -label "Create Model Interfaces ..." -underline 7
      if {[info exists ::env(SA_HOME)]} {
        addSeparator $topMenu
        add_menu_item $topMenu OpenSaResultsCommand command -label "System Architect Analyzer..." -underline 7
      }
      if {[info exists ::env(TLM_INFRA_HOME)] && $::env(TLM_INFRA_HOME) != "" } {
        addSeparator $topMenu
        add_menu_item $topMenu TlmInfraCreatePlatformCommand command -label "Create Tlm_infra Platform..."  -underline 1
        add_menu_item $topMenu TlmInfraModifyPlatformCommand command -label "Modify Tlm_infra Platform..."  -underline 1
      }
      
      addSeparator $topMenu
      if {[::Utilities::safeGet ::env(V2_DISABLE_ANALYSIS)] != "1"} {
        add_menu_item $topMenu OpenAnalysisViewCommand command -label "Open Analysis ..." -underline 5
        add_menu_item $topMenu OpenAnalysisReportsCommand command -label "Open Analysis Reports ..." -underline 14
        addSeparator $topMenu
      }
      # add_menu_item $topMenu OpenVistaPowerCommand command -label "Open Vista Power ..." -underline 11
#       addSeparator $topMenu
      add_menu_item $topMenu OpenCatapultCommand command -label "Open Catapult ..." -underline 5
    }

    protected method fill_simulation_menu {} {
      chain
      
      set topMenu [getMenu "Simulation"]
      if {$topMenu == ""} {
        return
      }

      addSeparator $topMenu 5
      insert_menu_item $topMenu [get_command_string OpenSimulationControlCommand] 6 command \
          -label "Open Simulation Control" -underline 7
    }
 
    private method fill_version_menu {} {
      set topMenu [createHeaderMenu "Version"]
    }
    
    protected method fill_window_menu  {} {
      set topMenu [createHeaderMenu "Window"]

      add_menu_item $topMenu EmacsClearMessagesCommand command -label "Clear Messages" -underline 0
      add_menu_item $topMenu EmacsListAllBuffersCommand command -label "List All Buffers" -underline 0 -accelerator "F6"
      bind $toplevel_widget <KeyRelease-F6> [code $document run_command EmacsListAllBuffersCommand]

      attach $topMenu WindowList
    }

    protected method fill_help_menu {} {
      set topMenu [createHeaderMenu "Help" 1]
      add_menu_item $topMenu HelpTopicsCommand command -label "Help Topics..." -underline 0

      addSeparator $topMenu

      $topMenu insert end command -label "Vista Simulation Prompt"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/vista_prompt.txt"

      $topMenu insert end command -label "Vista Debugging Commands"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/vista_debugging_commands.txt"

      $topMenu insert end command -label "Vista Tracing Commands"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/trace.txt"

      $topMenu insert end command -label "Vista Design Element Path Format"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/design_path.txt"

      $topMenu insert end command -label "Invoking Vista Simulation in Batch Mode"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/invoke.txt"

      addSeparator $topMenu
      $topMenu insert end command -label "Building Vista runtime for various simulators"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/build_vista_runtime.txt"
      addSeparator $topMenu

      $topMenu insert end command -label "Using Vista TLM Tracer facility"
      attach_menu_item $topMenu end EmacsOpenFileCommand File "$::env(V2_HOME)/doc/vista_tlm_tracer.txt"
      addSeparator $topMenu

#      add_menu_item $topMenu ConsoleCommand command -label "Using Help..." -underline 0
#      add_menu_item $topMenu ConsoleCommand command -label "Document Library..." -underline 0
#      add_menu_item $topMenu ConsoleCommand command -label "Summit Design on the Web..." -underline 21
      add_menu_item $topMenu AboutCommand command -label "About [set ::env(THIS_PRODUCT_NAME)]..." -underline 0
      
      if {[info exists ::env(V2_ALLOW_TCL_DEBUGGING)]} {
        addSeparator $topMenu
        add_menu_item $topMenu ConsoleCommand command -label "Tcl Console"
        add_menu_item $topMenu DebugCommand command -label "Document Debugger"
      }
    }

    protected method add_close_exit_menu {topMenu} {
      add_menu_item $topMenu V2ExitCommand command -label "Exit" -underline 1 
    }

    private method add_project_submenu {topMenu} {
      set project_submenu [addSubMenu $topMenu project_submenu -label "Add To Project" -underline 0]

      $project_submenu insert end command -label "New File..." -underline 0
      attach_menu_item $project_submenu end OpenFileDialogCommand IsAddToProject 1
      
      $project_submenu insert end command -label "New Folder..." -underline 2 
      attach_menu_item $project_submenu end OpenProjectDialog PageIndex 2
      addSeparator $project_submenu
      
      $project_submenu insert end command -label "Files..." -underline 0
      attach_menu_item $project_submenu end OpenProjectDialog PageIndex 3
    }
  }
}


namespace eval ::UI {
  ::itcl::class v2/ui/mainwindow/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
#     protected method attach_to_data {widget document CurrentTableType args} {
#       $widget configure -currentTableTypevariable [$document get_variable_name $CurrentTableType]
#     }
  }

  v2/ui/mainwindow/ViewMenu/DocumentLinker v2/ui/mainwindow/ViewMenu/DocumentLinkerObject
}
