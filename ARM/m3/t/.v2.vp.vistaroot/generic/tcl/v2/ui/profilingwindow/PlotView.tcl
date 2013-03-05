namespace eval ::v2::ui::profilingwindow {

  class PlotView {
    inherit ::UI::SWidget
    constructor {_document args} {
      ::UI::SWidget::constructor $_document

    } {
      eval itk_initialize $args
      create_view
      show
    }
    private method create_view {} {
      itk_component add graph_frame {
        frame $itk_interior.graph_frame
      }
      itk_component add memory_graph {
        ::UI::Bltplot $itk_component(graph_frame).memory_graph $document
      }
      if {$::PROFILING_USE_GNUPLOT} {
        $document set_variable_value CurrentGnuplotComponent $itk_component(memory_graph)
      }

      
      itk_component add x_scroll_frame {
        frame $itk_interior.x_scroll_frame
      }

      itk_component add scroll_left {
        Button $itk_component(x_scroll_frame).scroll_left -image [::UI::getimage left] -helptext "Scroll Left" -command [code $this scroll left]
      }

      itk_component add scroll_right {
        Button $itk_component(x_scroll_frame).scroll_right -image [::UI::getimage right] -helptext "Scroll Right" -command [code $this scroll right]
      }

      itk_component add y_scroll_frame {
        frame $itk_component(graph_frame).y_scroll_frame
      }

      itk_component add scroll_up {
        Button $itk_component(y_scroll_frame).scroll_up -image [::UI::getimage up] -helptext "Scroll Up" -command [code $this scroll up]
      }

      itk_component add scroll_down {
        Button $itk_component(y_scroll_frame).scroll_down -image [::UI::getimage down] -helptext "Scroll Down" -command [code $this scroll down]
      }

    }
    public method show {} {
      pack $itk_component(memory_graph)  -side left -fill both -expand 1

      pack $itk_component(scroll_up) -side top -pady 50 -padx 15
      pack $itk_component(scroll_down) -side bottom -pady 50 -padx 15
      pack $itk_component(scroll_left) -side left -padx 50 
      pack $itk_component(scroll_right) -side right -padx 50
      
      pack $itk_component(graph_frame) -side top -fill both -expand 1
      pack $itk_component(y_scroll_frame) -side left -fill y
      pack $itk_component(x_scroll_frame)   -side bottom -fill x 
    }

    private method scroll {direction} {
      variable ::v2::ui::profilingwindow::theWindow
      [$::v2::ui::profilingwindow::theWindow get_document] run_command ScrollCommand ScrollDirection $direction
    }
  }
}
