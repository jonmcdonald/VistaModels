### main frame option
option add *TopView.background \#e0e0e0 widgetDefault
option add *TopView.helpbackground yellow widgetDefault
option add *TopView.helpforeground black widgetDefault
option add *TopView.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *TopView.winwidth 768 widgetDefault
option add *TopView.winheight 512 widgetDefault

namespace eval ::v2::ui::simulation_control {
  class TopView {
    inherit ::UI::TopView
    
    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent] -winwidth 500 -winheight 300 -minwidth 500 -minheight 54
    } {
      wm protocol $itk_interior WM_DELETE_WINDOW [code $this onDelete]
      eval itk_initialize $args

      add_notebook
      attach $itk_component(notebook) CurrentTab
      create_standart_component $document
    }

    protected method onDelete {args} {
      saveGeometry
      $document run_command SimulationControlDestroyCommand
    }

    public method saveGeometry {} {
      scan [split [wm geometry $itk_interior] "x+"] "%d%d%d%d" width height x y
      $document set_variable_value XCoordSC $x
      $document set_variable_value YCoordSC $y
      $document set_variable_value WindowWidthSC $width
      $document set_variable_value WindowHeightSC $height
    }
    
    protected method set_geometry {} {
      $itk_interior configure -winx [$document get_variable_value XCoordSC] -winy [$document get_variable_value YCoordSC]
      set width  [$document get_variable_value WindowWidthSC]
      set height [$document get_variable_value WindowHeightSC]
      
      if {$width} {
        $itk_interior configure -winwidth $width 
      }
      if {$height} {
        $itk_interior configure -winheight $height 
      }
      chain
    }

  }
}

