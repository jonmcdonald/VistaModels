namespace eval ::v2::ui::projects {
  class ProjectsTree {
    inherit ::UI::TreeTable

    private variable x_press 0
    private variable y_press 0

    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args
      
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior CurrentSelection 

      $document run_command OpenNodeCommand NodeArgument 0

      set enable_drag_drop 1
      if {[info exists ::env(VISTA_DISABLE_DRAG_DROP)] && $::env(VISTA_DISABLE_DRAG_DROP) == 1} {
        set enable_drag_drop 0
      }
      if {$enable_drag_drop} {
        configure_drag_drop
      }
    }

    protected method configure_drag_drop {} {
      namespace import -force ::blt::*
      
      bind $itk_component(table) <B1-Motion> "+[list blt::drag&drop drag %W %X %Y]"
      bind $itk_component(table) <ButtonRelease-1> "+[list blt::drag&drop drop %W %X %Y]"

      bind $itk_component(table) <ButtonPress-1> "+[itcl::code $this button_pressed %x %y]"

      blt::drag&drop source $itk_component(table) -packagecmd [itcl::code $this start_drag_action %t %W] \
          -tokenborderwidth 0 \
          -button 0 ;# needed to allow using the above bindings (without <ButtonPress-1>)
      blt::drag&drop source $itk_component(table) handler txt
      #blt::drag&drop target $itk_component(table) handler txt [itcl::code $this drop_in_tree %v %W] ;# works if -selftarget 1
      
      set token [blt::drag&drop token $itk_component(table)]

      itk_component add token_label {
        label $token.label -text "" -justify left ;#-relief solid -borderwidth 1
      } {}
      pack $itk_component(token_label)

      bind $itk_component(token_label) <Unmap> [itcl::code $this unmap_token %W]
    }

    # in BD this method triggers drop
    private method unmap_token {widget} {
      set xy [blt::drag&drop location]
      
      set screen_height [winfo screenheight .]
      set x1 [lindex $xy 0]
      set tcl_y [lindex $xy 1]
      set y1 [expr $screen_height - $tcl_y] ;#convert tcl-coord top to motif-coord bottom
      
      set ret [$document get_variable_value ObjectForDrag]
      lappend ret $x1
      lappend ret $y1
      lappend ret $tcl_y ;# needed for x window coord

      $document run_command DropCommand DragDropDataArg $ret
    }

    protected method button_pressed {x y} {
      set x_press $x
      set y_press $y
    }

    protected method is_in_drag_tolerance {x y} {
      set delta_x [MATH_ABS [MATH_MINUS $x $x_press]]
      set delta_y [MATH_ABS [MATH_MINUS $y $y_press]]
      if {[MATH_GT $delta_x 3] || [MATH_GT $delta_y 3]} {
        return 1
      } else {
        return 0
      }
    }

    protected method start_drag_action {token widget} {

      $document set_variable_value ObjectForDrag ""

      set xy [blt::drag&drop location]
      set y [expr [lindex $xy 1] - [winfo rooty $widget]]
      set x [expr [lindex $xy 0] - [winfo rootx $widget]]
      
      set idx [$widget nearest $x $y]

      if {$idx == "" || $idx < 1} {
        return ""
      }

      if {[is_in_drag_tolerance $x $y] == 0} {
        return ""
      }
      
      set currentIdxs [$itk_component(table) curselection]
      if {[llength $currentIdxs] >1} {
        return ""
      }
      
      if {$idx == $currentIdxs} {
        $document run_command DragCommand ;# checks if the item fits dragging
      }
      
      set obj_label [$document get_variable_value ObjectForDrag]
      
      $itk_component(token_label) configure -text $obj_label
      return $obj_label
    }

    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::projects::PopupMenu $itk_interior.popup_menu $document
      }
    }
    protected method update_gui/selectedNodeIDs {}
  }
}

body ::v2::ui::projects::ProjectsTree::update_gui/selectedNodeIDs {} {
  chain
  
  set_variable_by_tabletag "Type" CurrentType
  set_variable_by_tabletag "File" CurrentFile
  set_variable_by_tabletag "Line" CurrentLine
  set_variable_by_tabletag "Kind" CurrentKind
}

namespace eval ::UI {
  ::itcl::class v2/ui/projects/ProjectsTree/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/projects/ProjectsTree/DocumentLinker v2/ui/projects/ProjectsTree/DocumentLinkerObject
}
