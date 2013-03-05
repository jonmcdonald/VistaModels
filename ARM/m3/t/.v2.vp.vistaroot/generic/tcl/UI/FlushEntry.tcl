itk::usual FlushEntry {
    keep -background -borderwidth -foreground -highlightcolor \
	 -highlightthickness -insertbackground -insertborderwidth \
	 -insertofftime -insertontime -insertwidth -labelfont \
	 -selectbackground -selectborderwidth -selectforeground \
	 -textbackground -textfont
}

namespace eval ::UI {
  class FlushEntry {
    inherit itk::Widget ::Utilities::Grabable

    private variable isEditing

    private method setBindings {}
    private method start_editing {}
    private method finish_editing {takeTmpData}
    private method on_Button {w x y}
    private method on_ButtonRelease {w x y}
    constructor {args} {}
    destructor {}
  }
  
  ::itcl::class UI/FlushEntry/DocumentLinker {
    inherit Entry/DocumentLinker
  }
  UI/FlushEntry/DocumentLinker UI/FlushEntry/DocumentLinkerObject


}

body ::UI::FlushEntry::constructor {args} {
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

body ::UI::FlushEntry::start_editing {} {
  if {$isEditing} {
    return
  }
  set isEditing 1
  grabGlobally $itk_component(entry)
  set var_name [$itk_component(entry) cget -textvariable]
  set tmp_var_name [set var_name]@@@tmp
  if {[info exists $var_name]} {
    set $tmp_var_name [set $var_name]
  }
  $itk_component(entry) configure -textvariable $tmp_var_name
  $itk_component(entry) configure -state normal
  catch {focus $itk_component(entry)}
}

body ::UI::FlushEntry::finish_editing {takeTmpData} {
  if {!$isEditing} {
    return
  }
  ungrab
  set tmp_var_name [$itk_component(entry) cget -textvariable]
  set length [string length $tmp_var_name]
  set var_name [string range $tmp_var_name 0 [expr {$length - [string length "@@@tmp"] -1 }]]
  if {[info exists $tmp_var_name]} {
    if {$takeTmpData} {
      if {![info exists $var_name] || [string compare [set $var_name] [set $tmp_var_name]]} {
        if {[catch {
          set $var_name [set $tmp_var_name]
        } msg]} {
          set bg [$itk_component(entry) cget -background]
          $itk_component(entry) config -background red
          update
          catch {bell; bell; bell}
          after 1 [list catch [list set $var_name [set $var_name]]]
          after 500 [list catch [list $itk_component(entry) config -background $bg]]
        }
      }
    }
    unset $tmp_var_name
  }
  $itk_component(entry) configure -textvariable $var_name
  set isEditing 0
  $itk_component(entry) configure -state disabled
  catch {focus [winfo toplevel $itk_component(entry)]}
}

body ::UI::FlushEntry::on_Button {w x y} {
  if {!$isEditing} {
    start_editing
  }
}

body ::UI::FlushEntry::on_ButtonRelease {w x y} {
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


body ::UI::FlushEntry::setBindings {} {
#  bind $itk_component(entry) <FocusIn> [::itcl::code $this start_editing]
  bind $itk_component(entry) <Button> [::itcl::code $this on_Button %W %x %y]
  bind $itk_component(entry) <ButtonRelease> [::itcl::code $this on_ButtonRelease %W %x %y]
  bind $itk_component(entry) <Escape> "[::itcl::code $this finish_editing 0]; break"
  bind $itk_component(entry) <Return> "[::itcl::code $this finish_editing 1]; break"
}
