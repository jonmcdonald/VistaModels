### main frame option
option add *TlmWindow.background \#e0e0e0 widgetDefault
option add *TlmWindow.helpbackground yellow widgetDefault
option add *TlmWindow.helpforeground black widgetDefault
option add *TlmWindow.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *TlmWindow.winwidth 768 widgetDefault
option add *TlmWindow.winheight 512 widgetDefault

namespace eval ::v2::ui::tlmwindow {
  
  proc refresh {history_file_name runtime time_params} {
    variable theWindow
    [$theWindow get_document] run_command RefreshCommand HistoryFileNameArg $history_file_name RuntimeArg $runtime TimeParamsArg $time_params
  }

  proc raise {} {
    variable theWindow
    $theWindow show
  }

  proc close {} {
    [$theWindow get_document] run_command DestroyCommand
  }

  proc sync_time { startTime} {
    variable theWindow
    [$theWindow get_document] run_command SyncTimeCommand StartTime $startTime
  }

  class TlmWindow {
    inherit ::UI::TopView
    
    private variable timeFrame
    private variable runtimeFrame

    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent]
    } {
      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onDelete]
      eval itk_initialize $args

      create_standart_component $document
      itk_component add table_view {
        ::v2::ui::tlmwindow::TlmTable $itk_interior.table_view $document
      } {}

      set timeFrame $itk_component(table_view).time_frame
      set runtimeFrame $timeFrame.runtime_frame
      frame $timeFrame
      frame $runtimeFrame

      itk_component add time_button {
        button $timeFrame.time_button -text "Go to Time" -pady 1 -padx 2 -borderwidth 1
      } {}
      attach $itk_component(time_button) GoToTimeCommand

      itk_component add time {
        entry $timeFrame.time
      } {}
      attach $itk_component(time) GoToTimeData
      bind $timeFrame.time <Return> [list $document run_command GoToTimeCommand]

#      itk_component add units {
#        ::UI::BwidgetCombobox $timeFrame.units
#      } {}
#      attach $itk_component(units) TimeUnits TimeUnitsList TimeUnitIndex
#      [$itk_component(units) component combobox] configure -width 3

      itk_component add runtime_label {
        label $runtimeFrame.runtime_label -text "     Runtime:"
      } {}

      itk_component add runtime {
        label $runtimeFrame.runtime -relief sunken -borderwidth 1
      } {}
      attach $itk_component(runtime) RuntimeRepresentation

      set ::v2::ui::tlmwindow::theWindow $this
    }

    private method on_runtime_changed {widget variable_name args} {
      set top $itk_component(table_view)
      set value ""
      catch {
        set value [string trim [$document get_variable_value RuntimeRepresentation]]
      }
      if {$value == ""} {
        pack forget $runtimeFrame
      } else {
        pack $runtimeFrame -anchor w
      }
    }
    
    private method onDelete {args} {
      $::main_doc run_command ExitCommand
    }

    public method show {} {
      show_standart_component
      pack $itk_component(table_view) -side top -fill both -expand 1 -anchor nw
      set top $itk_component(table_view)

#      set top $itk_interior
#      puts $timeFrame
#      pack $timeFrame -fill x -side top -padx 2
      grid $timeFrame -column 1 -row 4 -sticky ew

      pack $itk_component(time_button) -side left
      pack $itk_component(time) -side left  -anchor w
#      pack $itk_component(units) -side left -expand n -anchor w
      pack $runtimeFrame -side left -anchor w
      pack $itk_component(runtime_label) -side left
      pack $itk_component(runtime) -side left


      ::UI::auto_trace_with_init variable [$itk_component(runtime) cget -textvariable] w $itk_interior [::itcl::code $this on_runtime_changed]

      chain
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

