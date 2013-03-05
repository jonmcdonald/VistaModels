namespace eval ::UI {
  ::itcl::class Button/DocumentLinker {
    inherit CommandDocumentLinker
    protected method attach_to_command {widget document commandName args} {
      if {![$document is_command_name $commandName]} {
        error "$commandName is not a command name"
      }
      $widget configure -command [list eval [list $document run_command $commandName] $args]
      attach_to_disable_reason $widget $document $commandName
    }

    protected method attach_to_disable_reason {widget document tag} {
      set enable_var_name [$document get_enable_variable_name $tag]
      set disable_reason_var_name [$document get_disable_reason_variable_name $tag]

      ::UI::auto_trace_with_init variable $enable_var_name w $widget [::itcl::code $this _update_help_text $document $tag]
      ::UI::auto_trace_with_init variable $disable_reason_var_name w $widget [::itcl::code $this _update_help_text $document $tag]
    }
    
    private method _update_help_text {document tag widget args} {
      set enable_var_name [$document get_enable_variable_name $tag]
      set disable_reason_var_name [$document get_disable_reason_variable_name $tag]
      set helpText ""
      set helpTextIndex [string first "-helptext" [$widget configure]]
      if {$helpTextIndex != -1} {
        set helpText [$widget cget -helptext]
        regsub {\nDisabled:.*$} $helpText "" helpText
      }
      set is_enabled [::Utilities::safeGet $enable_var_name 1]
      if {!$is_enabled} {
        set reason [::Utilities::safeGet $disable_reason_var_name ""]
        if {$reason != ""} {
          append helpText "\nDisabled: $reason"
        }
      }
      if {$helpTextIndex != -1} {
        $widget configure -helptext $helpText
      }
    }

    public method attach_button_label_to_data {widget document tag {index ""}} {
      set variableName [$document get_variable_name $tag]
      if {$index == ""} {
        $widget configure -textvariable $variableName
      } else {
        ::UI::auto_trace_with_init variable $variableName w $widget [::itcl::code $this _on_button_label_variable_changed $index]
      }
    }

    private method _on_button_label_variable_changed {index widget var_name args} {
      $widget configure -text [lindex [::Utilities::safeGet $var_name] $index]
    }

    public method attach_button_image_to_data {widget document imageOrTag} {
      set index [string first ":tag:" $imageOrTag]
      if {$index == 0} {
        set variableName [$document get_variable_name [string range $imageOrTag [string length ":tag:"] end]]
        ::UI::auto_trace_with_init variable $variableName w $widget [::itcl::code $this _on_button_image_variable_changed]
      } else {
        $widget configure -image [::UI::getimage $imageOrTag]
      }
    }

    private method _on_button_image_variable_changed {widget var_name args} {
      catch {$widget configure -image [::UI::getimage [::Utilities::safeGet $var_name] 0]}
    }
  }
  Button/DocumentLinker Button/DocumentLinkerObject


  ::itcl::class Entry/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag args} {
      set variableName [$document get_variable_name $tag]
      $widget configure -textvariable $variableName
    }
  }
  Entry/DocumentLinker Entry/DocumentLinkerObject

  ::itcl::class Label/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag {index ""}} {
      set variableName [$document get_variable_name $tag]
      if {$index == ""} {
        $widget configure -textvariable $variableName
      } else {
        ::UI::auto_trace_with_init variable $variableName w $widget [::itcl::code $this _on_variable_changed $index]
      }
    }

    private method _on_variable_changed {index widget var_name args} {
      $widget configure -text [lindex [::Utilities::safeGet $var_name] $index]
    }

    protected method attach_to_enable {widget document tag args} {
    }
  }
  Label/DocumentLinker Label/DocumentLinkerObject

  ::itcl::class Checkbutton/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag args} {
      set variableName [$document get_variable_name $tag]
      $widget configure -variable $variableName
    }
  }
  Checkbutton/DocumentLinker Checkbutton/DocumentLinkerObject

  ::itcl::class Radiobutton/DocumentLinker {
    inherit DataDocumentLinker

    protected method attach_to_data {widget document tag args} {
      set value [$widget cget -value]
      if {![$document is_value_valid $tag $value]} {
        error "Value $value is not supported in $document for $tag"
      }
      set variableName [$document get_variable_name $tag]
      $widget configure -variable $variableName
    }
    
    protected method attach_to_enable {widget document tag args} {
      chain $widget $document $tag
      set value [$widget cget -value]
      set enable_var_name [$document get_sub_enable_variable_name $tag $value]
      ::UI::auto_trace variable $enable_var_name w $widget [::itcl::code $this _enable_value_state_changed]
    }

    private method _enable_value_state_changed {widget enable_var_name args} {
      ::UI::common_set_state_using_option $widget [set $enable_var_name]
    }
  }
  Radiobutton/DocumentLinker Radiobutton/DocumentLinkerObject
 
  ::itcl::class Listbox/DocumentLinker {
    inherit DynamicDocumentLinker

    protected method attach_to_data {widget document tag args} {
      set data_variable_name [$document get_variable_name $tag]
      ::UI::auto_trace variable $data_variable_name w $widget [::itcl::code $this _set_selection $document $tag]
      if {[info exists $data_variable_name]} {
        _set_selection $document $tag $widget $data_variable_name "" w
      }
    }

    private method bind_selection {widget document tag} {
      set data_variable_name [$document get_variable_name $tag]
      bind $widget <<ListboxSelect>> [::itcl::code $this _update_data_variable $data_variable_name $widget]
    }

    private method unbind_selection {widget document tag} {
      bind $widget <<ListboxSelect>> {}
    }

    protected method set_widget_state {widget document tag isEnable} {
      if {$isEnable} {
        bind_selection $widget $document $tag
      } else {
        unbind_selection $widget $document $tag
      }
    }

    private method _update_data_variable {data_variable_name widget} {
      set $data_variable_name [$widget curselection]
    }

    private method _set_selection {document tag widget variable_name args} {
      if {[info exists $variable_name]} {
        set value [set $variable_name]
      } else {
        set value {}
      }
      $widget selection clear 0 end
      set index ""
      foreach index $value {
        $widget selection set $index
      }
      if {$index != ""} {
        $widget see $index
      }
    }

    protected method attach_to_source {widget document tag} {
      $widget configure -listvariable $source_variable
    }
  }
  Listbox/DocumentLinker Listbox/DocumentLinkerObject
  
  ::itcl::class Menu/DocumentLinker {
    inherit DataDocumentLinker
    private variable builder
    constructor {} {
      set builder [objectNew ::UI::DocumentUIBuilder ""]
    }
    destructor {
      if {[find objects $builder] != {}} {
        delete object $builder
      }
    }
    protected method attach_to_data {widget document tag args} {
      set variable_name [$document get_variable_name $tag]
      ::UI::auto_trace variable $variable_name w $widget [::itcl::code $this on_menu_structure_changed $document $tag]
      set_client_data $widget $document $tag $variable_name
      on_menu_structure_changed $document $tag $widget $variable_name "" w
    }

    private method on_menu_structure_changed {document tag widget variable_name args} {
      $builder set_document $document
      set data [::UI::get_widget_client_data $widget data_$document$tag]
      
      
      #delete separator
      if {[llength $data] >0} {
        set first [lindex [lindex $data 0] 0]
        set index [::UI::find_menu_entry_index_by_label $widget $first]
        if {[string is integer -strict $index] && $index > 0} {
          incr index -1
          if {$index >= 0 && [$widget type $index] == "separator"} {
            $widget delete $index $index
          }
        }
      }

      #delete old items
      foreach rec $data {
        set label [lindex $rec 0]
        set index [::UI::find_menu_entry_index_by_label $widget $label]
        if {$index != ""} {
          $widget delete $index $index
        }
      }
      
      #add separator
      set recList [set $variable_name]
      if {[llength $recList] > 0 && [$widget index end] != "none" && \
              [$widget type end] != "separator" && [$widget type end] != ""} {
        $widget add separator
      }
      
      # add new items
      foreach rec $recList {
        set label [lindex $rec 0]
        $widget add command -label $label
        set entryIndex [$widget index end]
        set cr [ catch {
          eval [list $builder attach_menu_item $widget $entryIndex] [lrange $rec 1 end]
        } msg]
        if {$cr} {
          set errorInfo $::errorInfo
          set errorCode $::errorCode
          $widget delete $entryIndex $entryIndex
          error $msg $errorInfo $errorCode
        }
      }
      set_client_data $widget $document $tag $variable_name
    }

    private method set_client_data {widget document tag variable_name} {
      if {[info exists $variable_name]} {
        set data [set $variable_name]
      } else {
        set data {}
      }
      ::UI::set_widget_client_data $widget data_$document$tag $data
    }
    
    protected method attach_to_enable {widget document tag args} {
    }
  }
  Menu/DocumentLinker Menu/DocumentLinkerObject


  proc get_data_to_text_widget {widget} {
    return [regsub "\n\$" [$widget get 0.0 end] ""]
  }

  proc set_data_to_text_widget {widget newText} {
    set oldText [get_data_to_text_widget $widget]
    if {[string equal $newText $oldText]} {
      return
    }
    set oldSeparator [$widget cget -autoseparators]
    if {$oldSeparator} {
      $widget configure -autoseparators 0
      $widget edit separator
    }
    set old_state [$widget cget -state]
    $widget configure -state normal
    catch { $widget delete 0.0 end }
    if {[string length $newText] > 0} {
      catch { $widget insert end $newText }
    }
    $widget configure -state $old_state
    if {$oldSeparator} {
      $widget edit separator
      $widget configure -autoseparators 1
    }
  }
  
  ::itcl::class Text/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag args} {
      set data_variable_name [$document get_variable_name $tag]
      ::UI::auto_trace_with_init variable $data_variable_name w $widget [::itcl::code $this _data_changed $document $tag]
    }
    private method _data_changed {document tag widget variable_name args} {
      ::UI::set_data_to_text_widget $widget [::Utilities::safeGet $variable_name]
    }
  }
  Text/DocumentLinker Text/DocumentLinkerObject

}
