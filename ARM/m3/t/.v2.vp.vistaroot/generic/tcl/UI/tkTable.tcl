# sccsid = "%Z%sccs get -r%I% %P%"
# Created by Vladimir.
# This file should be loaded, after the standard tkTable file.

#Irena : tkTable.tcl added to v2 - from Visual CVS verison 1.4
proc ::tk::table::ClipboardKeysyms {copy cut paste} {
  bind Table <$copy> "::tk::table::CopySelected  %W"
  bind Table <$paste> "::tk::table::PasteSelected %W"
  bind Table <$cut>   "::tk::table::CutSelected %W"
}

::tk::table::ClipboardKeysyms <Copy> <Cut> <Paste>

#initial values for ::tk::table::Priv
set ::tk::table::Priv(ResizeMode) 0
set ::tk::table::Priv(PressedIndex) ""


bind Table <3> {
    ## You might want to check for row returned if you want to
    ## restrict the resizing of certain rows
    ::tk::table::PopUp %W %x %y %X %Y
}
bind Table <B3-Motion>	{ }
bind Table <B1-Motion> {
  if {[winfo exists %W]} {
    dbg tixTable "<B1-Motion> ResizeMode=$::tk::table::Priv(ResizeMode)"
    if {  $::tk::table::Priv(ResizeMode) == "1"} {
      #the last column should not be minimised to 0 !
      set lastCol [ expr [%W cget -cols] +  [%W cget -colorigin] - 1 ]
      set row [%W cget -roworigin]
      set bbox [%W bbox $row,$lastCol]
      #dbg tixTable "bbox = $bbox"
      
      if { $bbox != "" } {

        set width [lindex $bbox 2]
        set x [lindex $bbox 0]
        set delta [expr $x-%x]
        #dbg tixTable "width=$width x=$x delta=$delta"
        if { $delta < 0 } {
          set width [expr $width + $delta]
          #dbg tixTable "new width=$width"
        }
        
        
        if { ($width > 7 || $delta > 7) } {
          set ::tk::table::Priv(x) %x
          set ::tk::table::Priv(y) %y
          %W border dragto %x %y  
        }
      } else {
        set ::tk::table::Priv(x) %x
        set ::tk::table::Priv(y) %y
        %W border dragto %x %y  
      }
      
    } else {
      catch {
        # ::tk::table::Motion %W [%W index @%x,%y]
        # If we already had motion, or we moved more than 1 pixel,
        # then we start the Motion routine
        if { $::tk::table::Priv(mouseMoved)
            || abs(%x-$::tk::table::Priv(x)) > 1
            || abs(%y-$::tk::table::Priv(y)) > 1
          } {
          set ::tk::table::Priv(mouseMoved) 1
        }
        if {$::tk::table::Priv(mouseMoved)} {
          ::tk::table::Motion %W [%W index @%x,%y]
        }
      }
    }

  }
}
bind Table <Double-1> { }

bind Table <B1-Leave>	{
  set ::tk::table::Priv(x) %x
  set ::tk::table::Priv(y) %y
  if { $::tk::table::Priv(ResizeMode) != "1" } {
    #if non ResizeMode
    catch {
      ::tk::table::AutoScan %W
    }
  } 
    
}
bind Table <ButtonPress-1> {
#dbg tixTable <ButtonPress-1>
  if {[ winfo exists %W]} {
    set b [%W border mark %x %y]
    set borderRow [ lindex $b 0 ]
    set borderCol [lindex $b 1 ]
    #dbg tixTable "b=$b borderRow=$borderRow "
    
    #check that border mark is related to resize
    if { $b != "" && $borderCol != "" } {
      #check that resize is allowed for this column
      if { [ tixTable:canResizeColumn %W $borderCol ] } {
        set ::tk::table::Priv(ResizeMode) 1
      } else {
        #dbg tixTable "Cannot resize column ==> ResizeMode=0"
        set ::tk::table::Priv(ResizeMode) 0
      }
    } else {
      set ::tk::table::Priv(ResizeMode) 0
      set ind [%W index @%x,%y]
      ::tk::table::BeginSelect %W $ind
      #preserving index of pressed cell
      set ::tk::table::Priv(PressedIndex) $ind
      focus %W
      

    }
  }
}


bind Table <ButtonRelease-1> {
  set ::tk::table::Priv(ResizeMode) 0
  #dbg tixTable "<ButtonRelease-1>"
  if {[winfo exists %W]} {
    ::tk::table::CancelRepeat ; #irena 
  
    set curselection [%W curselection]
    if { [llength $curselection] <= 1} { 
      %W activate @%x,%y
    }
  }
}
bind Table <ButtonRelease-2> {
  #dbg tixTable "Table <ButtonRelease-2>"
  #    if {!$::tk::table::Priv(mouseMoved)} { tk_tablePaste %W [%W index @%x,%y] }
  if {!$::tk::table::Priv(mouseMoved)} { ::tk::table::PasteSelected %W [%W index @%x,%y]}
}

bind Table <Tab>           {catch {::tk::table::MoveCell %W  0  1}}
bind Table <Shift-Tab>     {catch {::tk::table::MoveCell %W  0 -1}}
bind Table <Control-Up>	   {catch {::tk::table::MoveCell %W -1  0}}
bind Table <Control-Down>  {catch {::tk::table::MoveCell %W  1  0}}
bind Table <Control-Left>  {catch {::tk::table::MoveCell %W  0 -1}}
bind Table <Control-Right> {catch {::tk::table::MoveCell %W  0  1}}

bind Table <Up>			{catch {::tk::table::MoveCell %W -1  0}}
bind Table <Down>		{catch {::tk::table::MoveCell %W  1  0}}
bind Table <Left>		{catch {::tk::table::MoveCell %W  0 -1}}
bind Table <Right>		{catch {::tk::table::MoveCell %W  0  1}}

# vladimir : probably these changes should be done in core
#bind Table <Any-Tab> {
# empty to allow Tk focus movement
#}

#irena:fix this bind because of bug in original tkTable
bind Table <BackSpace> {
  catch {
    set ::tk::table::Priv(junk) [%W icursor]
    if {[string compare {} $::tk::table::Priv(junk)] && \
	    $::tk::table::Priv(junk)} {
	%W delete active [expr {$::tk::table::Priv(junk)-1}]
    }
  }

}


bind Table <Return>		{::tk::table::MoveCell %W 1 0; break}
bind Table <Alt-Return>		{%W insert active insert "\n"}

# ::tk::table::BeginSelect --
#
# This procedure is typically invoked on button-1 presses. It begins
# the process of making a selection in the table. Its exact behavior
# depends on the selection mode currently in effect for the table;
# see the Motif documentation for details.
#
# Arguments:
# w	- The table widget.
# el	- The element for the selection operation (typically the
#	one under the pointer).  Must be in row,col form.
#Differences from original version :
#irena :  add call to tixTable rowcommand (8.08.01)
#alexz :  added flag - "select" (causes unselect all before selection) or "extend"

proc ::tk::table::BeginSelect {w el {flag "select"}} {
  #dbg tixTable "::tk::table::BeginSelect "
    variable Priv
    if {[scan $el %d,%d r c] != 2} return
    switch [$w cget -selectmode] {
	multiple {
	    if {[$w tag includes title $el]} {
		## in the title area
		if {$r < [$w cget -titlerows]+[$w cget -roworigin]} {
		    ## We're in a column header
		    if {$c < [$w cget -titlecols]+[$w cget -colorigin]} {
			## We're in the topleft title area
			set inc topleft
			set el2 end
		    } else {
			set inc [$w index topleft row],$c
			set el2 [$w index end row],$c
		    }
		} else {
		    ## We're in a row header
		    set inc $r,[$w index topleft col]
		    set el2 $r,[$w index end col]
		}
	    } else {
		set inc $el
		set el2 $el
	    }
	    if {[$w selection includes $inc]} {
		$w selection clear $el $el2
	    } else {
		$w selection set $el $el2
	    }
	}
	extended {
            if {$flag == "select"} {
              $w selection clear all
            }
	    if {[$w tag includes title $el]} {
		if {$r < [$w cget -titlerows]+[$w cget -roworigin]} {
		    ## We're in a column header
		    if {$c < [$w cget -titlecols]+[$w cget -colorigin]} {
			## We're in the topleft title area
			$w selection set $el end
		    } else {
			$w selection set $el [$w index end row],$c
		    }
		} else {
		    ## We're in a row header
		    $w selection set $el $r,[$w index end col]
                    #irena: 8.08.01
                    tixTable:invokeRowCommand [winfo parent $w] $r 
		}
	    } else {
		$w selection set $el
	    }
	    $w selection anchor $el
	    set Priv(tablePrev) $el
	}
	default {
	    if {![$w tag includes title $el]} {
		$w selection clear all
		$w selection set $el
		set Priv(tablePrev) $el
	    }
	    $w selection anchor $el
	}
    }
}





# ::tk::table::PopUp -- Haya 12.7.00
# 
# This procedure is called to process mouse events while
# button 3 is down. Records x and y border under that point in the table window, 
# if any; used in conjunction with later border dragto commands.
# if coord @x,@y is in the selection popUp the correct menu if exists,
# else clear the selection & select cell accordingly to @x,@y and popUp ...
#
#
# Arguments:
# w	- The table widget.
# x/y   - x/y coord in Table
# X/Y   - x/y coord in screen
proc ::tk::table::PopUp {w x y X Y} {
    $w border mark $x $y
    
    set Idx [$w index @$x,$y]
      

    if {  ![$w tag includes title $Idx] &&  [$w selection includes $Idx] == 0 } {
      #dbg tixTable "::tk::table::PopUp :  selection clear all"
      $w selection clear all
 # 	if {[$w tag includes title $Idx]} {
#  	    ::tk::table::BeginSelect $w $Idx
#  	    $w activate $Idx
#  	} else {
        $w selection set @$x,$y
# 	}
}

  tixTable:colPopUpMenu [winfo parent $w]  $Idx $X $Y	 

}

# ::tk::table::MoveCell --
#
# Moves the location cursor (active element) by the specified number
# of cells and changes the selection if we're in browse or extended
# selection mode.
#
# Arguments:
# w - The table widget.
# x - +1 to move down one cell, -1 to move up one cell.
# y - +1 to move right one cell, -1 to move left one cell.

#if the width of column is 0 ommites this column and moves to the next not 0 column
proc ::tk::table::MoveCell {w dy dx} {
  set col [$w index active col]
  if { $dx != 0 } {
    if { $dx > 0 } {
      set deltaX 1
    } else {
      set deltaX -1
    }
    set col [incr col $dx ]
    set width [$w width $col]
    while { $width == 0 } {
      set col [expr  $col + $deltaX ]
      if { [::tk::table::IsValidCol $w $col true] } {
        set dx [expr  $dx + $deltaX ]
        set width [$w width $col]

      } else {
        break
      }
    }
  }
  ::tk::table::ReallyMoveCell $w $dy $dx
}
#this method originally was  ::tk::table::MoveCell , \
    now we call it from new ::tk::table::MoveCell in order to jump through 0 width columns
proc ::tk::table::ReallyMoveCell {w x y} {
  #dbg tixTable "::tk::table::ReallyMoveCell $x $y"
    if {[catch {$w index active row} r]} return
    set c [$w index active col]
  set newCol [expr {$c +  $y}]
  set newRow  [expr {$r+ $x}]
  # eyalz - we check if we can activate before, otherwise visual will get stuck!
  #irena : don't move if next cell is title or last cell in the table 
  dbg tixTable "newRow=$newRow newCol=$newCol"
  if {$newCol <= [$w cget -cols] && $newRow <= [$w cget -rows] && \
          [tixTable:isValidCol [winfo parent $w] $newCol 0]  && \
          [tixTable:isValidRow [winfo parent $w] $newRow 0] } { 
    dbg tixTable "CAN ACTIVATE"
    
    #if new cell is disabled
    if {  [$w tag includes dis $newRow,$newCol] } {
      $w activate $newRow,$newCol
    } elseif {[focus] != $w} {
        focus $w ; # Haya for emb-win
        $w activate $newRow,$newCol
    }

    $w see active
    switch [$w cget -selectmode] {
	browse {
	    $w selection clear all
	    $w selection set active
	}
	extended {
	    $w selection clear all
	    $w selection set active
	    $w selection anchor active
	    set ::tk::table::Priv(tablePrev) [$w index active]
	}
    }
    
    }
}

proc tk_tableCut { w } {
  #dbg tixTable "tk_tableCut"
  if {[selection own -displayof $w] == "$w"} {
    clipboard clear -displayof $w
    catch {
      clipboard append -displayof $w [selection get -displayof $w]
     # $w cursel set {}
     
      #Haya 24.7.00
      #![$w tag includes dis $row]

      #$w selection clear all
      tixTable:clearSelectedCells [winfo parent $w]

    }
  }
}
proc tk_tablePaste {w {cell {}} } {
  dbg tixTable "tk_tablePaste : cell=$cell"
  if {[catch {selection get -displayof $w -selection CLIPBOARD} data]} {
    return
  }
  if {![string compare {} $cell]} {
    set cell active
  }

  #irena : add catch"

  set changedCellsList [ tk_tablePasteHandler $w [$w index $cell] $data]

  
  if {[$w cget -state] == "normal"} {focus $w}
  return $changedCellsList
}
proc tk_tablePasteHandler {w cell data} {
  #dbg tixTable "tk_tablePasteHandler : cell = $cell \ndata=$data"
  set rows	[expr {[$w cget -rows]+[$w cget -roworigin]}]
  set lastRow [expr $rows - 1]
  set hiddenCols [[winfo parent $w] cget -hiddenColsForPaste]
  if { $hiddenCols== "" } {
    set hiddenCols [[winfo parent $w] cget -hiddenCols]
  }
  dbg tixTable "begin : cols=[$w cget -cols] colorigin=[$w cget -colorigin]"
  set cols	[expr [$w cget -cols] + [$w cget -colorigin]  + $hiddenCols]
  dbg tixTable "hiddenCols=$hiddenCols cols=$cols"

    set r	[$w index $cell row]
    set c	[$w index $cell col]

    # Haya  - so it won't touch the title
    set beginRow [expr [$w cget -roworigin] + [$w cget -titlerows]]
    if { $r < $beginRow } {
	set r $beginRow
   }
    set beginCol [expr [$w cget -colorigin] + [$w cget -titlecols]]
    if { $c < $beginCol } {
	set c $beginCol 
    }
    
    
    set rsep	[$w cget -rowseparator]
    set csep	[$w cget -colseparator]

 
     if { [string index $data 0 ] !="{" ||  [string index $data  [expr [string length $data] - 1 ] ] !="}" } {
       set data "{{$data}}"
     }
    ## Assume separate rows are split by row separator if specified
    ## If you were to want multi-character row separators, you would need:
    # regsub -all $rsep $data <newline> data
    # set data [join $data <newline>]
    if {[string comp {} $rsep]} { set data [split $data $rsep] }
    set row	$r

  #parent is tixTable
  set parent [winfo parent $w]
  set dataVar [$parent cget -variable]

#  set changedCellsList ""
  set oldData ""
  set newData ""

  #check that data is in list form
  set fail [catch {
    foreach line $data {
      #dbg tixTable "row=$row lastRow=$lastRow"
      #if {$row > $rows} break
      if {$row > $lastRow && [$parent cget -canAddRows] } { 
        $parent addrow [expr $row - 1] 
        incr lastRow
      }
      

	set col	$c
	## Assume separate cols are split by col separator if specified
	## Unless a -separator was specified
	if {[string comp {} $csep]} { set line [split $line $csep] }
	## If you were to want multi-character col separators, you would need:
	# regsub -all $csep $line <newline> line
	# set line [join $line <newline>]
	foreach item $line {
          dbg tixTable "col=$col cols=$cols"
          if {$col >= $cols} break
	    #Haya 24.7.00
	    if {![$w tag includes dis $row,$col] && [ tixTable:IsLegalValueForCell $parent  $col $item] } {
              
              set oldVal [$w get $row,$col]
              #$w set $row,$col $item
              set [set dataVar]($row,$col) $item
              #append changedCellsList $row,$col
              
              lappend oldData "$row,$col $oldVal"
              lappend newData "$row,$col $item"
              
	    }
	    incr col
	}
	incr row
    }
  }] ;#end catch and set fail

  if { $fail } {

    tk_messageBox -title Alert  -type ok  -icon error -message "Illegal data for pasting." 
  }
  dbg tixTable "pasteError: $::errorInfo"


#  return $changedCellsList
  #dbg tixTable "oldData=$oldData\n newData=$newData"
  return [list $oldData $newData]
}
proc ::tk::table::IsValidCol { w col checkTitle } {
  set origincol [$w cget -colorigin]
  set lastCol [ expr [$w cget -cols] +  $origincol - 1 ]
  if { $col < $origincol || $col > $lastCol } { return false } 
  if { $checkTitle} {
    set titleCol [expr $origincol + [$w cget -titlecols]]
    if { $col < $titleCol } {
      return false
    }
  }
  return true
}

# proc ::tk::table::CanResizeColumn { w index} {
#   #dbg tixTable "::tk::table::CanResizeColumn : index=$index"
#   return [tixTable:canResizeColumn $w [lindex [split $index ,] 1]]
# }



proc ::tk::table::InvokeButtonCell { w index } {
  tixTable:InvokeButtonCell $w $index
}

proc ::tk::table::CopySelected { w } {
  tixTable:copySelected [winfo parent $w]
}
proc ::tk::table::PasteSelected { w { pasteIndex "" } } {
  tixTable:pasteSelected [winfo parent $w] $pasteIndex
}

proc ::tk::table::CutSelected { w } {
  tixTable:cutSelected [winfo parent $w]
}


#Irena :::tk::table::BeginExtend is changed in order to  fix problem with extend for ComboBox

# ::tk::table::BeginExtend --
#
# This procedure is typically invoked on shift-button-1 presses. It
# begins the process of extending a selection in the table. Its
# exact behavior depends on the selection mode currently in effect
# for the table; see the Motif documentation for details.
#
# Arguments:
# w - The table widget.
# el - The element for the selection operation (typically the
# one under the pointer). Must be in numerical form.

proc ::tk::table::BeginExtend {w el} {
  #dbg tixTable "::tk::table::BeginExtend"
  catch {
    #irena : fix problem with extend for ComboBox
    set curselection [$w curselection]
    #dbg tixTable "curselection=$curselection"
    if { $curselection == ""} {
      set anchor ""
      catch {
        set anchor [$w index anchor]
      }
      if { $anchor != "" } {
        $w selection set $anchor
      }
    }
    
    if {[string match extended [$w cget -selectmode]] &&
        [$w selection includes anchor]} {
      ::tk::table::Motion $w $el
    }
  }
}

# ::tk::table::BeginToggle --
#
# This procedure is typically invoked on control-button-1 presses. It
# begins the process of toggling a selection in the table. Its
# exact behavior depends on the selection mode currently in effect
# for the table; see the Motif documentation for details.
#
# Arguments:
# w - The table widget.
# el - The element for the selection operation (typically the
# one under the pointer). Must be in numerical form.

proc ::tk::table::BeginToggle {w el} {
  #dbg tixTable "::tk::table::BeginToggle : el=$el"
  if {[string match extended [$w cget -selectmode]]} {
    
      set prevAnchor ""
      catch {
        set prevAnchor [$w index anchor]
      }
      variable Priv
      set Priv(tablePrev) $el
      
      $w selection anchor $el
      if {[$w tag includes title $el]} {
	    scan $el %d,%d r c
	    if {$r < [$w cget -titlerows]+[$w cget -roworigin]} {
		## We're in a column header
		if {$c < [$w cget -titlecols]+[$w cget -colorigin]} {
		    ## We're in the topleft title area
		    set end end
		} else {
		    set end [$w index end row],$c
		}
	    } else {
		## We're in a row header
		set end $r,[$w index end col]
	    }
	} else {
	    ## We're in a non-title cell
	    set end $el
	}
      
      #irena : fix problem with toggle for ComboBox
      set curselection [$w curselection]
      #dbg tixTable "curselection=$curselection"
      if { $curselection == "" && $prevAnchor != "" } {
        catch {
          $w selection set $prevAnchor
        }
      }
      #dbg tixTable "selection=[$w curselection] end=$end"
      if {[$w selection includes  $end]} {
        $w selection clear $el $end
      } else {
        $w selection set   $el $end
      }
    }
}
