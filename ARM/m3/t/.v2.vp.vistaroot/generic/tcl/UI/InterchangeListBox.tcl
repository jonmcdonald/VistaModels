#tcl-mode

namespace eval ::UI {
  class InterchangeListBox {
    inherit itk::Widget ::UI::DocumentUIBuilder

    public variable lefttitle "" {
      if {[winfo exists $itk_component(left_label)]} {
        $itk_component(left_label) configure -text $lefttitle
      }
    }
    public variable righttitle "" {
      if {[winfo exists $itk_component(right_label)]} {
        $itk_component(right_label) configure -text $righttitle
      }
    }
    public variable comment ""
    

    ::UI::ADD_VARIABLE leftlist Leftlist {}
    ::UI::ADD_VARIABLE rightlist RightList {}
    ::UI::ADD_VARIABLE allitemslist Allitemslist {}
    ::UI::ADD_VARIABLE enableaction EnableAction 1

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      construct_variable leftlist
      construct_variable rightlist
      construct_variable allitemslist
      construct_variable enableaction
      
      CreateBody
      update

      eval itk_initialize $args 
      PackWidgets
      
    }

    destructor {
      destruct_variable leftlist
      destruct_variable rightlist
      destruct_variable allitemslist
      destruct_variable enableaction
    }
    
    private method  CreateBody {} {
      set top $itk_interior
      
      # Labels
      itk_component add left_label {
        label $top.label_left -text $lefttitle
      } {
        keep -foreground -background
        rename -font -headerfont headerfont Headerfont
      }
      itk_component add right_label {
        label $top.label_right -text $righttitle
      } {
        keep -foreground -background
        rename -font -headerfont headerfont Headerfont
      }
      
      # Windows
      cwidgets::Scrollframe $top.sw_left -auto both
      itk_component add left {
        listbox $top.sw_left.list -selectmode multiple -background white
      } {
        keep -font -foreground
        rename -background -listbackground listbackground Listbackground
      }
      $top.sw_left setcomponent  $itk_component(left)

      cwidgets::Scrollframe $top.sw_right -auto both
      itk_component add right {
        listbox $top.sw_right.list -selectmode multiple -background white
      } {
        keep -font -foreground
        rename -background -listbackground listbackground Listbackground
      }
      $top.sw_right setcomponent $itk_component(right)

      # Buttons
      frame $top.butt
      frame $top.butt.in
      button $top.butt.in.push    -image [::UI::getimage push] \
          -command [code $this Move left right]
      button $top.butt.in.pushall -image [::UI::getimage push_all] \
          -command [code $this MoveAll left right]
      button $top.butt.in.popall  -image [::UI::getimage pop_all] \
          -command [code $this MoveAll right left]
      button $top.butt.in.pop     -image [::UI::getimage pop] \
          -command [code $this Move right left]
      pack $top.butt.in.push $top.butt.in.pushall $top.butt.in.popall $top.butt.in.pop \
          -anchor c -pady 5
      pack $top.butt.in -side left -anchor c -fill x -expand 1
    }

    private method ForgetWidgets {} {
      set top $itk_interior
      
      # Labels
      place forget $top.label_left
      place forget $top.label_right
      # Windows
      place forget $top.sw_left
      place forget $top.sw_right
      
      # Buttons
      place forget $top.butt
    }

    private method PackWidgets {} {
      set top $itk_interior
      if {$enableaction} {
        # Labels
        place $top.label_left -x 0  -y 0 
        place $top.label_right  -relx 0.55  -y 0
        
        # Windows
        place $top.sw_left -x 0  -rely 0.12 -relwidth 0.45 -relheight 1 -bordermode outside  
        place $top.sw_right  -relx 0.55  -rely 0.12 -relwidth 0.45 -relheight 1 -bordermode outside 
        
        # Buttons
        place $top.butt -relx 0.45 -y 0 -relwidth 0.10 -relheight 1
        
      } else {
        # Labels
        place $top.label_right  -x 0  -y 0 
        # Windows
        place $top.sw_right  -x 0  -rely 0.12 -relwidth 1 -relheight 1  -bordermode outside 
      }
    }
    
    private method Move {from to} {
      set cursel [$itk_component($from) curselection]
      if {[llength $cursel]} {
        set selectlist {}
        foreach item $cursel {
          set element [$itk_component($from) get $item]
          lappend [GetVariableName $to] $element
          $itk_component($to) insert end $element
          lappend selectlist $element
        }
        foreach element $selectlist {
          set index [lsearch -exact [$itk_component($from) get 0 end] $element]
          set [GetVariableName $from] [lreplace [set [GetVariableName $from]] $index $index]
          $itk_component($from) delete $index
        }
      }
    }

    private method MoveAll {from to} {
      foreach element [$itk_component($from) get 0 end] {
        $itk_component($to) insert end $element
        lappend [GetVariableName $to] $element
      }
      $itk_component($from) delete 0 end
      set [GetVariableName $from] {}
    }

    private method GetVariableName {name_component} {
      if {$name_component == "left"} {
        return [cget -leftlistvariable]
      }
      return [cget -rightlistvariable]
    }
  }

  ::itcl::class UI/InterchangeListBox/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tagLeftlist tagRightlist \
                                         tagAllitemslist tagEnableaction } { 
      $widget configure -leftlistvariable [$document get_variable_name $tagLeftlist]
      $widget configure -rightlistvariable [$document get_variable_name $tagRightlist]
      $widget configure -allitemslistvariable [$document get_variable_name $tagAllitemslist]
      $widget configure -enableactionvariable [$document get_variable_name $tagEnableaction]
    }
  }
  UI/InterchangeListBox/DocumentLinker UI/InterchangeListBox/DocumentLinkerObject
}

body ::UI::InterchangeListBox::clean_gui/allitemslist {} {
  $itk_component(left) delete 0 end
  $itk_component(right) delete 0 end

  set [cget -rightlistvariable] {}
  set [cget -leftlistvariable] {}
}

body ::UI::InterchangeListBox::update_gui/allitemslist {} {
  foreach {item flag} $allitemslist {
    if {!$flag} {
      $itk_component(left) insert end $item
      lappend [cget -leftlistvariable] $item
    } else {
      $itk_component(right) insert end $item
      lappend [cget -rightlistvariable] $item
    }
  } 
}

body ::UI::InterchangeListBox::clean_gui/enableaction {} {
  ForgetWidgets
}

body ::UI::InterchangeListBox::update_gui/enableaction {} {
  if {$enableaction} {
    $itk_component(right_label) configure -text $righttitle
  } else {
    $itk_component(right_label) configure -text "$righttitle   $comment"
  }
  PackWidgets
  
}
