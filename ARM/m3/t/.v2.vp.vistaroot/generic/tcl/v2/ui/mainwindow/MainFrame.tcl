### main frame option
option add *MainFrame.background \#e0e0e0 widgetDefault
option add *MainFrame.helpbackground yellow widgetDefault
option add *MainFrame.helpforeground black widgetDefault
option add *MainFrame.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *MainFrame.winwidth 768 widgetDefault
option add *MainFrame.winheight 512 widgetDefault

namespace eval ::v2::ui::mainwindow {
  class MainFrame {
    inherit ::UI::TopView
    private variable console_object

    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent]
    } {
      configure -winwidth 800 -winheight 480

      $document set_variable_value MainWindowWidgetName $itk_interior
      
      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onDelete]
      eval itk_initialize $args
      if {0 == 1} { ;# console is a part of WorkWindow.tcl
        set console_frame [frame $itk_interior.console -border 4]
        set console_object [::UI::console::create_console $console_frame $::mgc_vista_api_interpreter]
        catch {
          $console_object configure -ExpandCustomnameProc [list ::v2::papoulis::exec_papoulis ::vfs::expand_vfs_path]
        }
        
        set_console_frame $console_frame
      }

      add_notebook

      attach $itk_component(notebook) WorkWindowWidgetName
      
# vladimir: moved to v2/main.tcl
#      $document run_command CreateProjectsWorkWindowCommand
      
      create_standart_component $document
      $itk_component(toolbar) create_simulation_toolbar
    }
    destructor {
      if {$console_object != ""} {
        catch {objectDelete $console_object}
      }
    }

    public method accept_console_output {output} {
      catch {
        if {$console_object != ""} {
          $console_object ConsoleOutput stdout $output
        }
      }
    }

    protected method set_binding {} {
      chain

      bind [winfo toplevel $itk_interior] <1> +[code $this on_toplevel_click %W]
    }    

    private method on_toplevel_click {clicked_widget} {
      [getCurrentWorkWindow] on_toplevel_click $clicked_widget
    }

    protected method onDelete {args} {
      $document run_command V2ExitCommand
    }

    private method getCurrentWorkWindow {} {
      return [$document get_variable_value WorkWindowWidgetName]
    }

    public method show {} {
      chain
      $itk_component(toolbar) show_simulation_toolbar
    }
    
    public method restore_tree_view {} {
      $itk_component(paned_view) restore_tree_view
    }

    public method update_title {} {
      $itk_component(paned_view) update_title
    }

    public method focus_in {pane} {
      $itk_component(paned_view) focus_in $pane
    }

    public method saveGeometry {} {
      scan [split [wm geometry $itk_interior] "x+"] "%d%d%d%d" width height x y
      $document set_variable_value XCoord $x
      $document set_variable_value YCoord $y
      $document set_variable_value WindowWidth $width
      $document set_variable_value WindowHeight $height
    }

    public method is_undeletable_tab {workWindowID} {
      if {![info exists itk_component(notebook)] || \
              ![winfo exists $itk_component(notebook)]} {
        return 1
      }
      return [$itk_component(notebook) is_undeletable_tab $workWindowID]
    }

    protected method set_geometry {} {
      set xcoord [$document get_variable_value XCoord]
      set ycoord [$document get_variable_value YCoord]
      set width  [$document get_variable_value WindowWidth]
      set height [$document get_variable_value WindowHeight]
      
      if {!$width && !$height} {
        wm geometry $itk_interior \
            [format "%sx%s+%s+%s" [winfo vrootwidth $itk_interior] \
                 [expr round([winfo vrootheight $itk_interior]*0.9)] 0 0]
        return
      }
      
      if {$width <  $itk_option(-winwidth)} {
        set width $itk_option(-winwidth)
      }
      if {$height < $itk_option(-winheight)} {
        set height $itk_option(-winheight)
      }
      
      wm geometry $itk_interior \
          [format "%sx%s+%s+%s" $width $height $xcoord $ycoord]
    }
    
  }
}

