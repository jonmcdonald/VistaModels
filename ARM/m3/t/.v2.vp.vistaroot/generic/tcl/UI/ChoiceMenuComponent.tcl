namespace eval ::UI {
  usual ChoiceMenuComponent {}
  itcl::class ChoiceMenuComponent {
    inherit itk::Widget
    ::UI::ADD_VARIABLE choice Choice
    ::UI::ADD_VARIABLE choiceList ChoiceList
    
    constructor {args} {
      construct_variable choice
      itk_component add choicemenu {
        cwidgets::Choicemenu $itk_interior.choicemenu -outlinethickness 0 \
            -highlightthickness 0
      } {
        keep -state -background -foreground -font 
      }
 
      pack $itk_component(choicemenu) -expand 1 -fill both
      $itk_component(choicemenu) configure -selectcommand [::itcl::code $this on_select]

      eval itk_initialize $args
    }

    destructor {
      destruct_variable choice
    }

    itk_option define -state state State normal {
#      $itk_component(choicemenu) configure -state $itk_option(state)
    }

    private method on_select {} {
      $this configure -choice [$itk_component(choicemenu) get -text]
    }

    public method choices {args} {
      eval [list $itk_component(choicemenu) choices] $args
    }

  }
  ::itcl::class UI/ChoiceMenuComponent/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag listTag args} {
      $widget configure -choiceListvariable [$document get_variable_name $listTag]
      $widget configure -choicevariable [$document get_variable_name $tag]
    }
    protected method attach_to_enable {widget document tag args} {
      chain $widget $document $tag
      set enable_var_name [$document get_enable_variable_name $tag]
      ::UI::auto_trace variable $enable_var_name w $widget [::itcl::code $this _enable_value_state_changed]
    }

    private method _enable_value_state_changed {widget enable_var_name args} {
      ::UI::common_set_state_using_option [$widget component choicemenu] [set $enable_var_name]
    }
  }
  UI/ChoiceMenuComponent/DocumentLinker UI/ChoiceMenuComponent/DocumentLinkerObject
}

itcl::body ::UI::ChoiceMenuComponent::setup_data/choice {} {
  $itk_component(choicemenu) select $choice
}

itcl::body ::UI::ChoiceMenuComponent::setup_data/choiceList {} {
  set widget $itk_component(choicemenu)
  set oldChoice $choice
  $widget choices delete 0 end
  set lst [::Utilities::safeGet $choiceList]
  foreach el $choiceList {
    $widget choices insert end $el $el
  }
  update idle
  foreach el $choiceList {
    $widget component menu entryconfigure $el -underline [::v2::UI::getDefs_underlineIndex $el]
  }
  if {[lsearch -exact $choiceList $oldChoice] != -1} {
    $widget select $oldChoice
  } 
}
