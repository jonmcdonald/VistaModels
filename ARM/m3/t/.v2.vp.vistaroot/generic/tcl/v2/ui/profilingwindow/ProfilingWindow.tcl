### main frame option
option add *ProfilingWindow.background \#e0e0e0 widgetDefault
option add *ProfilingWindow.helpbackground yellow widgetDefault
option add *ProfilingWindow.helpforeground black widgetDefault
option add *ProfilingWindow.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *ProfilingWindow.winwidth 768 widgetDefault
option add *ProfilingWindow.winheight 512 widgetDefault

namespace eval ::v2::ui::profilingwindow {
  
  proc set_simulation_directory {simulation_directory} {
    variable theWindow
    [$theWindow get_document] set_variable_value SimulationDirectory $simulation_directory
  }

  proc set_report_command {report_command} {
    variable theWindow
    [$theWindow get_document] set_variable_value ReportCommand $report_command
  }

  proc refresh {simulation_directory time_params_string has_deltas} {
    variable theWindow
   
    set_simulation_directory $simulation_directory
    [$theWindow get_document]  set_variable_value TimeParamsString $time_params_string 
    [$theWindow get_document]  set_variable_value HasDeltaCycles $has_deltas 
    set_show_delta_cycles_state $has_deltas
    [$theWindow get_document] run_command RefreshCommand
  }
  proc set_show_delta_cycles_state {has_deltas} {
    variable delta_cycles_button   
    variable view_menu
    #disable delta_cycle if does not have delta cycles
    set state normal
    if {$has_deltas != "1"} {
      set state disabled
    }
    
    $delta_cycles_button configure -state $state

    set entryIndex [::UI::find_menu_entry_index_by_label $view_menu "View Delta Cycles"]
    if {$entryIndex != ""} {
      ::UI::common_set_menu_entry_state $view_menu $entryIndex $has_deltas
    }
    
  }

  proc show_report {simulation_directory report_command} {
    set_report_command $report_command
    refresh $simulation_directory
  }

  proc raise {} {
    variable theWindow
    $theWindow show
  }

  proc close {} {
    variable theWindow
    [$theWindow get_document] run_command DestroyCommand
  }

  class ProfilingWindow {
    inherit ::UI::TopView
    
    private variable randomColor [objectNew ::UI::RandomColor]

    public method get_next_random_color {} {
      return [$randomColor get_color]
    }

    public method reset_random_color {} {
      $randomColor reset
    }

    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent]
    } {
      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onDelete]
      eval itk_initialize $args

      set ::v2::ui::profilingwindow::theWindow $this

      add_notebook
      attach $itk_component(notebook) CurrentTab

      create_standart_component $document

    }

    destructor {
      catch {objectDelete $randomColor}
    }

    private method onDelete {args} {
      $::main_doc run_command ExitCommand
    }

    protected method set_geometry {} {
      wm minsize $itk_interior 500 300
      set width  [expr round([winfo screenwidth $itk_interior]*0.7)]
      set height [expr round([winfo screenheight $itk_interior]*0.7)]
      wm geometry $itk_interior \
          [format "%sx%s" $width $height]
    }
  }
}

