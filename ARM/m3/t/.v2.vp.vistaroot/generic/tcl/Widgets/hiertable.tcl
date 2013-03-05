
namespace eval ::Widgets {
  proc disable_hiertable_autoscroll {} {
    bind Hiertable <B1-Leave> ""
    #bind TreeView <B1-Leave> ""
  }

  proc fix_hiertable_keybindings {} {
    set oldScript [bind TreeView <Key-space>]
    bind TreeView <Control-Key-space> $oldScript
    set newScript "%W selection clearall\n$oldScript"
    bind TreeView <Key-space> $newScript
  
    set oldScript [bind Hiertable <Key-space>]
    bind Hiertable <Control-Key-space> $oldScript
    set newScript "%W selection clearall\n$oldScript"
    bind Hiertable <Key-space> $newScript

    bind TreeView <F1> {}

    # do not need this function anymore
    proc fix_hiertable_keybindings {} {}
  }

  proc fix_hiertable_binding_bug { widget } {

    $widget bind Entry <ButtonPress-1> {
      catch {
        set blt::tv::x %x
        set blt::tv::y %y
        set index [%W nearest %x %y]
        blt::tv::SetSelectionAnchor %W $index
        set blt::tv::scroll 1
        focus %W
      }
    }

    $widget bind Entry <ButtonRelease-1> { 
      catch {
        after cancel $blt::tv::afterId
        set blt::tv::scroll 0
      }
    }
    
    $widget bind Entry <Shift-ButtonPress-1> { 
      catch {
        set blt::tv::x %x
        set blt::tv::y %y
        set cur_index [%W nearest %x %y]
        
        if { [%W cget -selectmode] == "multiple" && [%W selection present] } {
          if { [%W index anchor] == "" } {
            %W selection anchor $cur_index
          }
          
          set index [%W index anchor]
          %W selection clearall
          %W selection set $index $cur_index
        } else {
          blt::tv::SetSelectionAnchor %W $cur_index
        }
        focus %W
      }
    }

    $widget bind Entry <Control-ButtonPress-1> { 
      catch {
        set blt::tv::x %x
        set blt::tv::y %y
        set index [%W nearest %x %y]
        
        if { [%W cget -selectmode] == "multiple" } {
          %W selection toggle $index
          %W selection anchor $index
        } else {
          blt::tv::SetSelectionAnchor %W $index
        }
        focus %W
      }
    }

    $widget bind Entry <B1-Motion> ""
    
    bind TreeView <B1-Leave> {
      catch {
        if { $blt::tv::scroll } {
          ::Widgets::AutoScroll %W
        }
      }
    }

    $widget button bind all <ButtonRelease-1> {
      set cur_id [%W index current]
      %W toggle current
      ::Widgets::see_brach %W [%W index $cur_id]
    }
  }
  
  proc AutoScroll { w } {
    catch {
      if { ![winfo exists $w] } {
        return
      }
      
      set y [winfo pointery .]
      set widget_y [winfo rooty $w]
      set height [winfo height $w]
      set bottom_y [expr $widget_y + $height]
      
      if {$y > $bottom_y} {
        $w yview scroll 1 units
      } elseif {$y < $widget_y} {
        $w yview scroll -1 units
      }
      set ::blt::tv::afterId [after 50 ::Widgets::AutoScroll $w ]
    } 
  }

  proc see_brach {widget entry_index} {
    if {$entry_index < 1} {
      return
    }

    # if entry is closed
    if {[$widget entry isopen $entry_index] == 0} {
      return
    }

    # find last child
    set last_child [::Widgets::get_last_child $widget $entry_index]
    
    # is last child is identical with entry index
    if {$last_child == "" || $last_child == $entry_index} {
      return
    }

    #calculate viewable height
    scan [winfo geometry $widget] "%*d\x%d+%*d+%*d" viewable_height
    update
    scan [$widget yview] "%s %s" rel_y_top rel_y_bottom

    # calculate real widget height
    set widget_height [expr round($viewable_height / ($rel_y_bottom - $rel_y_top))]
    
    #calculate viewable area
    set bottom_viewable_y [expr round($rel_y_bottom * $widget_height)]
    set top_viewable_y [expr round($rel_y_top * $widget_height)]

    #if last child is viewable
    scan [$widget bbox $last_child] "%*d %d %*d %d" y_last_child height_entry
    if {![info exists y_last_child]} {
      return
    }
    set bottom_y_last_child [expr $y_last_child + $height_entry]

    if {$bottom_y_last_child < $bottom_viewable_y} {
      return
    }
     
    # calculate branch height
    scan [$widget bbox $entry_index] "%*d %d %*d %*d" y_entry_index
    set branch_height [expr  $y_last_child - $y_entry_index + $height_entry]

    if {$branch_height < $viewable_height} {
      $widget see $last_child
    } else { 
      $widget yview moveto [expr $y_entry_index * 1.0 / $widget_height]
    }
  }

  proc get_last_child {widget index} {
    set children_list [$widget entry children $index]
    set last_child ""
    while {1} {
      set last_child [lindex $children_list end]
      if {$last_child == "" || ![$widget entry ishidden $last_child]} {
        break
      }
      set children_list [lrange $children_list 0 end-1]
    }
    if {$last_child != ""} {
      return [get_last_child $widget $last_child]
    }
    return $index
  }
}
