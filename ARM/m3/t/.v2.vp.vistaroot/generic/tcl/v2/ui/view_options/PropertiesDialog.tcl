namespace eval ::v2::ui::view_options {
  class PropertiesDialog {
    inherit ::UI::BaseDialog
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      
      wm minsize $itk_interior 500 0
      wm resizable $itk_interior 1 0

      add_state_trace RangeKind

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      #Path
      itk_component add path_frame {
        frame $top.path_frame 
      } {}
      itk_component add path_label {
        label  $itk_component(path_frame).path_label -text "Path Pattern: "
      } {}
      itk_component add path {
        entry $itk_component(path_frame).path 
      } {}
      attach $itk_component(path) Path
      pack $itk_component(path_label) -side left -anchor w -padx 5 -pady 5 
      pack $itk_component(path) -side left -anchor w -padx 5 -pady 5  -fill x -expand 1  
      pack $itk_component(path_frame) -side top -anchor w -padx 5 -pady 5 -fill x -expand 1         

      #radix, array index radix
      foreach radix {value_radix index_radix} radix_label {"Radix" "Index Radix"} radix_var_name { Radix ArrayIndexRadix} { 
        itk_component add $radix\_lf {
          iwidgets::Labeledframe $top.$radix\_lf -labeltext $radix_label -labelpos nw
        } {}
        set radix_childsite  [$itk_component($radix\_lf) childsite]
        
        itk_component add $radix\_as_is {
          radiobutton $radix_childsite.$radix\_as_is -text "As Is"  -value "u"
        } {}
        attach $itk_component($radix\_as_is) $radix_var_name\Value
        itk_component add $radix\_bin {
          radiobutton $radix_childsite.$radix\_bin -text "Binary"  -value "b"
        } {}
        attach $itk_component($radix\_bin) $radix_var_name\Value
        itk_component add $radix\_oct {
          radiobutton $radix_childsite.$radix\_oct -text "Octal"  -value "o"
        } {}
        attach $itk_component($radix\_oct) $radix_var_name\Value
        itk_component add $radix\_hex {
          radiobutton $radix_childsite.$radix\_hex -text "Hexadecimal"  -value "h"
        } {}
        attach $itk_component($radix\_hex) $radix_var_name\Value
        itk_component add $radix\_dec {
        radiobutton $radix_childsite.$radix\_dec -text "Decimal"  -value "d"
        } {}
        attach $itk_component($radix\_dec) $radix_var_name\Value

        itk_component add $radix\_tree {
          ::UI::Checkbutton $radix_childsite.$radix\_tree -text "Apply to Subtree" 
        } {}
        attach $itk_component($radix\_tree) $radix_var_name\IsTree

        itk_component add $radix\_type_frame {
          frame $radix_childsite.$radix\_type_frame
        } {}
        itk_component add $radix\_type_label {
          label  $itk_component($radix\_type_frame).$radix\_type_label -text "Data Type Pattern: "
        } {}
        itk_component add $radix\_type {
          entry $itk_component($radix\_type_frame).$radix\_type  
        } {}
        attach $itk_component($radix\_type) $radix_var_name\TypePattern
        

        pack $itk_component($radix\_type_label) -side left  -pady 5 
        pack $itk_component($radix\_type) -side left -pady 5 -padx 5 -fill x -expand 1
        pack $itk_component($radix\_as_is) $itk_component($radix\_bin) $itk_component($radix\_oct) $itk_component($radix\_hex) $itk_component($radix\_dec) $itk_component($radix\_tree)  -side left  -pady 5
        pack  $itk_component($radix\_type_frame) -side left  -pady 5 -fill x -expand 1

        pack $itk_component($radix\_lf)  -side top -anchor w -padx 5 -ipadx 5 -pady 5 -fill x -expand 1 
      }
      #array range
      itk_component add range_lf {
        iwidgets::Labeledframe $top.range_lf -labeltext "Range:" -labelpos nw
      } {}
      set range_childsite  [$itk_component(range_lf) childsite]
      itk_component add range_as_is {
        radiobutton $range_childsite.range_as_is -text "As Is"  -value "as_is"
      } {}
      attach $itk_component(range_as_is) RangeKind
      itk_component add range_all {
        radiobutton $range_childsite.range_all -text "All"  -value "all"
      } {}
      attach $itk_component(range_all) RangeKind
      itk_component add range_range {
        radiobutton $range_childsite.range_range -text "Range"  -value "range"
      } {}
      attach $itk_component(range_range) RangeKind

      itk_component add range {
        entry $range_childsite.range -width 10  -disabledbackground gray
      } {}
      attach $itk_component(range) RangeValue

      itk_component add range_tail {
        radiobutton $range_childsite.range_tail -text "Tail"  -value "tail"
      } {}
      attach $itk_component(range_tail) RangeKind
      
      itk_component add tail {
        entry $range_childsite.tail -width 10  -disabledbackground gray
      } {}
      attach $itk_component(tail) TailValue

      itk_component add range_tree {
        ::UI::Checkbutton $range_childsite.range_tree -text "Apply to Subtree" 
      } {}
      attach $itk_component(range_tree) RangeIsTree
      
      itk_component add range_type_frame {
        frame $range_childsite.range_type_frame
      } {}
      itk_component add range_type_label {
        label  $itk_component(range_type_frame).range_type_label -text "Data Type Pattern: "
      } {}
      itk_component add range_type {
        entry $itk_component(range_type_frame).range_type
      } {}
      attach $itk_component(range_type) RangeTypePattern
      pack $itk_component(range_as_is) $itk_component(range_all) $itk_component(range_range) $itk_component(range) $itk_component(range_tail) $itk_component(tail) \
          -side left -padx 5 -pady 5
      pack $itk_component(range_type_label) -side left -padx 0 -pady 5 
      pack $itk_component(range_type) -side left -padx 0 -pady 5 

      pack $itk_component(range_tree)  $itk_component(range_type_frame) -side left -padx 5 -pady 5 

      pack $itk_component(range_lf)  -side top -anchor w -padx 5 -pady 5  -fill x -expand 1 
    }

    private method change_state {args} {
      set range_kind [$document get_variable_value "RangeKind"]
      if {$range_kind == "as_is" || $range_kind == "all"} {
        $itk_component(range) configure -state disabled
        $itk_component(tail) configure -state disabled
      } elseif  {$range_kind == "range" } {
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
              
 
 
    
