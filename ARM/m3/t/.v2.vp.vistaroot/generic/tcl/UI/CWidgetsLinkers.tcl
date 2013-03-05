namespace eval ::UI {
  ::itcl::class cwidgets/ListSelector/DocumentLinker {
    inherit DynamicDocumentLinker
    
    protected method attach_to_data {widget document tag args} {
      set data_variable_name [$document get_variable_name $tag]
      ::UI::auto_trace variable $data_variable_name w $widget [::itcl::code $this _set_selection $document $tag]
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
      $widget select [lindex $value 0]
    }

    protected method attach_to_source {widget document tag} {
      $widget configure -listvariable $source_variable
    }

    private method bind_selection {widget document tag} {
      set data_variable_name [$document get_variable_name $tag]
      $widget configure -selectcommand [::itcl::code $this _update_data_variable $data_variable_name $widget]
    }

    private method unbind_selection {widget document tag} {
      $widget configure -selectcommand {}
    }

    protected method set_widget_state {widget document tag isEnable} {
      if {$isEnable} {
        bind_selection $widget $document $tag
      } else {
        unbind_selection $widget $document $tag
      }
    }
  }
  cwidgets/ListSelector/DocumentLinker cwidgets/ListSelector/DocumentLinkerObject

  ::itcl::class cwidgets/Combobox/DocumentLinker {
    inherit DynamicDocumentLinker
    
    protected method attach_to_data {widget document tag args} {
      set data_variable_name [$document get_variable_name $tag]
      $widget config -setcommand [::itcl::code $this _update_data_variable $data_variable_name $widget]
      ::UI::auto_trace variable $data_variable_name w $widget [::itcl::code $this _update_widget]
    }

    private method _update_data_variable {data_variable_name widget} {
      set $data_variable_name [$widget get]
    }

    private method _update_widget {widget data_variable_name args} {
      $widget select [set $data_variable_name]
    }

    protected method attach_to_source {widget document tag} {
      set listbox [$widget component list]
      $listbox configure -listvariable $source_variable
    }
    
  }
  cwidgets/Combobox/DocumentLinker cwidgets/Combobox/DocumentLinkerObject

  ::itcl::class cwidgets/Choicemenu/DocumentLinker {
    inherit DynamicDocumentLinker
    
    protected method attach_to_data {widget document tag args} {
    }

    protected method attach_to_source {widget document tag} {
    }
  }
  cwidgets/Choicemenu/DocumentLinker cwidgets/Choicemenu/DocumentLinkerObject
  
  ::itcl::class Compoundbutton/DocumentLinker {
    inherit CommandDocumentLinker
    protected method attach_to_command {widget document commandName args} {
      if {![$document is_command_name $commandName]} {
        error "$commandName is not a command name"
      }
      $widget configure -command [list eval [list $document run_command $commandName] $args]
    }
  }
  Compoundbutton/DocumentLinker Compoundbutton/DocumentLinkerObject
}

