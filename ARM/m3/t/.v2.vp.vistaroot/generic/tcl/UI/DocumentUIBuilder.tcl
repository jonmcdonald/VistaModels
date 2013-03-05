namespace eval ::UI {
  class DocumentUIBuilder {
    protected variable document
    constructor {_document} {
      set document $_document
    }
    public method get_document {} {
      return $document
    }

    public method get_document_ID {} {
      return [$document get_ID]
    }
    public method set_document {_document} {
      set document $_document
    }

    public method attach {widget tag args} {
      set linker [get_document_linker $widget]
      if {$linker == ""} {
        error "can't attach $widget to document: linker is not found"
      }
      eval {$linker attach_to_document $widget $document $tag} $args
    }

    public method attachToDocument {otherDoc widget tag args} {
      set linker [get_document_linker $widget]
      if {$linker == ""} {
        error "can't attach $widget to document: linker is not found"
      }
      eval {$linker attach_to_document $widget $otherDoc $tag} $args
    }

    public method bind_sequence {widget sequence commandName args} {
      if {![$document is_command_name $commandName]} {
        error "$commandName is not a command name"
      }
      bind $widget $sequence [list $document run_command $commandName]
    }

    public method attach_last_menu_item {menu tag} {
      set type [$menu type end]
      attach_menu_item/$type $menu end $tag
    }

    public method attach_menu_item {menu entryIndex tag args} {
      set type [$menu type $entryIndex]
      eval [list attach_menu_item/$type $menu $entryIndex $tag] $args
    }

    public method attach_menu_item/command {menu entryIndex tag args} {
      if {![$document is_command_name $tag]} {
        error "$tag is not a command name"
      }
      attach_menu_item_to_enable $menu $entryIndex $tag
      $menu entryconfigure $entryIndex -command [concat [list $document run_command $tag] $args]
    }

    public method attach_menu_item/cascade {menu entryIndex tag args} {
      if {![$document is_command_name $tag]} {
        error "$tag is not a command name"
      }
      attach_menu_item_to_enable $menu $entryIndex $tag
      $menu entryconfigure $entryIndex -command [concat [list $document run_command $tag] $args]
    }

    public method attach_menu_item/checkbutton {menu entryIndex tag} {
      attach_menu_item_to_enable $menu $entryIndex $tag
      set variable_name [$document get_variable_name $tag]
      $menu entryconfigure $entryIndex -variable $variable_name -selectcolor yellow
    }

    public method attach_menu_item/radiobutton {menu entryIndex tag} {
      attach_menu_item_to_enable $menu $entryIndex $tag
      set value [$menu entrycget $entryIndex -value]
      set enable_var_name [$document get_sub_enable_variable_name $tag $value]
      attach_menu_item_to_enable_variable $menu $entryIndex $enable_var_name
      set variable_name [$document get_variable_name $tag]
      $menu entryconfigure $entryIndex -variable $variable_name
    }
  
    public method attach_menu_item_to_enable {menu entryIndex tag} {
      set enable_var_name [$document get_enable_variable_name $tag]
      attach_menu_item_to_enable_variable $menu $entryIndex $enable_var_name
    }

    private proc attach_menu_item_to_enable_variable {menu entryIndex enable_var_name} {
      set entryLabel [$menu entrycget $entryIndex -label]
      ::UI::auto_trace variable $enable_var_name w $menu [::itcl::code _on_menu_item_state_changed $entryLabel]
      _on_menu_item_state_changed $entryLabel $menu $enable_var_name "" w
    }

    private proc _on_menu_item_state_changed {entryLabel menu enable_var_name args} {
      set entryIndex [::UI::find_menu_entry_index_by_label $menu $entryLabel]
      if {$entryIndex != ""} {
        ::UI::common_set_menu_entry_state $menu $entryIndex [::Document::get_enable_value $enable_var_name]
      }
    }

    public method insert_menu_item {menu tag index type args} {
      eval {$menu insert $index $type} $args
      set cr [ catch {
        attach_menu_item $menu $index $tag
      } msg]
      if {$cr} {
        set errorInfo $::errorInfo
        set errorCode $::errorCode
        catch {$menu delete $index $index}
        error $msg $errorInfo $errorCode
      }
    }

    public method add_menu_item {menu tag type args} {
      eval [list insert_menu_item $menu $tag end $type] $args
    }

    private method get_document_linker {widget} {
      ::Utilities::objectExists $widget
      if {[::Utilities::objectExists $widget]} {
        set widget_class [string range [$widget info class] 2 end]
        regsub -all {::} $widget_class "/" widget_class
        set linkerObject [get_document_linker2 $widget $widget_class]
        if {$linkerObject != ""} {
          return $linkerObject
        }
      }
      set widget_class [winfo class $widget]
      return [get_document_linker2 $widget $widget_class]
    }
    private method get_document_linker2 {widget widget_class} {
      set linker_class [set widget_class]/DocumentLinker
      set find_result [namespace eval ::UI [list ::itcl::find class $linker_class]]
      if {$find_result == ""} {
        return ""
      }
      return ::UI::[set linker_class]Object
    }
  }
}
