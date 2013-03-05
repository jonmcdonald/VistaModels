itk::usual Selectmenu {
  
}

blt::bitmap define Selectmenu-down {
#define down_width 7
#define down_height 4
static unsigned char down_bits[] = {
   0x7f, 0x3e, 0x1c, 0x08};
}

::itcl::class ::UI::Selectmenu {
  inherit itk::Widget
  
  constructor {args} {}
  destructor {}
  itk_option define -arrowrelief arrowRelief Relief raised
  itk_option define -grab grab Grab global
  
  private method _createComponents {}
  private method _toggleList {}
  private method _postList {}
  private method _unpostList {{takeTmpData 1}}
  private method _positionList {}
  private method _drawArrow {}
  private method size {}
  private method _next {}
  private method _previous {}
  private method _listShowing {{val ""}}
  private method _dropdownBindings {}
  private method _commonBindings {}
  private method _dropdownBtnRelease {{window {}} {x 1} {y 1}}
  private method _get_shell_width {}
  private method _on_Enter {w}
  private method _on_Leave {w}
  private method on_Button {}

  private variable _isPosted false;		 ;# is the dropdown popped up.
  private variable _currItem {};			 ;# current selected item.
  private variable _ignoreReleaseCallback 0

  private common _listShowing
  private common count 0
  
}

::itcl::body ::UI::Selectmenu::constructor {args} {
  set _ignoreReleaseCallback 0
  set _listShowing($this) 0

  if {$count == 0} {
    image create bitmap downarrow -data {
	    #define down_width 16
	    #define down_height 16
	    static unsigned char down_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
        0x00, 0x00, 0x00, 0x00, 0xfc, 0x7f, 0xf8, 0x3f, 
        0xf0, 0x1f, 0xe0, 0x0f, 0xc0, 0x07, 0x80, 0x03, 
        0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	    };
    }
    image create bitmap uparrow -data {
	    #define up_width 16
	    #define up_height 16
	    static unsigned char up_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 
        0xc0, 0x01, 0xe0, 0x03, 0xf0, 0x07, 0xf8, 0x0f, 
        0xfc, 0x1f, 0xfe, 0x3f, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	    };
    }
  }
  incr count
  _createComponents
  eval itk_initialize $args
}

::itcl::body ::UI::Selectmenu::destructor {} {
  incr count -1
  if {$count == 0} {
    image delete uparrow
    image delete downarrow
  }
}

::itcl::body ::UI::Selectmenu::_on_Enter {w} {
  $itk_interior.bottomFrame configure -relief raise
  focus $w
}

::itcl::body ::UI::Selectmenu::_on_Leave {w} {
  $itk_interior.bottomFrame configure -relief flat
}

::itcl::body ::UI::Selectmenu::_createComponents {} {
  
  #	configure -childsitepos e
	
  set bottomFrame $itk_interior.bottomFrame
  frame $bottomFrame -borderwidth 2
  pack $bottomFrame -fill x
  itk_component add labelbox {
    ::UI::Labelbox $bottomFrame.labelbox  -borderwidth 2 -relief flat
  } {
    keep -listvariable -list
  }

  pack $bottomFrame.labelbox -side left -fill x
  bind $bottomFrame.labelbox <Enter> [itcl::code $this _on_Enter $bottomFrame.labelbox]
  bind $bottomFrame.labelbox <Leave> [itcl::code $this _on_Leave $bottomFrame.labelbox]
	# arrow button to popup the list
	itk_component add arrowBtn {
    button $bottomFrame.arrowBtn -borderwidth 0 \
        -highlightbackground $itk_option(-background) \
        -highlightcolor $itk_option(-background) \
        -activebackground $itk_option(-background) \
        -width 15 -height 15 -bitmap Selectmenu-down \
        -command [::itcl::code $this _toggleList]
	} {
    keep -background -borderwidth -cursor -state 
    rename -highlightbackground -background background Background
	}
  pack $bottomFrame.arrowBtn -side left -anchor e
  bind $bottomFrame.arrowBtn <Enter> [itcl::code $this _on_Enter $bottomFrame.arrowBtn]
  bind $bottomFrame.arrowBtn <Leave> [itcl::code $this _on_Leave $bottomFrame.arrowBtn]
	# popup list container
	itk_component add popup {
    toplevel $itk_interior.popup
	} {
    keep -background -cursor
	}
	wm withdraw $itk_interior.popup
	
	itk_component add list {
    ::UI::Checkbuttonbox $itk_interior.popup.list -background red -borderwidth 2 -relief sunk
	} {
    keep -background -borderwidth -cursor -listvariable -list
  }
  pack $itk_interior.popup.list -fill both

	# mode specific bindings
	_dropdownBindings
  
	# Ugly hack to avoid tk buglet revealed in _dropdownBtnRelease where 
	# relief is used but not set in scrollbar.tcl. 
	global tkPriv
	set tkPriv(relief) raise
  
  # add mode independent bindings
  _commonBindings
}


# ------------------------------------------------------
# PRIVATE METHOD:	 _toggleList
#
# Post or unpost the dropdown frame (toggle).
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_toggleList {} {
  if {[winfo ismapped $itk_component(popup)] } {
    _unpostList
  } else {
    _postList
  }
}

# ------------------------------------------------------
# PRIVATE METHOD:	  _postList
#
# Pop up the list in a dropdown style Selectmenu.
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_postList {} {
#  if {[size] == 0} {
#    return
#  }
  
  set _isPosted true
  _positionList
  
  # map window and do a grab
  wm deiconify $itk_component(popup)
  _listShowing -wait
  if {$itk_option(-grab) == "global"} {
    grab -global $itk_component(popup) 
  } else {
    grab $itk_component(popup) 
  }
  raise $itk_component(popup)
  focus $itk_component(popup)
  _drawArrow
  $itk_component(list) tmpMode
}


# ------------------------------------------------------
# PRIVATE METHOD:	  _unpostList
#
# Unmap the shell (pop it down).
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_unpostList {{takeTmpData 1}} {

  set x [winfo x $itk_component(list)]
  set y [winfo y $itk_component(list)]
  set w [winfo width $itk_component(list)]
  set h [winfo height $itk_component(list)]
  
  wm withdraw $itk_component(popup)
  grab release $itk_component(popup)	
  
  set _isPosted false
  
  _drawArrow
  $itk_component(list) regularMode $takeTmpData
}

::itcl::body ::UI::Selectmenu::_get_shell_width {} {
  set size [expr {[winfo width $itk_component(labelbox) ] + [winfo width $itk_component(arrowBtn)]}] 

  set listVar [$itk_component(list) cget -listvariable]

  if {[info exists $listVar]} {
    set max 0
    set maxLabel ""
    foreach rec [set $listVar] {
      set label [lindex $rec 2]
      set length [string length $label]
      if {$length > $max} {
        set max $length
        set maxLabel $label
      }
    }
    set path [$itk_component(list) getButtonByLabel $maxLabel]
    if {$path != ""} {
      if {[set newSize [font measure [$path cget -font] abcde$maxLabel]] > $size} {
        set size $newSize
      }
    }
  }
  return $size
}

# ------------------------------------------------------
# PRIVATE METHOD:	  _positionList
#
# Determine the position (geometry) for the popped up list
# and map it to the screen.
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_positionList {} {
  
  set x [winfo rootx $itk_component(labelbox) ]
  set y [expr [winfo rooty $itk_component(labelbox) ] + \
             [winfo height $itk_component(labelbox) ]]
  set w [_get_shell_width] 
  set sh [winfo screenheight .]
  
  wm overrideredirect $itk_component(popup) 0
  wm geometry $itk_component(popup) +$x+$y
  wm overrideredirect $itk_component(popup) 1
}

::itcl::body ::UI::Selectmenu::_drawArrow {} {
  set flip false
  set relief ""
  if {$_isPosted} {
    set flip true
    set relief "-relief sunken"
  } else {
    set relief "-relief $itk_option(-arrowrelief)"
  }
  
  if {$flip} {
    #	 
    #				draw up arrow
    #
    eval $itk_component(arrowBtn) configure -bitmap Selectmenu-down $relief
  } else {
    #	 
    #				draw down arrow
    #
    eval $itk_component(arrowBtn) configure -bitmap Selectmenu-down $relief
  }
}

::itcl::body ::UI::Selectmenu::size {} {
  return 10 ;# temporary
}

::itcl::body ::UI::Selectmenu::_next {} {
}

::itcl::body ::UI::Selectmenu::_previous {} {
}
# ------------------------------------------------------
# PRIVATE METHOD: _listShowing ?val?
#
# Used instead of "tkwait visibility" to make sure that
# the dropdown list is visible.	 Whenever the list gets
# mapped or unmapped, this method is called to keep
# track of it.	When it is called with the value "-wait",
# it waits for the list to be mapped.
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_listShowing {{val ""}} {
  if {$val == ""} {
    return $_listShowing($this)
  } elseif {$val == "-wait"} {
    while {!$_listShowing($this)} {
	    tkwait variable [::itcl::scope _listShowing($this)]
    }
    return
  }
  set _listShowing($this) $val
}

::itcl::body ::UI::Selectmenu::_dropdownBtnRelease {{window {}} {x 1} {y 1}} {
  if {$_ignoreReleaseCallback} {
    set _ignoreReleaseCallback 0
    return
  }
  if { [winfo ismapped $itk_component(popup)] &&
       (($x < 0) || ($x >= [winfo width $itk_component(popup)])
        || ($y < 0) || ($y >= [winfo height $itk_component(popup)]))} {
    _unpostList
  }
}

::itcl::body ::UI::Selectmenu::on_Button {} {
  set _ignoreReleaseCallback 1
  _toggleList
}

# ------------------------------------------------------
# PRIVATE METHOD: _dropdownBindings
#
# Bindings used only by the dropdown type Selectmenu.
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_dropdownBindings {} {
  bind $itk_component(popup)  <Escape> "[::itcl::code $this _unpostList 0];break"
  bind $itk_component(popup)  <ButtonRelease-1> \
      [::itcl::code $this _dropdownBtnRelease %W %x %y]
  bind $itk_component(list)  <Map> \
      [::itcl::code $this _listShowing 1]
  bind $itk_component(list)  <Unmap> \
      [::itcl::code $this _listShowing 0]
  
#   bind $itk_component(arrowBtn) <3>          [::itcl::code $this _next]
#   bind $itk_component(arrowBtn) <Shift-3>    [::itcl::code $this _previous]
#   bind $itk_component(arrowBtn) <Down>       [::itcl::code $this _next]
#   bind $itk_component(arrowBtn) <Up>         [::itcl::code $this _previous]
#   bind $itk_component(arrowBtn) <Control-n>  [::itcl::code $this _next]
#   bind $itk_component(arrowBtn) <Control-p>  [::itcl::code $this _previous]
  bind $itk_component(arrowBtn) <Shift-Down> [::itcl::code $this _toggleList]
  bind $itk_component(arrowBtn) <Shift-Up>   [::itcl::code $this _toggleList]
  bind $itk_component(arrowBtn) <Return>     [::itcl::code $this _toggleList]
  bind $itk_component(arrowBtn) <space>      [::itcl::code $this _toggleList]
  bind $itk_component(arrowBtn) <Button-3>      [::itcl::code $this _toggleList]

  bind $itk_component(labelbox) <space>      [::itcl::code $this _toggleList]
  bind $itk_component(labelbox) <Button> [::itcl::code $this on_Button]
}

# ------------------------------------------------------
# PRIVATE METHOD:	  _commonBindings
#
# Bindings that are used by both simple and dropdown
# style Selectmenues.
#
# ------------------------------------------------------
::itcl::body ::UI::Selectmenu::_commonBindings {} {
}


