namespace eval ::v2::ui::processes {
  class ProcessesView {
    inherit ::UI::SWidget

    private variable current_focus_component ""

    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args
      
      # create top Pane Container
      itk_component add pane_ver {
        ::UI::PaneContainer $itk_interior.pane_ver $document -orient vertical -isselected 1 \
            -withsashbitmap 0
      } { }
      
      set winwidth [$document get_variable_value WindowWidthSC]
      set itk_component(processes) \
          [$itk_component(pane_ver) add pane processes -minimum 50 \
               -thickness [expr $winwidth / 13 * 5] \
               -withtitle 1 -showInCreate 1]
      
      set itk_component(pane_hor) \
          [$itk_component(pane_ver) add container right \
               -minimum 0  -orient horizontal -withsashbitmap 0]

      set winheight [$document get_variable_value WindowHeightSC]
      set itk_component(stack) \
          [$itk_component(pane_hor) add pane stack -minimum 50 \
              -thickness [expr $winheight / 3] -withtitle 1 -showInCreate 1]
      
      set itk_component(local_variables) \
          [$itk_component(pane_hor) add pane local_variables -minimum 50 -withtitle 1 \
               -showInCreate 1]
      
      pack $itk_component(pane_ver) -side top -fill both -expand 1 -anchor nw
      
      create_components

      set_binding
    }

    public method focus_in {component} {
      if { $current_focus_component != "" } {
        $itk_component($current_focus_component) focus_in table 
      }
    }

    private method create_components {} {
      itk_component add processes_tree {
        ::v2::ui::processes::ProcessesTreeView [$itk_component(pane_ver) childsite processes].tree \
            [$document create_tcl_sub_document DocumentTypeProcessesTreeView]
      } {}

      pack $itk_component(processes_tree) \
          -fill both -anchor nw -side left -expand 1 

      itk_component add stack_view {
        ::v2::ui::processes::StackView [$itk_component(pane_hor) childsite stack].view $document
      } {}
      attach $itk_component(stack_view) CurrentStackLevel
      ::UI::auto_trace_with_init variable [$document get_variable_name CurrentProcessFrameData] \
          w $itk_interior [::itcl::code $this update_stack_title]

      pack $itk_component(stack_view) \
          -fill both -anchor nw -side left -expand 1 

      itk_component add local_variables_view {
        ::v2::ui::processes::LocalVariablesView [$itk_component(pane_hor) childsite local_variables].view \
            [$document create_tcl_sub_document DocumentTypeLocalVariablesView]
      } {}
      ::UI::auto_trace_with_init variable [$document get_variable_name CurrentStackFrameData] \
          w $itk_interior [::itcl::code $this update_variables_title]

      pack $itk_component(local_variables_view) \
          -fill both -anchor nw -side left -expand 1 
      $document set_variable_value FlatProcessTree 1
    }

    private method update_stack_title {args} {
      $itk_component(stack) update_title "Process: [$document get_variable_value CurrentProcessFrameData]"
    }
    
    private method update_variables_title {args} {
      $itk_component(local_variables) update_title "Frame: [$document get_variable_value CurrentStackFrameData]"
    }

    protected method set_binding {} {
      chain 

      bind $itk_component(processes_tree) <FocusIn> "+[code $this set_current_focus_component processes_tree]"
      bind $itk_component(stack_view) <FocusIn> "+[code $this set_current_focus_component stack_view]"
      bind $itk_component(local_variables_view) <FocusIn> "+[code $this set_current_focus_component local_variables_view]"
    }

    private method set_current_focus_component {component} {
      set current_focus_component $component
    }
  }
}
