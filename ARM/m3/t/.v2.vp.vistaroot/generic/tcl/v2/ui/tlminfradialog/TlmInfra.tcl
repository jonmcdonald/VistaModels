namespace eval ::v2::ui::tlminfradialog {
  class TlmInfra {
    #remove common code, use CommandLineDialog methods instead
    inherit ::UI::BaseDialog ::UI::CommandLineDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 320 320

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]
      
      #Command Line
      itk_component add command_line_frame {
        frame $top.command_line_frame
      }

      itk_component add command_line_label {
        label $itk_component(command_line_frame).command_line_label -text "Command Line:" 
      } {}

      #Save/Load buttons
      itk_component add save_button {
        button $itk_component(command_line_frame).save_button -text "Save As" -underline 0 -command "$this saveCommandToFile" 
      } {}

      itk_component add load_button {
        button $itk_component(command_line_frame).load_button -text "Load" -underline 0 -command "$this loadCommandFromFile" 
      } {}


      itk_component add command_line_text {
        ::UI::SText $top.command_line_text $document -height 5 -state normal -font "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
      } {
        keep -font
      }

      attach $itk_component(command_line_text) CommandLine
      set text  [$itk_component(command_line_text) component text]
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind SText_$text $event [code $this updateCommandLineIsEditedManuallyOnKey $key 1]
      }
      bindtags $text  "[bindtags $text] SText_$text"
      #Working Directory
      itk_component add wd_frame {
        frame $top.wd
      }
      itk_component add wd_label {
        label $itk_component(wd_frame).wd_label -text "Working Directory:" 
      } {}

      itk_component add wd {
        ::UI::FileChooser $itk_component(wd_frame).wd \
            -filenamevariable [$document get_variable_name TlmInfraWorkingDirectory] \
            -browsetype directory \
            -dialogtitle "Select Directory" \
            -initialdir [set [$document get_variable_name TlmInfraWorkingDirectory]]
      } {}
      set wd_entry [$itk_component(wd) get_entry ]
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind Active_$wd_entry $event [code $this updateCommandLineIsEditedManuallyOnKey $key 0]
      }
      set tags  [bindtags $wd_entry]
      bindtags $wd_entry [linsert $tags [expr [lsearch $tags "Entry"] + 1] Active_$wd_entry]
      $itk_component(wd) config -openFileViaBrowserPostHook "catch {$document set_variable_value CommandLineIsEditedManually 0}"

      #Key Files
#       itk_component add key_files_label {
#         label $top.key_files_label -text "Key Files:" 
#       }
#       itk_component add key_files_frame {
#         frame $top.key_files_frame
#       }
      itk_component add key_files_table {
        tixTable $top.key_files_table -cols 2 -titlerows 1 -xscroll no 
      } {}

      #add embedded windows to the table
      itk_component add key_file {
       ::UI::FileChooser $top.key_files  \
           -browsetype file -buttoncmdtype openfile \
           -filetypes {{"Key Files" "*.txt"} {"All Files" "*"}} \
           -filenamevariable [namespace current]::key_file_var -takefocus 0 \
           -with_multiple_select 1
      } {}


      setTableHooksAndBindings key_file key_files_table 
      $itk_component(key_file) config -openFileViaBrowserPostHook [code $this openMultipleKeyFilePosthook]

      $itk_component(key_files_table)  window 0 $itk_component(key_file)
      attach $itk_component(key_files_table) KeyFilesTable
      $itk_component(key_files_table).table configure -height 4
      set titleRow [$itk_component(key_files_table).table cget -roworigin]
      $itk_component(key_files_table).table set  $titleRow,0 "Key Files"

      #Central Repositories (Objects)
#       itk_component add objects_label {
#         label $top.objects_label -text "Central Repositories:"
#       }
      
#       itk_component add objects_frame {
#         frame $top.objects_frame
#       }

      itk_component add objects_table {
        tixTable $top.objects_table -cols 2 -titlerows 1 -xscroll no 
      } {}

      #add embedded windows to the table
      itk_component add object {
       ::UI::FileChooser $top.object  \
           -browsetype directory -dialogtitle "Select Directory" \
           -filenamevariable [namespace current]::object_var -takefocus 0 
      } {}
      $itk_component(objects_table)  window 0 $itk_component(object)
      attach $itk_component(objects_table) CentralRepositoriesTable
      $itk_component(objects_table).table configure -height 4
      set titleRow [$itk_component(objects_table).table cget -roworigin]
      $itk_component(objects_table).table set  $titleRow,0 "Central Repositories"

      setTableHooksAndBindings object objects_table

      #Design Packages
      # itk_component add design_packages_label {
#         label $top.design_packages_label -text "Design Packages:"
#       }

#       itk_component add design_packages_frame {
#         frame $top.design_packages_table
#       } {}
      itk_component add design_packages_table {
        tixTable $top.design_packages_table -cols 2 -titlerows 1 -xscroll no 
      } {}

      #add embedded windows to the table
      itk_component add design_package {
       ::UI::FileChooser $top.design_package  \
           -browsetype file -buttoncmdtype openfile \
           -filetypes {{"Design Packages" "*.txt"} {"All Files" "*"}} \
           -filenamevariable [namespace current]::design_package_var -takefocus 0 \
           -with_multiple_select 1
      } {}
      $itk_component(design_packages_table)  window 0 $itk_component(design_package)
      attach $itk_component(design_packages_table) DesignPackagesTable
      $itk_component(design_packages_table).table configure -height 4
      set titleRow [$itk_component(design_packages_table).table cget -roworigin]
      $itk_component(design_packages_table).table set  $titleRow,0 "Design Packages"
      setTableHooksAndBindings design_package design_packages_table
      $itk_component(design_package) config -openFileViaBrowserPostHook [code $this openMultipleDesignPackageFilePosthook]

      #Top
      itk_component add top_frame {
        frame $top.top_frame
      } {}
      itk_component add top_label {
        label $itk_component(top_frame).top_label -text "Top Level Object:"
      } {}
      itk_component add top_combobox {
        ::UI::BwidgetCombobox $itk_component(top_frame).top_combobox
      } {}
      attach $itk_component(top_combobox) TopObject TopObjectsList TopObjectIndex 

      set cb [$itk_component(top_combobox) component combobox]
      $cb configure -postcommand [code $this fillObjectsList]
      set modify_cmd [$cb cget -modifycmd]
      $cb configure -modifycmd "$modify_cmd; [code $this updateCommandLineIsEditedManuallyOnKey x 0]"
      set entry $cb.e
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind ComboboxEntryActive_$entry $event [code $this updateComboboxOnKey $key $entry TopObject]
      }
      set tags  [bindtags $entry]
      bindtags $entry [linsert $tags [expr [lsearch $tags "BwEditableEntry"] + 1] ComboboxEntryActive_$entry] 

      #With
      itk_component add with_label {
        label $top.with_label -text "With:"
      } {}
      itk_component add with_text {
        ::UI::SText $top.with_text $document -height 3 -state normal -font "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
      } {
        keep -font
      }

      attach $itk_component(with_text) With
      set with_text [$itk_component(with_text) component text]
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind SText_$with_text $event [code $this updateCommandLineIsEditedManuallyOnKey $key 0]
      }
      bindtags $with_text  "[bindtags $with_text] SText_$with_text"


      #Packing
      pack $itk_component(command_line_frame)    -anchor nw  -fill x -expand 0 
      pack $itk_component(command_line_label)    -side left -padx 5 -pady 5
      pack $itk_component(save_button)           -side left  -padx 20 -pady 5
      pack $itk_component(load_button)           -side right  -padx 20 -pady 5

      pack $itk_component(command_line_text)     -anchor nw -padx 5 -pady 5 -fill both -expand 1
      pack $itk_component(wd_frame)              -anchor nw  -fill x -expand 0 
      pack $itk_component(wd_label)              -side left -padx 5 -pady 5
      pack $itk_component(wd)                    -side right -padx 5 -pady 5 -fill x -expand 1
#      pack $itk_component(key_files_label)       -anchor nw -padx 5  
#      pack $itk_component(key_files_frame)       -pady 5 -fill both -expand 1
      pack $itk_component(key_files_table)        -anchor nw -padx 5 -pady 5 -fill x 
#      pack $itk_component(key_files_nav)         -side right 
#      pack $itk_component(objects_label)         -anchor nw -padx 5 
#      pack $itk_component(objects_frame)         -pady 5 -fill x
#      pack $itk_component(objects_table)         -side left -padx 5  -fill x -expand 1
      pack $itk_component(objects_table)          -anchor nw -padx 5 -pady 5 -fill x 
#      pack $itk_component(objects_nav)           -side right 
#      pack $itk_component(design_packages_label) -anchor nw -padx 5 
#      pack $itk_component(design_packages_frame) -pady 5 -fill x
#      pack $itk_component(design_packages_table) -side left -padx 5  -fill x -expand 1
      pack $itk_component(design_packages_table)  -anchor nw -padx 5 -pady 5 -fill x 
#      pack $itk_component(design_packages_nav)   -side right  
      pack $itk_component(top_frame)             -anchor nw  -fill x -expand 0 
      pack $itk_component(top_label)             -side left -padx 5 -pady 5
      pack $itk_component(top_combobox)          -side right -padx 5 -pady 5 -fill x -expand 1
      pack $itk_component(with_label)            -anchor nw -padx 5 -pady 5
      pack $itk_component(with_text)             -anchor nw -padx 5 -fill both -expand 1

    }

    
    protected method create_buttons {} {
      add_button "" -text "Go" -width 5 -underline 0 -command [ code $document run_command TlmInfraGoCommand]
      add_button "" -text "Apply" -width 5 -underline 0 -command [ code $document run_command ApplyCommand]
      
      add_common_buttons
    }


    protected method draw {} {
      set_geometry
      update idle
      set children [winfo children $itk_component(buttons)]
      foreach child $children {
        pack forget $child
        pack $child -padx 20 -side left 
      }
      pack $itk_component(buttons) -side bottom -anchor center -padx 5 -pady 5 
      pack $itk_component(body) -padx 5 -pady 5 -side top -anchor nw -fill both -expand 1
      catch {focus $itk_component(buttons).b0}
    }

    private method updateTableDataOnKey { key table } {
      if {[isMeaningfulKey $key]} {
        $document set_variable_value CommandLineIsEditedManually 0
        catch { $itk_component($table) saveactivedata 0 }
      }
    }
    private method openMultipleKeyFilePosthook { filenames } {
      openMultipleFilePosthook $filenames $itk_component(key_files_table)
    }
    private method openMultipleDesignPackageFilePosthook { filenames } {
      openMultipleFilePosthook $filenames $itk_component(design_packages_table)
    }
    private method openMultipleFilePosthook { filenames table} {
      $document set_variable_value CommandLineIsEditedManually 0 
      $table saveactivedata 0 

      set row  [$table active row]
      set col  [$table active col]

      $table saveactivedata
      set current_row $row

      foreach file $filenames {

        if {$current_row == $row} {
          $table.table set $row,$col $file
        } else {
          if {[$table isEmptyRow $current_row]} {
            $table.table set $current_row,$col $file
          } else {
            $table insertrow $current_row
            $table.table set $current_row,$col $file
          }
        }
        incr current_row
        
      }
    }
    private method create_popup_menu  {table} {
      itk_component add popup_menu_$table {
        ::UI::TableMenu $itk_component($table).popup_menu_$table $document -table_widget $itk_component($table) -addShowRowsCommand 1
      }
      $itk_component($table) configure -menuCallback [code $this popup_menu_$table\_callback]
    }
    private method popup_menu_key_files_table_callback {args} {
      return $itk_component(popup_menu_key_files_table)
    }
    private method popup_menu_objects_table_callback {args} {
      return $itk_component(popup_menu_objects_table)
    }
    private method popup_menu_design_packages_table_callback {args} {
      return $itk_component(popup_menu_design_packages_table)
    }
    

    private method setTableHooksAndBindings { chooser table } {
      set chooser_entry [$itk_component($chooser) get_entry ]
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind ChooserActive_$chooser_entry $event [code $this updateTableDataOnKey $key $table]
      }
      set tags  [bindtags $chooser_entry]
      bindtags $chooser_entry [linsert $tags [expr [lsearch $tags "Entry"] + 1]  ChooserActive_$chooser_entry]
      
      $itk_component($chooser) config -openFileViaBrowserPostHook "catch {$document set_variable_value CommandLineIsEditedManually 0; $itk_component($table) saveactivedata 0 }"

      set tk_table $itk_component($table).table
      bind DelActive_$tk_table <Delete> "catch {$document set_variable_value CommandLineIsEditedManually 0}"
      bindtags $tk_table "[ bindtags $tk_table ] DelActive_$tk_table "

      $itk_component($table).table tag configure title -anchor c -relief raised -bg gray -fg black -font $::defaultFont
      create_popup_menu $table
    }
    private method updateComboboxOnKey {key entry tag} {
      catch {
        if {[isMeaningfulKey $key]} {
          $document set_variable_value CommandLineIsEditedManually 0
          eval [list $document set_variable_value $tag [$entry get]]
        }
      }
    }
    private method fillObjectsList {} {
      $document run_command UpdateTopLevelObjectsListCommand
      set cb [$itk_component(top_combobox) component combobox]
      if {[llength [$cb cget -values]] == 0} {
        $cb configure -values [$document get_variable_value TopObjectsList]
      }
    }

    private method updateCommandLineIsEditedManuallyOnKey {key value} {
      if {[isMeaningfulKey $key] } {
        $document set_variable_value CommandLineIsEditedManually $value
     }
    }
    private method isMeaningfulKey {key} {
      if {[lsearch {Right Left Home End} $key] == "-1"} {
        return 1
      }
      return 0
    }
    
    public method saveCommandToFile {} {
      $document run_command TlmInfraSaveCommandToFile
    }
    public method loadCommandFromFile {} {
      $document run_command TlmInfraLoadCommandFromFile
    }
  }
  

}
