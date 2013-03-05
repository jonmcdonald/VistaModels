#tcl-mode
option add *TopView.winwidth 768 widgetDefault
option add *TopView.winheight 512 widgetDefault

namespace eval ::UI {
  class TopView {
    inherit ::UI::SToplevel

    protected variable workspace ""
    private variable has_notebook 0
    private variable console_frame ""

    public variable winwidth 768
    public variable winheight 512
    public variable minwidth 725
    public variable minheight 480
    public variable winx 0
    public variable winy 0

    constructor {_document _workspace args} {
      ::UI::SToplevel::constructor $_document
    } {
      set workspace $_workspace
      
      eval itk_initialize $args
      set_geometry
    }

    destructor {}

    public method getWinType {} { return [namespace tail $workspace] }

    public method show {} {
      show_standart_component
      if {$has_notebook} {
        $itk_component(notebook) show
        pack $itk_component(notebook) -side top -fill both -expand 1 -anchor nw
      }
      if {$console_frame != ""} {
        pack $console_frame -side top -fill both -expand 1 -anchor nw
      }

      chain
    }

    public method update_title {} {}

    public method run_component_command {component command args} {
      eval [list $itk_component($component) $command] $args
    }
    
    protected method create_standart_component {sub_document} {
      ### menu -- class ViewMenu
      itk_component add menu {
        [set workspace]::ViewMenu $itk_interior.menu $sub_document 
      } 

      ### toolbar -- class Toolbar
      itk_component add toolbar {
        [set workspace]::Toolbar $itk_interior.toolbar $sub_document 
      } 
      
      ### statusbar -- class StatusBar
      itk_component add statusBar {
        [set workspace]::StatusBar $itk_interior.sts $sub_document 
      }
    }

    protected method show_standart_component {} { 
      $itk_component(menu) show
      pack $itk_component(menu) -side top -fill x -anchor nw 
      $itk_component(toolbar) show
      pack $itk_component(toolbar) -side top -fill x -anchor nw 
      $itk_component(statusBar) show
      pack $itk_component(statusBar) -side bottom -anchor sw -fill x
    }

    protected method set_geometry {} {
      wm minsize $itk_interior $minwidth $minheight
      
      if {$winwidth < $minwidth} {
        set winwidth $minwidth
      }
      if {$winheight < $minheight} {
        set winheight $minheight
      }
      wm geometry $itk_interior \
          [format "%sx%s+%s+%s" $winwidth $winheight $winx $winy]
    }

    protected method add_notebook {} {
      set has_notebook 1
      itk_component add notebook {
        [set workspace]::Notebook $itk_interior.notebook [get_document]
      }
    }

    protected method set_console_frame {_console_frame} {
      set console_frame $_console_frame 
    }

    protected method set_binding {} {
      chain
      
      bind [winfo toplevel $itk_interior] <1> +[code $this on_toplevel_click %W]
    }
    
    protected method on_toplevel_click {clicked_widget} {}
    protected method onDelete {args} {}
    
  }
}
