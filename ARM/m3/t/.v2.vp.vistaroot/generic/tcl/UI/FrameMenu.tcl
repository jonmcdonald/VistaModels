#tcl-mode

option add *FrameMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *FrameMenu.background \#e0e0e0 widgetDefault
option add *FrameMenu.foreground black widgetDefault

namespace eval ::UI {
  
  usual FrameMenu {}
  class FrameMenu {
    inherit ::UI::BaseMenu
    
    constructor {_document args} {
      chain $_document
    } {
      
      itk_component add frame {
        frame $itk_interior.f -relief raised -borderwidth 1
      } {
        keep -height -background
      }
      eval itk_initialize $args
    }

    public method show {} {
      pack $itk_component(frame) -fill x -expand 1 -anchor nw
    }
    
    public method createHeaderMenu {item {packRight 0} {underline_index 0} } {
      if {[getMenu $item] != ""} {
        return
      }

      set itemName [string tolower [normalizeItemName $item]]
      set frame $itk_component(frame)
      set mb $frame.$itemName
      itk_component add menu_$itemName {
        menubutton $mb -text $item -underline $underline_index -bd 1 -menu $mb.menu 
      } {
        keep -background -font -foreground 
        rename -highlightbackground -background background Background 
      }
      menu $mb.menu -tearoff 0

      set listMenu($itemName) $mb.menu
      
      if {$packRight == 0} {
        pack $mb -side left -padx 2 -fill y
      } else {
        pack $mb -side right -padx 2 -fill y
      } 
      return $mb.menu
    }

    public method revertVariableValue {varName} {
      upvar $varName variableName
      set $varName [expr ! $variableName]
    }

    protected method fill_menu {} {}

    protected method add_binding {tag sequences script} {
      foreach sequence $sequences {
        bind $tag $sequence $script
      }
    }
  } ;# FrameMenu
} ;# namespace
