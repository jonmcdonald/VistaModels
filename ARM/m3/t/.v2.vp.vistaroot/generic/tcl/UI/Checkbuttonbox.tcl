namespace eval ::UI {
  usual Checkbuttonbox {
    keep -background -borderwidth -relief
  }
  itcl::class Checkbuttonbox {
    inherit itk::Widget
    ::UI::ADD_VARIABLE list List 

    itk_option define -borderwidth borderWidth BorderWidth 2
    itk_option define -relief relief Relief flat
    itk_option define -state state State normal

    constructor {args} {}
    destructor {
      destruct_variable list
    }
    public method getButtonByLabel {label}
    public method tmpMode {}
    public method regularMode {takeTmpData}
  }

  ::itcl::class UI/Checkbuttonbox/DocumentLinker {
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
      set cb [$widget getButtonByLabel $element_label]
      if {$cb != ""} {
        ::UI::common_set_state_using_option $cb [::Document::get_enable_value $enable_var_name]
      }
    }

  }
  UI/Checkbuttonbox/DocumentLinker UI/Checkbuttonbox/DocumentLinkerObject
  

}

itcl::body ::UI::Checkbuttonbox::check_new_value/list {value} {
  llength $value
}

itcl::body ::UI::Checkbuttonbox::clean_gui/list {} {
  if {[llength $list]} {
    if {[winfo exists $top.frame]} {
      destroy $top.frame
    }
  }
}

itcl::body ::UI::Checkbuttonbox::clean_data/list {} {
}

itcl::body ::UI::Checkbuttonbox::setup_data/list {} {
  set frame $itk_interior.frame
  if {[winfo exists $frame]} {
    destroy $frame
  }
  frame $frame -relief $itk_option(-relief) -borderwidth $itk_option(-borderwidth)
  pack $frame -fill both
  set ind  0
  foreach pair $list {
    set tag [lindex $pair 0]
    set label [lindex $pair 1]
    set var_name [full_variable_path [lindex $pair 2]]
    
    set cb [ ::UI::Checkbutton $frame.cb$ind -text $label -variable $var_name -selectcolor yellow \
                 -highlightthickness 0]
    bindtags $cb [list $cb Checkbutton all]
    pack $cb -side top -anchor w
    incr ind
  }
}

itcl::body ::UI::Checkbuttonbox::tmpMode {} {
  set ind  0
  foreach pair $list {
    set var_name [full_variable_path [lindex $pair 2]]
    set tmp_var_name [set var_name]@@@tmp
    if {[info exists $var_name]} {
      set $tmp_var_name [set $var_name]
    }
    $itk_interior.frame.cb$ind configure -variable $tmp_var_name
    incr ind
  }
}

itcl::body ::UI::Checkbuttonbox::regularMode {takeTmpData} {
  set ind  0
  foreach pair $list {
    set var_name [full_variable_path [lindex $pair 2]]
    set tmp_var_name [set var_name]@@@tmp
    if {[info exists $tmp_var_name]} {
      if {$takeTmpData} {
        set $var_name [set $tmp_var_name]
      }
      unset $tmp_var_name
    }
    $itk_interior.frame.cb$ind configure -variable $var_name
    incr ind
  }
}

itcl::body ::UI::Checkbuttonbox::constructor {args} {
  construct_variable list
  eval itk_initialize $args
}

itcl::body ::UI::Checkbuttonbox::getButtonByLabel {label} {
  set frame $itk_interior.frame
  if {[winfo exists $frame]} {
    foreach cb [winfo children $frame] {
      if {[winfo class $cb] == "Checkbutton" && "[$cb cget -text]" == $label} {
        return $cb
      }
    }
  }
  return ""
}

configbody ::UI::Checkbuttonbox::relief {
  if {[winfo exists $itk_interior.frame]} {
    $itk_interior.frame configure -relief  $itk_option(-relief)
  }
}

configbody ::UI::Checkbuttonbox::borderwidth {
  if {[winfo exists $itk_interior.frame]} {
    $itk_interior.frame configure -borderwidth  $itk_option(-borderwidth)
  }
}

configbody ::UI::Checkbuttonbox::state {
  if {[winfo exists $itk_interior.frame]} {

  }
}


