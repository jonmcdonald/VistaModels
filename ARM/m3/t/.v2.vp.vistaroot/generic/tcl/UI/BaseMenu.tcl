#tcl-mode

option add *BaseMenu.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *BaseMenu.background \#e0e0e0 widgetDefault
option add *BaseMenu.foreground black widgetDefault

namespace eval ::UI {
  
  usual BaseMenu {}
  class BaseMenu {
    inherit itk::Widget ::UI::DocumentUIBuilder

    protected variable listMenu 
    protected variable toplevel_widget
    
    itk_option define -font font Font ""
    itk_option define -foreground foreground Foreground black
 
    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      set toplevel_widget [winfo toplevel $itk_interior]
      eval itk_initialize $args
    }
    

    
    public method getMenu {menuName} {
      set menuName [string tolower $menuName]
      if {[info exist listMenu($menuName)]} {
        return [set listMenu($menuName)]
      } else {
        return ""
      }
    }

    public method addSeparator {parentMenu {index "end"}} {
      if {[$parentMenu index "end"] == "none"} {
        return
      }
      set prev_index [$parentMenu index $index]
      if {$index != "end"} {
        incr prev_index -1
      }

      if {$prev_index < 0 || [$parentMenu type $prev_index] == "separator"} {
        return
      }

      $parentMenu insert $index separator -background [cget -background]
    } 
    
    #args - -label, -underline, -accelerator 
    public method addSubMenu {parentMenu submenu args} {
      set existingMenu [getMenu $submenu]
      if {$existingMenu != ""} {
        return $existingMenu
      }
      set submenu [string tolower $submenu]
      eval [list $parentMenu add cascade -menu $parentMenu.$submenu -font [GetFont]  \
                -background [cget -background] \
                -foreground [GetForeground]] $args
          
      menu $parentMenu.$submenu -tearoff 0 
      
      set listMenu($submenu) $parentMenu.$submenu
      return $parentMenu.$submenu
    } 

    public method insert_menu_item {menu tag index type args} {
      eval [list chain $menu $tag $index $type] \
          [list -font [GetFont] -background [cget -background] \
               -foreground [GetForeground]] $args
    }

    # deprecated
    #args -- -label, -variable and other    
    public method addItemMenu {parentMenu type args}  {
      return [ eval [list $parentMenu add $type -font [GetFont] \
                         -foreground [GetForeground] \
                         -background [cget -background]] $args]
    }

    public method insertItemMenu {parentMenu type index args} {
      return [ eval [list $parentMenu insert $index $type -font [GetFont] \
                         -foreground [GetForeground] \
                         -background [cget -background]] $args] 
    }
    
    public method removeAllMenuItems {parentMenu} {
      set names [array names listMenu]
      foreach name $names {
        set submenu  [set listMenu($name)]
        $submenu delete 0 end 
        destroy $submenu
      }
      $parentMenu delete 0 end
      array unset listMenu
    }
    
    protected method GetFont {} { return $itk_option(-font) }
    protected method GetForeground {} { return $itk_option(-foreground) } 

    protected method normalizeItemName {itemName} {
      regsub -all " " $itemName "_" newItemName
      return $newItemName
    }
  }
}
