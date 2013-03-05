
usual PopupMenu {}

namespace eval ::UI {
  class PopupMenu {
    inherit  ::UI::BaseMenu
    
    constructor {_document args} {
      chain $_document
    } {
      itk_component add menu {
        menu $itk_interior.menu 
      } {
        keep -background -font -foreground
      }
      $itk_interior.menu configure -tearoff 0
      fill_menu
      eval itk_initialize $args

    }
    
    public method raise {x y} {
      if { [$itk_interior.menu index end] != "none" } {
        tk_popup $itk_interior.menu $x $y
      }
    }
    public method update_menu {} {}
    protected method fill_menu {} {}
    
  }
}
