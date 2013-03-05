
namespace eval ::v2::ui::analysis::window {


  class AnalysisWindow {
    inherit ::UI::TopView

    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent]
    } {
      #puts "^^^    AnalysisWindow this-$this id=[$document get_ID]"
      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onExit]
      eval itk_initialize $args
      create_body
    }
    
    private method create_body {} {
      add_notebook
      create_standart_component $document
      bind $itk_interior <Configure> "[itcl::code $this saveGeometry %W]"

      ::UI::auto_trace_with_init variable [$document get_variable_name ShowDesignTree] \
          w $itk_interior [code $this set_pane_visibility tree ShowDesignTree]

      ::UI::auto_trace_with_init variable [$document get_variable_name ShowGraphsView] \
          w $itk_interior [code $this set_pane_visibility graphs ShowGraphsView]

      ::UI::auto_trace_with_init variable [$document get_variable_name ShowReportView] \
          w $itk_interior [code $this set_pane_visibility report ShowReportView]

#       ::UI::auto_trace_with_init variable [$document get_variable_name IsFlatTree] \
#           w $itk_interior [code $this update_browser_view_button]

      ::UI::auto_trace_with_init variable [$document get_variable_name CurrentReportTable] \
          w $itk_interior [code $this update_current_report_table]

      ::UI::auto_trace_with_init variable [$document get_variable_name CurrentSummaryTable] \
          w $itk_interior [code $this update_current_summary_table]
    }
    
    public method show {} {
      show_standart_component
      chain
      pack forget $itk_component(statusBar)
    }

    private method set_geometry {} {
      
      set xcoord [$document get_variable_value XCoordAnalysis]
      set ycoord [$document get_variable_value YCoordAnalysis]
      set width  [$document get_variable_value WindowWidthAnalysis]
      set height [$document get_variable_value WindowHeightAnalysis]

      if {!$width} {
        set width [expr round([winfo vrootwidth $itk_interior]*0.8)]
      }
      if {!$height} {
        set height [expr round([winfo vrootheight $itk_interior]*0.8)]
      }
      wm geometry $itk_interior \
          [format "%sx%s+%s+%s" $width $height $xcoord $ycoord]

    }

    public method saveGeometry {widget} {
      scan [split [wm geometry $itk_interior] "x+"] "%d%d%d%d" width height x y
      $document set_variable_value XCoordAnalysis $x
      $document set_variable_value YCoordAnalysis $y
      $document set_variable_value WindowWidthAnalysis $width
      $document set_variable_value WindowHeightAnalysis $height
    }

#    public method update_browser_view_button {args} { $itk_component(toolbar) update_browser_view_button }
    public method update_current_report_table {args} { $itk_component(notebook) update_current_report_table }
    public method update_current_summary_table {args} { $itk_component(notebook) update_current_summary_table }

    protected method onExit {args} {
      $document run_command DestroyAnalysisWindow
    }

    private method set_pane_visibility {pane varname args} {
      if {[set [$document get_variable_name $varname]]} {
        $itk_component(notebook) show_pane $pane
      } else {
        $itk_component(notebook) hide_pane $pane
      }
    }
    public method show_pane {pane} { $itk_component(notebook) show_pane $pane }
    public method hide_pane {pane} { $itk_component(notebook) hide_pane $pane }
    public method saveSession {target_dir session_name} {
      $document run_command SaveAnalysisSessionCommand ResultDirectoryArg $target_dir ResultSessionNameArg $session_name
    }

    public method copy {} {
      clipboard clear
      set text ""
      set focus_item [focus -displayof .]
      catch {set text [$focus_item get]}
      clipboard append $text
    }

    public method paste {} {
      set focus_item [focus -displayof .]
      #puts "paste - focus_item=$focus_item"
      catch {$focus_item insert end [clipboard get]}
    }

    public method on_toplevel_click {clicked_widget} {
      if {![::UI::is_parent_of $itk_interior $clicked_widget]} {
        return
      }
      $itk_component(notebook) set_current_tree $clicked_widget
    }

    public method open_saved_session {} {
      catch {
        set init_dir [file dirname [$document get_variable_value A_SimPath]]
        set list [::UI::open_directory_dialog tk_chooseDirectory $init_dir "Load Analysis Session" 1 $itk_interior]
        foreach path $list {
          $document run_command LoadAnalysisSessionCommand SessionPathArg $path
        }
      }
    }


  } ;# class


} ;# namespace

::blt::bitmap define ::v2::ui::analysis::window::unused_pattern "#define foo_width 16
#define foo_height 16
static char foo_bits[] = {
   0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xcc, 0x33, 0x33, 0x33, 0x33, 0xcc, 0xcc,
   0xcc, 0xcc, 0x33, 0x33, 0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xcc, 0x33, 0x33,
   0x33, 0x33, 0xcc, 0xcc, 0xcc, 0xcc, 0x33, 0x33};"
