# PaneContainer
# ----------------------------------------------------------------------
# Implements a multiple pane container widget capable of orienting the panes
# either vertically or horizontally.  Each pane is itself a frame acting
# as a child site for other widgets.  The border separating each pane 
# contains a sash which allows user positioning of the panes relative to
# one another.  
#
# ----------------------------------------------------------------------
# ======================================================================

#
# Usual options.
#

itk::usual PaneContainer {
  keep -background -cursor
}

#
# Use option database to override default resources of base classes.
#
option add *PaneContainer.width 10 widgetDefault
option add *PaneContainer.height 10 widgetDefault


# ------------------------------------------------------------------
#                            PANE CONTAINER
# ------------------------------------------------------------------
namespace eval ::UI {
  class PaneContainer {
    inherit ::UI::Pane

# ------------------------------------------------------------------
#                        CONSTRUCTOR
# ------------------------------------------------------------------
    
    constructor {_document args} {
      ::UI::Pane::constructor $_document
    } {
      pack propagate $itk_component(hull) no
      
      _set_binding
      
      eval itk_initialize $args
    }
    
    destructor {}
    
    itk_option define -orient orient Orient horizontal ; # read only
    itk_option define -sashborderwidth sashBorderWidth SashBorderWidth 1 
    itk_option define -sashthickness sashThickness SashThickness 6 ; # read only
    itk_option define -withsashbitmap withsashBitmap WithSashBitmap 0 ; #read only
    
    public method index {index} 
    public method childsite {args} 
    public method add {type tag args} ; #type - pane or container
    public method insert {type tag index args} 
    public method delete {index} 
    public method hide {tag}    
    public method show {tag} 
    public method placeof {packed_tag unpacked_tag}
    public method paneconfigure {index args} 
    public method wasMinimaised {tag}
    public method minimazePane {tag}
    public method restorePane {tag}
    public method selectPane {tag} 
    public method unselectPane {tag} 

    protected method _pwConfigureEventHandler {width height} 
    protected method _startGrip {where num} 
    protected method _endGrip {where num} 
    protected method _configGrip {where num} 
    protected method _handleGrip {where tag} 
    
    private method _add_component {tag widget_class args} 
    private method _makeSash {tag num} 
    private method _placeTempSash {tag} 
    private method _moveTempSash {tag}
    private method _placeComponents {}
    private method _changeSizeOfLastPane {}
    private method _getStartPosition {tag}
    private method _getRealThickness {tag}
    private method _shiftPanes {starttag delta}
    private method _set_regular_sash {tag}
    private method _get_tag_by_index { index }
    private method _get_index_by_pane_widget_name {pane_widget_name}
    private method _get_last_pane {}
    private method _set_binding {}
    private method _get_activePanes {}
    
    private variable _initialized -1    ;# Denotes initialized state.
    private variable _panes {}         ;# List of panes.
    private variable _activePanes {}   ;# List of active panes.
    private variable _lowerlimit       ;# Margin distance above/left of sash.
    private variable _upperlimit       ;# Margin distance below/right of sash.
    private variable _dimension      0 ;# Width/Height at start of drag.
    private variable _sashloc          ;# Array of dist of sash from above/left.
    private variable _dragging 0       ;# Boolean for dragging enabled.
    private variable _movecount 0      ;# Kludge counter to get sashes to
    ;# display without calling update 
    ;# idletasks too often.
    private variable _width 0          ;# hull's width.
    private variable _height 0         ;# hull's height.
    private variable _unique -1        ;# Unique number for pane names.
    private variable _prevPaneSize     ;# Array of previous size of panes
    private variable _prevSashSize     ;# Array of previous size of sashes
    private variable _wasMinimaised    "";# List of minimazed panes
  }
}

# ------------------------------------------------------------------
#                             OPTIONS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# OPTION: -orient
#
# Specifies the orientation of the sashes.  Once the pane container
# has been mapped, set the sash bindings and place the panes.
# ------------------------------------------------------------------
configbody ::UI::PaneContainer::orient {
  switch $itk_option(-orient) {
    vertical {
      set _dimension $_width
    }
    
    horizontal {
      set _dimension $_height
    }
	    
    default {
      error "bad orientation option \"$itk_option(-orient)\":\
 			should be horizontal or vertical"
    }
  }
}

# ------------------------------------------------------------------
# OPTION: -sashborderwidth
#
# Specifies a non-negative value indicating the width of the 3-D
# border to draw around the outside of the sash.
# ------------------------------------------------------------------
configbody ::UI::PaneContainer::sashborderwidth {
  set pixels [winfo pixels $itk_component(hull) \
                  $itk_option(-sashborderwidth)]
  set itk_option(-sashborderwidth) $pixels
  
  for {set i 1} {$i < [llength $_activePanes]} {incr i} {
    $itk_component(sash$i) configure \
        -borderwidth $itk_option(-sashborderwidth)
  }
}

# ------------------------------------------------------------------
# OPTION: -withsashbitmap
#
# Specifies a non-negative value indicating the width of the 3-D
# border to draw around the outside of the sash.
# ------------------------------------------------------------------
configbody ::UI::PaneContainer::withsashbitmap {
  if {$itk_option(-withsashbitmap) == 1 &&
      ([::UI::getimage hide_pane 0] == "" || [::UI::getimage show_pane 0] == "" ||
       [::UI::getimage hide_pane_hor 0] == "" || [::UI::getimage show_pane_hor 0] == "")} {
    set itk_option(-withsashbitmap) 0
  }
}

# ------------------------------------------------------------------
#                            METHODS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# METHOD: index index
#
# Searches the panes in the pane container for the one with the 
# requested tag, numerical index, or keyword "end".  Returns the pane's 
# numerical index if found, otherwise error.
# ------------------------------------------------------------------    
body ::UI::PaneContainer::index {index} {
  if {$index == "end"} {
    return $index
  }
  
  if {[llength $_panes] > 0} {
    if {[regexp {(^[0-9]+$)} $index]} {
	    if {$index < [llength $_panes]} {
        return $index
	    } else {
        error "PaneContainer index \"$index\" is out of range"
	    }
    } else {
	    if {[set idx [lsearch $_panes $index]] != -1} {
        return $idx
	    }
	    
	    error "bad PaneContainer index \"$index\": must be number, end,\
		    or pattern"
    }
    
  } else {
    error "PaneContainer \"$itk_component(hull)\" has no panes"
  }
}

# ------------------------------------------------------------------
# METHOD: childsite ?index?
#
# Given an index return the specifc childsite path name.  Invoked 
# without an index return a list of all the child site panes.  The 
# list is ordered from the near side (left/top).
# ------------------------------------------------------------------
body ::UI::PaneContainer::childsite {index} {
  if {[llength $index] == 0} {
    set children {}
	
    foreach pane $_panes {
	    lappend children [$itk_component($pane) childsite]
    }
    
    return $children
    
  } else {
    set index [index $index]
    return [$itk_component([lindex $_panes $index]) childsite]
  }
}

# ------------------------------------------------------------------
# METHOD: add type tag ?option value option value ...?
#
# Add a new pane to the pane container to the far (right/bottom) side.
# The method takes additional options which are passed on to the 
# pane constructor.  These include -margin, and -minimum.  The path 
# of the pane is returned.
# ------------------------------------------------------------------

body ::UI::PaneContainer::add {type tag args} {
  return [eval [list insert $type $tag end] $args]
}

# ------------------------------------------------------------------
# METHOD: insert type index tag ?option value option value ...?
#
# Insert the specified pane in the pane container just before the one 
# given by index.  Any additional options which are passed on to the 
# pane constructor.  These include -margin, -minimum.  The path of 
# the pane is returned.
# ------------------------------------------------------------------
body ::UI::PaneContainer::insert {type tag index args} {
  return [eval [list _add_component $type $tag $index] $args]
}

# ------------------------------------------------------------------
# METHOD: delete index
#
# Delete the specified pane.
# ------------------------------------------------------------------
body ::UI::PaneContainer::delete {index} {
  set index [index $index]
  set tag [lindex $_panes $index]
  hide $tag
  
  catch {
    destroy $itk_component($tag)
    destroy $itk_component(sash_$tag)
  }
  
  set _panes [lreplace $_panes $index $index]
}

# ------------------------------------------------------------------
# METHOD: hide tag
#
# Remove the specified pane from the pane container. 
# ------------------------------------------------------------------
body ::UI::PaneContainer::hide {tag} {

  set idx [lsearch -exact $_activePanes $tag]
  if {$idx == -1} {
    set tag [_get_tag_by_index $tag]
    if {$tag == ""} {
      return
    }
    set idx [lsearch -exact $_activePanes $tag] 
  }
  
  set delta 0
  set real_thickness [_getRealThickness $tag]
  
  if {[llength $_activePanes] != 1} {
    if {$real_thickness > 0} {
      set _prevPaneSize($tag) $real_thickness
      set delta [expr $delta + $_prevPaneSize($tag)]
    }
  } 
  
  place forget $itk_component($tag) 
  set is_last_pane 0
  if {[_get_last_pane] == $tag} {
    set is_last_pane 1
  }

  set _activePanes [lreplace $_activePanes $idx $idx]
  
  # case - last viewable pane in container
  if {[llength $_activePanes] == 0} {
    set parent [winfo parent $itk_interior]
    if {[winfo class $parent] == "PaneContainer"} {
      $parent hide [_get_index_by_pane_widget_name $itk_interior]
    }
    return
  }


  if {!$is_last_pane } {

    set delta [expr $delta + [_getRealThickness sash_$tag]]
    if {$real_thickness > 0} {
      set _prevSashSize($tag) [_getRealThickness sash_$tag]
    } else {
      _set_regular_sash $tag
      set _prevSashSize($tag) [_getRealThickness sash_$tag]
    }
    place forget $itk_component(sash_$tag) 

    if {[llength $_activePanes] == 1} {
      _changeSizeOfLastPane
    } else {
      _shiftPanes [lindex $_activePanes $idx] $delta
    }
  } else {
    set prev_pane_tag [lindex $_activePanes end]
    
    set real_thickness [_getRealThickness $prev_pane_tag]
    set sash_real_thickness [_getRealThickness sash_$prev_pane_tag]
    if {$real_thickness > 0} {
      set _prevPaneSize($prev_pane_tag) $real_thickness 
      set _prevSashSize($prev_pane_tag) $sash_real_thickness
    } else {
      _set_regular_sash $prev_pane_tag
      set _prevSashSize($prev_pane_tag) $sash_real_thickness
    }   
    place forget $itk_component(sash_$prev_pane_tag) 
    

    _changeSizeOfLastPane
  }
}

# ------------------------------------------------------------------
# METHOD: _set_binding
#
# Add binding
# ------------------------------------------------------------------
body ::UI::PaneContainer::_set_binding {} {
  #
  # Add binding for the configure event.
  #
  bind pw-config-$this <Configure> [code $this _pwConfigureEventHandler %w %h]
  bindtags $itk_component(hull) \
	    [linsert [bindtags $itk_component(hull)] 0 pw-config-$this]
}

body ::UI::PaneContainer::_get_activePanes {} {
  return $_activePanes
}

# ------------------------------------------------------------------
# METHOD: show tag
#
# Display the specified pane in the pane container.
# ------------------------------------------------------------------
body ::UI::PaneContainer::show {tag} {
  #if tag is active
  if {[lsearch -exact $_activePanes $tag] != -1} {
    return  
  }

  #if tag is exist
  if {[lsearch -exact $_panes $tag] == -1 } {
    set tag [_get_tag_by_index $tag]
    if {$tag == ""} {
      return
    }
  }
 
  #if _activePanes is empty
  if {[llength $_activePanes] == 0} {
    set _activePanes [list $tag]
    place $itk_component($tag) -x 0 -y 0 -relwidth 1 -relheight 1 -width {} -height {}
  
    set parent [winfo parent $itk_interior]
    if {[winfo class $parent] == "PaneContainer"} {
      $parent show [_get_index_by_pane_widget_name $itk_interior]
    }
    return
  } 

  # find place in the _activePanes to insert this tag
  set paneIdx 0
  
  if {[llength $_activePanes] > 0} {
    foreach pane $_panes {
      if {$pane == $tag} {
        break
      }
      set prevPaneIdx [lsearch -exact $_activePanes $pane]
      if {$prevPaneIdx != -1 } {
        incr paneIdx
      }
    }
  }
  
  set is_last_pane 0
  if {[llength $_activePanes] == $paneIdx} {
    set is_last_pane 1
  } 
  
  set _activePanes [linsert $_activePanes $paneIdx $tag]
  
  set last_pane_tag [lindex $_activePanes end]
  if {[info exists _prevPaneSize($last_pane_tag)] == 0} {
    _placeComponents
    return
  } 

  ### calculate the inserted pane dimention
  
  if {$is_last_pane} {
    set last_pane_tag [lindex $_activePanes end-1]
  }
  set last_pane_size [_getRealThickness $last_pane_tag]
  set inserted_pane_size $_prevPaneSize($tag)
  set last_pane_min_size [$itk_component($last_pane_tag) cget -minimum]
  if {[expr $last_pane_size - $inserted_pane_size - $itk_option(-sashthickness)] < $last_pane_min_size} {
    set inserted_pane_min_size [$itk_component($tag) cget -minimum]
    if {[expr $last_pane_size - $inserted_pane_min_size - $itk_option(-sashthickness)] < $last_pane_min_size} {
      _placeComponents
    } else {
      set inserted_pane_size $inserted_pane_min_size
    }
  }

  ### calculate the inserted pane position

  set posPane 0
  if {$paneIdx > 0} {
    set prevPane [lindex $_activePanes [expr $paneIdx - 1]]
    if {!$is_last_pane} {
      set posPane [expr [_getStartPosition sash_$prevPane] + [_getRealThickness sash_$prevPane]]
      
    } else {
      set prevPaneSize [expr [_getRealThickness $prevPane] - $itk_option(-sashthickness) - $inserted_pane_size]
      if {$itk_option(-orient) == "vertical"} {
        place configure $itk_component($prevPane) -width $prevPaneSize -relwidth {}
      } else {
        place configure $itk_component($prevPane) -height $prevPaneSize -relheight {}
      }

      set posSash [expr [_getStartPosition $prevPane] +[_getRealThickness $prevPane]]
      if {$itk_option(-orient) == "vertical"} {
        place $itk_component(sash_$prevPane) -x $posSash -width $_prevSashSize($prevPane) \
            -y 0 -relheight 1
      } else {
        place $itk_component(sash_$prevPane) -y $posSash -height $_prevSashSize($prevPane) \
            -x 0 -relwidth 1
      }
      set posPane [expr [_getStartPosition sash_$prevPane] +[_getRealThickness sash_$prevPane]]
    }
  }

  if {$itk_option(-orient) == "vertical"} {
    place $itk_component($tag) -x $posPane -width $inserted_pane_size -y 0 -relheight 1
  } else {
    place $itk_component($tag) -y $posPane -height $inserted_pane_size -x 0 -relwidth 1
  }
  
  if {!$is_last_pane} {
    set posSash [expr $posPane + $inserted_pane_size]
    if {$itk_option(-orient) == "vertical"} {
      place $itk_component(sash_$tag) -x $posSash -width $_prevSashSize($tag) \
          -y 0 -relheight 1
    } else {
      place $itk_component(sash_$tag) -y $posSash -height $_prevSashSize($tag) \
          -x 0 -relwidth 1
    }
     
    set delta [expr $inserted_pane_size + $_prevSashSize($tag)]
      
    _shiftPanes [lindex $_activePanes [expr $paneIdx + 1]] -$delta
  }
  _changeSizeOfLastPane
  

}

body ::UI::PaneContainer::placeof {packed_tag unpacked_tag} {
  set paneIdx [lsearch -exact $_activePanes $packed_tag]
  if {$paneIdx == -1} {
    if {[lsearch -exact $_activePanes $unpacked_tag] == -1} {
      show $unpacked_tag
    }
    return
  }
  if {[lsearch -exact $_activePanes $unpacked_tag] == 1} {
    return
  }

  set _activePanes [lreplace $_activePanes $paneIdx $paneIdx $unpacked_tag]
  
  set position [_getStartPosition $packed_tag]
  set thickness [_getRealThickness $packed_tag]
  place forget $itk_component($packed_tag)
  
  if {$itk_option(-orient) == "vertical"} {
    place $itk_component($unpacked_tag) -x $position -width $thickness \
        -y 0 -relheight 1
  } else {
    place $itk_component($unpacked_tag) -y $position -height $thickness \
        -x 0 -relwidth 1
  }
  # with sash
  if {[info exists $itk_component(sash_$packed_tag)] &&
      [winfo manager $itk_component(sash_$packed_tag)] != ""} {
    
    set position [_getStartPosition sash_$packed_tag]
    set thickness [_getRealThickness sash_$packed_tag]
    place forget $itk_component(sash_$packed_tag)
    
    if {$itk_option(-orient) == "vertical"} {
      place $itk_component(sash_$unpacked_tag) -x $position -width $thickness \
          -y 0 -relheight 1
    } else {
      place $itk_component(sash_$unpacked_tag) -y $position -height $thickness \
        -x 0 -relwidth 1
    }
  }
}

# ------------------------------------------------------------------
# METHOD: paneconfigure index ?option? ?value option value ...?
#
# Configure a specified pane.  This method allows configuration of
# panes from the PaneContainer level.  The options may have any of the 
# values accepted by the add method.
# ------------------------------------------------------------------
body ::UI::PaneContainer::paneconfigure {index args} {
    set index [index $index]
    set tag [lindex $_panes $index]
    
    return [uplevel $itk_component($tag) configure $args]
}

# ------------------------------------------------------------------
# METHOD: wasMinimaised
#
# Return 1 if pane was minimazed
# ------------------------------------------------------------------
body ::UI::PaneContainer::wasMinimaised {tag} {
  if {[lsearch $_wasMinimaised $tag] == -1} {
    return 0
  }
  return 1
}

# ------------------------------------------------------------------
# PROTECTED METHOD: _pwConfigureEventHandler
#
# Performs operations necessary following a configure event.  This
# includes placing the panes.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_pwConfigureEventHandler {width height} {
  if {$_initialized == -1} {
    set _initialized 1
  } else {
    set _initialized 0
  }
  set _width $width
  set _height $height
  if {$itk_option(-orient) == "vertical"} {
    set _dimension $width
  } else {
    set _dimension $height
  }
  
  if {$_initialized == 1} {
    _placeComponents
  } else {
    _changeSizeOfLastPane
  } 
}

# ------------------------------------------------------------------
# PROTECTED METHOD: _startGrip where num
#
# Starts the sash drag and drop operation.  At the start of the drag
# operation all the information is known as for the upper and lower
# limits for sash movement.  The calculation is made at this time and
# stored in protected variables for later access during the drag
# handling routines.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_startGrip {where tag} {
  set _sashloc($tag) [expr [_getStartPosition sash_$tag] + \
                          [$itk_component(sash_$tag) cget -bd]*2]
  
  set _lowerlimit [expr [_getStartPosition $tag] + $where]
  switch $itk_option(-orient) {
    vertical {  
      set sashcursor sb_h_double_arrow
      set _upperlimit $_width
    }
    horizontal {
      set sashcursor sb_v_double_arrow
      set _upperlimit $_height
    }
  }
  
  itk_component add temp_sash_$tag {
    frame $itk_interior.temp_sash_$tag \
        -borderwidth [$itk_component(sash_$tag) cget -bd] \
        -cursor $sashcursor -relief [$itk_component(sash_$tag) cget -relief] \
         -bg gray70
  } {
  }
  scan [split [winfo geometry $itk_component(sash_$tag)] "+x"] "%d %d" sash_width sash_height
  if {$itk_option(-orient) == "vertical" } {  
    $itk_component(temp_sash_$tag) configure -width $sash_width
  } else {
    $itk_component(temp_sash_$tag) configure -height $sash_height
  }
  _placeTempSash $tag 

  if {$itk_option(-orient) == "vertical" } {  
    bind $itk_component(temp_sash_$tag) <Configure> \
        [code $this _configGrip %x $tag]
    bind $itk_component(temp_sash_$tag) <B1-Motion> \
        [code $this _handleGrip %x $tag]
    bind $itk_component(temp_sash_$tag) <B1-ButtonRelease-1> \
        [code $this _endGrip %x $tag]
  } else {
    bind $itk_component(temp_sash_$tag) <Configure> \
        [code $this _configGrip %y $tag]
    bind $itk_component(temp_sash_$tag) <B1-Motion> \
        [code $this _handleGrip %y $tag]
    bind $itk_component(temp_sash_$tag) <B1-ButtonRelease-1> \
        [code $this _endGrip %y $tag]
  }
  
  update idle

  grab $itk_component(temp_sash_$tag)
  raise $itk_component(temp_sash_$tag)
  
  set _dragging 1

}

# ------------------------------------------------------------------
# PROTECTED METHOD: _endGrip where tag
#
# Ends the sash drag and drop operation.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_endGrip {where tag} {
  if {![info exist itk_component(temp_sash_$tag)] || 
      ![winfo exists $itk_component(temp_sash_$tag)]} {
    return
  }
  grab release $itk_component(temp_sash_$tag)
  destroy $itk_component(temp_sash_$tag)
  
  set min_pane [$itk_component($tag) cget -minimum]
  set sash_position [_getStartPosition sash_$tag]
  set sash_thickness [_getRealThickness sash_$tag]  
  
  set delta [expr $sash_position - $_sashloc($tag)]
  if {$delta == 0} {
    return
  }

  if {$_sashloc($tag) <= [expr $_lowerlimit + $min_pane]} {
    if {[_getRealThickness $tag] == 0 } {
      if {$delta > 0} {
        return
      }
      set delta -$min_pane
    } else {
      minimazePane $tag
      return
    }
  } elseif {$_sashloc($tag) >= $_upperlimit} {
    set delta [expr $sash_position - $_upperlimit + $sash_thickness]
  }
  set diff 0
  if {$itk_option(-withsashbitmap) == 1 && [_getRealThickness $tag] == 0 } {

    if {$itk_option(-orient) == "vertical"} {
      set image_name hide_pane
    } else {
      set image_name hide_pane_hor
    }
    $itk_component(sash_label_$tag) config \
        -image [::UI::getimage $image_name] \
        -padx 2 -pady 2 -bd 0 -relief flat -bg gray80
    set diff [expr [_getRealThickness sash_$tag] - $_prevSashSize($tag)]
    if {$itk_option(-orient) == "vertical"} {
      $itk_component(sash_label_$tag) config -height 0
      place configure $itk_component(sash_$tag) -width $_prevSashSize($tag)
    } else {
      $itk_component(sash_label_$tag) config -width 0
      place configure $itk_component(sash_$tag) -height $_prevSashSize($tag)
    }
    bind $itk_component(sash_label_$tag) <1> \
        [code $this minimazePane $tag]
  }

  set pane_thickness [_getRealThickness $tag]
  if {$itk_option(-orient) == "vertical"} {
    place configure $itk_component($tag) \
        -width [expr $pane_thickness - $delta]
    place configure $itk_component(sash_$tag) -x [expr $sash_position - $delta]
  } else {
    place configure $itk_component($tag) \
        -height [expr $pane_thickness - $delta]
    place configure $itk_component(sash_$tag) -y [expr $sash_position - $delta]
  }
  
  set pane_index [lsearch $_activePanes $tag]
  _shiftPanes [lindex $_activePanes [incr pane_index]] [expr $delta + $diff]
}

# ------------------------------------------------------------------
# PROTECTED METHOD: _configGrip where num
#
# Configure  action for sash.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_configGrip {where tag} {
  if {![info exist itk_component(temp_sash_$tag)] || 
      ![winfo exists $itk_component(temp_sash_$tag)]} {
    return
  }
  set _sashloc($tag) $where
}

# ------------------------------------------------------------------
# PROTECTED METHOD: _handleGrip where num
#
# Motion action for sash.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_handleGrip {where tag} {
  if {![info exist itk_component(temp_sash_$tag)] || 
      ![winfo exists $itk_component(temp_sash_$tag)]} {
    return
  }
  set _sashloc($tag) [expr $_sashloc($tag) + $where]
  if {$_sashloc($tag) <= $_upperlimit && $_sashloc($tag) >= $_lowerlimit} {
    _moveTempSash $tag
  }
  incr _movecount
  if {$_movecount>4} {
    set _movecount 0
    update idletasks
  }
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _add_component 
#
# Adds component by tag and type ( pane or container) after index pane.
# ------------------------------------------------------------------

body ::UI::PaneContainer::_add_component {type tag index args} {
  if {[lsearch -exact [array names itk_component] $tag] != -1} {
    puts "Pane with $tag name exists"
    return ""
  }
  
  set widget_class "::UI::PaneContainer"
  if {$type == "pane"} {
    set widget_class "::UI::Pane"
  }

  lappend args -orientpane $itk_option(-orient)
  itk_component add $tag {
    eval [list $widget_class $itk_interior.pane[incr _unique]] $document $args
  } {
    keep -background -cursor
  }
  
  set index [index $index]
  set _panes [linsert $_panes $index $tag]
  
  if {[$itk_component($tag) cget -showInCreate] == 1 } {
    if {$index == 0} {
      set _activePanes [linsert $_activePanes $index $tag]
    } elseif {$index == "end" || ![llength $_activePanes]} {
      lappend _activePanes $tag
    } else {
      set paneIdx 0
      foreach pane $_panes {
        if {$pane == $tag} {
          break
        }
        set prevPaneIdx [lsearch -exact $_activePanes $pane]
        if {$prevPaneIdx != -1 } {
          incr paneIdx
        }
      }
      set _activePanes [linsert $_activePanes $paneIdx $tag]
    }
  }
  
  _makeSash $tag $_unique
  update idle
  
  _placeComponents
  
   return $itk_component($tag)
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _makeSash
#
# Removes any previous sashes and creates new one.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_makeSash {tag num} {
  switch $itk_option(-orient) {
    vertical {  
      set sashcursor sb_h_double_arrow
    }
    horizontal {
      set sashcursor sb_v_double_arrow
    }
  }
  
  itk_component add sash_$tag {
    frame $itk_interior.sash$num -relief raised \
        -borderwidth $itk_option(-sashborderwidth) \
        -cursor $sashcursor 
  } {
    keep -background
  }
  
  if {$itk_option(-withsashbitmap) == 1} {
    if {$itk_option(-orient) == "vertical"} {
      set image_name hide_pane
    } else {
      set image_name hide_pane_hor
    }
    
    itk_component add sash_label_$tag {
      label $itk_component(sash_$tag).lbl  \
          -image [::UI::getimage $image_name]
    } {
    }
    $itk_component(sash_label_$tag) configure -cursor hand2  \
        -padx 2 -pady 2 -bd 0 -relief flat -bg gray80
    if {$itk_option(-orient) == "vertical"} {
      pack $itk_component(sash_label_$tag) -side left -anchor c 
    } else {
      pack $itk_component(sash_label_$tag) -side top -anchor c 
    }
    
    bind $itk_component(sash_label_$tag) <1> \
        [code $this minimazePane $tag]
  }
  
  switch $itk_option(-orient) {
    vertical {
      bind $itk_component(sash_$tag) <Button-1> \
          [code $this _startGrip %x $tag]
      bind $itk_component(sash_$tag) <B1-Motion> \
          [code $this _handleGrip %x $tag]
      bind $itk_component(sash_$tag) <B1-ButtonRelease-1> \
          [code $this _endGrip %x $tag]
 
      
      if {[info exists itk_component(sash_label_$tag)] == 0} {
        $itk_component(sash_$tag) configure -width $itk_option(-sashthickness)
      }
    }
    
    horizontal {
      bind $itk_component(sash_$tag) <Button-1> \
          [code $this _startGrip %y $tag]
      bind $itk_component(sash_$tag) <B1-Motion> \
          [code $this _handleGrip %y $tag]
      bind $itk_component(sash_$tag) <B1-ButtonRelease-1> \
          [code $this _endGrip %y $tag]
      
      if {[info exists itk_component(sash_label_$tag)] == 0} {
        $itk_component(sash_$tag) configure -height $itk_option(-sashthickness) 
      }
    }
  }
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _placeTempSash 
#
# Places the position of the temporary sash by tag.
# ------------------------------------------------------------------
body ::UI::PaneContainer::_placeTempSash {tag} {
  if {![info exist itk_component(temp_sash_$tag)] || 
      ![winfo exists $itk_component(temp_sash_$tag)]} {
    return
  }
  
  if {$itk_option(-orient) == "horizontal"} {
    place $itk_component(temp_sash_$tag) -in $itk_component(hull) \
        -x 0 -y $_sashloc($tag) -anchor w -relwidth 1
  } else {
    place $itk_component(temp_sash_$tag) -in $itk_component(hull) \
        -y 0 -x $_sashloc($tag) -anchor n -relheight 1
  }
}

body ::UI::PaneContainer::_moveTempSash {tag} {
  if {![info exist itk_component(temp_sash_$tag)] || 
      ![winfo exists $itk_component(temp_sash_$tag)]} {
    return
  }
  
  if {$itk_option(-orient) == "horizontal"} {
    place configure $itk_component(temp_sash_$tag) -y $_sashloc($tag)
  } else {
    place configure $itk_component(temp_sash_$tag) -x $_sashloc($tag)
  }
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _placeComponents
#
# Places all of components into the container
# ------------------------------------------------------------------
body ::UI::PaneContainer::_placeComponents {} {

  set activePanes_num [llength $_activePanes]
  if {$activePanes_num == 0} {
    return
  }
  
  if {$activePanes_num == 1} {
    # there is only one pane 
    set tag [lindex $_activePanes 0]
    place forget $itk_component($tag)
    if {[winfo manager $itk_component(sash_$tag)] != ""} {
      place forget $itk_component(sash_$tag)
    }
    _changeSizeOfLastPane
    return
  }

  set num_of_null_width_pane 0
  set req_thickness 0
  set lastPane [_get_last_pane]
  
  foreach pane $_activePanes {
    place forget $itk_component($pane)
    if {[$itk_component($pane) cget -thickness] == 0 } {
      incr num_of_null_width_pane
    } else {
      set req_thickness [expr $req_thickness + [$itk_component($pane) cget -thickness]]
    }
    if {[winfo manager $itk_component(sash_$pane)] != ""} {
      place forget $itk_component(sash_$pane)
    }
    if {$pane != $lastPane} {
      if {$itk_option(-orient) == "vertical"} {
        set req_thickness [expr $req_thickness + [winfo reqwidth $itk_component(sash_$pane)]]
      } else {
        set req_thickness [expr $req_thickness + [winfo reqheight $itk_component(sash_$pane)]]
      }
    }
  }

  set thickness_of_null_width_pane 0
  if {$num_of_null_width_pane && $_dimension > $req_thickness} {
    set thickness_of_null_width_pane \
        [expr int(($_dimension - $req_thickness) / $num_of_null_width_pane)]
  }
  
  set start_coord 0
  set reqthickness 0
  set lastPane [_get_last_pane]
  
  foreach pane $_activePanes {
    if {[$itk_component($pane) cget -thickness] > 0 } { 
      set reqthickness [$itk_component($pane) cget -thickness]
    } else {
      set minsize [$itk_component($pane) cget -minimum]
      set reqthickness [max $minsize $thickness_of_null_width_pane]
      
    }

    if {$itk_option(-orient) == "vertical"} {
      place $itk_component($pane) -x $start_coord -width $reqthickness \
          -y 0 -relheight 1
    } else {
      place $itk_component($pane) -y $start_coord -height $reqthickness \
          -x 0 -relwidth 1
    }

    set start_coord [expr $start_coord + int($reqthickness)]
     
    if {$pane != $lastPane} {
      set sash_thickness 0
      if {$itk_option(-orient) == "vertical"} {
        set sash_thickness [winfo reqwidth $itk_component(sash_$pane)]
        place $itk_component(sash_$pane) -x $start_coord -width $sash_thickness \
            -y 0 -relheight 1
      } else {
        set sash_thickness [winfo reqheight $itk_component(sash_$pane)]
        place $itk_component(sash_$pane) -y $start_coord  -height $sash_thickness \
            -x 0 -relwidth 1
       
      }
      incr start_coord $sash_thickness
      set start_coord [expr $start_coord + int($sash_thickness)]
    } 
  }
}

# ------------------------------------------------------------------
# METHOD: minimazePane
#
# Minimaze the pane by tag
# ------------------------------------------------------------------
body ::UI::PaneContainer::minimazePane {tag} {
  set pane_index [lsearch $_activePanes $tag]
  set delta [_getRealThickness $tag]
  set sash_position [_getStartPosition sash_$tag]
  if {$itk_option(-orient) == "vertical"} {
    place configure $itk_component($tag) -width 0
    place configure $itk_component(sash_$tag) -x [expr $sash_position - $delta] 
  } else {
    place configure $itk_component($tag) -height 0
    place configure $itk_component(sash_$tag) -y [expr $sash_position - $delta]
  }
  set _prevPaneSize($tag) $delta
  set _prevSashSize($tag) [_getRealThickness sash_$tag] 
  if {$itk_option(-withsashbitmap) == 1} {

    if {$itk_option(-orient) == "vertical"} {
      set image_name show_pane
    } else {
      set image_name show_pane_hor
    }  
    $itk_component(sash_label_$tag) config \
        -image [::UI::getimage $image_name]  
    
    bind $itk_component(sash_label_$tag) <1> \
        [code $this restorePane $tag]
  }
  _shiftPanes [lindex $_activePanes [incr pane_index]] $delta
  lappend _wasMinimaised $tag
}

# ------------------------------------------------------------------
# METHOD: restorePane
#
# Restores the previous pane size by tag
# ------------------------------------------------------------------
body ::UI::PaneContainer::restorePane {tag} {
  if {[wasMinimaised $tag] == 0} {
    return
  }
  set pane_index [lsearch $_activePanes $tag]
  set delta $_prevPaneSize($tag)
  set sash_thickness [_getRealThickness sash_$tag]
  set pane_start_position [_getStartPosition $tag]
  set min_pane_size [$itk_component($tag) cget -minimum]
  if {[expr $pane_start_position + $delta + $sash_thickness] > $_width} {
    set delta [max [expr $_width - $pane_start_position - $sash_thickness] \
                            $min_pane_size]
  }
  if {$delta < 0} {
    return
  }
  
  set sash_position [_getStartPosition sash_$tag]
  if {$itk_option(-orient) == "vertical"} {
    place configure $itk_component($tag) -width $delta
    place configure $itk_component(sash_$tag) -x [expr $sash_position + $delta]
  } else {
    place configure $itk_component($tag) -height $delta
    place configure $itk_component(sash_$tag) -y [expr $sash_position + $delta]
  }
  set _prevPaneSize($tag) 0
  set diff 0
  
  if {$itk_option(-withsashbitmap) == 1 } {
    if {$itk_option(-orient) == "vertical"} {
      set image_name hide_pane
    } else {
      set image_name hide_pane_hor
    }     
    $itk_component(sash_label_$tag) config \
        -image [::UI::getimage $image_name]  \
        -padx 2 -pady 2 -bd 0 -relief flat -bg gray80
    set diff [expr [_getRealThickness sash_$tag] - $_prevSashSize($tag)]
    if {$itk_option(-orient) == "vertical"} { 
      $itk_component(sash_label_$tag) config -height 0
      place configure $itk_component(sash_$tag) -width $_prevSashSize($tag)
    } else {
      $itk_component(sash_label_$tag) config -width 0
      place configure $itk_component(sash_$tag) -height $_prevSashSize($tag)
    }
    bind $itk_component(sash_label_$tag) <1> \
        [code $this minimazePane $tag]
  }
  _shiftPanes [lindex $_activePanes [incr pane_index]] -[expr $delta - $diff]
  set _wasMinimaised [lreplace $_wasMinimaised [lsearch $_wasMinimaised $tag] [lsearch $_wasMinimaised $tag]]
}

# ------------------------------------------------------------------
# METHOD: selectPane tag
#
# Select the pane by tag 
# ------------------------------------------------------------------
body ::UI::PaneContainer::selectPane {tag} {
  if {[winfo class $itk_component($tag)] == "Pane"} {
    $itk_component($tag) configure -isselected 1
  }
}

body ::UI::PaneContainer::unselectPane {tag} {
  if {[winfo class $itk_component($tag)] == "Pane"} {  
    $itk_component($tag) configure -isselected 0
  }
}


# ------------------------------------------------------------------
# PRIVATE METHOD: _changeSizeOfLastPane
#
# Changes size of last pane according to container width
# ------------------------------------------------------------------
body ::UI::PaneContainer::_changeSizeOfLastPane {} {
  
  if {[llength $_activePanes] == 1} {
    set last_pane [lindex $_activePanes 0]
    place configure $itk_component($last_pane) -x 0 -y 0 -relwidth 1 -relheight 1 -width {} -height {}
    return 
  }

  set lastPane [_get_last_pane]
  if {$lastPane == ""} {
    return
  }
  set position [_getStartPosition $lastPane]
  set thickness [_getRealThickness $lastPane]
  set min_pane_size [$itk_component($lastPane) cget -minimum]
  
  if {$itk_option(-orient) == "vertical"} {
    set parameter "width"
    set dimension $_width
  } else {
    set parameter "height"
    set dimension $_height
  }
  
  if {$position < $dimension} {
    set new_thickness [expr $dimension - $position]
    if {[expr $position + $thickness] <= $dimension} {
      place configure $itk_component($lastPane) \
          -[set parameter] $new_thickness -rel[set parameter] {}
    } else {
      if {$new_thickness > $min_pane_size} {
        place configure $itk_component($lastPane) \
            -[set parameter] $new_thickness -rel[set parameter] {}
      } else {
        place configure $itk_component($lastPane) \
            -[set parameter] $min_pane_size -rel[set parameter] {}
      }
    }
  } else {
    _placeComponents
  }
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _getStartPosition
#
# Gets start position of component by tag
# ------------------------------------------------------------------
body ::UI::PaneContainer::_getStartPosition {tag} {
  #update
  set tag_position 0
  
  if {[winfo manager $itk_component($tag)] != ""} {
    set place_list [place info $itk_component($tag)]
    if {$itk_option(-orient) == "vertical"} {
      set x_index [lsearch $place_list "-x"]
      set tag_position [lindex $place_list [incr x_index]]
    } else {
      set y_index [lsearch $place_list "-y"]
      set tag_position [lindex $place_list [incr y_index]]
    }
  }
  return $tag_position
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _getRealThickness
#
# Gets real thickness of component by tag
# ------------------------------------------------------------------
body ::UI::PaneContainer::_getRealThickness {tag} {

  set real_thickness 0

  if {[winfo manager $itk_component($tag)] != ""} {
    set place_list [place info $itk_component($tag)]

    if {$itk_option(-orient) == "vertical"} {
      set width_index [lsearch $place_list "-width"]
      set real_thickness [lindex $place_list [incr width_index]]
    } else {
      set height_index [lsearch $place_list "-height"]
      set real_thickness [lindex $place_list [incr height_index]]
    }
  }
  if {$real_thickness == ""} {
    set real_thickness $_dimension
  }
  return $real_thickness
}

# ------------------------------------------------------------------
# PRIVATE METHOD: _shiftPanes
#
# Shifts all components
# ------------------------------------------------------------------
body ::UI::PaneContainer::_shiftPanes {starttag delta} {
  if {$starttag == ""} {
    return
  }
  set start_index [lsearch -exact $_activePanes $starttag]
  set last_pane [_get_last_pane]
  
  if {$itk_option(-orient) == "vertical"} {
    set parameter "x"
  } else {
    set parameter "y"
  }
  
  foreach pane [lrange $_activePanes $start_index end] {
    set parameter_size [_getStartPosition $pane]
    place configure $itk_component($pane) \
        -[set parameter] [expr $parameter_size - $delta]
    if {$pane != $last_pane} {
      set parameter_size [_getStartPosition sash_$pane]
      place configure $itk_component(sash_$pane) \
          -[set parameter] [expr $parameter_size - $delta]
    }
  }
  
  _changeSizeOfLastPane
}

body ::UI::PaneContainer::_set_regular_sash {tag} {
  if {$itk_option(-withsashbitmap) == 1 } {
    if {$itk_option(-orient) == "vertical"} {
      set image_name hide_pane
    } else {
      set image_name hide_pane_hor
    }  

    $itk_component(sash_label_$tag) config \
        -image [::UI::getimage $image_name]  \
        -padx 2 -pady 2 -bd 0 -relief flat -bg gray80 -height 0 -width 0
    
    bind $itk_component(sash_label_$tag) <1> \
        [code $this minimazePane $tag]
  }
}

body ::UI::PaneContainer::_get_tag_by_index { index } {
  set idx [index $index]
  return [lindex $_panes $idx]
}

body ::UI::PaneContainer::_get_index_by_pane_widget_name {pane_widget_name} {
  if {$pane_widget_name == ""} {
    return -1
  }

  set last_name [lindex [split $pane_widget_name "."] end]

  if { [string first "pane" $last_name] == -1} {
    return -1
  }
  
  return [string range $last_name 4 end]
  
}

body ::UI::PaneContainer::_get_last_pane {} {
  if {[llength $_activePanes] > 0} {
    return [lindex $_activePanes end]
  }
  return ""
}
