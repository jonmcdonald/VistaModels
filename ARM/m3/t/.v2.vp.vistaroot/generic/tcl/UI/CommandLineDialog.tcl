namespace eval ::UI {
  #child class should first call setCommandLineBindings
  class CommandLineDialog {
    private variable command_line_is_edited_manually_variable_name ""
    private variable document ""
    
    protected method setCommandLineBindings {command_line_widget _command_line_isedited_manually_variable_name _document} {
      set document $_document
      set command_line_is_edited_manually_variable_name $_command_line_isedited_manually_variable_name
      set text  [$command_line_widget component text]
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind SText_$text $event [code $this updateCommandLineIsEditedManuallyOnKey $key 1]
      }
      bindtags $text  "[bindtags $text] SText_$text"
      
    }
    protected method setEntryBindings {entry_widget} {
      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind EntryActive_$entry_widget $event [code $this updateCommandLineIsEditedManuallyOnKey $key 0]
      }
      bindtags $entry_widget  "[bindtags $entry_widget] EntryActive_$entry_widget"
    }

    protected method setBwidgetComboboxBindings {bwcombobox_widget dataTag} {
      set cb [$bwcombobox_widget component combobox]
      set modify_cmd [$cb cget -modifycmd]
      $cb configure -modifycmd "$modify_cmd; [code $this updateCommandLineIsEditedManuallyOnKey x 0]"
      if {[$cb cget -editable]} {
        set entry $cb.e
        foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
          bind ComboboxEntryActive_$entry $event [code $this updateComboboxOnKey $key $entry $dataTag]
        }
        set tags  [bindtags $entry]
        bindtags $entry [linsert $tags [expr [lsearch $tags "BwEditableEntry"] + 1] ComboboxEntryActive_$entry] 
      }
    }
    #checkbutton_widget is UI::Checkbutton
    protected method setCheckbuttonBindings {ui_checkbutton_widget } {
      set check [$ui_checkbutton_widget component checkbutton]
      set command [$ui_checkbutton_widget cget -command]
      $check configure -command "$command; [code $this updateCommandLineIsEditedManuallyOnKey x 0]"
    }

    protected method setRadiobuttonBindings {radiobutton_widget} {
      set command [$radiobutton_widget cget -command]
      $radiobutton_widget configure -command "$command; [code $this updateCommandLineIsEditedManuallyOnKey x 0]"
    }

    private method updateCommandLineIsEditedManuallyOnKey {key value} {
      if {[isMeaningfulKey $key] } {
        $document set_variable_value $command_line_is_edited_manually_variable_name $value
        #puts "updateCommandLineIsEditedManuallyOnKey $key $value"
     }
    }
    private method isMeaningfulKey {key} {
      if {[lsearch {Right Left Home End} $key] == "-1"} {
        return 1
      }
      return 0
    }

    private method updateComboboxOnKey {key entry tag} {
      catch {
        if {[isMeaningfulKey $key]} {
          $document set_variable_value $command_line_is_edited_manually_variable_name 0
          eval [list $document set_variable_value $tag [$entry get]]
        }
      }
    }

  }
}
