itk::usual SEntry {
    keep -background -borderwidth -foreground -highlightcolor \
	 -highlightthickness -insertbackground -insertborderwidth \
	 -insertofftime -insertontime -insertwidth -labelfont \
	 -selectbackground -selectborderwidth -selectforeground \
	 -textbackground -textfont
}

namespace eval ::UI {
  class SEntry {
    inherit itk::Widget

    public variable type "" ;# may be all of types of string command
    private variable isEditing
    private variable entryVariable ""

    private method setBindings {}
    private method start_editing {}
    private method finish_editing {takeTmpData}
    private method on_Button {w x y}
    private method on_ButtonRelease {w x y}
    private method isValid {}
    constructor {args} {}
    destructor {}
  }
  
  ::itcl::class UI/SEntry/DocumentLinker {
    inherit Entry/DocumentLinker
  }
  UI/SEntry/DocumentLinker UI/SEntry/DocumentLinkerObject


}

body ::UI::SEntry::constructor {args} {
  set isEditing 0
  itk_component add entry {
    Entry $itk_interior.entry -state disabled
  } {
    keep -borderwidth -exportselection \
        -background \
        -foreground -highlightcolor \
        -highlightthickness -insertbackground -insertborderwidth \
        -insertofftime -insertontime -insertwidth -justify \
        -relief -selectbackground -selectborderwidth \
        -selectforeground -show -state -textvariable -width -font \
        -helptext -helptype -helpvar \
        -disabledforeground
  }

  pack $itk_component(entry) -fill x -expand yes
  eval itk_initialize $args
  configure -cursor xterm
  setBindings

}

body ::UI::SEntry::start_editing {} {
  if {$isEditing} {
    return
  }
  set isEditing 1
  set entryVariable [$itk_component(entry) cget -textvariable]
  $itk_component(entry) configure -textvariable "" -state normal
  
}

body ::UI::SEntry::finish_editing {takeTmpData} {
  if {!$isEditing} {
    return
  }
  if {$takeTmpData && [isValid]} {
    set $entryVariable [$itk_component(entry) get]
  }
  $itk_component(entry) configure -textvariable $entryVariable -state disabled
  if {[focus] == $itk_component(entry)} {
    focus $itk_interior
  }
  set isEditing 0
}

body ::UI::SEntry::on_Button {w x y} {
  if {!$isEditing} {
    focus $itk_component(entry)
    start_editing
  }
}

body ::UI::SEntry::on_ButtonRelease {w x y} {
  if {!$isEditing} {
    return
  }
  
  if {($x < 0) || 
      ($x >= [winfo width $w]) ||
      ($y < 0) || 
      ($y >= [winfo height $w])} {
    finish_editing 1
  }

  
}


body ::UI::SEntry::setBindings {} {
  bind $itk_component(entry) <Button> [::itcl::code $this on_Button %W %x %y]
  bind $itk_component(entry) <ButtonRelease> [::itcl::code $this on_ButtonRelease %W %x %y]
  bind $itk_component(entry) <Escape> "[::itcl::code $this finish_editing 0]; break"
  bind $itk_component(entry) <Return> "[::itcl::code $this finish_editing 1]; break"
  bind $itk_component(entry) <FocusIn> [::itcl::code $this start_editing]
  bind $itk_component(entry) <FocusOut> "[::itcl::code $this finish_editing 1]; break"
}

body ::UI::SEntry::isValid {} {
  if {$type == ""}  {
    return 1
  }
  return [string is $type -strict [$itk_component(entry) get]]
}
