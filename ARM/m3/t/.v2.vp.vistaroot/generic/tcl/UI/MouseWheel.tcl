namespace eval ::UI {
  proc mousewheel_binding {bindtag} {
    bind $bindtag <MouseWheel> {
      %W yview scroll [expr {- (%D / 120) * 4}] units
    }

    if {[string equal "x11" [tk windowingsystem]]} {
      #      if {!$tk_strictMotif} {
      # Support for mousewheels on Linux/Unix commonly comes through mapping
      # the wheel to the extended buttons.  If you have a mousewheel, find
      # Linux configuration info at:
      #	http://www.inria.fr/koala/colas/mouse-wheel-scroll/
      bind $bindtag <Button-5> [list %W yview scroll 5 units]
      bind $bindtag <Button-4> [list %W yview scroll -5 units]
      bind $bindtag <Shift-Button-5> [list %W yview scroll 1 units]
      bind $bindtag <Shift-Button-4> [list %W yview scroll -1 units]
      bind $bindtag <Control-Button-5> [list %W yview scroll 1 pages]
      bind $bindtag <Control-Button-4> [list %W yview scroll -1 pages]
      #    }
    }
  }
}
