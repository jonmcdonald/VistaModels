### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::tlmwindow {
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
      fill_filter_menu
#      fill_table_menu
      fill_help_menu
    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu ForceRefreshCommand command -label "Refresh" -underline 1 
      addSeparator $topMenu
      add_menu_item $topMenu DestroyCommand command -label "Close" -underline 1 
    }

    private method fill_filter_menu {} {
      set topMenu [createHeaderMenu "Filter"]
      add_menu_item $topMenu IsFilterSet radiobutton -value 1 -label "Use Filter" -underline 0
      add_menu_item $topMenu IsFilterSet radiobutton -value 0 -label "View All" -underline 5

      addSeparator $topMenu
      add_menu_item $topMenu HidePortsCommand command -label "Hide Selected Ports ..." -underline 14
      add_menu_item $topMenu HideMethodsCommand command -label "Hide Selected Methods ..." -underline 14
      add_menu_item $topMenu ShowOnlySelectedPortsCommand command -label "Show Only Selected Ports ..." -underline 0
      add_menu_item $topMenu ShowOnlySelectedMethodsCommand command -label "Show Only Selected Methods ..."  -underline 3
      addSeparator $topMenu
      add_menu_item $topMenu EditFilterCommand command -label "Edit Filter ..." -underline 0

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
  ::itcl::class v2/ui/tlmwindow/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
#     protected method attach_to_data {widget document CurrentTableType args} {
#       $widget configure -currentTableTypevariable [$document get_variable_name $CurrentTableType]
#     }
  }

  v2/ui/tlmwindow/ViewMenu/DocumentLinker v2/ui/tlmwindow/ViewMenu/DocumentLinkerObject
}
