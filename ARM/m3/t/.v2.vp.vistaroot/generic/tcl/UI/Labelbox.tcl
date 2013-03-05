namespace eval ::UI {
  usual Labelbox  {
    keep -background -borderwidth -relief 
  }

  itcl::class Labelbox {
    inherit itk::Widget
    ::UI::ADD_VARIABLE list List 

    itk_option define -borderwidth borderWidth BorderWidth 2
    itk_option define -relief relief Relief flat
    itk_option define -state state State normal


    constructor {args} {}
    destructor {
      destruct_variable list
    }
    public method getLabelByText {text}
    private method _element_chosen {ind widget var_name args}

  }

  ::itcl::class UI/Labelbox/DocumentLinker {
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
          set element_label [lindex $rec 0]
          set element_tag [lindex $rec 3]
          set enable_var_name [$document get_enable_variable_name $element_tag]
          ::UI::auto_trace variable $enable_var_name w $widget \
              [::itcl::code $this _element_enable_state_changed $document $element_label]
          _element_enable_state_changed $document $element_label $widget $enable_var_name "" w
        }
      }
    }

    private method _element_enable_state_changed {document element_label widget enable_var_name args} {
      set cb [$widget getLabelByText $element_label]
      if {$cb != ""} {
        ::UI::common_set_state_using_option $cb [::Document::get_enable_value $enable_var_name]
      }
    }

  }
  UI/Labelbox/DocumentLinker UI/Labelbox/DocumentLinkerObject

}

itcl::body ::UI::Labelbox::check_new_value/list {value} {
  llength $value
}

itcl::body ::UI::Labelbox::clean_gui/list {} {
  if {[llength $list]} {
    if {[winfo exists $itk_interior.frame]} {
      destroy $itk_interior.frame
    }
  }
}

itcl::body ::UI::Labelbox::clean_data/list {} {
  set ind 0
  foreach pair $list {
    set var_name [full_variable_path [lindex $pair 2]]
    ::UI::auto_trace vdelete $var_name w $itk_interior \
        [::itcl::code $this _element_chosen $ind]
    incr ind
  }
}

itcl::body ::UI::Labelbox::setup_data/list {} {
  set frame $itk_interior.frame
  if {[winfo exists $frame]} {
    destroy $frame
  }
  frame $frame -relief $itk_option(-relief) -borderwidth $itk_option(-borderwidth)
  pack $frame -fill both
  set ind  0
  foreach pair $list {
    set label [lindex $pair 0]
    set var_name [full_variable_path [lindex $pair 2]]
    
    set cb [ label $frame.cb$ind -text $label]
    ::UI::auto_trace variable $var_name w $itk_interior \
        [::itcl::code $this _element_chosen $ind]

     _element_chosen $ind $itk_interior $var_name w $itk_interior $var_name "" w
    bindtags $cb $itk_interior
    pack $cb -side left
    incr ind
  }
  
}

itcl::body ::UI::Labelbox::_element_chosen {ind widget var_name args} {
  set cb $itk_interior.frame.cb$ind
  if {[winfo exists $cb]} {
    set rec [lindex $list $ind]
    set var_name [lindex $rec 2]
    set value [::Utilities::safeGet $var_name]
    if {$value == 0 || $value == ""} {
      $cb config -foreground Grey
    } else {
      $cb config -foreground Black
    }
  }
}


itcl::body ::UI::Labelbox::constructor {args} {
  construct_variable list
  eval itk_initialize $args
}

itcl::body ::UI::Labelbox::getLabelByText {text} {
  set frame $itk_interior.frame
  if {[winfo exists $frame]} {
    foreach cb [winfo children $frame] {
      if {[winfo class $cb] == "Label" && "[$cb cget -text]" == $text} {
        return $cb
      }
    }
  }
  return ""
}


configbody ::UI::Labelbox::relief {
  if {[winfo exists $itk_interior.frame]} {
    $itk_interior.frame configure -relief  $itk_option(-relief)
  }
}

configbody ::UI::Labelbox::borderwidth {
  if {[winfo exists $itk_interior.frame]} {
    $itk_interior.frame configure -borderwidth  $itk_option(-borderwidth)
  }
}

configbody ::UI::Labelbox::state {
  if {[winfo exists $itk_interior.frame]} {

  }
}


