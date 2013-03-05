### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::text_editor {
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

    protected method fill_menu {} {
      if { [$document get_variable_value HasMenu]} {
        fill_file_menu
        fill_edit_menu
        fill_help_menu
      }
    }

    protected method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]

      if { [$document get_variable_value HasOpenCloseCommand]} {
        add_menu_item $topMenu OpenCommand command -label "Open..." -underline 0
      }
      if { [$document get_variable_value HasSaveCommand]} {
        add_menu_item $topMenu SaveCommand command -label "Save" -underline 0
      }
      add_menu_item $topMenu SaveAsCommand command -label "Save As..." -underline 5
      if { [$document get_variable_value HasInsertFromFileCommand]} {
        add_menu_item $topMenu InsertFromFileCommand command -label "Insert on Top..." -underline 0
      }
      addSeparator $topMenu
#      if { [$document isEnabled DestroyCommand]} {
#        add_menu_item $topMenu DestroyCommand command -label "Close" -underline 1 
#      }
      if { [$document get_variable_value HasOpenCloseCommand]} {
        add_menu_item $topMenu CloseFileCommand command -label "Close" -underline 1 
      }
    }

    protected method fill_edit_menu {} {
      set topMenu [createHeaderMenu "Edit"]

      add_menu_item $topMenu UndoCommand command -label "Undo"  -underline 0 -accelerator "Ctrl+Z"
      add_menu_item $topMenu RedoCommand command -label "Redo"  -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu CutCommand command -label "Cut"  -underline 2 -accelerator "Ctrl+X"
      add_menu_item $topMenu CopyCommand command -label "Copy"  -underline 0 -accelerator "Ctrl+C"
      add_menu_item $topMenu PasteCommand command -label "Paste"  -underline 0 -accelerator "Ctrl+V"
      addSeparator $topMenu
      add_menu_item $topMenu ClearCommand command -label "Clear"  -underline 4
    }


    protected method fill_help_menu {} {
      
    }
  }
}


namespace eval ::UI {
  ::itcl::class v2/ui/text_editor/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
  }

  v2/ui/text_editor/ViewMenu/DocumentLinker v2/ui/text_editor/ViewMenu/DocumentLinkerObject
}
