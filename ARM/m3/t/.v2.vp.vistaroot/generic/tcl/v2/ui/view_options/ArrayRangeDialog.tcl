namespace eval ::v2::ui::view_options {
  class ArrayRangeDialog {
    inherit ::UI::BaseDialog
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      
      wm minsize $itk_interior 250 0
      wm resizable $itk_interior 1 0

      add_state_trace RangeType

      draw
    }
    protected method create_body {} {
      set top [get_body_frame]
      
      #Path
      itk_component add path_frame {
        frame $top.path_frame 
      } {}
      itk_component add path_label {
        label  $itk_component(path_frame).path_label -text "Path: "
      } {}
      itk_component add path {
        entry $itk_component(path_frame).path  
      } {}

      attach $itk_component(path) Path
      $itk_component(path) config -state disabled -disabledforeground black -disabledbackground gray
      
      itk_component add array_lf {
        iwidgets::Labeledframe $top.array_lf -labeltext "Range:" -labelpos nw
      } {}
      set childsite  [$itk_component(array_lf) childsite]

      itk_component add is_all {
        radiobutton $childsite.is_all -text "All"  -value all
      } {}

      attach $itk_component(is_all) RangeType 

      itk_component add range_frame {
        frame $childsite.range_frame
      } {}

      itk_component add is_range {
        radiobutton $itk_component(range_frame).is_range -text "Range"  -value range
      } {}

      attach $itk_component(is_range) RangeType

      itk_component add range {
        entry $itk_component(range_frame).range -disabledbackground gray
      } {}
      attach $itk_component(range) ArrayRangeValue 
      
      itk_component add explanation {
        label $childsite.explanation -text "Enter indexes and/or ranges separated by commas.\nFor example, 1,3,10-20" -justify left
      } {}

      itk_component add tail_frame {
        frame $childsite.tail_frame
      } {}

      itk_component add is_tail {
        radiobutton $itk_component(tail_frame).is_tail -text "Tail   "  -value tail
      } {}

      attach $itk_component(is_tail) RangeType

      itk_component add tail {
        entry $itk_component(tail_frame).tail -disabledbackground gray
      } {}
      attach $itk_component(tail) TailValue 

      pack $itk_component(path_label) -side left -anchor w -padx 5 -pady 5 
      pack $itk_component(path) -side left -anchor w -padx 5 -pady 5  -fill x -expand 1  
      pack $itk_component(path_frame) -side top -anchor w -padx 5 -fill x -expand 1  
      pack $itk_component(is_all) -side top -padx 5 -pady 5 -anchor w
      pack $itk_component(is_range) -side left -pady 5  -anchor w
      pack $itk_component(range) -side left -padx 5  -fill x -expand 1  -anchor w
      pack $itk_component(range_frame) -side top -padx 5  -fill x -expand 1 -anchor w
      pack $itk_component(explanation) -side top -padx 10 -pady 5 -anchor w
      pack $itk_component(is_tail) -side left -pady 5  -anchor w
      pack $itk_component(tail) -side left -padx 5  -fill x -expand 1  -anchor w
      pack $itk_component(tail_frame) -side top -padx 5  -fill x -expand 1 -anchor w
      pack $itk_component(array_lf) -side top -padx 5 -pady 5 -fill both -expand 1 -anchor w      


    }

    private method change_state {args} {
      set range_type [$document get_variable_value "RangeType"]
      if {$range_type == "all" } {
        $itk_component(range) configure -state disabled
        $itk_component(tail) configure -state disabled
      } elseif  {$range_type == "range" } {
        $itk_component(range) configure -state normal
        $itk_component(tail) configure -state disabled
      } else {
        #tail state
        $itk_component(range) configure -state disabled
        $itk_component(tail) configure -state normal
      }
    } 
  };#class
};#namespace
              
 
