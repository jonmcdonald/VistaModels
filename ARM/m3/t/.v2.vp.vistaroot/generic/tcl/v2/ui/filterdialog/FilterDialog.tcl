namespace eval ::v2::ui::filterdialog {
  usual FilterDialog {}
  class FilterDialog {
    inherit ::UI::SWidget
    
    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      create_body
 
      eval itk_initialize $args

      #set_title "Filtering"
    }
    
    private method create_body {} {
      set top $itk_interior
      itk_component add buttons {
        frame $top.buttons -highlightthickness 0 -bd 0
      } {}

      pack [button $top.buttons.set_as_def -highlightbackground [$itk_component(buttons) cget -background] \
               -text "Set as Default"] -padx 5 -pady 5 -side left -anchor c
      attach $top.buttons.set_as_def SetAsDefaultCommand

      pack [button $top.buttons.reset_to_def -highlightbackground [$itk_component(buttons) cget -background] \
               -text "Reset to Default"] -padx 5 -pady 5 -side left -anchor c
      attach $top.buttons.reset_to_def ResetToDefaultCommand

      pack [button $top.buttons.apply_to_all -highlightbackground [$itk_component(buttons) cget -background] \
               -text "Apply to All Tabs"] -padx 5 -pady 5 -side left -anchor c
      attach $top.buttons.apply_to_all ApplyToAllTabsCommand
      
      itk_component add tabset {
        blt::tabset $top.tabset -side top \
            -relief flat -outerpad 0 -bd 0 -highlightthickness 0  \
            -gap 0 -borderwidth 0 -selectpad 0 -samewidth 1 -tearoff 0

      } { 
        keep -background 
        rename -tabforeground -foreground foreground Foreground 
        rename -tabbackground  -background background Background
        rename -activebackground -background background Background
        rename -activeforeground -foreground foreground Foreground 
        rename -selectbackground -background background Background
      }

      create_tabs
      show
    }

    public method show {} {
      pack $itk_component(buttons) -anchor c -side top
      pack $itk_component(tabset) -expand 1 -fill both -anchor nw -side top
      
      }
    
    private method create_tabs {} {
      #files "Project View"
      itk_component add files_fr {
        frame $itk_component(tabset).files_fr
      } {}
      $itk_component(tabset) insert end files -text "Full View" \
            -fill both -anchor center -background {} -selectbackground {} -selectforeground {} \
            -window $itk_component(files_fr)
      create_files $itk_component(files_fr)

      foreach tab {library model code design} text { "Library View" "Model View" "Code View" "Design View"} { 
        
        itk_component add sw_$tab {
          ScrolledWindow $itk_component(tabset).sw_$tab -auto both -scrollbar both
        } {}
        
        $itk_component(sw_$tab).hscroll configure -width 10
        $itk_component(sw_$tab).vscroll configure -width 10

        ScrollableFrame $itk_component(sw_$tab).sf -constrainedwidth 1

        create_$tab [$itk_component(sw_$tab).sf getframe]

        $itk_component(sw_$tab) setwidget $itk_component(sw_$tab).sf
        
        $itk_component(tabset) insert end $tab -text $text \
            -fill both -anchor center -background {} -selectbackground {} -selectforeground {} \
            -window $itk_component(sw_$tab)  
      }

      $itk_component(tabset) select 3
    }
    
    private method create_files {frame_name} {
      foreach name {"Show full paths for files" "Show files in simulation \"Code\" folder"} varname {"ShowFullPath" "ShowCodeFiles"} {
        set component [set frame_name].[string tolower $varname]\_checkbutton
        ::UI::Checkbutton $component -text $name 
        attach $component $varname
        pack $component -side top -anchor w -padx 30 -pady 5
      }
      create_projects_visibility_frame $frame_name
    }

    private method create_projects_visibility_frame {frame_name} {
      itk_component add projects_visibility_fr {
        labelframe $frame_name.vis_fr -labelanchor nw -text "Project Visibility Options:" \
            -padx 5 
      } {}
      #buttons
      itk_component add projects_buttons_fr {
        frame $itk_component(projects_visibility_fr).buttons_fr -relief flat -borderwidth 0 
      } {}
      itk_component add visibility_label {
        label $itk_component(projects_buttons_fr).label -text "Show:"
      } {}
      itk_component add all_button {
        button $itk_component(projects_buttons_fr).all -text "All" -command "$this selectAllProjects" 
      } {}
      
      itk_component add none_button {
        button $itk_component(projects_buttons_fr).none -text "None" -command "$this unselectAllProjects" 
      } {}

      #listbox
      #change later to BwidgetListboxMultiple
      itk_component add projects_listbox {
        UI::BwidgetListbox $itk_component(projects_visibility_fr).proj_listbox 
      } {
        keep -background 
      } 
      [$itk_component(projects_listbox) component listbox] configure -selectmode multiple
      attach $itk_component(projects_listbox) AllProjectsNames VisibleProjectsNames
      $itk_component(projects_listbox) configure -height 4 -highlightthickness 0 \
          -deltay 25 -borderwidth 2 -relief groove 

      #packing
      pack $itk_component(visibility_label) -side left -padx 10 
      pack $itk_component(all_button) -side left -padx 20 
      pack $itk_component(none_button) -side left -padx 20
      pack $itk_component(projects_buttons_fr) -side top -anchor nw -fill x -padx 10 -pady 5
      pack $itk_component(projects_listbox) -side top -anchor nw -padx 10 -pady 5 -fill both -expand 1

      pack $itk_component(projects_visibility_fr)  -side top -anchor nw -padx 10 -pady 5 -fill both -expand 1
      #grid $itk_component(projects_visibility_fr) -row 2 -sticky nesw

    }
    
    private method create_code {frame_name} {
      
      itk_component add code_filter_lframe {
        labelframe $frame_name.code_filter_lframe -text "Code Tree Viewing Options:" \
            -labelanchor nw -padx 5 
      } {}

      set frame $itk_component(code_filter_lframe)
      set index 0

      foreach record {\
                          {"Show Classes" ShowClasses} \
                          {"Show Base Classes" ShowBaseClasses} \
                          {"Show Fields" ShowFields} \
                          {"Show Methods" ShowMethods} \
                          {"Show Return Type" ShowReturnType} \
                          {"Show Functions" ShowFunctions} \
                          {"Show Variables" ShowVariables}
                        } {
        set framic $frame.code_show_frame$index
        pack [frame $framic] -side top -anchor w -expand yes -fill x -pady 5
    
        set component $framic.element
        pack [::UI::Checkbutton $component -text [lindex $record 0]]  -side left -anchor w
        attach $component [lindex $record 1]

        set component $framic.folder
        pack [::UI::Checkbutton $component -text "In Folder"] -side right -anchor e
        attach $component [lindex $record 1]Folder

        incr index
      }

      pack  $frame -side top  -pady 20 -padx 10 -anchor w -fill x -expand 1 
    }
    
    private method create_design {frame_name} {
      
      itk_component add design_filter_lframe {
        labelframe $frame_name.design_filter_lframe \
            -text "Design Tree Viewing Options:" -labelanchor nw -padx 5 
      } {}
      
      set frame $itk_component(design_filter_lframe)
      set index 0
      foreach record {\
                          {"Show Modules" ShowModules} \
                          {"Show Ports and Exports" ShowPortsAndExports} \
                          {"Show Channels" ShowChannels} \
                          {"Show SystemC Processes" ShowProcesses} \
                          {"Show C++ Methods" DesignShowMethods} \
                          {"Show Global Variables in Design" DesignShowGlobalVariables} \
                          {"Show Base Classes in Design" DesignShowBaseClasses} \
                          {"Show Fields in Design" DesignShowFields} \
                          {"Dereference Pointers in Design" DesignShowDerefs} \
                          {"Show Array Members in Design" DesignShowIndexes} \
                          {"Show TLM Sockets" ShowTLMSockets} \
                          {"Show Attributes" ShowAttributes} \
                          {"Show Events" ShowEvents} \
                        } {
        set framic $frame.design_show_frame$index
        pack [frame $framic] -side top  -expand yes -fill x -pady 3

        set component_el $framic.element
        pack [::UI::Checkbutton $component_el -text [lindex $record 0]] -side left  -padx 5
        attach $component_el [lindex $record 1]

        set component_folder $framic.folder
        pack [::UI::Checkbutton $component_folder -text "In Folder"] -side right -padx 5
        attach $component_folder [lindex $record 1]Folder

        incr index
      }
      pack  $frame -side top  -pady 20 -padx 10  -fill x    
    }

    private method create_library {frame_name} {
      
      itk_component add library_filter_lframe {
        labelframe $frame_name.library_filter_lframe \
            -text "Library Tree Viewing Options:" -labelanchor nw -padx 5 
      } {}
      
      set frame $itk_component(library_filter_lframe)
      set index 0
      foreach record {\
                          {"Show C++ Header Files" LibraryViewShowHeaderFiles} \
                          {"Show C++ Source Files" LibraryViewShowSourceFiles} \
                          {"Show Documentation Files" LibraryViewShowDocumentationFiles} \
                          {"Show Models" LibraryViewShowModels} \
                          {"Show Model Interfaces" LibraryViewShowModelInterfaces} \
                          {"Show Schematics" LibraryViewShowSchematics} \
                        } {
        set framic $frame.library_show_frame$index
        pack [frame $framic] -side top  -expand yes -fill x -pady 3

        set component_el $framic.element
        pack [::UI::Checkbutton $component_el -text [lindex $record 0]] -side left  -padx 5
        attach $component_el [lindex $record 1]

        set component_folder $framic.folder
        pack [::UI::Checkbutton $component_folder -text "In Folder"] -side right -padx 5
        attach $component_folder [lindex $record 1]Folder

        incr index
      }
      pack  $frame -side top  -pady 20 -padx 10  -fill x    
    }
    private method create_model {frame_name} {
      
      itk_component add model_filter_lframe {
        labelframe $frame_name.model_filter_lframe \
            -text "Model Tree Viewing Options:" -labelanchor nw -padx 5 
      } {}
      
      set frame $itk_component(model_filter_lframe)
      set index 0
      foreach record {\
                          {"Show Ports" ModelViewShowPorts} \
                          {"Show Graphical Symbols" ModelViewShowSymbols} \
                          {"Show C++ Header Files" ModelViewShowHeaderFiles} \
                          {"Show C++ Source Files" ModelViewShowSourceFiles} \
                          {"Show Documentation Files" ModelViewShowDocumentationFiles} \
                          {"Show Learn Files" ModelViewShowLearning} \
                          {"Show HDL Simulation Results" ModelViewShowSimulationDirectories} \
                          {"Show RTL Power Files" ModelViewShowRTLPower} \
                        } {
        set framic $frame.model_show_frame$index
        pack [frame $framic] -side top  -expand yes -fill x -pady 3

        set component_el $framic.element
        pack [::UI::Checkbutton $component_el -text [lindex $record 0]] -side left  -padx 5
        attach $component_el [lindex $record 1]

        set component_folder $framic.folder
        pack [::UI::Checkbutton $component_folder -text "In Folder"] -side right -padx 5
        attach $component_folder [lindex $record 1]Folder

        incr index
      }
      pack  $frame -side top  -pady 20 -padx 10  -fill x    
    }
    

#for future development
    private method create_version_frame {} {
      itk_component add version_fr {
        labelframe $itk_component(files_fr).version_fr -labelanchor nw
      } {}
      itk_component add version_checkbutton {
          ::UI::Checkbutton $itk_component(version_fr).version_checkbutton \
              -text  "Show version control information:" \
              -command "$this SetCheckbuttonsState $itk_component(version_fr) $itk_component(version_fr).version_checkbutton  FileShowVersion"
      } {}

      $itk_component(version_fr) config -labelwidget  $itk_component(version_checkbutton) -padx 15
      attach $itk_component(version_checkbutton) FileShowVersion

      foreach name {"Version number" "Version status" "Checked out by"} varname {Number Status Out} {
        set wname [lindex $name 1]\_checkbutton
        itk_component add $wname {
          ::UI::Checkbutton $itk_component(version_fr).$wname -text $name \
              -command "$this SetFrameCheckbuttonState  $itk_component(version_fr) $itk_component(version_checkbutton) FileShowVersion"
        } {}
        pack $itk_component($wname) -side top -anchor w -padx 5 -pady 15 -anchor nw
        set varname FileShowVersion$varname
        attach $itk_component($wname) $varname
      }
      pack $itk_component(version_fr) -side top -anchor w -padx 5  -pady 20 -fill x -expand 1 -anchor nw
      
    }

#for future development

    private method create_code_notebook {} {
      itk_component add code_fr { 
        frame $itk_component(tabset).code_fr 
      } { }
      itk_component add code_tabset {
        blt::tabset $itk_component(code_fr).code_tabset -side left  \
            -relief flat -outerpad 5 -bd 2 -highlightthickness 0  \
            -gap 2 -borderwidth 0 -selectpad 2 -samewidth 1 
      } { 
        keep -background 
        rename -tabforeground -foreground foreground Foreground 
        rename -tabbackground  -background background Background
        rename -activebackground -background background Background
        rename -activeforeground -foreground foreground Foreground 
        rename -selectbackground -background background Background
      }
      pack $itk_component(code_tabset) -fill both -expand 1 -pady 2
      create_sorting
      create_grouping
      create_filtering
      
      $itk_component(code_tabset) insert end sorting -text " Sorting " \
          -fill both -anchor center -window $itk_component(sorting_fr) -background {} \
          -selectbackground {} -selectforeground {} -ipady 10 
      $itk_component(code_tabset) insert end grouping -text " Grouping " \
          -fill both -anchor center -window $itk_component(grouping_fr) -background {} \
          -selectbackground {} -selectforeground {} 
      $itk_component(code_tabset) insert end filtering -text " Filtering " \
          -fill both -anchor center -window $itk_component(filtering_fr) -background {} \
          -selectbackground {} -selectforeground {} 
    }

    private method create_design_sorting_frame {} {
                                              
      itk_component add design_sorting_lframe {
        labelframe $itk_component(design_fr).design_sorting_lframe -text "Sorting" -labelanchor nw -padx 5 
      } {}
      set i 0
      foreach kind  {"as_is" "by_type" "alphabetical"} \
          text {"As is" "By type" "Alphabetical"} {
           itk_component add des_sorting_$kind {
              radiobutton $itk_component(design_sorting_lframe).sorting_$kind -text $text  \
                  -value $i 
            } { } 
            attach  $itk_component(des_sorting_$kind) DesignSorting
            pack $itk_component(des_sorting_$kind) -side left -padx 30 -anchor w -pady 15 
            incr i
          }


      pack  $itk_component(design_sorting_lframe) -side top  -pady 20 -padx 10 -anchor w -fill x    
    }

    private method create_sorting {  } {
      itk_component add sorting_fr { 
        frame $itk_component(code_tabset).sorting_fr 
      } { }
      set i 0
      foreach kind  {"as_is" "by_type" "alphabetical" "by_access"} \
          text {"As is" "By type" "Alphabetical" "By access type"} {
            itk_component add sorting_$kind {
              radiobutton $itk_component(sorting_fr).sorting_$kind -text $text  -value $i
            } { }
            attach  $itk_component(sorting_$kind) CodeSorting
            pack $itk_component(sorting_$kind) -side top -padx 10 -anchor w -pady 15 
            incr i
          }
    }


    private method create_filtering {  } {
      itk_component add filtering_fr { 
        frame $itk_component(tabset).filtering_fr 
      } { }
      itk_component add filter_label {
        labelframe $itk_component(filtering_fr).filter_label -text "Filter out:" -labelanchor nw -padx 5 
      } {}
      itk_component add filter_fr_0 {
        frame $itk_component(filter_label).filter_fr_0 
      } {}
      itk_component add filter_fr_1 {
        frame $itk_component(filter_label).filter_fr_1 
      } {}
      
      

      set i 0
      
      
      foreach name { "Classes / structs" "Enums" "Unions" "Typedefs"}  {
        set varname [lindex $name 0]
        set wname [string tolower $varname]_checkbutton
        set frame filter_fr_$i
        itk_component add $wname {
          ::UI::Checkbutton $itk_component($frame).$wname -text $name
        } {}
        attach $itk_component($wname) FilterCode$varname
        set i [expr !$i] 
        pack $itk_component($wname) -side top -padx 9 -pady 5 -anchor w

      }

      itk_component add data_labelframe {
        labelframe $itk_component(filter_fr_0).data_labelframe -labelanchor nw ;
      } {}
      itk_component add data_checkbutton {
        ::UI::Checkbutton $itk_component(data_labelframe).data_checkbutton  -text "Data members:" \
            -command "$this SetCheckbuttonsState $itk_component(data_labelframe) $itk_component(data_labelframe).data_checkbutton FilterCodeData"
      }
      attach $itk_component(data_checkbutton) FilterCodeData
      $itk_component(data_labelframe) config -labelwidget $itk_component(data_checkbutton) -padx 5
      foreach name {"Base Classes" "Instance data members" "Static data members"} {
        set varname [lindex $name 0]
        set wname [string tolower $varname]\_data_checkbutton
        itk_component add $wname {
          ::UI::Checkbutton $itk_component(data_labelframe).$wname -text $name \
              -command "$this SetFrameCheckbuttonState $itk_component(data_labelframe) $itk_component(data_checkbutton) FilterCodeData"
        } {}
        pack $itk_component($wname) -side top -anchor w -padx 0 -pady 5 -anchor nw
        set varname FilterCodeData$varname
        attach $itk_component($wname) $varname
      }

      itk_component add methods_labelframe {
        labelframe $itk_component(filter_fr_1).methods_labelframe -labelanchor nw -pady 3;
      } {}
      
      itk_component add methods_checkbutton {
        ::UI::Checkbutton $itk_component(methods_labelframe).methods_checkbutton  -text "Methods:" \
            -command "$this SetCheckbuttonsState $itk_component(methods_labelframe) $itk_component(methods_labelframe).methods_checkbutton FilterCodeMethods"
      }
      attach $itk_component(methods_checkbutton) FilterCodeMethods
      $itk_component(methods_labelframe) config -labelwidget $itk_component(methods_checkbutton) -padx 5
      foreach name {"Virtual methods" "Non-virtual methods" "Static methods" "Constructors" "Destructors"} \
          varname {Virtual NonVirtual Static Constructors Destructors} {
        set wname [string tolower $varname]\_methods_checkbutton
        itk_component add $wname {
          ::UI::Checkbutton $itk_component(methods_labelframe).$wname -text $name \
              -command "$this SetFrameCheckbuttonState $itk_component(methods_labelframe) $itk_component(methods_checkbutton) FilterCodeMethods"
        } {}
        pack $itk_component($wname) -side top  -padx 0 -pady 5 -anchor nw
        set varname FilterCodeMethods$varname
        attach $itk_component($wname) $varname
      }


      pack $itk_component(data_labelframe) -side top -padx 2 -anchor n -pady 3
      pack $itk_component(methods_labelframe) -side top -padx 2 -anchor n -pady 3
      
      pack  $itk_component(filter_fr_0) -side left -padx 2 -anchor n 
      pack  $itk_component(filter_fr_1) -side left -padx 2 -anchor n

      pack $itk_component(filter_label) -side top  -pady 5 -padx 10 -anchor w -fill x      
      
      itk_component add access_fr {
        labelframe $itk_component(filtering_fr).access_fr -text "Filter out by access type:" \
            -labelanchor nw -padx 5
      } {}

      
      foreach name {"Public" "Protected" "Private"} padx {25 0 25} {
        set wname [string tolower $name]_checkbutton
        itk_component add $wname {
          ::UI::Checkbutton $itk_component(access_fr).$wname -text $name
        } {}
        attach $itk_component($wname) FilterCode$name
        pack $itk_component($wname) -side left -padx $padx -pady 5 -anchor w
      }
      pack $itk_component(access_fr)  -padx 10 -pady 5 -anchor w -fill x      

      
      foreach name {"Show SystemC objects only" "Add access type notations"} \
          varname {ShowSystemCobjectsOnly AddAccessTypeNotation} {
            set wname [string tolower [lindex $name 0]]_checkbutton
            itk_component add $wname {
              ::UI::Checkbutton $itk_component(filtering_fr).$wname -text $name
            } {}
            attach $itk_component($wname)  $varname
            pack $itk_component($wname)  -padx 10 -pady 5 -anchor w
          }

    }
      

    private method create_grouping {  } {
      itk_component add grouping_fr { 
        frame $itk_component(code_tabset).grouping_fr 
      } { }
      set i 0
      foreach kind  {"flat" "by_type" } \
          text {"Flat - no grouping" "Group by type"} {
            itk_component add grouping_$kind {
              radiobutton $itk_component(grouping_fr).grouping_$kind -text $text  \
                  -value $i \
                  -command "$this SetInstanceNumberEntryState"
            } { }
            attach $itk_component(grouping_$kind) CodeGrouping
            pack $itk_component(grouping_$kind) -side top -padx 10 -anchor w -pady 15 
            incr i            
          }
      itk_component add inst_number_fr { 
        frame $itk_component(grouping_fr).inst_number_fr 
      } { }
      itk_component add grouping_automatic {
        radiobutton $itk_component(inst_number_fr).grouping_automatic \
            -text "Group by type automatic\n when number of instances exceed:"  \
            -value $i -justify left \
            -command "$this SetInstanceNumberEntryState"
      } { }
      attach $itk_component(grouping_automatic) CodeGrouping
      pack $itk_component(grouping_automatic) -side top -padx 10 -anchor w -pady 0 
      
      itk_component add instances_number {
        entry $itk_component(inst_number_fr).instances_number -width 3
      } {}
      attach $itk_component(instances_number) InstancesNumber
      SetInstanceNumberEntryState
            
      pack $itk_component(grouping_automatic) -side left -padx 10

      pack $itk_component(instances_number) -side left -padx 10 -anchor w 
      pack $itk_component(inst_number_fr) -side top -padx 0 -anchor w -pady 15 -fill x
    }
    
    public method SetCheckbuttonsState {frame  frame_checkbutton varname} {
      foreach child [winfo children $frame] {
        if {$child == "$frame_checkbutton"} continue
        if {[$document get_variable_value $varname] ==1 } {
          set [$child cget -variable] 1
        } else {
          set [$child cget -variable] 0
        }
      }
      
    }

    public method SetFrameCheckbuttonState {frame checkbutton_widget varname} {
      set all_uncheck 1
      foreach child [winfo children $frame] {
        if {$child == "$checkbutton_widget"} continue
        if {[set  [$child cget -variable] ] == "1"} {
          set all_uncheck 0
        }
      }
      set value [$document get_variable_value $varname]
      if { $all_uncheck &&  $value==1} {
        $document set_variable_value $varname 0
      } else {
        if {$value ==0} {
          $document set_variable_value $varname 1
        }
      }
      
    }

    public method SetInstanceNumberEntryState { } {
      if {[$document get_variable_value CodeGrouping] == "2" } {
        $itk_component(instances_number) config -state normal
      } else {
        $itk_component(instances_number) config -state disabled
      }
    }

    public method selectAllProjects {} {
      $document set_variable_value VisibleProjectsNames [$document get_variable_value AllProjectsNames]
    }

    public method unselectAllProjects {} {
       $document set_variable_value VisibleProjectsNames {}
    }
    
    
  }
}
