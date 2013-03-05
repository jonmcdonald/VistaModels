namespace eval ::UI {
  usual CheckMenu {}
  itcl::class CheckMenu {
    inherit itk::Widget
    ::UI::ADD_VARIABLE list List 

    constructor {args} {}
    destructor {
      destruct_variable list
    }

    private method update_indicator {ind value} {
      set c $itk_component(choicemenu)
      set border [$c component border]
      if {$value == 0 || $value == ""} {
        $border.lb$ind con -foreground Grey
      } else {
        $border.lb$ind con -foreground Black
      }
    }
    
    ;# invoked, when some part of data is changed
    private method on_choice {ind var_name args} {
      update_indicator $ind [set $var_name]
    }

  }

  ::itcl::class UI/CheckMenu/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document tag args} {
      set source_variable [$document get_variable_name $tag]
      $widget configure -listvariable $source_variable
    }

    protected method attach_to_document_impl {widget document tag args} {
      chain $widget $document $tag
      attach_subelements_to_enable $widget $document $tag
    }

    private method attach_subelements_to_enable {widget document tag} {
      set source_variable [$document get_variable_name $tag]
      if {[info exists $source_variable]} {
        foreach rec [set $source_variable] {
          set element_label [lindex $rec 1]
          set element_tag [lindex $rec 3]
          set enable_var_name [$document get_enable_variable_name $element_tag]
          ::UI::auto_trace variable $enable_var_name w $widget \
              [::itcl::code $this _element_enable_state_changed $document $element_label]
          _element_enable_state_changed $document $element_label $widget $enable_var_name "" w
        }
      }
    }

    private method _element_enable_state_changed {document element_label widget enable_var_name args} {
      set choicemenu [$widget component choicemenu]
      set menu [$choicemenu component menu]
      ::UI::common_set_menu_entry_state $menu $element_label [::Document::get_enable_value $enable_var_name]
    }

  }
  UI/CheckMenu/DocumentLinker UI/CheckMenu/DocumentLinkerObject
  

}

itcl::body ::UI::CheckMenu::check_new_value/list {value} {
  llength $value
}

itcl::body ::UI::CheckMenu::clean_gui/list {} {
  if {[llength $list]} {
    set c $itk_component(choicemenu)
    set border [$c component border]
    set ind 0
    foreach pair $list {
      destroy $border.lb$ind
      incr ind
    }
    set menu [$c component menu]
    $menu delete 0 end
  }
}

itcl::body ::UI::CheckMenu::clean_data/list {} {
  set ind 0
  foreach pair $list {
    set var_name [full_variable_path [lindex $pair 2]]
    trace vdelete $var_name w [::itcl::code $this on_choice $ind $var_name]
    incr ind
  }
}

itcl::body ::UI::CheckMenu::setup_data/list {} {
  set c $itk_component(choicemenu)
  set menu [$c component menu]
  set border [$c component border]
  set choice [$c component choice]
  set arrow [$c component arrow]
  pack forget $choice
  pack forget $arrow
  set ind  0
  foreach pair $list {
    set tag [lindex $pair 0]
    set label [lindex $pair 1]
    set var_name [full_variable_path [lindex $pair 2]]
    $menu insert end checkbutton -label $label -variable $var_name -selectcolor yellow
    set value [set $var_name]
    trace variable $var_name w [code $this on_choice $ind $var_name]
    pack [label $border.lb$ind -text $tag] -side left -anchor w
    update_indicator $ind $value
    incr ind
  }
  pack $arrow -side left -anchor w
}

itcl::body ::UI::CheckMenu::constructor {args} {
  construct_variable list
  itk_component add choicemenu {
    cwidgets::Choicemenu $itk_interior.cm -size dynamic
  } {
    usual
    keep -state
  }
  eval itk_initialize $args
  
  set c $itk_component(choicemenu)
  pack $c
}
