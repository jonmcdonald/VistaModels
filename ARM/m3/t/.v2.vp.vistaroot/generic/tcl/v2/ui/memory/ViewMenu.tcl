### tcl-mode
option add *ViewMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ViewMenu.background \#e0e0e0 widgetDefault
option add *ViewMenu.foreground black widgetDefault

namespace eval ::v2::ui::memory {
  class ViewMenu {
    inherit ::UI::FrameMenu
    
    constructor {_document args} {
      ::UI::FrameMenu::constructor $_document
    } {
      eval itk_initialize $args
      fill_menu
    }
    
    protected method fill_menu {} {
      fill_file_menu
      
      fill_window_menu 

      fill_help_menu

    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]

      add_menu_item $topMenu DestroyCommand command -label "Close" -underline 0
      
    }


    protected method fill_window_menu  {} {
      set topMenu [createHeaderMenu "Window"]

      attach $topMenu WindowList
    }

    protected method fill_help_menu {} {
      set topMenu [createHeaderMenu "Help" 1]
      add_menu_item $topMenu HelpCommand command -label "Help Topics..." -underline 0
      add_menu_item $topMenu AboutCommand command -label "About [set ::env(THIS_PRODUCT_NAME)]..." -underline 0
    }
  }
}


namespace eval ::UI {
  ::itcl::class v2/ui/memory/ViewMenu/DocumentLinker {
    inherit DataDocumentLinker
  }

  v2/ui/memory/ViewMenu/DocumentLinker v2/ui/memory/ViewMenu/DocumentLinkerObject
}
