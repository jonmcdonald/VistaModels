### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::profilingwindow {
  variable view_menu
  class ViewMenu {
    inherit ::UI::FrameMenu
    
    constructor {_document args} {
      ::UI::FrameMenu::constructor $_document
    } {
      eval itk_initialize $args
      configure -height 30
      fill_menu
    }
    
    destructor {
    }

    private method fill_menu {} {
      fill_file_menu
      fill_plot_menu
      fill_view_menu
      fill_help_menu
    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu RefreshCommand command -label "Refresh" -underline 1 
      addSeparator $topMenu
      add_menu_item $topMenu DestroyCommand command -label "Close" -underline 1 
    }

    private method fill_view_menu {} {
      set topMenu [createHeaderMenu "View"]
      add_menu_item $topMenu ShowDeltaCycles checkbutton -label "View Delta Cycles" -underline 0
      set ::v2::ui::profilingwindow::view_menu $topMenu
      
#      if {$::PROFILING_USE_GNUPLOT} {
      add_menu_item $topMenu ZoomInCommand command -label "Zoom In" -underline 5
      add_menu_item $topMenu ZoomOutCommand command -label "Zoom Out" -underline 5
      add_menu_item $topMenu ZoomFullCommand command -label "Full Zoom" -underline 0
      add_menu_item $topMenu ZoomPreviousCommand command -label "Previous Zoom" -underline 5
#      }
      
    }
    private method fill_plot_menu {} {
      set topMenu [createHeaderMenu "Plot"]
      add_menu_item $topMenu AddToPlotCommand command -label "Add Process To Plot" -underline 0
      add_menu_item $topMenu ClearPlotCommand command -label "Clear All From Plot" -underline 0
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
  ::itcl::class v2/ui/profilingwindow/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
#     protected method attach_to_data {widget document CurrentTableType args} {
#       $widget configure -currentTableTypevariable [$document get_variable_name $CurrentTableType]
#     }
  }

  v2/ui/profilingwindow/ViewMenu/DocumentLinker v2/ui/profilingwindow/ViewMenu/DocumentLinkerObject
}
