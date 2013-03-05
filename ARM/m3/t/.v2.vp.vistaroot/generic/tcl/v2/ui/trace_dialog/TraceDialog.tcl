namespace eval ::v2::ui::trace_dialog {
  class TraceDialog {
    inherit ::UI::BaseDialog ::UI::CommandLineDialog
    private variable action "Trace"
    private variable command_action "Trace"

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set dialogType  [$document get_variable_value "DialogType"]
      if {$dialogType == "acquire" || $dialogType == "acquire_to_analysis"} {
        set action "Acquire"
      } else {
        set action "Trace"
      }
      switch -- $dialogType {
        "trace" { set command_action "Trace"}
        "trace_transactions" {set command_action "Trace transactions"}
        "acquire" {set command_action "Acquire"}
        "acquire_to_analysis" { set command_action "Acquire to analysis"}
        
      }

      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 100 100
      if {$dialogType != "acquire" && $dialogType != "acquire_to_analysis"} {
        add_state_trace IsUntrace
        add_state_trace IsTraceAtTime
      } else {
        add_state_trace IsAcquireAndTrace
      }
#      add_state_trace IsAcquire             

      add_state_trace IsUnlimited


      draw
    }


    protected method create_body {} {
      set top [get_body_frame]
      set dialogType [$document get_variable_value "DialogType"]

      itk_component add dialog_type_frame {
        frame $top.dialog_type_frame
      } {}

      #Trace/Untrace radio button
      if {$dialogType == "acquire"} {
        itk_component add acquire_and_trace {
          radiobutton $itk_component(dialog_type_frame).acquire_and_trace -text "Acquire and trace"  -value 1
        } {}
        attach $itk_component(acquire_and_trace) IsAcquireAndTrace
        setRadiobuttonBindings $itk_component(acquire_and_trace)

        itk_component add acquire_only {
          radiobutton $itk_component(dialog_type_frame).acquire_only -text "Acquire only" -value 0
        } {}
        attach $itk_component(acquire_only) IsAcquireAndTrace
        setRadiobuttonBindings $itk_component(acquire_only)
      } elseif {$dialogType != "acquire_to_analysis"} {

        itk_component add trace {
          radiobutton $itk_component(dialog_type_frame).trace -text "Trace" -value 0
        } {}
        attach $itk_component(trace) IsUntrace
        setRadiobuttonBindings $itk_component(trace)

        itk_component add untrace {
          radiobutton $itk_component(dialog_type_frame).untrace -text "Untrace" -value 1
        } {}
        attach $itk_component(untrace) IsUntrace
        setRadiobuttonBindings $itk_component(untrace)
      }
      #Command Line
      itk_component add command_line_lf {
        iwidgets::Labeledframe $top.command_line_lf -labeltext "$command_action command:"  -labelpos nw
      } {}
      set childsite  [$itk_component(command_line_lf) childsite]
      itk_component add command_line_text {
        ::UI::SText $childsite.command_line_text $document -height 3 -state normal -font "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
      } {
        keep -font
      }
      attach $itk_component(command_line_text) CommandLine
      setCommandLineBindings  $itk_component(command_line_text) TraceCommandIsEditedManually $document

      #Acquire
      if {$dialogType == "acquire"} {
        itk_component add acquire_frame {
          frame $childsite.acquire_frame
        } {}
        itk_component add wave_label {
          label $itk_component(acquire_frame).wave_label -text "Acquire to wave:"
        } {}
      
        itk_component add waves {
          ::UI::BwidgetCombobox   $itk_component(acquire_frame).waves -helptext "Choose wave" -editable 1
        } {}
        attach $itk_component(waves) Wave WaveList WaveIndex
        setBwidgetComboboxBindings $itk_component(waves) Wave
      }

      #path
      itk_component add path_frame {
        frame $childsite.path_frame 
      } {}
      itk_component add path_label {
        label  $itk_component(path_frame).path_label -text "$action path: "
      } {}
      itk_component add path {
        entry $itk_component(path_frame).path -disabledbackground gray
      } {}
      attach $itk_component(path) Path
      setEntryBindings $itk_component(path)

      #name and kind
      itk_component add name_and_kind_frame {
        frame $childsite.name_and_kind_frame
      } {}
      itk_component add name_label {
        label $itk_component(name_and_kind_frame).name_label -text "Name pattern:"
      } {}
      itk_component add name {
        entry $itk_component(name_and_kind_frame).name -disabledbackground gray
      } {}
      attach $itk_component(name) Name
      setEntryBindings $itk_component(name) 
      if {$dialogType != "trace_transactions"} {
        itk_component add kind_label {
          label $itk_component(name_and_kind_frame).kind_label -text "Kind:"
        } {}
        itk_component add kind {
          ::UI::BwidgetCombobox   $itk_component(name_and_kind_frame).kind -editable 1
        } {}
        attach $itk_component(kind) Kind KindsList KindIndex
        setBwidgetComboboxBindings $itk_component(kind) Kind
        #[$itk_component(kind) component combobox] configure -width 15
      }

      #Tree
      itk_component add tree {
        ::UI::Checkbutton $itk_component(name_and_kind_frame).tree -text "$action tree"
      } {}

      attach $itk_component(tree) IsTraceTree
      setCheckbuttonBindings  $itk_component(tree)

      #time 
      itk_component add time_frame {
        frame $childsite.time_frame 
      } {}
      if {$dialogType != "acquire" && $dialogType != "acquire_to_analysis"} {
        itk_component add at_time_button {
          ::UI::Checkbutton $itk_component(time_frame).at_time_button -text "$action at time:"
        } {}
        attach $itk_component(at_time_button) IsTraceAtTime
        setCheckbuttonBindings $itk_component(at_time_button)
      
        itk_component add at_time {
          entry $itk_component(time_frame).at_time -disabledbackground gray
        } {}
        attach $itk_component(at_time) AtTime
        setEntryBindings $itk_component(at_time)

        itk_component add at_time_units {
          ::UI::BwidgetCombobox   $itk_component(time_frame).at_time_units -editable 0
        } {}
        [$itk_component(at_time_units) component combobox] configure -width 4
        attach $itk_component(at_time_units) TimeUnits TimeUnitsList TimeUnitIndex
        setBwidgetComboboxBindings $itk_component(at_time_units) TimeUnits
      }
      #until
      itk_component add until_frame {
        frame $itk_component(time_frame).until_frame
      } {}

      if {$dialogType == "acquire" || $dialogType == "acquire_to_analysis" } {
        set until_text "Trace until:    "
      } else {
        set until_text " Until:"
      }
      itk_component add until_time_label {
        label $itk_component(until_frame).until_time_label -text $until_text
      } {}
      itk_component add until_time {
        entry $itk_component(until_frame).until_time -disabledbackground gray
      } {}
      attach $itk_component(until_time) UntilTime
      setEntryBindings $itk_component(until_time)
      
      itk_component add until_time_units {
        ::UI::BwidgetCombobox   $itk_component(until_frame).until_time_units -helptext "Choose time units" -editable 0
        } {}
      attach $itk_component(until_time_units) UntilTimeUnits TimeUnitsList UntilTimeUnitIndex
      [$itk_component(until_time_units) component combobox] configure -width 4
      setBwidgetComboboxBindings $itk_component(until_time_units) UntilTimeUnits


      #Limit
      itk_component add limit_frame {
        frame $childsite.limit_frame
      } {}
      itk_component add limited {
        radiobutton $itk_component(limit_frame).limited -text "$action Limit" -value 0
      } {}
      attach $itk_component(limited) IsUnlimited
      setRadiobuttonBindings $itk_component(limited)
      itk_component add limit {
        entry $itk_component(limit_frame).limit -disabledbackground gray
      } {}
      attach $itk_component(limit) Limit
      setEntryBindings $itk_component(limit)

      itk_component add unlimited {
        radiobutton $itk_component(limit_frame).unlimited -text "Unlimited" -value 1
      } {}
      attach $itk_component(unlimited) IsUnlimited
      setRadiobuttonBindings $itk_component(unlimited)


      #Packing:

      if {$dialogType == "acquire"} {
        pack $itk_component(acquire_and_trace) -side left -anchor nw -padx 5
        pack $itk_component(acquire_only) -side left  -anchor nw -padx 50
      } elseif {$dialogType != "acquire_to_analysis"} {
        pack $itk_component(trace) -side left -anchor nw -padx 5
        pack $itk_component(untrace) -side left  -anchor nw -padx 50
      }


      pack $itk_component(command_line_text) -side top -fill both -expand 1 -anchor nw -pady 5 -padx 5

      if {$dialogType == "acquire"} {
        pack $itk_component(wave_label) -side left -anchor nw  -padx 0
        pack $itk_component(waves) -side left  -anchor nw -padx 10
      }      

      if {$dialogType == "acquire"} {
        pack $itk_component(path_label) -side left -anchor nw -padx 0
        pack $itk_component(path) -side left  -anchor nw -fill x -expand 1
      } elseif {$dialogType != "acquire_to_analysis"} {
        pack $itk_component(path_label) -side left -anchor nw -padx 5
        pack $itk_component(path) -side left  -anchor nw -fill x -expand 1 -padx 10
      }
      pack $itk_component(name_label) -side left -anchor nw -padx 5
      pack $itk_component(name) -side left -fill x -expand 1 -anchor nw
      if {$dialogType != "trace_transactions"} {
        pack $itk_component(kind_label) -side left -padx 10 -anchor nw
        pack $itk_component(kind) -side left -fill x -expand 1 -anchor nw    
      }
      pack $itk_component(tree) -side left -anchor nw


      if {$dialogType != "acquire" && $dialogType != "acquire_to_analysis"} {
        pack $itk_component(at_time_button) -side left -anchor nw -pady 10 
        pack $itk_component(at_time) -side left -anchor nw -fill x -expand 1 -anchor nw -pady 10 
        pack $itk_component(at_time_units) -side left -anchor nw -pady 10
      } 
      pack $itk_component(until_time_label) -side left -anchor nw -padx 5 -pady 10 
      pack $itk_component(until_time) -side left  -fill x -expand 1 -anchor nw -pady 10

      pack $itk_component(until_time_units) -side left -anchor nw -pady 10 
      pack $itk_component(limited) -side left  -anchor nw -padx 5
      pack $itk_component(limit) -side left  -anchor nw  -padx 10
      pack $itk_component(unlimited) -side left  -anchor nw -padx 5
      


      pack $itk_component(dialog_type_frame) -side top -fill x  -pady 10 -anchor nw
      if {$dialogType == "acquire"} {
        pack $itk_component(acquire_frame)  -side top -anchor nw -pady 5 -padx 5 -fill x 
        pack $itk_component(path_frame) -side top -fill x  -pady 10 -anchor nw -padx 5
      } else {
        pack $itk_component(path_frame) -side top -fill x  -pady 10 -anchor nw
      }

      pack $itk_component(name_and_kind_frame) -side top -fill x  -anchor nw
      if {$dialogType == "acquire" || $dialogType == "acquire_to_analysis"} {
        pack $itk_component(until_frame) -side left -anchor nw -fill x -padx 0
      } else {
        pack $itk_component(until_frame) -side left -anchor nw -fill x -padx 10
      }
      pack $itk_component(time_frame) -side top -anchor nw -fill x 
      pack $itk_component(limit_frame) -side top -anchor nw -fill x -pady 2 

      pack $itk_component(command_line_lf) -side top -anchor nw -pady 5 -fill both -expand 1 

    }
    
    private method redraw_on_dialog_trace_untrace_action_change {} {
      #we cannot get here from acquire dialog
      set dialogType [$document get_variable_value "DialogType"]
      if { [$document get_variable_value "IsUntrace"]} {
        set action "Untrace"
        $itk_component(until_time) configure -state disabled
        $itk_component(until_time_units) configure -state disabled
        [$itk_component(until_time_units) component combobox] configure -entrybg gray
      } else {
        set action "Trace"
        $itk_component(until_time) configure -state normal
        $itk_component(until_time_units) configure -state normal 
        [$itk_component(until_time_units) component combobox] configure -entrybg white
      }
      if {$dialogType == "trace_transactions"} {
        set command_action "$action Transactions"
      } 
      $itk_component(command_line_lf) configure -labeltext "$command_action command:"

      $itk_component(path_label) configure -text "$action path: "
      $itk_component(tree) configure -text "$action tree"
      $itk_component(at_time_button) configure -text "$action at time:"
    }
    
    private method redraw_on_dialog_acquire_action_change {} {
      if { [$document get_variable_value "IsAcquireAndTrace"]} {
        $itk_component(until_time) configure -state normal
        $itk_component(until_time_units) configure -state normal 
        [$itk_component(until_time_units) component combobox] configure -entrybg white
        
      } else {
        $itk_component(until_time) configure -state disabled
        $itk_component(until_time_units) configure -state disabled
        [$itk_component(until_time_units) component combobox] configure -entrybg gray
      }
    }
    
    private method change_state {args} {
      set variable_name [lindex $args 0]
      if { $variable_name == "IsUntrace" } {
        redraw_on_dialog_trace_untrace_action_change
      } elseif {$variable_name == "IsAcquireAndTrace"} {
        redraw_on_dialog_acquire_action_change
      } elseif {$variable_name == "IsTraceAtTime"} {
        if {[$document get_variable_value "IsTraceAtTime"]} {
          $itk_component(at_time) configure -state normal
          $itk_component(at_time_units) configure -state normal 
          [$itk_component(at_time_units) component combobox] configure -entrybg white
        } else {
          $itk_component(at_time) configure -state disabled
          $itk_component(at_time_units) configure -state disabled 
          [$itk_component(at_time_units) component combobox] configure -entrybg gray
        } 
      } elseif {$variable_name == "IsUnlimited"} {
        if {[$document get_variable_value "IsUnlimited"]} {
          $itk_component(limit) configure -state disabled
        } else {
          $itk_component(limit) configure -state normal
        }
      }
    }

    public proc parse_command_line {line dialog_type} {
      set kind "any"
      set path ""
      set name ""
      set tree 0
      set is_untrace 0
      set is_unlimited 0
      set limit 100
      set is_acquire_and_trace 0
      set line [::Utilities::guiInputToValidTclString $line]
      set until_reached 0

      #try to read time at the beginning of the line
      set res [get_time_notation $line]

      #the line without time notation if found, otherwise the same line as before
      set line [lindex $res 0]
      set time [lindex $res 1]
      set timeUnits [lindex $res 2]
      set untilTime ""
      set untilTimeUnits ""

      set count [llength $line]
      set next_arg_type "unknown"

      for {set i 0} {$i < $count && !$until_reached} { incr i} {
        set arg [lindex $line $i]
#        puts "arg=$arg next_arg_type = $next_arg_type"
        
        switch -exact -- $arg {
          "trace" -
          "trace_transactions" {
            set next_arg_type "path"
            set is_untrace 0
            set is_acquire 0
          }
          "untrace" -
          "untrace_transactions" {
            set next_arg_type "path"
            set is_untrace 1
          }
          "acquire" {
            set next_arg_type "path"
            set is_untrace 0
          }
          "-kind" {
            set next_arg_type "kind"
          }
          "-name" {
            set next_arg_type "name"
          }
          "-tree" {
            set tree 1
            set next_arg_type "unknown"
          }
          "-limit" {
            set next_arg_type "limit"
            set is_unlimited 0
          }
          "-unlimited" {
            set is_unlimited 1
            set next_arg_type "unknown"
          }
          "-trace" {
            set is_acquire_and_trace 1
            set next_arg_type "unknown"
          }
          default {
            switch -exact -- $next_arg_type {
              "kind" {
                set kind $arg
                set next_arg_type "unknown"
              }
              "name" {
                set name $arg
                set next_arg_type "unknown"
               }
              "path" {
                append path " " $arg
              }
              "limit" {
                set limit $arg
                set next_arg_type "unknown"
              }
              default { 
                set first_char [string index $arg 0]
                if { $first_char == "@" } {
                  #try to read until_time 
                  set until_res [get_time_notation [lrange $line $i end]]
                  set untilTime [lindex $until_res 1]
                  set untilTimeUnits [lindex $until_res 2]
                  set until_reached 1
                }  elseif { $first_char != "-" } {
                  append path " " $arg
                }
                set next_arg_type "unknown"
              }
              
            }
          }
        }
      }

      switch -- $dialog_type {
        "trace" { 
          set keyed_list [list "Path" $path "Name" $name "Kind" $kind "Tree" $tree "AtTime" $time "TimeUnits" $timeUnits "IsUntrace" $is_untrace "IsUnlimited" $is_unlimited "Limit" $limit  "UntilTime" $untilTime "UntilTimeUnits" $untilTimeUnits]
        }
        "trace_transactions" {
          set keyed_list [list "Path" $path "Name" $name "Tree" $tree "AtTime" $time "TimeUnits" $timeUnits "IsUntrace" $is_untrace "IsUnlimited" $is_unlimited "Limit" $limit  "UntilTime" $untilTime "UntilTimeUnits" $untilTimeUnits]
        }
        "acquire" {
          set keyed_list [list "Path" $path "Name" $name "Kind" $kind "Tree" $tree "IsUnlimited" $is_unlimited "Limit" $limit "IsAcquireAndTrace" $is_acquire_and_trace "UntilTime" $untilTime "UntilTimeUnits" $untilTimeUnits]
        }
      }

#      puts "keyed_list = $keyed_list"
      return $keyed_list
      
    }

    private proc get_time_notation {line} {
      set time ""
      set timeUnits ""
      set timeNotation ""
      set line [string trim $line]
      
      if {[regexp {^@\s*([0-9]*\.?[0-9]*)\s*(ps|ns|us|ms|fs|s)} $line timeNotation time timeUnits]} {
        set length [string length $timeNotation]
        set line [string range $line $length end]
      } 
      set res [list $line $time $timeUnits]
      return $res
    }

  };#class
};#namespace
