
namespace eval ::v2::ui::projectdialog {
 
  class ProjectSetting {
    inherit ::UI::BaseDialog
    
    public variable isAdvancedMode 0
    private variable lastOpenedPage
    private variable pagesList {general folders files include path_variables pre_proc_defintions link}
    common path_variables_frame_name "path_variables_fr"

    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {

      create_body
      create_buttons

      eval itk_initialize $args
      set_title "Project Setting"

      draw
    }
    
    protected method set_geometry {} {
      wm minsize $itk_interior 550 450
      set geometry [format "%sx%s+%s+%s" \
                        [expr round([winfo vrootwidth $itk_interior]*0.7)]\
                        [expr round([winfo vrootheight $itk_interior]*0.7)]\
                        [expr  [winfo vrootx $itk_interior] + round([winfo vrootwidth $itk_interior]*0.15)]\
                        [expr  [winfo vrooty $itk_interior] + round([winfo vrootheight $itk_interior]*0.15)]]
      wm geometry $itk_interior $geometry
#      puts "geometry=$geometry"
    }
    
    protected method create_buttons {} {
      add_button "" -text "OK" -width 5 -underline 0 -command [code $this SettingOKCommand]
      add_button "" -text "Apply" -width 5 -underline 0 -command [code $this SettingApplyCommand]
      add_common_buttons
    }

    public method SettingOKCommand {} {
      updateTables
#       $document set_variable_value DirectoryName [file dirname [ $itk_component(files_selection).filter get] ]
      $document run_command OKCommand
    }

    public method SettingApplyCommand {} {
      updateTables
      set was_new [$document get_variable_value IsNewProject]
#       $document set_variable_value DirectoryName [file dirname [ $itk_component(files_selection).filter get] ]
      $document run_command ApplyCommand
#       set is_new [$document get_variable_value IsNewProject]
      
#       if {$was_new && !$is_new} {
#         create_not_new
#         pack_not_new
#       }
    }
    
    public method CancelCommand {} {
      #first destroy path variables adder
      $document run_command DestroyCommand
    }

    protected method create_body {} {
      set top [get_body_frame]
      itk_component add tabs {
        blt::tabset $top.tabs -side top \
            -relief flat  -bd 1 -highlightthickness 0 -samewidth 0 \
            -gap 1 -borderwidth 2 -selectpad 2 \
            -selectcommand [code $this PageChanged] -pagewidth 500
      } { 
        keep -background 
        rename -tabforeground -foreground foreground Foreground 
        rename -tabbackground  -background background Background
        rename -activebackground -background background Background
        rename -activeforeground -foreground foreground Foreground 
        rename -selectbackground -background background Background
      }
      
      create_general
      create_path_variables      
      create_folders
      create_files
      create_includes
      create_pre_proc_defintions
      create_link
      
      $itk_component(tabs) insert end general -text "General" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(general_fr)
      $itk_component(tabs) insert end variables -text "Path Variables" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {}  \
          -window $itk_component($path_variables_frame_name)
      $itk_component(tabs) insert end folders -text "Folders" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
          -window $itk_component(folders_fr)
      $itk_component(tabs) insert end files -text "Files" \
          -fill both -anchor nw -background {} -selectbackground {} -selectforeground {}  \
          -window $itk_component(files_fr)
      
      $itk_component(tabs) insert end include -text "Include Paths" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {}  \
          -window $itk_component(includes_fr)

      $itk_component(tabs) insert end definitions -text "Compilation" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {}  \
          -window $itk_component(pre_proc_defintions_fr)
      $itk_component(tabs) insert end link -text "Link" \
          -fill both -anchor c -background {} -selectbackground {} -selectforeground {}  \
          -window $itk_component(link_fr)
      $itk_component(tabs) config -tiers 2
      pack $itk_component(tabs) -fill both -expand 1 -side top
      set currentTabIndex [$document get_variable_value PageIndex]
      $itk_component(tabs) select $currentTabIndex
      set lastOpenedPage [lindex $pagesList $currentTabIndex]
    }

    private method create_general {} {
      itk_component add general_fr { 
        frame $itk_component(tabs).general_fr 
      } { }
      ### Left side - project name & path
      itk_component add general_prj {
        iwidgets::Labeledframe $itk_component(general_fr).general_prj
      } { }

      set general_left [$itk_component(general_prj) childsite]

      # Add to Project:
      #in case of subproject
      itk_component add add_to_label {
        label $general_left.add_to_label -text "Add to Project:"
      } {}
      
      itk_component add add_to_combo {
        ::UI::BwidgetCombobox $general_left.add_to_combo
      } {}
      attach $itk_component(add_to_combo) ParentProjectName AllProjectsNames

      # Project name
      itk_component add name_label {
        label $general_left.name_label -text "Project name:" 
      } { }
      itk_component add project_name { 
        entry $general_left.project_name 
      } { }
      
      create_not_new


      itk_component add platform_provider_label {
        label $general_left.platform_provider_label -text "Platform provider:" 
      } { }
      itk_component add platform_provider { 
        entry $general_left.platform_provider 
      } { }

      itk_component add platform_name_label {
        label $general_left.platform_name_label -text "Platform name:" 
      } { }
      itk_component add platform_name { 
        entry $general_left.platform_name 
      } { }

      itk_component add platform_version_label {
        label $general_left.platform_version_label -text "Platform version:" 
      } { }
      itk_component add platform_version { 
        entry $general_left.platform_version 
      } { }

      itk_component add build_dir_label {
        label $general_left.build_dir_label -text "Project build directory:" 
      } { }
      itk_component add build_dir { 
        ::UI::FileChooser $general_left.build_dir___advanced___   -filenamevariable [$document get_variable_name ProjectWorkingDirectory] -browsetype directory_advanced -path_variable_document $document -dialogtitle "Select Directory" -initialdir [set [$document get_variable_name ProjectWorkingDirectory]]
      } { }
      itk_component add project_library_label {
        label $general_left.project_library_label -text "Project graphical library path:"
      } {}
      itk_component add project_library_path {
        ::UI::FileChooser $general_left.project_library_path___advanced___   -filenamevariable [$document get_variable_name ProjectComponentsLibraryPath] -browsetype directory_advanced -path_variable_document $document -dialogtitle "Select Directory" -initialdir [set [$document get_variable_name ProjectComponentsLibraryPath]]
        } { }
      
      itk_component add has_tlm_support_checkbutton {
        ::UI::Checkbutton $general_left.has_tlm_support_checkbutton \
            -text "Transaction Sequence Recording Support"
      }
      attach $itk_component(has_tlm_support_checkbutton) HasTLMSupport

      itk_component add alwaysCompileInCPPMode_checkbutton {
        ::UI::Checkbutton $general_left.alwaysCompileInCPPMode_checkbutton \
            -text "Always compile in C++ mode"
      } {}
      attach $itk_component(alwaysCompileInCPPMode_checkbutton) AlwaysCompileInCPPMode

#####

      attach $itk_component(project_name) EnvProjectName
      attach $itk_component(platform_provider) PlatformProvider
      attach $itk_component(platform_name) PlatformName
      attach $itk_component(platform_version) PlatformVersion

      if {[$document get_variable_value IsSubProject]} {
        pack $itk_component(add_to_label) -side top -anchor nw -padx 5 -pady 5
        pack $itk_component(add_to_combo) -side top -anchor nw -padx 5 -pady 5
      }
      
      pack $itk_component(name_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(project_name) -side top -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(platform_provider_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(platform_provider) -side top -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(platform_name_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(platform_name) -side top -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(platform_version_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(platform_version) -side top -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(build_dir_label)  -side top -anchor nw -padx 5 -pady 5 
      pack $itk_component(build_dir)  -side top -anchor nw -padx 5 -pady 5 -fill x 
      pack $itk_component(project_library_label)  -side top -anchor nw -padx 5 -pady 5 
      pack $itk_component(project_library_path)  -side top -anchor nw -padx 5 -pady 5 -fill x 
      pack $itk_component(has_tlm_support_checkbutton) -side top -anchor nw -padx 5 -pady 5 
      pack $itk_component(alwaysCompileInCPPMode_checkbutton) -side top -anchor nw -padx 5 -pady 5 
      pack_not_new

      # place main frames
      pack $itk_component(general_prj) -side top -fill both -expand 1
    }
    
    private method create_not_new {} {
      #currently show everything always 
      #set is_new [$document get_variable_value IsNewProject]
      #if {$is_new} {return}
      set general_left [$itk_component(general_prj) childsite]
      
      itk_component add path_label {
        label $general_left.path_label -text "Project path:"
      } { }
      itk_component add project_path {
        #label $general_left.project_path 

        entry $general_left.project_path -relief flat -bg [cget -background] -selectborderwidth 0 \
            -borderwidth 0 -readonlybackground "" 
      } { }
      
      #         itk_component add sim_dir_label {
      #         label $general_left.sim_dir_label -text "Project simulation directory:" 
      #         } { }
      #         itk_component add sim_dir { 
      #           ::UI::FileChooser $general_left.sim_dir___advanced___   -filenamevariable [$document get_variable_name ProjectSimulationDirectory] -path_variable_document $document -browsetype directory_advanced -dialogtitle "Select Directory" -initialdir [set [$document get_variable_name ProjectSimulationDirectory]]\
          #         } { }
      
      attach $itk_component(project_path) DocumentFile 
      $itk_component(project_path) configure -state readonly -takefocus 0
      $itk_component(add_to_combo) configure -state disabled
      $itk_component(add_to_label) configure -text "Sub Project of:"

      
    }
    private method pack_not_new {} {
      #currently show everything always
#      set is_new [$document get_variable_value IsNewProject]
#      if {$is_new} {return}
      pack $itk_component(path_label)  -before  $itk_component(build_dir_label) -side top -anchor nw -padx 5 -pady 5 
      #pack $itk_component(project_path)  -before  $itk_component(build_dir_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(project_path)  -before  $itk_component(build_dir_label) -side top -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(project_library_label)  -side top -anchor nw -padx 5 -pady 5 
      pack $itk_component(project_library_path)  -side top -anchor nw -padx 5 -pady 5 -fill x 
      pack $itk_component(alwaysCompileInCPPMode_checkbutton) -side top -anchor nw -padx 5 -pady 5 
      #          pack $itk_component(sim_dir_label)  -side top -anchor nw -padx 5 -pady 5 
      #          pack $itk_component(sim_dir)  -side top -anchor nw -padx 5 -pady 5 -fill x 
    }
    
    private method create_folders {} {
      
      itk_component add folders_fr { 
        frame $itk_component(tabs).folders_fr 
      } { }

      itk_component add folders_table {
        tixTable $itk_component(folders_fr).folders_table -cols 3  -titlerows 1 -xscroll no
      } { }
      pack $itk_component(folders_table) -fill both -expand 1
      #add embedded windows to the table
      itk_component add folder_name {
        entry  $itk_component(folders_fr).folder_name -textvariable [namespace current]::folder_name_var \
            -bd 1 -bg white \
            -takefocus 0
      } {}
      itk_component add folder_ext {
        entry  $itk_component(folders_fr).folder_ext -textvariable [namespace current]::folder_ext_var -bd 1 -bg white \
            -takefocus 0
      } {}
      $itk_component(folders_table) window 0  $itk_component(folder_name) 1 $itk_component(folder_ext) 
      attach $itk_component(folders_table) FoldersTable

      set titleRow [$itk_component(folders_table).table cget -roworigin]
      $itk_component(folders_table).table set $titleRow,0 "Folder Name"
      $itk_component(folders_table).table set $titleRow,1 "Files Extension"
    }

    private method create_files {} {
      itk_component add files_fr {
        ::UI::PaneContainer $itk_component(tabs).files_fr $document -orient vertical
      } { }
      
      set files_left [[$itk_component(files_fr) add pane tree ] childsite]
      set files_right [[$itk_component(files_fr) add pane options] childsite]
      
      ### Left side - project tree ##########
      label $files_left.label -text "Project Files:"
      itk_component add files_tree {
        ::v2::ui::projectdialog::ProjectSettingTree $files_left.files_tree $document
      } {}

      pack $files_left.label -anchor nw -side top
      pack $itk_component(files_tree) -fill both -anchor nw -side top -expand 1 -pady 3 


      ### Right side - select file  #########
      label $files_right.label -text "Select Files:"
#       itk_component add files_selection {
#         ::UI::FileMultipleSelectionBox $files_right.files_selection  \
#             -selectfilecommand "$this OnFileSelection" -dirchangecommand "$this OnDirectoryChange"
#       } { }
#       attach $itk_component(files_selection) DirectoryName 
#       [$itk_component(files_selection) component selection] configure -validate "$this OnFileSelection"

      pack $files_right.label -padx 5 -side top -anchor nw -pady 5
 #     pack $itk_component(files_selection) -padx 5 -side top  -anchor nw -fill both -expand 1
      
      ### Add by Extension
      itk_component add by_extension {
        radiobutton $files_right.by_extension -text "Add by Extension" \
            -value by_extension -command "$this AddRadioChanged" -width 15 -anchor nw
      } { }
      attach $itk_component(by_extension) AddFilesMethod

      ### Add to Folder
      itk_component add to_folder_fr {
        frame $files_right.folder_fr
      } {}
      itk_component add to_folder {
        radiobutton $itk_component(to_folder_fr).to_folder -text "Add to folder" \
            -value to_folder -command "$this AddRadioChanged" -width 15 -anchor nw
      } {}
      attach $itk_component(to_folder) AddFilesMethod
      
      itk_component add folder_choice {
        ::UI::BwidgetCombobox $itk_component(to_folder_fr).folder_choice -editable 0
      } 
      attach $itk_component(folder_choice) AddToFolder FoldersList
      
      pack $itk_component(to_folder) -side left -anchor nw
      pack $itk_component(folder_choice) -side left -anchor nw -fill x -expand 1
      
      ### Adder frame
      itk_component add adder_frame {
        frame  $files_right.adder_frame 
      }
      catch {
        $document run_command OpenPathVariableAdderCommand FrameArgument $itk_component(adder_frame)
      }
      
      # must be created after OpenPathVariableAdderCommand
#      label $files_right.label -text "Select Files:"
#      itk_component add files_selection {
#        ::UI::FileMultipleSelectionBox $files_right.files_selection  \
#            -selectfilecommand "$this OnFileSelection" -dirchangecommand "$this OnDirectoryChange"
#      } { }
#      attach $itk_component(files_selection) DirectoryName 
#      [$itk_component(files_selection) component selection] configure -validate "$this OnFileSelection"
      
      ### Add buttons Add Remove "Create Folder"
      itk_component add buttons_fr {
        frame $files_right.buttons_fr
      } {}
      itk_component add add_button {
        button $itk_component(buttons_fr).add_button -text "Add Files" -command "$this AddFiles"
      } {}
      itk_component add remove_button {
        button $itk_component(buttons_fr).remove_button -text "Remove Files" 
      } {}
      attach $itk_component(remove_button) ProjectDialogRemoveFilesCommand
      
      itk_component add createfolder_button {
        button $itk_component(buttons_fr).createfolder_button -text "Create Folder" -width 20
      } {}
      attach $itk_component(createfolder_button) OpenCreateFolderDialogCommand
      
#      pack $files_right.label -padx 5 -side top -anchor nw -pady 5
#      pack $itk_component(files_selection) -padx 5 -side top  -anchor nw -fill both -expand 1
      
#      pack $itk_component(to_folder) -side left -anchor nw
#      pack $itk_component(folder_choice) -side left -anchor nw -fill x -expand 1
      
      pack $itk_component(add_button) -side left -padx 20 -pady 5
      pack $itk_component(remove_button) -side left  -padx 20 -pady 5
      pack $itk_component(createfolder_button) -side left -padx 20 -pady 5

      pack $itk_component(by_extension) -side top  -anchor nw -pady {50 5} -padx 5
      pack $itk_component(to_folder_fr) -side top -fill x  -anchor nw -padx 5
      pack $itk_component(adder_frame) -side top -fill x  -anchor nw -pady {50 5} -padx 5
      pack $itk_component(buttons_fr) -side bottom -anchor ne -fill x -padx 5

      $this AddRadioChanged

      set isAdvancedMode 1
    }

    public method AddFiles {} {
      catch {
        set filetypes {
          {"Sources and Headers" "*.c *.cpp *.cc *.h*" ".hpp"} 
          {"Models" "*.mb"} 
          {"Binaries" "*.o *.a *.so *.exe *.x"}
          {"Documentation" "*.txt *.doc *.pdf *.html *.htm"}
          {"All Files" "*"}
        }
        set fileslist [::UI::open_file_dialog tk_getOpenFile "" "Select Files" $filetypes $itk_interior [set [$document get_variable_name DirectoryName]] 1]
#        set fileslist [$itk_component(files_selection) get]
        catch {
          set [$document get_variable_name {DocumentTypePathVariablesAdder FileSelectionList}] $fileslist
        }
        $document set_variable_value DirectoryName [file dirname [lindex $fileslist 0]]
        $document run_command ProjectDialogAddFilesCommand AddFilesList $fileslist
      }
    }
    public method OnDelete {x y} {
      if { $lastOpenedPage == "files"} {
        catch {
#          puts  "w=[winfo containing -displayof $itk_interior $x $y] class=[winfo class [winfo containing -displayof $itk_interior $x $y]]"
          if { [winfo class [winfo containing -displayof $itk_interior $x $y]] == "TreeView"} {
            $document run_command ProjectDialogRemoveFilesCommand 
          }
        }
      }
    }
    
    public method OnFileSelection {} {
      set selection [$itk_component(files_selection) get]
      catch {
        set [$document get_variable_name {DocumentTypePathVariablesAdder FileSelectionList}] $selection
      }
      return true
    }
    public method OnDirectoryChange { dir } {
      catch {
        #reset CurrentDirectory in order to cause recalculation of used path variable
        set [$document get_variable_name {DocumentTypePathVariablesAdder CurrentDirectory}] ""
        set [$document get_variable_name {DocumentTypePathVariablesAdder FileSelectionList}] $dir
      }
      return true
    }

#     public method OffAdvancedCommand {} {
#       if {$isAdvancedMode} {
#           set adder_frame $itk_component(adder_frame)
#           $itk_component(more_button) configure -command "$this OnAdvancedCommand" -text "More >"
#           pack forget $adder_frame 
#           update
#           set height [winfo height $itk_interior]
#           set reqheight [winfo reqheight $adder_frame];
#           set width [winfo width $itk_interior]
#           set newheight [expr $height - $reqheight]
          
#           wm geometry $itk_interior  $width\x$newheight
#           set isAdvancedMode 0
#       }
#     }

#     public method OnAdvancedCommand {{adder_frame ""}} {
 
#       if {!$isAdvancedMode} {
#         if {$adder_frame==""} {
#           set adder_frame $itk_component(adder_frame)
#         }
#         $itk_component(more_button) configure -command "$this OffAdvancedCommand" -text "< Less"
#         set height [winfo height $itk_interior]
#         set width [winfo width $itk_interior]
        
#         pack $adder_frame  -side top -fill x  -anchor nw
#         update
#         set reqheight [winfo reqheight $adder_frame];
#         set newheight [expr $height + $reqheight]
#         wm geometry $itk_interior  $width\x$newheight      
#         set isAdvancedMode 1
#       }
#     }
    
    public method AddRadioChanged {} {
      if {[$document get_variable_value AddFilesMethod] == "to_folder"} {
        $itk_component(folder_choice) configure -state normal
      } else {
        $itk_component(folder_choice) configure -state disabled
      }
    }

    private method create_includes {} {
      itk_component add includes_fr { 
        frame $itk_component(tabs).includes_fr 
      } { }

      itk_component add includes_table {
        tixTable $itk_component(includes_fr).includes_table -cols 2  -titlerows 1 -xscroll no
      } {}
      pack $itk_component(includes_table) -fill both -expand 1
      #add embedded windows to the table
      itk_component add includes_path {
        ::UI::FileChooser $itk_component(includes_fr).includes_path___advanced___ \
            -browsetype directory_advanced -path_variable_document $document -dialogtitle "Select Directory" \
            -filenamevariable [namespace current]::includes_path_var -takefocus 0
      } {}
      attach $itk_component(includes_path) DirectoryName
 
      $itk_component(includes_table) window 0 $itk_component(includes_path)
      attach $itk_component(includes_table) IncludeTable
      

      set titleRow [$itk_component(includes_table).table cget -roworigin]
      $itk_component(includes_table).table set $titleRow,0 "Include Path"
    }

    private method create_path_variables {} {
      itk_component add $path_variables_frame_name { 
        frame $itk_component(tabs).$path_variables_frame_name 
      } { }
      itk_component add path_variables_table {
        tixTable $itk_component($path_variables_frame_name).path_variables_table \
            -cols 3  -titlerows 1 -xscroll no
      } {}

            
      pack $itk_component(path_variables_table) -fill both -expand 1
      #add embedded windows to the table
      itk_component add variable_name {
        entry  $itk_component($path_variables_frame_name).variable_name \
            -textvariable [namespace current]::variable_name_var -bd 1 -bg white -takefocus 0
      } {}
      itk_component add variable_path {
        ::UI::FileChooser $itk_component($path_variables_frame_name).variable_path___advanced___  \
            -filenamevariable [namespace current]::variable_path_var \
            -browsetype directory_advanced -path_variable_document $document  -dialogtitle "Select Directory" \
            -takefocus 0

      } {}
      attach  $itk_component(variable_path) DirectoryName
      $itk_component(path_variables_table) window 0 $itk_component(variable_name) 1 $itk_component(variable_path)

      attach $itk_component(path_variables_table) PathVariablesTable

      #configuring for predefined path variables

        set rowsToDisableNum [$document get_variable_value NumberOfPredefinedPathVariables]
        if {$rowsToDisableNum > 0} {
          set wordLength [$document get_variable_value MaxLengthOfPredefinedPathVariableValue] 
        #disable predefined path variables - currently 2 rows
        $itk_component(path_variables_table) disablerowrange 0 [expr $rowsToDisableNum - 1]
        if {$wordLength > 40} {
          $itk_component(path_variables_table).table width 0 15 1 $wordLength
          $itk_component(path_variables_table) config -xscroll yes
        }
      }
      
      set titleRow [$itk_component(path_variables_table).table cget -roworigin]
      $itk_component(path_variables_table).table set $titleRow,0 "Name"
      $itk_component(path_variables_table).table set $titleRow,1 "Value"
    }
    
    private method create_pre_proc_defintions {} {
      itk_component add pre_proc_defintions_fr { 
        frame $itk_component(tabs).pre_proc_defintions_fr 
      } { }
      itk_component add definitions_lf {
        iwidgets::Labeledframe $itk_component(pre_proc_defintions_fr).definitions_lf \
            -labelpos nw -labeltext "Definitions:"
      } {}

      itk_component add definitions_table {
        tixTable [$itk_component(definitions_lf) childsite].definitions_table \
            -cols 3 -titlerows 1 -xscroll no 
      } {}
      
      #add embedded windows to the table
      itk_component add definition_name {
        entry  $itk_component(pre_proc_defintions_fr).variable_name \
            -textvariable [namespace current]::definition_name_var -bd 1 -bg white -takefocus 0
      } {}
      itk_component add definition_value {
        entry  $itk_component(pre_proc_defintions_fr).variable_path \
            -textvariable [namespace current]::definition_value_var -bd 1 -bg white -takefocus 0
      } {}
      $itk_component(definitions_table) window 0  \
          $itk_component(definition_name) 1 $itk_component(definition_value)
      attach $itk_component(definitions_table) PreProcessorTable
      $itk_component(definitions_table).table config -height 10

      set titleRow [$itk_component(definitions_table).table cget -roworigin]
      $itk_component(definitions_table).table set $titleRow,0 "Name"
      $itk_component(definitions_table).table set $titleRow,1 "Value"
      
       itk_component add options_lf {
         iwidgets::Labeledframe $itk_component(pre_proc_defintions_fr).options_lf \
             -labelpos nw -labeltext "Options:"
       } {}

      itk_component add make_options_label {
        label [$itk_component(options_lf) childsite].make_options_label -text "Makefile Invocation Options:"
      }
      itk_component add make_options {
        entry [$itk_component(options_lf) childsite].make_options  
      } {}

      attach $itk_component(make_options) MakeOptions

      itk_component add gen_comp_options_label {
        label [$itk_component(options_lf) childsite].gen_comp_options_label -text "Compilation Options:"
      }

      itk_component add gen_comp_options {
        entry [$itk_component(options_lf) childsite].gen_comp_options  
      } {}
      
      attach $itk_component(gen_comp_options) GeneralCompilationOptions
#################################################################################
#       itk_component add optimize_options_label {
#         label [$itk_component(options_lf) childsite].optimize_options_label -text "Options for Optimized Compilation:"
#       }

#       itk_component add optimize_options {
#         entry [$itk_component(options_lf) childsite].optimize_options  
#       } {}
      
# #      attach $itk_component(optimize_options) OptimizeOptions
#       itk_component add radio_frame {
#         frame [$itk_component(options_lf) childsite].radio_frame
#       } {}


#       itk_component add optimize_radio_label {
#         label $itk_component(radio_frame).optimize_radio_label -text "Compile Optimized:"
#       } {}
#       # All, Nothing or Some
#       itk_component add optimize_all {
#         radiobutton $itk_component(radio_frame).optimize_all -text "All" -value 0
#       } {}
#       itk_component add optimize_some {
#         radiobutton $itk_component(radio_frame).optimize_some -text "Specific Files" -value 1
#       } {}
      
#       itk_component add optimize_nothing {
#         radiobutton $itk_component(radio_frame).optimize_nothing -text "Nothing" -value 0
#       } {}
      
      
#       #-variable is temporary, should be changed to attach
#       itk_component add optimize_table {
#         tixTable [$itk_component(options_lf) childsite].optimize_table \
#             -cols 3 -titlerows 1 -xscroll no -center 1 -variable [namespace current]::opt_table_var
#       } {}
      
#       #add embedded windows to the table

#       itk_component add file_name {
#         entry  $itk_component(pre_proc_defintions_fr).file_name \
#             -textvariable [namespace current]::file_name_var -bd 1 -bg white -takefocus 0
#       } {}
      
#       #should be listbox
#       itk_component add optimize_value {
#           entry  $itk_component(pre_proc_defintions_fr).optimize_value \
#               -textvariable [namespace current]::optimize_value_var -bd 1 -bg white -takefocus 0
#       } {}
#       itk_component add is_optimized {
#         ::UI::Checkbutton $itk_component(pre_proc_defintions_fr).is_optimized \
#             -variable [namespace current]::is_optimized_var -bd 1 -bg white -takefocus 0
#       } {}
      
#       $itk_component(optimize_table) window 0  \
#           $itk_component(file_name) 1 $itk_component(is_optimized) 2 $itk_component(optimize_value)
      
        
#       set titleRow [$itk_component(optimize_table).table cget -roworigin]
#       $itk_component(optimize_table).table set $titleRow,0 "File Name"
#       $itk_component(optimize_table).table set $titleRow,1 "Optimize"
# #      $itk_component(optimize_table).table set $titleRow,2 "Optimization Options"
#       $itk_component(optimize_table).table width 1 15
######################################################################################      
      #packing
      pack $itk_component(definitions_table) -side top -fill both -anchor nw 
      pack $itk_component(definitions_lf)  -side top -fill both -expand 0 -anchor nw

      pack $itk_component(make_options_label) -side top -anchor nw -pady 6 -padx 5
      pack $itk_component(make_options)  -side top -fill x -expand 1 -anchor nw
      
      pack $itk_component(gen_comp_options_label) -side top -anchor nw -pady 6 -padx 5
      pack $itk_component(gen_comp_options)  -side top -fill x -expand 1 -anchor nw

######################################################################################        
      
#       pack $itk_component(optimize_options_label) -side top -anchor nw -pady 6 -padx 5
#       pack $itk_component(optimize_options)  -side top -fill x -expand 1 -anchor nw

#       pack $itk_component(optimize_radio_label) -side left -anchor nw -pady 2
#       pack $itk_component(optimize_all) -side left -anchor nw -padx 20
#       pack $itk_component(optimize_some) -side left -anchor center -padx 20
#       pack $itk_component(optimize_nothing) -side left -anchor ne -padx 20

#       pack $itk_component(radio_frame) -side top -fill x -expand 1 -anchor nw -pady 6 -padx 5
#       pack $itk_component(optimize_table)  -side top -fill both -expand 1 -anchor nw
######################################################################################  
      
      pack $itk_component(options_lf) -side top -fill both -anchor nw -expand 0 -pady 6

    }

    private method create_link {} {
      itk_component add link_fr {
        ::UI::PaneContainer $itk_component(tabs).link_fr $document -orient horizontal
      } { }
      
      ### Dependencies
      set dependencies [[$itk_component(link_fr) add pane dependencies \
                            -minimum 200 -thickness 300] childsite]

      itk_component add depend_lf {
        iwidgets::Labeledframe $dependencies.depend_lf \
            -labelpos nw -labeltext "Dependencies:"
      } {}
      set depend_frame [$itk_component(depend_lf) childsite]
      
      itk_component add dependencies {
        ::v2::ui::projectdialog::Dependences $depend_frame.dependencies $document
      } {}
      attach $itk_component(dependencies) AllProjectsNames LinkDependencies AllPackagesNames LinkPackages

      pack $itk_component(dependencies) -side top -fill both -anchor nw -expand 1
      pack $itk_component(depend_lf)  -side top -fill both -anchor nw -expand 1
      
      ### Linked objects table
      set linked_objects [[$itk_component(link_fr) add pane linked_objects] childsite]

      itk_component add link_objects {
        iwidgets::Labeledframe $linked_objects.link_objects \
            -labelpos nw -labeltext "Linked Objects:"
      } { }
      set link_objects [$itk_component(link_objects) childsite]

      itk_component add link_table {
        tixTable $link_objects.link_table -cols 2 -titlerows 1 -xscroll no
      } {}
      set titleRow [$itk_component(link_table).table cget -roworigin]
      $itk_component(link_table).table set $titleRow,0 "Linked Object Name"
      attach $itk_component(link_table) LinkObjectsTable
      $itk_component(link_table).table config -height 6

      #add embedded windows to the table
      itk_component add link_objects_path {
        ::UI::FileChooser $itk_component(link_objects).link_objects_path__advanced__ \
            -buttoncmdtype openfile -dialogtitle "Select Object" \
            -filetypes {{"Objects" "*.o"} {"Archives" "*.a"} {"Shared Libraries" "*.so"} {"All Files" "*"}} \
            -filenamevariable [namespace current]::link_path_var \
            -browsetype file_advanced -path_variable_document $document -takefocus 0
      } {}
      attach $itk_component(link_objects_path) DirectoryName
      $itk_component(link_table) window 0 $itk_component(link_objects_path)
      
      itk_component add link_label {
        label $link_objects.link_label -text "Link Options:"
      } {}
      itk_component add link_options {
        entry $link_objects.link_options 
      } {}
      attach $itk_component(link_options) LinkOptions

      set isUnix [::Utilities::isUnix]
      #Project Library Type
      if {$isUnix} {
        itk_component add library_frame {
          frame $link_objects.library_frame
        } {}
        itk_component add library_label {
          label $itk_component(library_frame).library_label -text "Project Library Type:"
        } {}
        itk_component add archive_library {
          radiobutton $itk_component(library_frame).archive_library -text "Archive" -value "archive" -width 15 -anchor nw
        } {}
        attach $itk_component(archive_library) ProjectLibraryType
        itk_component add shared_library {
        radiobutton $itk_component(library_frame).shared_library -text "Shared Library" -value "shared" -width 15 -anchor nw
        } {}
        attach $itk_component(shared_library) ProjectLibraryType
      }
      pack $itk_component(link_table) -side top  -fill x -anchor nw -pady 10
      pack $itk_component(link_label) -side top -anchor nw -pady 10 -padx 5
      pack $itk_component(link_options) -side top -fill x -anchor nw 
      if {$isUnix} {
        pack $itk_component(library_label) -side left -padx 5
        pack $itk_component(archive_library) -side left -padx 10
        pack $itk_component(shared_library) -side right -padx 100
        pack $itk_component(library_frame) -anchor nw -side top -fill x -pady 20
      }
      pack $itk_component(link_objects) -side top -fill both -anchor nw -expand 1
      
      # AllProjectsNames and AllPackagesNames are empty 
      set projectsList [$document get_variable_value AllProjectsNames]
      set packagesList [$document get_variable_value AllPackagesNames]
      if {$projectsList == {} && $packagesList == {}} {
        $itk_component(link_fr) hide dependencies
      }
    }
    

    public method updateTables {} {
      $itk_component(folders_table) saveactivedata
      $itk_component(includes_table) saveactivedata
      $itk_component(path_variables_table) saveactivedata
      $itk_component(definitions_table) saveactivedata
      $itk_component(link_table) saveactivedata
      update idle
    }

    private method PageChanged {} {
      if {$lastOpenedPage == "folders"} {
        $itk_component(folders_table) saveactivedata
        $document run_command FoldersUpdateCommand
      } elseif {$lastOpenedPage == "variables" } {
        $itk_component(path_variables_table) saveactivedata
        $document run_command PathVariablesUpdateCommand
      }
      set lastOpenedPage [$itk_component(tabs) get focus]
      if {$lastOpenedPage == "files"} {
#        $this OnFileSelection
        $document run_command FilesTabCommand
      }
      $document set_variable_value CurrentPage $lastOpenedPage
    }
    
  };#class
  
};#namespace
