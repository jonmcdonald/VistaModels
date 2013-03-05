usual PopupMenu {}
namespace eval ::v2::ui {
  class PopupMenu {
    inherit  ::UI::PopupMenu ::v2::ui::SimulationInterface
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    public method fill_menu {} {}

    public method update_menu {} {

      set kind [set [$document get_variable_name "CurrentKind"]]
      #puts "kind=$kind"
      set is_specific_kind 1
      if {$kind == "" || [string match *general_folder $kind] || $kind == "folder" || $kind == "library" || $kind == "project"} {
        set is_specific_kind 0
      }
      #$itk_component(menu) delete 0 end
      removeAllMenuItems  $itk_component(menu)
      if {$is_specific_kind} {
        add_menu_item $itk_component(menu) OpenSelectionCommand command -label "Open"
        addSeparator $itk_component(menu)
      }
      add_menu_item $itk_component(menu) UpdateTreeCommand command -label "Refresh Browser"
      if {$is_specific_kind} {
        addSeparator $itk_component(menu)
      }

      if {[$document isEnabled [get_command_string GenerateLibraryCommand]]} {
        addSeparator $itk_component(menu)
        add_menu_item $itk_component(menu) GenerateLibraryCommand command -label "Create Model Interfaces ..."
        addSeparator $itk_component(menu)
      }

      if {$kind == "library"} {
        addSeparator $itk_component(menu)
        add_menu_item $itk_component(menu) OpenLibraryManagerDialog command -label "Open Library Manager..."
        addSeparator $itk_component(menu)
        add_menu_item $itk_component(menu) OpenFileDialogCommand command -label "New File..."
        add_menu_item $itk_component(menu) CreateNewPapoulisModelCommand command -label "New Model"
        add_menu_item $itk_component(menu) CreateNewBlockDiagramCommand command -label "New Schematic"
        add_menu_item $itk_component(menu) CreateNewGraphicalSymbolCommand command -label "New Graphical Symbols"
      }
      set modeling_items_added 0
      if {[$document isEnabled [get_command_string RunMBFilesCommand]]} {
        add_menu_item $itk_component(menu) RunMBFilesCommand command -label "Load Model File(s)"
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string GeneratePapoulisModelCommand]]} {
        add_menu_item $itk_component(menu) GeneratePapoulisModelCommand command -label "Generate Code"
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string AddModelFilesToProjectCommand]]} {
        add_menu_item $itk_component(menu) AddModelFilesToProjectCommand command -label "Add to Project..."
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string AddModelPowerFilesToProjectCommand]]} {
        add_menu_item $itk_component(menu) AddModelPowerFilesToProjectCommand command -label "Add Power Model Files to Project..."
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string CompilePapoulisProtocolsCommand]]} {
        add_menu_item $itk_component(menu) CompilePapoulisProtocolsCommand command -label "Compile Protocol"
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string OpenProtocolStateMachineCommand]]} {
        add_menu_item $itk_component(menu) OpenProtocolStateMachineCommand command -label "Show State Machine"
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string OpenModelPVFileCommand]]} {
        add_menu_item $itk_component(menu) OpenModelPVFileCommand command -label "Go to PV"
        set modeling_items_added 1
      }
      if {[$document isEnabled [get_command_string OpenReadVcdDialogCommand]]} {
        add_menu_item $itk_component(menu) OpenReadVcdDialogCommand command -label "Read VCD..."
      }
      if {[$document isEnabled [get_command_string OpenLearnDialogCommand]]} {
        add_menu_item $itk_component(menu) OpenLearnDialogCommand command -label "Learn..."
      }
      if {[$document isEnabled [get_command_string InvokeGetMostActiveSignalsCommand]]} {
        add_menu_item $itk_component(menu) InvokeGetMostActiveSignalsCommand command -label "Get most active signals..."
      }
      if {[$document isEnabled [get_command_string InvokeLearnPowerHdlCommand]]} {
        add_menu_item $itk_component(menu) InvokeLearnPowerHdlCommand command -label "Learn Power HDL..."
      }
      if {$modeling_items_added} {
        addSeparator $itk_component(menu)
      }
      
      switch $kind {
        "file" {
          add_menu_item $itk_component(menu) EmacsCompileProjectCommand command -label "Compile"
        }
        "project" {
          addSeparator $itk_component(menu)
          $itk_component(menu) insert end command -label "Build"
          attach_menu_item $itk_component(menu) end EmacsBuildCommand \
              Target "prepare all"
#          $itk_component(menu) insert end command -label "Build Tree"
#          attach_menu_item $itk_component(menu) end EmacsBuildCommand   Target full
          $itk_component(menu) insert end command -label "Rebuild"
          attach_menu_item $itk_component(menu) end EmacsBuildCommand \
              Target "clean prepare all"
#          $itk_component(menu) insert end command -label "Rebuild Tree"
#          attach_menu_item $itk_component(menu) end EmacsBuildCommand Target full_rebuild
          addSeparator $itk_component(menu)
          $itk_component(menu) insert end command -label "New Folder..."
          attach_menu_item  $itk_component(menu) end OpenProjectDialog PageIndex 2
          $itk_component(menu) insert end command -label "Add Files to Project..."
          attach_menu_item $itk_component(menu) end OpenProjectDialog PageIndex 3
          $itk_component(menu) insert end command -label "Settings..."
          attach_menu_item $itk_component(menu) end OpenProjectDialog IsSubProject 0
        }
        "folder" {
          addSeparator $itk_component(menu)
          $itk_component(menu) insert end command -label "Add Files to Folder..." ;

          set tree [$document get_variable_value Tree]
          set cursel [$tree curselection]
          set curIndex [lindex $cursel 0] 
          set folderName [$tree entry cget $curIndex -label]
 
          attach_menu_item $itk_component(menu) end OpenProjectDialog PageIndex 3 \
              AddToFolderArg $folderName
          $itk_component(menu) insert end command -label "Settings..."
          attach_menu_item $itk_component(menu) end OpenProjectDialog IsSubProject 0 PageIndex 2
          $itk_component(menu) insert end command -label "New File..."
          attach_menu_item $itk_component(menu) end OpenFileDialogCommand \
              IsAddToProject 1 AddToFolderArg $folderName
        }
        "designs_folder" {
          $itk_component(menu) insert end command -label "Add sc_main File to Folder..." ;
          set tree [$document get_variable_value Tree]
          set cursel [$tree curselection]
          set curIndex [lindex $cursel 0] 
          set folderName [$tree entry cget $curIndex -label]
          attach_menu_item $itk_component(menu) end OpenProjectDialog PageIndex 3 AddToFolderArg $folderName

          $itk_component(menu) insert end command -label "New sc_main File..."
          attach_menu_item $itk_component(menu) end OpenScMainFileDialogCommand IsAddToProject 1 \
              AddToFolderArg $folderName
        }
        "sc_main" {
          add_menu_item $itk_component(menu) OpenClockDialogCommand command \
              -label "Add Clock..."
          addSeparator $itk_component(menu)
          $itk_component(menu)  insert end command -label "Build executable"
          attach_menu_item $itk_component(menu) end EmacsBuildExecutableCommand BuildTypeArgument build 
          $itk_component(menu)  insert end command -label "Relink executable"
          attach_menu_item $itk_component(menu) end EmacsBuildExecutableCommand BuildTypeArgument relink 
          addSeparator $itk_component(menu)
          $itk_component(menu)  insert end command -label "Simulate" 
          attach_menu_item $itk_component(menu) end [get_command_string OpenStartSimulationDialog]
        }
        "class" {
          add_menu_item $itk_component(menu)  OpenCurrentSelectionInEmacs \
              command -label "Go to Implementation"
          addSeparator $itk_component(menu)
          add_menu_item  $itk_component(menu)  OpenScMainFileDialogCommand command -label "New sc_main..." 
          add_menu_item $itk_component(menu) OpenTopDialogCommand command \
              -label "Add sc_module/s to sc_main..."

          addSeparator $itk_component(menu)
        }
        "function" -
        "base_class" {
          add_menu_item $itk_component(menu)   OpenCurrentSelectionInEmacs \
              command -label "Go to Implementation"
        }
        "module" - 
        "hier_channel" {
          $itk_component(menu) insert end  command -label "Go to Declaration";
          attach_menu_item $itk_component(menu) end \
              OpenCurrentSelectionInEmacs Args [list IsDeclaration]
          $itk_component(menu) insert end  command -label "Go to Implementation";
          attach_menu_item $itk_component(menu) end \
              OpenCurrentSelectionInEmacs Args [list IsImplementation]
          $itk_component(menu) insert end  command -label "Go to Instantiation";
          attach_menu_item $itk_component(menu) end \
              OpenCurrentSelectionInEmacs Args [list IsInstantiation]
          
           addSeparator $itk_component(menu)
        }
        "port" -
        "export" -
        "event" -
        "attribute" -
        "prim_channel" -
        "tlm_fifo_channel" -
        "channel" -
        "field" -
        "stl_size_field" -
        "pointer" {
          $itk_component(menu) insert end command -label "Go to Declaration"
          attach_menu_item  $itk_component(menu) end  \
              OpenCurrentSelectionInEmacs Args [list IsDeclaration]
        }
        "variable" -
        "member" {
          $itk_component(menu) insert end command -label "Go to Declaration"
          attach_menu_item  $itk_component(menu) end  \
              OpenCurrentSelectionInEmacs Args [list IsDeclaration]
          set type [set [$document get_variable_name "CurrentType"]]
          #if member is class
          if {$type != ""} {
            $itk_component(menu) insert end command -label "Go to Implementation"
            attach_menu_item  $itk_component(menu) end \
                OpenCurrentSelectionInEmacs Args [list IsImplementation]
          }
          addSeparator $itk_component(menu)
        }
        
        "process" -
        "method_handle" -
        "method" {
          $itk_component(menu) insert end command -label "Go to Implementation"
          attach_menu_item  $itk_component(menu) end  \
              OpenCurrentSelectionInEmacs Args [list IsImplementation]
          $itk_component(menu) insert end command -label "Go to Declaration"
          attach_menu_item  $itk_component(menu) end \
              OpenMethodDeclarationInEmacs
          addSeparator $itk_component(menu)
          if {[$document isEnabled [get_command_string SwitchToProcessCommand]]} {
            $itk_component(menu) insert end command -label "Switch to process"
            attach_menu_item  $itk_component(menu) end [get_command_string SwitchToProcessCommand]
            addSeparator $itk_component(menu)
          }
        }
      }

      if {$is_specific_kind} {
        addSimulateCommands
        addWavesList $kind ;# Acquire + analysis
        addTraceItems $kind
        addTlmItems $kind ;# Trace Transactions
        addBreakpointsItems
        addWatchItems $kind
        addSimulationViewOptionsItems $kind ;# Radix
      }
     
      addCutCopyPasteCommands $kind
      addDeleteCommand $kind
    }

    private method addCutCopyPasteCommands {kind} {
      switch $kind {
        "class" -
        "function" -
        "base_class" -
        "module" -
        "hier_channel" -
        "port" - 
        "export" -
        "event" -
        "attribute" -
        "prim_channel" -
        "tlm_fifo_channel" -
        "channel" -
        "field" -
        "stl_size_field" -
        "pointer" -
        "variable" -
        "member" -
        "process" -
        "method_handle" -
        "method" {
          return
        }
        default {
          set copyEnabled [$document isEnabled [get_command_string CutOrCopyCommand]]
          set pasteEnabled [$document isEnabled [get_command_string PasteCommand]]
          if {!$copyEnabled && !$pasteEnabled} {
            return
          }
          set deleteEnabled [$document isEnabled [get_command_string DeleteCommand]]
          set cutEnabled [expr $copyEnabled && $deleteEnabled]
          
          addSeparator $itk_component(menu)
          if {$cutEnabled} {
            $itk_component(menu)  insert end command -label "Cut" 
            attach_menu_item $itk_component(menu) end CutOrCopyCommand IsCutID 1 
          }
          if {$copyEnabled} {
            $itk_component(menu)  insert end command -label "Copy"
            attach_menu_item $itk_component(menu) end CutOrCopyCommand IsCutID 0
          }
          if {$pasteEnabled} {
            $itk_component(menu)  insert end command -label "Paste"
            attach_menu_item $itk_component(menu) end PasteCommand
          }
        }
      }
    }

    private method addTlmItems { kind } {
      if {$kind == "process"} {
        return
      }
      set isAddEnabled [$document isEnabled [get_command_string TlmTraceSelectionCommand]]
      set isDeleteEnabled [$document isEnabled [get_command_string TlmUntraceSelectionCommand]]
      if {!$isAddEnabled && !$isDeleteEnabled} {
        return
      }
      addSeparator $itk_component(menu)
      if {$isAddEnabled} {
        $itk_component(menu) insert end command -label "Trace Transactions"
        attach_menu_item  $itk_component(menu) end [get_command_string TlmTraceSelectionCommand]
      }
      if {$isDeleteEnabled} {
        $itk_component(menu) insert end command -label "Untrace Transactions"
        attach_menu_item  $itk_component(menu) end [get_command_string TlmUntraceSelectionCommand]
      }
      if {[$document isEnabled [get_command_string OpenTraceTransactionsDialogCommand]]} {  
        $itk_component(menu) insert end command -label "Trace Transactions Dialog ..."
        attach_menu_item  $itk_component(menu) end [get_command_string OpenTraceTransactionsDialogCommand]
      }
    }

    private method addTraceItems { kind } {
      if {$kind == "breakpoint" || $kind == "class" || $kind == "analysis_session" || \
              $kind == "file"} {
        return
      }
      set isAddEnabled [$document isEnabled [get_command_string TraceSelectionCommand]]
      set isDeleteEnabled [$document isEnabled [get_command_string UntraceSelectionCommand]]
      if {!$isAddEnabled && !$isDeleteEnabled} {
        return
      }
      addSeparator $itk_component(menu)
      if {$isAddEnabled} {
        $itk_component(menu) insert end command -label "Trace"
        attach_menu_item  $itk_component(menu) end [get_command_string TraceSelectionCommand]
      }

      if {$isDeleteEnabled} {
        $itk_component(menu) insert end command -label "Untrace"
        attach_menu_item  $itk_component(menu) end [get_command_string UntraceSelectionCommand]
      }

      if {[$document isEnabled [get_command_string OpenTraceDialogCommand]]} {  
        $itk_component(menu) insert end command -label "Trace Dialog ..."
        attach_menu_item  $itk_component(menu) end [get_command_string OpenTraceDialogCommand]
      }
    }
    
    private method addSimulationViewOptionsItems { kind } {
      if {$kind == "breakpoint" || $kind == "wave" || $kind == "analysis_session" || \
              $kind == "file"} {
        return
      }
      addSeparator $itk_component(menu)
      set showRadix [$document isEnabled [get_command_string SetRadixCommand]]
      if {$showRadix} {
        switch $kind {
          "port" -
          "export" -
          "event" -
          "attribute" -
          "prim_channel" -
          "tlm_fifo_channel" -
          "channel" -
          "field" -
          "stl_size_field" -
          "pointer" -
          "variable" -
          "member" {
            ;
          }
          default { set showRadix 0} 
        }
      }
      if {$showRadix} {
        set radix_submenu [addSubMenu $itk_component(menu) radix_submenu -label "Radix" -underline 4]
        $radix_submenu insert end command -label "Binary" -underline 0 
        attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "b" RadixType value
        $radix_submenu insert end command -label "Octal" -underline 0 
        attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "o" RadixType value
        $radix_submenu insert end command -label "Decimal" -underline 0 
        attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "d" RadixType value
        $radix_submenu insert end command -label "Hexadecimal" -underline 0
        attach_menu_item $radix_submenu end [get_command_string SetRadixCommand] RadixValue "x" RadixType value
        set array_index_submenu [addSubMenu $itk_component(menu) array_index_submenu -label "Index Radix"]
        $array_index_submenu insert end command -label "Binary" -underline 0 
        attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "b" RadixType index
        $array_index_submenu insert end command -label "Octal" -underline 0 
        attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "o" RadixType index
        $array_index_submenu insert end command -label "Decimal" -underline 0 
        attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "d" RadixType index
        $array_index_submenu insert end command -label "Hexadecimal" -underline 0
        attach_menu_item $array_index_submenu end [get_command_string SetRadixCommand] RadixValue "x" RadixType index
        

      }
      set showArrayRange [$document isEnabled [get_command_string OpenArrayRangeDialog]]

      if {!$showRadix} {
        set showArrayRange 0
      } else {
        switch $kind {
          "field" -
          "stl_size_field" -
          "tlm_fifo_channel" -
          "pointer" -
          "variable" {
            ;
          }
          default { set showArrayRange 0} 
        }
      }

      if {$showArrayRange} {
        add_menu_item $itk_component(menu) [get_command_string OpenArrayRangeDialog] command -label "Range ..." 
      }
      if {[$document isEnabled [get_command_string OpenArrayRangeDialog]]} {
        add_menu_item $itk_component(menu) [get_command_string OpenPropertiesDialog] command -label "Radix & Range Options ..." 
      }
    }

    private method addWatchItems { kind } {
      if {$kind == "unknown" || $kind == "breakpoint" || $kind == "wave" || \
              $kind == "analysis_session" || $kind == "file"} {
        return
      }
      set isAddEnabled [$document isEnabled [get_command_string AddWatchRootsCommand]]
      set isDeleteEnabled [$document isEnabled [get_command_string DeleteWatchRootsCommand]]
      if {!$isAddEnabled && !$isDeleteEnabled} {
        return
      }
      addSeparator $itk_component(menu)
      if {$isAddEnabled} {
        $itk_component(menu) insert end command -label "Add to Watch"
        attach_menu_item  $itk_component(menu) end  [get_command_string AddWatchRootsCommand]
      }
      if {$isDeleteEnabled} {
        $itk_component(menu) insert end command -label "Delete Watch"
        attach_menu_item  $itk_component(menu) end  [get_command_string DeleteWatchRootsCommand]
      }
    }

    private method addBreakpointsItems {} {
      set showAdd [$document isEnabled [get_command_string AddBreakpointsCommand]]
      set showDelete [$document isEnabled [get_command_string DeleteBreakpointsCommand]]
      set showEnable [$document isEnabled [get_command_string EnableBreakpointsCommand]]
      set showDisable [$document isEnabled [get_command_string DisableBreakpointsCommand]]

      if {!$showAdd && !$showDelete && !$showEnable && !$showDisable} {
        return
      }
      addSeparator $itk_component(menu)
      if {$showAdd} {
        $itk_component(menu) insert end command -label "Set Breakpoint"
        attach_menu_item  $itk_component(menu) end  [get_command_string AddBreakpointsCommand]
      }
      if {$showDelete} {
        $itk_component(menu) insert end command -label "Delete Breakpoint"
        attach_menu_item  $itk_component(menu) end  [get_command_string DeleteBreakpointsCommand]
      }
      if {$showEnable} {
        $itk_component(menu) insert end command -label "Enable Breakpoint"
        attach_menu_item  $itk_component(menu) end  [get_command_string EnableBreakpointsCommand]
      }
      if {$showDisable} {
        $itk_component(menu) insert end command -label "Disable Breakpoint"
        attach_menu_item  $itk_component(menu) end  [get_command_string DisableBreakpointsCommand]
      }
    }

    private method addWavesList { kind } {
      if {$kind == "wave"} {
        return
      }
      addSeparator  $itk_component(menu)

      if {![$document isEnabled [get_command_string AcquireSelectionCommand]]} {
        return
      }
      catch {
        set acquireList [$document get_variable_value [get_command_string AcquireMenuDataList]]
        if {$acquireList != {}} {
          attach $itk_component(menu) [get_command_string AcquireMenuDataList]
        }
        if {[$document isEnabled [get_command_string OpenAcquireDialogCommand]]} {  
          $itk_component(menu) insert end command -label "Acquire Dialog ..."
          attach_menu_item  $itk_component(menu) end [get_command_string OpenAcquireDialogCommand]
        }
      }
      addSeparator  $itk_component(menu)
      if {[$document isEnabled [get_command_string AcquireToAnalysisCommand]]} {  
        $itk_component(menu) insert end command -label "Acquire to Analysis"
        attach_menu_item  $itk_component(menu) end [get_command_string AcquireToAnalysisCommand]
      }
      if {[$document isEnabled [get_command_string OpenAcquireToAnalysisDialogCommand]]} {  
        $itk_component(menu) insert end command -label "Acquire to Analysis Dialog ..."
        attach_menu_item  $itk_component(menu) end [get_command_string OpenAcquireToAnalysisDialogCommand]
      }
      
    }

    private method addSimulateCommands {} {
      set isSimulateEnabled [$document isEnabled [get_command_string OpenStartSimulationDialog]]

      if {!$isSimulateEnabled} {
        return
      }
      addSeparator $itk_component(menu)
#       if {$isSimulateEnabled} {
#         $itk_component(menu) insert end command -label "Resimulate"
#         attach_menu_item  $itk_component(menu) end  [get_command_string OpenResimulateDialog]
#       }
    }

    private method addDeleteCommand { kind } {
      if {$kind == "port" || $kind == "export" || $kind == "prim_channel" || $kind == "process" || \
          $kind == "field" || $kind == "class"} {
        return
      }
      set isDeleteEnabled [$document isEnabled [get_command_string DeleteCommand]]
      if {$isDeleteEnabled} {
        addSeparator $itk_component(menu)
        if {$kind == "project"} {
          $itk_component(menu) insert end command -label "Remove Project"
        } else {
          $itk_component(menu) insert end command -label "Delete"
        }
        attach_menu_item  $itk_component(menu) end [get_command_string DeleteCommand]
      }
    }
  }
}
