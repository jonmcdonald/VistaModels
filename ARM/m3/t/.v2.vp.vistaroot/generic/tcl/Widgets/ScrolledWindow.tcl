proc ::Widgets::ScrolledWindow {path args} {
  set widget [eval [list ::ScrolledWindow $path ] $args]
  $widget.hscroll configure -width 9
  $widget.vscroll configure -width 9
  return $widget
}
