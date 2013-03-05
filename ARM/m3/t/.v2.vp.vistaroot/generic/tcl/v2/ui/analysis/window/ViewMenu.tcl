### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::analysis::window {
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
      #fill_edit_menu
      fill_tools_menu
      fill_view_menu
      fill_window_menu
      itk_component add session_label {
        label $itk_component(frame).session -fg blue
      } {}
      attach $itk_component(session_label) StatusText
      pack $itk_component(session_label) -side left -padx 10 -anchor center
      
      fill_help_menu
    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu OpenAnalysisSessionCommand command -label "Load session..." -underline 0
      add_menu_item $topMenu SaveCommand command -label "Save" -underline 0
      add_menu_item $topMenu OpenSaveAnalysisDialogCommand command -label "Save As..." -underline 5
      addSeparator $topMenu
      add_menu_item $topMenu DestroyAnalysisWindow command -label "Close" -underline 0
    }

    private method fill_edit_menu {} {
      set topMenu [createHeaderMenu "Edit"]
      add_menu_item $topMenu CopyCommand command -label "Copy" -underline 0
      add_menu_item $topMenu PasteCommand command -label "Paste" -underline 0
    }

    private method fill_tools_menu {} {
      set topMenu [createHeaderMenu "Tools"]
      add_menu_item $topMenu AddObjectsCommand command -label "Add objects" -underline 0
      #add_menu_item $topMenu AddAllObjectsCommand command -label "Add all objects" -underline 1
      add_menu_item $topMenu RemoveObjectsCommand command -label "Remove objects" -underline 0 -accelerator "Del"
      add_menu_item $topMenu RemoveAllObjectsCommand command -label "Remove all objects" -underline 2
      addSeparator $topMenu
      add_menu_item $topMenu PrintAnalysisSegmentTreeCommand command -label "Print current segment results..." -underline 0
      add_menu_item $topMenu OpenAnalysisReportsDialogCommand command -label "Analysis Reports..." -underline 1
     
    }

    private method fill_view_menu {} {
      set topMenu [createHeaderMenu "View"]
      add_menu_item $topMenu ZoomInCommand command -label   "Zoom In" -underline 5 -accelerator "Ctrl+I"
      add_binding $toplevel_widget [list <Control-i> <Control-I>] "[code $document run_command ZoomInCommand]"
      add_menu_item $topMenu ZoomOutCommand command -label  "Zoom Out" -underline 5 -accelerator "Ctrl+O"
      add_binding $toplevel_widget [list <Control-o> <Control-O>] "[code $document run_command ZoomOutCommand]"
      add_menu_item $topMenu FullZoomCommand command -label "Full Zoom" -underline 0 -accelerator "Ctrl+F"
      add_binding $toplevel_widget [list <Control-f> <Control-F>] "[code $document run_command FullZoomCommand]"
      add_menu_item $topMenu PrevZoomCommand command -label "Prev Zoom" -underline 0 -accelerator "Ctrl+Z"
      add_binding $toplevel_widget [list <Control-z> <Control-Z>] "[code $document run_command PrevZoomCommand]"
      addSeparator $topMenu
      add_menu_item $topMenu SyncTimeCommand command -label "Sync Views" -underline 0 
    }

    private method fill_window_menu {} {
      set topMenu [createHeaderMenu "Window"]
      add_menu_item $topMenu DuplicateWindowCommand command -label "Duplicate window" -underline 0
    }

    private method fill_help_menu {} {
      set topMenu [createHeaderMenu "Help" 1]
      add_menu_item $topMenu HelpCommand command -label "Help Topics..." -underline 0
      add_menu_item $topMenu AboutCommand command -label "About [set ::env(THIS_PRODUCT_NAME)]..." -underline 0
    }

    
  } ;# class
} ;# namespace


namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
#     protected method attach_to_data {widget document CurrentTableType args} {
#       $widget configure -currentTableTypevariable [$document get_variable_name $CurrentTableType]
#     }
  }

  v2/ui/analysis/window/ViewMenu/DocumentLinker v2/ui/analysis/window/ViewMenu/DocumentLinkerObject
}
