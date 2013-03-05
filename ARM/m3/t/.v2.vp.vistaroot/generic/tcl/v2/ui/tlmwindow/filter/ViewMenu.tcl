### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::tlmwindow::filter {
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
      fill_edit_menu
      fill_help_menu
    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu SaveAsCommand command -label "Save As..." -underline 5
      add_menu_item $topMenu InsertFromFileCommand command -label "Insert on Top..." -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu DestroyCommand command -label "Close" -underline 1 
    }

    private method fill_edit_menu {} {
      set topMenu [createHeaderMenu "Edit"]

      add_menu_item $topMenu UndoCommand command -label "Undo"  -underline 0 -accelerator "Ctrl+Z"
      add_menu_item $topMenu RedoCommand command -label "Redo"  -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu CutCommand command -label "Cut"  -underline 2 -accelerator "Ctrl+X"
      add_menu_item $topMenu CopyCommand command -label "Copy"  -underline 0 -accelerator "Ctrl+C"
      add_menu_item $topMenu PasteCommand command -label "Paste"  -underline 0 -accelerator "Ctrl+V"
      addSeparator $topMenu
      #add_menu_item $topMenu SelectAllCommand command -label "Select All"  -underline 0  -accelerator "Ctrl+A"
      add_menu_item $topMenu ClearCommand command -label "Clear"  -underline 4
      #add_menu_item $topMenu FindCommand command -label "Find..."  -underline 0 -accelerator "Ctrl+F"
      #add_menu_item $topMenu FindNextCommand command -label "Find Next"  -underline 5 -accelerator "F3"
      #add_menu_item $topMenu ReplaceCommand command -label "Replace..."  -underline 0
      #add_menu_item $topMenu ReplaceCommand command -label "Replace..."  -underline 1 
      #addSeparator $topMenu
      #add_menu_item $topMenu GoToLineCommand command -label "Go To Line..."  -underline 0 
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
  ::itcl::class v2/ui/tlmwindow/filter/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
#     protected method attach_to_data {widget document CurrentTableType args} {
#       $widget configure -currentTableTypevariable [$document get_variable_name $CurrentTableType]
#     }
  }

  v2/ui/tlmwindow/filter/ViewMenu/DocumentLinker v2/ui/tlmwindow/filter/ViewMenu/DocumentLinkerObject
}
