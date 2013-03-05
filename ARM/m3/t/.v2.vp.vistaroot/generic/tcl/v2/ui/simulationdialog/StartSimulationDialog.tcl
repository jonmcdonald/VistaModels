
namespace eval ::v2::ui::simulationdialog {

  class StartSimulationDialog {
    inherit ::UI::BaseDialog
    private variable savedTopName ""
    private variable visual_simulation_flag ""
    private variable text_editor_doc
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set text_editor_doc [$document create_tcl_sub_document ScriptEditor]

      if {[catch {
        create_body
      }]} {
        puts stderr $::errorInfo
      }

      create_buttons
      add_update_table_hook_to_OK_button

      eval itk_initialize $args
      
      set_title "Simulation"
      
      wm minsize $itk_interior 490 0
      wm resizable $itk_interior 1 1
      set geometry [format "%sx%s+%s+%s" \
                        [expr round([winfo vrootwidth $itk_interior]*0.3)]\
                        [expr round([winfo vrootheight $itk_interior]*0.70)]\
                        [expr  [winfo vrootx $itk_interior] + round([winfo vrootwidth $itk_interior]*0.15)]\
                        [expr  [winfo vrooty $itk_interior] + round([winfo vrootheight $itk_interior]*0.15)]]
      wm geometry $itk_interior $geometry

      add_state_trace SimulateExternalExecutable
      add_state_trace EnableEventDebugging

      draw
    }

    destructor {
      catch {
        if {[find objects $text_editor_doc] != {}} {
          delete object $text_editor_doc
        }
      }
    }

    protected method create_body {} {
      
      itk_component add tabs {
        blt::tabset [get_body_frame].tabs -side top \
            -relief flat  -bd 1 -highlightthickness 0 -samewidth 0 \
            -gap 1 -borderwidth 2 -selectpad 2
      } { 
        keep -background 
        rename -tabforeground -foreground foreground Foreground 
        rename -tabbackground  -background background Background
        rename -activebackground -background background Background
        rename -activeforeground -foreground foreground Foreground 
        rename -selectbackground -background background Background
      }

      create_general
      create_trace
      create_software
      create_environment
      create_representation
      create_IpXact


      $itk_component(tabs) config -tiers 2
      pack $itk_component(tabs) -fill both -expand 1 -side left
      
    }

    private method is_visual_simulation {} {
      if {$visual_simulation_flag != ""} {
        return $visual_simulation_flag
      }
      set visual_simulation_flag 0
      set is_external_executable [$document get_variable_value SimulateExternalExecutable]
      if {![string equal [$document get_variable_value SimulateExternalExecutable] "1"]} {
        return 0
      }
      set dirname [file dirname [$document get_variable_value ExternalExecutable]]
      if {$dirname == ""} {
        return 0
      }
      if {![file exists "$dirname/unitmap.see"]} {
        return 0
      }
      set dirname [file dirname $dirname]
      if {$dirname == ""} {
        return 0
      }
      if {![file exists "$dirname/libmap.see"]} {
        return 0
      }
      set visual_simulation_flag 1
      return 1
    }


    private method create_general {} {
      
      itk_component add sw_general {
        ::Widgets::ScrolledWindow $itk_component(tabs).sw_params -auto vertical -scrollbar vertical
      } {}
      ScrollableFrame $itk_component(sw_general).fr -constrainedwidth 1
      $itk_component(sw_general) setwidget $itk_component(sw_general).fr

      itk_component add general_fr { 
        $itk_component(sw_general).fr getframe
      } { }
      
      set top $itk_component(general_fr)
      
      ### Simulation Target
      set simulation_target [pack_framed_topic $top.simulation_target "Target"]
      
      if {[is_visual_simulation]} {
        pack forget $simulation_target
      }

      pack_subtopic [frame $simulation_target.choose]
      attach [pack_left [radiobutton $simulation_target.choose.external \
                             -text "Executable" -value 1]] SimulateExternalExecutable
      attach [pack_left [radiobutton $simulation_target.choose.internal \
                             -text "Top" -value 0]] SimulateExternalExecutable
      
      pack_topic_line [::UI::FileChooser $simulation_target.executable \
                           -buttoncmdtype openfile \
                           -dialogtitle "Executable" \
                           -filenamevariable [$document get_variable_name ExternalExecutable]] -fill x

      attach [pack_topic_line [entry $simulation_target.top_name] -fill x] SimulatingTopName
      $simulation_target.top_name configure -state disabled
      
      ### Command line arguments
      pack_framed_topic $top.args "Command line arguments"
      attach [pack_topic_line [entry $top.args.value] -fill x] \
          CommandLineArgs

      ### Parameters file
      pack_framed_topic $top.params_file "Parameters file"
      pack_topic_line [::UI::FileChooser $top.params_file.value \
                           -buttoncmdtype openfile \
                           -dialogtitle "Select Parameters File" \
                           -filenamevariable [$document get_variable_name ParametersFilePath]] -fill x   
      
      ### Working Directory
      pack_framed_topic $top.working_directory "Working Directory"
      pack_topic_line [::UI::FileChooser $top.working_directory.value \
                           -browsetype "directory" \
                           -buttoncmdtype openfile \
                           -dialogtitle "Select Working Directory" \
                           -filenamevariable [$document get_variable_name WorkingDirectory]] -fill x

      ### Simulation Result
      pack_framed_topic $top.result "Simulation Result"
      set directory1 [pack_topic_line [frame $top.result.directory] -fill x]
      pack_left [label $directory1.label -text "Directory:"]
      attach [pack_right [::UI::Checkbutton $directory1.overwrite -text "Overwrite"]] \
          OverwriteSimulationDirectory
      pack_topic_line [::UI::FileChooser $top.result.chooser -browsetype "directory"\
                           -buttoncmdtype openfile \
                           -dialogtitle "Select Simulation Results Directory" \
                           -filenamevariable [$document get_variable_name SimulationDirectory]] -fill x
      
      ### Debugging
      set fr_debug [pack_framed_topic $top.debugging "Debugging"]
      attach [pack_topic_line [::UI::Checkbutton $fr_debug.stop_before_elaboration \
                                   -text "Stop before elaboration"]] StopBeforeElaboration
      attach [pack_topic_line [::UI::Checkbutton $fr_debug.stop_after_elaboration \
                                   -text "Stop after elaboration"]]  StopAfterElaboration

      set break_on_time_frame [frame $fr_debug.break_on_time_frame -highlightthickness 0]
      label $break_on_time_frame.label -text "Stop At Time:"
      pack_subtopic $break_on_time_frame.label -side left -padx 10

      itk_component add break_on_time_entry { 
        entry $break_on_time_frame.entry 
      }
      attach $itk_component(break_on_time_entry) BreakTime
      pack_subtopic $itk_component(break_on_time_entry) -expand y -fill x -side left
    
      itk_component add break_on_time_units {
        ::UI::BwidgetCombobox $break_on_time_frame.units
      }
      attach $itk_component(break_on_time_units) BreakTimeUnit TimeUnitsList BreakTimeUnitIndex
      pack_right $itk_component(break_on_time_units)
      
      [$itk_component(break_on_time_units) component combobox] configure -width 4

      pack_topic_line $break_on_time_frame -fill x

      ### Log files
      pack_framed_topic $top.log1 "Gdb logfile"
      pack_topic_line [::UI::FileChooser $top.log1.gdblogfile \
                           -buttoncmdtype openfile \
                           -dialogtitle "GDB logfile" \
                           -filenamevariable [$document get_variable_name GDBLogfile]] -fill x

      pack_framed_topic $top.log2 "SystemC logfile"
      pack_topic_line [::UI::FileChooser $top.log2.gdblogfile \
                           -buttoncmdtype openfile \
                           -dialogtitle "SystemC logfile" \
                           -filenamevariable [$document get_variable_name SystemCLogfile]] -fill x

      $itk_component(tabs) insert end general -text "General" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(sw_general)
    }
    

    private method create_trace {} {

      itk_component add sw_trace {
        ::Widgets::ScrolledWindow $itk_component(tabs).sw_trace -auto vertical -scrollbar vertical
      } {}
      ScrollableFrame $itk_component(sw_trace).fr -constrainedwidth 1
      $itk_component(sw_trace) setwidget $itk_component(sw_trace).fr
      
      set fr_trace [$itk_component(sw_trace).fr getframe]

      set fr_trace_mode [frame $fr_trace.fr_trace_mode]
      pack $fr_trace_mode -fill x -side top
      set rb_dont_restore [radiobutton $fr_trace_mode.dont_restore -text "Use Scripts" -value 0]
      set rb_restore [radiobutton $fr_trace_mode.restore -text "Restore Last Tracing" -value 1]
      attach $rb_dont_restore RestoreLastTracing
      attach $rb_restore RestoreLastTracing
      pack $rb_dont_restore $rb_restore -side left
      
      set fr_trace_script [pack_framed_topic $fr_trace.trace_script "Initial Script"]
      pack $fr_trace_script -fill x -side top

      set cb_use_trace_script [::UI::Checkbutton $fr_trace_script.use -text "Use"]
      attach $cb_use_trace_script RunSimulationScript
      pack $cb_use_trace_script -side left
      set e_trace_script [::UI::FileChooser $fr_trace_script.script \
                              -buttoncmdtype openfile \
                              -dialogtitle "Simulation Script" \
                              -filetypes {{"Tcl" "*.tcl"} {"All Files" "*"}} \
                              -filenamevariable [$document get_variable_name SimulationScript]]
      pack $e_trace_script -side left -fill x -expand y

      set fr_transcript [pack_framed_topic $fr_trace.transcript "Trace Transcript"]
      pack $fr_transcript -fill both -side top -expand 1
      set cb_use_transcript [::UI::Checkbutton $fr_transcript.use -text "Use"]
      attach $cb_use_transcript RunTranscript
      pack $cb_use_transcript -side top -anchor nw

      set text_editor [::v2::ui::text_editor::TextEditor $fr_transcript.text_editor $text_editor_doc]

      pack $text_editor -anchor nw -side top -fill both -expand 1
      pack forget [$text_editor component menu]

      set fr_trace_tlm [pack_framed_topic $fr_trace.tlm "TLM"]
      attach [pack_topic_line [::UI::Checkbutton $fr_trace_tlm.traceAllSockets \
                                   -text "Trace all sockets"]] TraceAllSockets
      attach [pack_topic_line [::UI::Checkbutton $fr_trace_tlm.saveEventsCounter \
                                   -text "Enable Transaction Sequence Recording"]] SaveEventsCounter

      itk_component add advanced_fr {
        labelframe $fr_trace.more -labelanchor nw -text "Advanced"
      } {}

      set fr_trace_more $itk_component(advanced_fr)
      pack $itk_component(advanced_fr) -side top -anchor w -fill x -pady 5

      attach [pack_topic_line [::UI::Checkbutton $fr_trace_more.saveDeltaCycles \
                                   -text "Trace Delta Cycles"]] SaveDeltaCycles
      if {[::Utilities::safeGet ::env(V2_ENABLE_MEMORY_PROFILING)] == "1"} {
        attach [pack_topic_line [::UI::Checkbutton $fr_trace_more.enableMemoryProfiling \
                                     -text "Enable Memory Allocation Profiling"]] EnableMemoryProfiling
      }
      attach [pack_topic_line [::UI::Checkbutton $fr_trace_more.traceAllSignals \
                                   -text "Trace all signals"]] TraceAllPrimitiveChannels
      
      itk_component add enable_event_debugging {
        ::UI::Checkbutton $fr_trace_more.enableEventDebugging -text "Enable Event Debugging"
      } {}
      attach [pack_topic_line $itk_component(enable_event_debugging) ] EnableEventDebugging
      itk_component add enable_stack_logging {
        ::UI::Checkbutton $fr_trace_more.enableStackLogging -text "Enable Cause"
      } {}
      attach [pack_topic_line $itk_component(enable_stack_logging) -padx 15 ] EnableStackLogging


      itk_component add analysis_fr {
        labelframe $fr_trace.analysis -labelanchor nw -text "Analysis"
      } {}

      set fr_trace_analysis $itk_component(analysis_fr)
      pack $itk_component(analysis_fr) -side top -anchor w -fill x -pady 5

      attach [pack_topic_line [::UI::Checkbutton $fr_trace_analysis.traceHitMissRatio \
                                   -text "Trace Cache Hit/Miss Ratio"]] TraceHitMisRatio


      #add to tabs#
      $itk_component(tabs) insert end  trace -text "Tracing" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
           -window $itk_component(sw_trace)
    }

    private method create_software {} {
      itk_component add software_fr { 
        frame $itk_component(tabs).software_fr 
      } { }
      
      set codebug [pack_framed_topic $itk_component(software_fr).codebug "Hardware/Software co-Debug settings"]
      pack_subtopic [frame $codebug.choose]
       itk_component add use_go_to_next_instruction {
        ::UI::Checkbutton $codebug.use_go_to_next_instruction -text "Enable Go to Next Software Instruction"
      } {}
      attach [pack_topic_line $itk_component(use_go_to_next_instruction) ] EnableGoToNextSoftwareInstruction

      set license [pack_framed_topic $itk_component(software_fr).license "Licensing"]
      pack_subtopic [frame $license.choose]
       itk_component add enable_vp_plus {
        ::UI::Checkbutton $license.enable_vp_plus -text "Enable VP PLUS License"
      } {}
      attach [pack_topic_line $itk_component(enable_vp_plus) ] EnableVPPLUS
      

      $itk_component(tabs) insert end software -text "Software" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(software_fr)
    }

    private method create_environment {} {
      itk_component add env_fr { 
        frame $itk_component(tabs).env_fr 
      } { }
      
      itk_component add env_label_fr {
        labelframe $itk_component(env_fr).env_label_fr -labelanchor nw -text  "Environment Variables"
      } {}

      #create table
      itk_component add env_table {
        tixTable $itk_component(env_label_fr).env_table -cols 3 -titlerows 1 -xscroll no
      } {}
      
      #add embedded windows to the table
      itk_component add env_name {
        entry  $itk_component(env_fr).env_name -textvariable [namespace current]::env_name_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      itk_component add env_value {
        entry  $itk_component(env_fr).env_value -textvariable [namespace current]::env_value_var -bd 1 -bg white \
            -takefocus 0
      } {}
      $itk_component(env_table) window 0  $itk_component(env_name) 1 $itk_component(env_value) 

      attach $itk_component(env_table) EnvironmentTable
      $itk_component(env_table).table config -height 20

      set titleRow [$itk_component(env_table).table cget -roworigin]
      $itk_component(env_table).table set $titleRow,0 "Name"
      $itk_component(env_table).table set $titleRow,1 "Value"
      
      #buttons
      itk_component add buttons_fr {
        frame $itk_component(env_label_fr).buttons_fr
      } {}

      itk_component add save_button {
        button $itk_component(buttons_fr).add_button -text "Save" -underline 0 -command "$this saveEnvironmentVariables"
      } {}
      itk_component add load_button {
        button $itk_component(buttons_fr).load_button -text "Load" -underline 0 -command "$this loadEnvironmentVariables"
      } {}
      
      #packing
      pack $itk_component(env_table) -fill x  -side top -anchor w -pady 2 -padx 5
      pack $itk_component(env_label_fr) -fill x  -side top -anchor w -pady 5
      pack $itk_component(save_button) -side left  -padx 20 -pady 5
      pack $itk_component(load_button) -side right  -padx 20 -pady 5
      pack $itk_component(buttons_fr) -fill x -expand 0 -side top -anchor w

      $itk_component(tabs) insert end  env -text "Environment" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(env_fr)
    }

    private method create_representation {} {
      itk_component add represent_fr { 
        frame $itk_component(tabs).represent_fr 
      } { }
      
      set transactions_data [pack_framed_topic $itk_component(represent_fr).transactions_data "TLM Transactions Data Representation"]
      pack_subtopic [frame $transactions_data.choose]
      attach [pack_left [radiobutton $transactions_data.choose.little \
                             -text "Little-endian" -value 1] -padx 10 ] IsLittleEndian
      attach [pack_left [radiobutton $transactions_data.choose.big \
                             -text "Big-endian" -value 0] ] IsLittleEndian
      itk_component add remove_leading_zeros {
        ::UI::Checkbutton $transactions_data.removeLeadingZeroes -text "Remove Leading Zeroes"
      } {}
      attach [pack_topic_line $itk_component(remove_leading_zeros) ] RemoveLeadingZeroes
      

      $itk_component(tabs) insert end  rep -text "Representation" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(represent_fr)
    }

    private method create_IpXact {} {
      itk_component add ipx_fr { 
        frame $itk_component(tabs).ipx_fr 
      } { }

      set ipx $itk_component(ipx_fr)

      set gen_ipxact [pack_framed_topic $ipx.gen_ipxact "IP-XACT Generation"]
      attach [pack_topic_line [::UI::Checkbutton $gen_ipxact.generate \
                                   -text "Generate IP-XACT"]] GenerateIpXactDesign
      set out_direct [pack_topic_line [frame $gen_ipxact.out_direct] -fill x]
      pack_left [label $out_direct.label -text "Output Directory:"]
      pack_topic_line [::UI::FileChooser $gen_ipxact.chooser -browsetype "directory"\
                           -buttoncmdtype openfile \
                           -dialogtitle "Select Output Directory for IP-XACT" \
                           -filenamevariable [$document get_variable_name IpXactOutputDirectory]] -fill x

      $itk_component(tabs) insert end ipx -text "IP-XACT" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(ipx_fr)
    }

    private method pack_topic {el args} {
      eval [list pack $el -side top -anchor w -fill x -pady 5] $args
      return $el
    }

    private method pack_framed_topic {el text args} {
      eval [list pack_topic [labelframe $el -labelanchor nw -text $text]] $args
      return $el
    }

    private method pack_topic_line {el args} {
      eval [list pack $el -side top -anchor w -pady 2 -padx 5] $args
      return $el
    }

    private method pack_subtopic {el args} {
      eval [list pack $el -side top -anchor w -fill x -pady 2] $args
      return $el
    }

    private method pack_left {el args} {
      eval [list pack $el -side left -anchor w -fill x -padx 5] $args
      return $el
    }

    private method pack_right {el args} {
      eval [list pack $el -side right -anchor e -padx 2] $args
      return $el
    }

    private method change_state {args} {
      set variable_name [lindex $args 0]
      if {$variable_name == "SimulateExternalExecutable"} {
        $itk_component(break_on_time_entry) configure -state normal
        $itk_component(break_on_time_entry) configure -background white
        $itk_component(break_on_time_units) configure -state normal
        set simulateExternalExecutable [$document get_variable_value SimulateExternalExecutable]
        set simulation_target $itk_component(general_fr).simulation_target
        
        switch $simulateExternalExecutable {
          0 {
            pack forget $simulation_target.executable 
            pack_topic_line $simulation_target.top_name -fill x
            $simulation_target.executable configure -state disabled
          }
          1 {
            pack_topic_line $simulation_target.executable -fill x
            pack forget $simulation_target.top_name
            $simulation_target.executable configure -state normal
          }
        }
      } else {
        #EnableEventDebugging / EnableStackLogging
        if {[$document get_variable_value "EnableEventDebugging"]} {
          $itk_component(enable_stack_logging) configure -state normal
        } else {
          $itk_component(enable_stack_logging) configure -state disabled
        }
      }
      
    }
    private method add_update_table_hook_to_OK_button { } {
      set children [winfo children $itk_component(buttons)]
      catch {
        foreach child $children {
          set command [$child cget -command] 
          if { [string first "OKCommand" $command] != -1} {
            $child config -command "$this updateTable; $command"
            break
          }
        }
      }
    }

    public method updateTable {} {
      $itk_component(env_table) saveactivedata
    }
    public method saveEnvironmentVariables {} {
      updateTable
      $document run_command SimulationDialogSaveEnvironmentCommand
    }
    public method loadEnvironmentVariables {} {
      updateTable
      $document run_command SimulationDialogLoadEnvironmentCommand
    }
    

  };#class
};#namespace
