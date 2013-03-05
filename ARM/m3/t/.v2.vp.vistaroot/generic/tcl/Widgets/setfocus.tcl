namespace eval ::Widgets {
  proc set_focus_by_mouse_press {w} {
    bind $w <Button-1> "+focus %W"
    bind $w <Double-Button-1> "+focus %W"
    bind $w <Button-2> "+focus %W"
  }
}
