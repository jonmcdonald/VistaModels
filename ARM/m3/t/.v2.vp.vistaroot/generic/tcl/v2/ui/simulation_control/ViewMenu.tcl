### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::simulation_control {
  class ViewMenu {
    inherit ::v2::ui::SimulationMenu
    
    constructor {_document args} {
      ::v2::ui::SimulationMenu::constructor $_document
    } {
      eval itk_initialize $args
      fill_menu
    }
    
    protected method fill_menu {} {
      fill_file_menu
      fill_view_menu
      fill_simulation_menu
      fill_breakpoints_menu
      fill_trace_menu
      fill_watches_menu
      fill_window_menu 

      fill_help_menu

    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]

      add_menu_item $topMenu SimulationControlDestroyCommand command -label "Close" -underline 0
    }

    private method fill_view_menu {} {
      set topMenu [createHeaderMenu "View"]
      
      add_menu_item $topMenu {DocumentTypeProcessesView FlatProcessTree} checkbutton \
          -label "Show Flat Process View" \
                -underline 5
      add_menu_item $topMenu {DocumentTypeProcessesView FullPathForProcess} checkbutton \
          -label "Show Full Paths For Processes" \
                -underline 10
    }

    protected method fill_window_menu  {} {
      set topMenu [createHeaderMenu "Window"]

      attach $topMenu WindowList
    }

    protected method fill_help_menu {} {
      set topMenu [createHeaderMenu "Help" 1]
      add_menu_item $topMenu HelpCommand command -label "Help Topics..." -underline 0
      add_menu_item $topMenu AboutCommand command -label "About [set ::env(THIS_PRODUCT_NAME)]..." -underline 0
      
      if {[info exists ::env(V2_ALLOW_TCL_DEBUGGING)]} {
        addSeparator $topMenu
        add_menu_item $topMenu ConsoleCommand command -label "Tcl Console"
        add_menu_item $topMenu DebugCommand command -label "Document Debugger"
      }
    }
  }
}


namespace eval ::UI {
  ::itcl::class v2/ui/simulation_control/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
  }

  v2/ui/simulation_control/ViewMenu/DocumentLinker v2/ui/simulation_control/ViewMenu/DocumentLinkerObject
}
