namespace eval ::UI {
  ::itcl::class DocumentLinker {
    public method attach_to_document {widget document tag args} {
      init $widget $document $tag $args
      eval [list attach_to_document_impl $widget $document $tag] $args
      determine_enable_state $widget $document $tag
      destroy $widget $document $tag $args
    }

    protected method init {document widget tag arguments} {
    }

    protected method destroy {document widget tag arguments} {
    }

    protected method attach_to_document_impl {widget document tag args} {
      eval [list attach_to_enable $widget $document $tag] $args
    }

    ;# may be override
    protected method attach_to_enable {widget document tag args} {
      set enable_var_name [$document get_enable_variable_name $tag]
      ::UI::auto_trace variable $enable_var_name w $widget [::itcl::code $this _enable_state_changed $document $tag]
    }

    protected method determine_enable_state {widget document tag} {
      set enable_var_name [$document get_enable_variable_name $tag]
      if {[info exists $enable_var_name]} {
        #set $enable_var_name [set $enable_var_name]
        set_widget_state $widget $document $tag [set $enable_var_name]
      } else {
        set_widget_state $widget $document $tag 1
      }
    }

    private method _enable_state_changed {document tag widget enable_var_name args} {
      set_widget_state $widget $document $tag [set $enable_var_name]
    }
    
    protected method set_widget_state {widget document tag isEnable} {
      if {[catch {::UI::common_set_state_using_option $widget $isEnable}]} {
        #catch {::UI::common_set_state_using_bindtags $widget $isEnable}
      }
    }
  }

  ;# tag is treated as a name of the command
  ::itcl::class CommandDocumentLinker {
    inherit DocumentLinker
    protected method attach_to_document_impl {widget document tag args} {
      eval [list chain $widget $document $tag] $args
      eval [list attach_to_command $widget $document $tag] $args
    }
    protected method attach_to_command {widget document commandName args}
  }

  ::itcl::class DataDocumentLinker {
    inherit DocumentLinker
    protected method attach_to_document_impl {widget document tag args} {
      eval [list attach_to_enable $widget $document $tag] $args
      eval [list attach_to_data $widget $document $tag] $args
    }
    protected method attach_to_data {widget document tag args}
  }

  ::itcl::class DynamicDocumentLinker {
    inherit DataDocumentLinker
    protected variable source_variable {}

    protected method init {document widget tag arguments} {
      set source_variable [lindex $arguments 0]
      if {$source_variable == ""} {
        error "Source variable is not specified"
      }
    }
    protected method destroy {document widget tag arguments} {
      if {[info exists source_variable]} {
        unset source_variable
      }
    }

    protected method attach_to_document_impl {widget document tag args} {
      attach_to_source $widget $document $tag 
      eval [list chain $widget $document $tag] $args
    }
    protected method attach_to_source {widget document tag}
  }

}
