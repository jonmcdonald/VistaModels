
namespace eval ::v2::ui::vpdialog {
  catch {delete class VPDialog}
  class VPDialog {
    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      
      eval itk_initialize $args
      
      if {[catch {
        create_body
      }]} {
        puts stderr $::errorInfo
      }

      create_buttons
      add_update_table_hook_to_OK_button

      set_title "Virtual Prototype"
      
      wm minsize $itk_interior 800 400
      wm resizable $itk_interior 1 1

      add_state_trace VirtualPrototypeUseExternalExecutable

      draw
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
      create_environment env_fr "Environment" \
          [join [list \
                     "Set runtime environment variables for Virtual Prototype." \
                     "" \
                     "For each variable, fill variable name and value." \
                     "The root of Virtual Prototype environment may be referred via \$VPROOT ." \
                    ] \n] \
          VirtualPrototypeEnvironmentTable
      create_copy_tab copy_directories_fr "Directories" \
          [join [list \
                     "Copy directories into Virtual Prototype running environment." \
                     "" \
                     "Specify source directory, relative path to the target directory in the runtime environment," \
                     "and/or the name of the environment variable to access the directory in the runtime." \
                     "" \
                     "If no source directory is specified, a new directory will be created in the runtime environment."
                    ] \n] \
          VirtualPrototypeCopyDirectoriesTable directory "Select Directory"
      create_copy_tab copy_files_fr "Files" \
          [join [list \
                     "Copy files into Virtual Prototype running environment." \
                     "" \
                     "Specify source file, relative path to the target directory in the runtime environment," \
                     "and/or the name of the environment variable to access the file in the runtime." \
                    ] \n] \
          VirtualPrototypeCopyFilesTable file "Select File"


      $itk_component(tabs) config -tiers 2
      pack $itk_component(tabs) -fill both -expand 1 -side top
    }

    private method create_message {component_name} {
      set message_component_name [set component_name]_message
      itk_component add $message_component_name {
        label $itk_component($component_name).$message_component_name -fg red -justify left
      }
      attach $itk_component($message_component_name) LastErrorText
      bind $itk_component($message_component_name) <ButtonPress-1> [itcl::code $this clearLastErrorText]

      pack $itk_component($message_component_name) -fill none -expand 1 -side bottom -anchor w -padx 5 -pady 2
    }

    private method create_general {} {
      set component_name general_fr

      itk_component add general_fr { 
        frame $itk_component(tabs).general_fr 
      } { }
      
      set top $itk_component(general_fr)
      
      set docfile_topic [pack_bottom_framed_topic $top.docfile_topic "Virtual Prototype Project File:"]
      pack_topic_line [label $top.docfile_topic.explanation -fg blue -justify left \
                           -text [join [list \
                                            "File to store settings in this dialog." \
                                           ] \n] ]
      pack_topic_line [::UI::FileChooser $top.docfile_topic.docfile \
                           -buttoncmdtype savefile \
                           -dialogtitle "Virtual Prototype Project File" \
                           -filenamevariable [$document get_variable_name VirtualPrototypeFile]] -fill x

      set result_topic [pack_bottom_framed_topic $top.result_topic "Virtual Prototype File:"]
      pack_topic_line [label $top.result_topic.explanation -fg blue -justify left \
                           -text [join [list \
                                            "Virtual Prototype file to be generated." \
                                           ] \n] ]
      pack_topic_line [::UI::FileChooser $top.result_topic.result \
                           -buttoncmdtype savefile \
                           -dialogtitle "Virtual Prototype File" \
                           -filenamevariable [$document get_variable_name VirtualPrototypeResultExecutable]] -fill x

      ### For Windows?
      set vp_target_platform [pack_framed_topic $top.vp_target_platform "Virtual Prototype Target Platform:"]
      attach [pack_left [::UI::Checkbutton $vp_target_platform.for_windows -text "Virtual Prototype for Windows"]] \
          VirtualPrototypeForWindows

      ### VP Target
      set vp_target [pack_framed_topic $top.vp_target "Virtual Prototype Simulator Program:"]
      pack_topic_line [label $vp_target.explanation -fg blue -justify left \
                           -text [join [list \
                                            "Program running the Virtual Prototype." \
                                           ] \n] ]      
      pack_subtopic [frame $vp_target.choose]
      attach [pack_left [radiobutton $vp_target.choose.external \
                             -text "Executable" -value 1]] VirtualPrototypeUseExternalExecutable
      attach [pack_left [radiobutton $vp_target.choose.internal \
                             -text "Top" -value 0]] VirtualPrototypeUseExternalExecutable
      
      pack_topic_line [::UI::FileChooser $vp_target.executable \
                           -buttoncmdtype openfile \
                           -dialogtitle "Executable" \
                           -filenamevariable [$document get_variable_name VirtualPrototypeExternalExecutableFile]] -fill x

      attach [pack_topic_line [entry $vp_target.top_name] -fill x] VirtualPrototypeTopName
      $vp_target.top_name configure -state disabled
      
      ### Command line arguments
      pack_framed_topic $top.args "Command line arguments"
      pack_topic_line [label $top.args.explanation -fg blue -justify left \
                           -text [join [list \
                                            "Arguments to pass to the simulator program via its command line." \
                                            "" \
                                            "The root of Virtual Prototype environment may be referred via \$VPROOT ." \
                                           ] \n] ]      
      attach [pack_topic_line [entry $top.args.value] -fill x] \
          VirtualPrototypeCommandLineArgs

      ### Working Directory
      pack_framed_topic $top.working_directory "Working Directory"
      pack_topic_line [label $top.working_directory.explanation -fg blue -justify left \
                           -text [join [list \
                                            "Path to the working directory in the Virtual Prototype runtime." \
                                            "" \
                                            "If left blank, Virtual Prototype will not change the working directory." \
                                            "Non-absolute paths are computed relative to the root of Virtual Prototype environment." \
                                           ] \n] ]      
      attach [pack_topic_line [entry $top.working_directory.value] -fill x] \
          VirtualPrototypeWorkingDirectory

      itk_component add sa_fr { 
        frame $itk_component(tabs).sa_fr 
      } { }

      pack_framed_topic $top.params "Parameters File"
      pack_topic_line [label $top.params.explanation -fg blue -justify left \
                           -text [join [list \
                                            "Vista parameters file contains runtime parameters of the design." \
                                           ] \n] ]      
      pack_topic_line [::UI::FileChooser $top.params.value \
                           -buttoncmdtype openfile \
                           -dialogtitle "Select Parameters File" \
                           -filenamevariable [$document get_variable_name VirtualPrototypeParametersFilePath]] -fill x

      pack_framed_topic $top.license "License File"
      pack_topic_line [label $top.license.explanation -fg blue -justify left \
                           -text [join [list \
                                            "File containing the end user license agreement." \
                                            "" \
                                            "If specified, the Virtual Prototype end user will be prompted to accept the agreement" \
                                            "On the first invocation of the Virtual Prototype executable." \
                                           ] \n] ]      
      pack_topic_line [::UI::FileChooser $top.license.value \
                           -buttoncmdtype openfile \
                           -dialogtitle "Select EULA File" \
                           -filenamevariable [$document get_variable_name VirtualPrototypeLicenseFilePath]] -fill x


      create_message $component_name

      $itk_component(tabs) insert end general -text "General" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(general_fr)
    }
    
    private method create_environment {component_name title explanation array_variable} {
      itk_component add $component_name { 
        frame $itk_component(tabs).$component_name 
      } {}
      
      set label_component_name [set component_name]_label
      itk_component add $label_component_name {
        label $itk_component($component_name).$label_component_name -text $explanation -justify left -fg blue
      }
      

      #create table
      set table_component_name [set component_name]_table
      itk_component add $table_component_name {
        tixTable $itk_component($component_name).$table_component_name -cols 4 -titlerows 1 -xscroll no
      } {}
      ;# Resize the Operation column
      $itk_component($table_component_name).table width 0 12

      #add embedded windows to the table
      set editor_0_component_name [set component_name]_editor_0
      set editor_0_component_var [set editor_0_component_name]_var
      itk_component add $editor_0_component_name {
        tixComboBox $itk_component($component_name).$editor_0_component_name
      } {}
      [$itk_component($component_name).$editor_0_component_name subwidget entry] configure -textvariable [namespace current]::$editor_0_component_var
      $itk_component($component_name).$editor_0_component_name insert end set
      $itk_component($component_name).$editor_0_component_name insert end default
      $itk_component($component_name).$editor_0_component_name insert end prepend
      $itk_component($component_name).$editor_0_component_name insert end append
      set editor_1_component_name [set component_name]_editor_1
      set editor_1_component_var [set editor_1_component_name]_var
      itk_component add $editor_1_component_name {
        entry  $itk_component($component_name).$editor_1_component_name -textvariable [namespace current]::$editor_1_component_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      set editor_2_component_name [set component_name]_editor_2
      set editor_2_component_var [set editor_2_component_name]_var
      itk_component add $editor_2_component_name {
        entry  $itk_component($component_name).$editor_2_component_name -textvariable [namespace current]::$editor_2_component_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      $itk_component($table_component_name) window \
          0 $itk_component($editor_0_component_name) \
          1 $itk_component($editor_1_component_name) \
          2 $itk_component($editor_2_component_name)
      $itk_component($table_component_name).table configure -height 10

      attach $itk_component($table_component_name) $array_variable

      set titleRow [$itk_component($table_component_name).table cget -roworigin]
      $itk_component($table_component_name).table set $titleRow,0 "Operation"
      $itk_component($table_component_name).table set $titleRow,1 "Variable Name"
      $itk_component($table_component_name).table set $titleRow,2 "Value"
      
      #packing
      pack $itk_component($label_component_name) -fill none -side top -anchor nw -padx 5
      pack $itk_component($table_component_name) -fill x  -side top -anchor w -pady 2 -padx 5

      create_message $component_name

      set tabname [set component_name]_tab
      $itk_component(tabs) insert end $tabname -text $title \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component($component_name)
    }

    private method create_copy_tab {component_name title explanation array_variable browsetype dialogtitle} {
      itk_component add $component_name { 
        frame $itk_component(tabs).$component_name 
      } {}
      
      set label_component_name [set component_name]_label
      itk_component add $label_component_name {
        label $itk_component($component_name).$label_component_name -text $explanation -justify left -fg blue
      }

      #create table
      set table_component_name [set component_name]_table
      itk_component add $table_component_name {
        tixTable $itk_component($component_name).$table_component_name -cols 4 -titlerows 1 -xscroll no
      } {}
      
      #add embedded windows to the table
      set editor_0_component_name [set component_name]_editor_0
      set editor_0_component_var [set editor_0_component_name]_var
      itk_component add $editor_0_component_name {
        ::UI::FileChooser $itk_component($component_name).$editor_0_component_name \
            -browsetype $browsetype -buttoncmdtype openfile -dialogtitle $dialogtitle \
            -filenamevariable [namespace current]::$editor_0_component_var -takefocus 0
      } {}
#            -browsetype directory_advanced -path_variable_document $document -dialogtitle "Select Directory"
      set editor_1_component_name [set component_name]_editor_1
      set editor_1_component_var [set editor_1_component_name]_var
      itk_component add $editor_1_component_name {
        entry  $itk_component($component_name).$editor_1_component_name -textvariable [namespace current]::$editor_1_component_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      set editor_2_component_name [set component_name]_editor_2
      set editor_2_component_var [set editor_2_component_name]_var
      itk_component add $editor_2_component_name {
        entry  $itk_component($component_name).$editor_2_component_name -textvariable [namespace current]::$editor_2_component_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      $itk_component($table_component_name) window \
          0 $itk_component($editor_0_component_name) \
          1 $itk_component($editor_1_component_name) \
          2 $itk_component($editor_2_component_name)
      $itk_component($table_component_name).table configure -height 10

      attach $itk_component($table_component_name) $array_variable

      set titleRow [$itk_component($table_component_name).table cget -roworigin]
      $itk_component($table_component_name).table set $titleRow,0 "Source Path"
      $itk_component($table_component_name).table set $titleRow,1 "Target Directory"
      $itk_component($table_component_name).table set $titleRow,2 "Environment Variable"
      
      #packing
      pack $itk_component($label_component_name) -fill none -side top -anchor nw -padx 5
      pack $itk_component($table_component_name) -fill x  -side top -anchor w -pady 2 -padx 5

      create_message $component_name

      set tabname [set component_name]_tab
      $itk_component(tabs) insert end $tabname -text $title \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component($component_name)
    }

    private method pack_topic {el args} {
      eval [list pack $el -side top -anchor w -fill x -pady 5] $args
      return $el
    }

    private method pack_bottom_topic {el args} {
      eval [list pack $el -side bottom -anchor w -fill x -pady 5] $args
      return $el
    }

    private method pack_framed_topic {el text args} {
      eval [list pack_topic [labelframe $el -labelanchor nw -text $text]] $args
      return $el
    }

    private method pack_bottom_framed_topic {el text args} {
      eval [list pack_bottom_topic [labelframe $el -labelanchor nw -text $text]] $args
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
      if {$variable_name == "VirtualPrototypeUseExternalExecutable"} {
        set virtualPrototypeUseExternalExecutable [$document get_variable_value VirtualPrototypeUseExternalExecutable]
        set vp_target $itk_component(general_fr).vp_target
        
        switch $virtualPrototypeUseExternalExecutable {
          0 {
            pack forget $vp_target.executable 
            pack_topic_line $vp_target.top_name -fill x
            $vp_target.executable configure -state disabled
          }
          1 {
            pack_topic_line $vp_target.executable -fill x
            pack forget $vp_target.top_name
            $vp_target.executable configure -state normal
          }
        }
        return
      }
      
    }
    protected method create_buttons {} {
      add_ok_button "Save"
      add_button SaveAndGenerateCommand -text "Save & Generate" -underline 7 
      add_cancel_button
      add_help_button
    }
    private method add_update_table_hook_to_OK_button { } {
      set children [winfo children $itk_component(buttons)]
      catch {
        foreach child $children {
          set command [$child cget -command] 
          if { [string first "OKCommand" $command] != -1} {
            $child config -command "$this updateTables; $command"
          }
          if { [string first "SaveAndGenerateCommand" $command] != -1} {
            $child config -command "$this updateTables; $command"
          }
        }
      }
    }

    public method updateTables {} {
      updateTable env_fr
      updateTable copy_directories_fr
      updateTable copy_files_fr
    }

    private method updateTable {component_name} {
      set table_component_name [set component_name]_table
      $itk_component($table_component_name) saveactivedata
    }

    public method clearLastErrorText {args} {
      set [$document get_variable_name LastErrorText] ""
    }

  };#class
};#namespace
