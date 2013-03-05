#Irena : tixTable.tcl added to v2 - from Visual CVS verison 1.8
#irena : change rowheight to 2 - for TkTable 2.8
# Table.tcl --
#
# 	TixTable Widget: a frame box with a table
#

#tixTable flags :
#stayInCell - if true Left/Right arrow moves only inside the cell; Up and Down arrows are disabled as well 
#           - if false(default)  Left/Right arrow moves between cells ; after click on cell moves inside the cell
#fixedColumns - List of columns that will not be resizable,for ex. "-1 5"
#xscroll - if yes create xscrollbar
#yscroll - if yes create yscrollbar
#hiddenCols - number of hidden columns - columns that are not real table columns but are used for storing data only (used in declarations )

#NEW FLAG :
#hiddenColsForPaste - number of hidden columns that should be processed in Copy/Paste operation \
(sometimes there are hidden cols that we don't want to overwrite during paste,\
then these columns should be last , for example hiddenCols=3 and hiddenColsForPaste = 2)

#command - command that will be invoked when changing row in order to validate the previous row data\
 parameter is previous row
#rowtagsetcommand - command that will be invoked when changing row in order to set special tags of row cells \
 (is used in declarations for sm and fc) \
 parameter is current row
#canAddRows - if it is true some commands (for example,paste)  will add rows to table if needed - default is false, \
by default number of rows in table is constant

#cellCommand - callback method that will be invoked when cell is activated

#NEW FLAGS :
#deleteMode - may be "clear","delete","command","none" Default value is "clear"
#deleteCommand - command that will be bind to Del if deleteMode is "command"

#rowcommand - command that will be evaluated EVERY time after row is changed,
#parameters are previous row and current row

#Methods : 
#findWordInColumn - this method searches for the whole word in specific column ,is used for cause-end-effect
# if the word is found returns row number,else returns -1

#setTraceForEmbeddededWin - traces all embeded windows variables
#removeTraceForEmbeddededWin - removes trace from all embeded windows variables
#add value parameter to canEditCell

#isTableEmpty - returns true if the table is empty - has no data

#new method:
#getBeginRow
#getMaxRow
#getMaxCol
#registerToggleWindowCommand - the same column can be associated with different embedded widgets,
#registerToggleWindowCommand should return appropriate widget depending on cell's row,column

#new options
#pasteCallback - call back method that will be called after paste with list of indexes of cells changed
#by paste as parameter; needed for peforming some application specific actions on changed cells (for example,
#disabling some cells)

#getDataCommand - command needed for representing tixTable data when tixTable itself is used as embedded window.
#setDataCommand - command needed for setting tixTable data when tixTable itself is used as embedded window.

#menuCallback - call back method that will be called before popup menu with the index of the active cell,
#if it returns menu the menu will be popuped.
#preserveRowTitles - don't remove or change row titles when moverow or clearrow - default value is true,
#is false for CTE


#new methods
#getEmbeddedWindow - returns embbeded window widget for specific column
#changeCellsValues -explicitly sets  value of table cells , supports undo - registrates typing information for undo
#startCompoundCommand - starts compound command in undo manager
#endCompoundCommand - ends  compound command in undo manager
#getPrevActiveIndex - returns previously active index in the table
#selectColumns - selects columns from dpecified columns list
#getUndoManager - returns undo manager of the table (for use in ONLY in special cases)
#moveCol - move column to direction right, left, start, end.
#moveMergedCols - move merged columns (right, left, start, end), all table from a column till end must contain the same num of columns merged; used in CTE.
#sortMergedTitleText - sort and change the text of merged titles, used in CTE.

proc dbg {args} {
}
tixWidgetClass tixTable {
  -classname TixTable
  -superclass tixPrimitive
  -method {active activate window saveactivedata coltitletag \
               setchkbtnimg colmenu colcenter delete insert fillcolbytag \
               disablecell disablerowrange enablerowrange  enablecell  mergetitle \
               selectincell selectrow selectColumns replaceincell \
               isdirty embwinsbind cursel pointedcell insertrow addrow \
               addcols removecols clearrow clearcell colsort \
               sortMergedTitleText find findnext findprev \
               fillSelectedCells isEmptyRow isTableEmpty \
               ShowEmbWidget rowmenu cellmenu  canModifyCell canEditCell \
               clearSelectedCells pasteSelected copySelected cutSelected deleteSelectedRows \
               moveRow deleteSelectedCellsOrRows \
               isValidRow findWordInColumn undo redo startCompoundCommand endCompoundCommand setTraceForEmbeddededWin removeTraceForEmbeddededWin \
               getBeginRow getMaxRow getMaxCol registerToggleWindowCommand getEmbeddedWindow changeCellsValues \
             getPrevActiveIndex moveCol moveMergedCols getUndoManager getSelectedRowsList deleteRow }
    -flag {
      -cols -rows -variable -command -center -xscroll -yscroll -fixedColumns -stayInCell -rowtagsetcommand \
          -canAddRows -cellCommand -undo -undoLimit -deleteMode -deleteCommand -rowcommand -pasteCallback \
          -menuCallback -preserveRowTitles

    }
    -static {}
    -configspec {
      {-center center Center {} }
      {-colorigin colOrigin ColOrigin -1}
      {-cols cols Cols 10}
      {-hiddenCols hiddenCols HiddenCols 0}
      {-hiddenColsForPaste hiddenColsForPaste HiddenColsForPaste "" }
      {-command command Command {} }
      {-rowtagsetcommand rowtagsetcommand Rowtagsetcommand {} }
      {-rowcommand rowcommand Rowcommand {} }
      {-padx padX PadX 2}
      {-pady padY PadY 2}
      {-rows rows Rows 10}
      {-roworigin rowOrigin RowOrigin -1}
      {-state state State normal}
      {-titlecols titleCols TitleCols 1}
      {-titlerows titleRows TitleRows 1}
      {-variable variable Variable {} }
      {-xscroll xscroll Xscroll "yes" }
      {-yscroll yscroll Yscroll "yes" }
      {-fixedColumns fixedColumns FixedColumns -1}
      {-stayInCell stayInCell StayInCell false }
      {-canAddRows canAddRows CanAddRows false }
      {-cellCommand cellCommand CellCommand ""}
      {-undo undo Undo 0}
      {-undoLimit  undoLimit  UndoLimit  10}
      {-deleteMode deleteMode DeleteMode "clear" }
      {-deleteCommand deleteCommand DeleteCommand "" }
      {-pasteCallback pasteCallback PasteCallback "" }
      {-menuCallback menuCallback MenuCallback "" }
      {-getDataCommand getDataCommand  GetDataCommand "" }
      {-setDataCommand setDataCommand SetDataCommand "" }
      {-preserveRowTitles preserveRowTitles PreserveRowTitles 1 }
      {-cellselectbackground cellSelectBackground CellSelectBackground "#000000008080"}
    }
    -alias {}
    -default {}
}



#----------------------------------------------------------------------
# Public methods
#----------------------------------------------------------------------

proc tixTable:ConstructWidget {w} {

    upvar #0 $w data

    tixChainMethod $w ConstructWidget

#    #for excel-like behaviour
#    
#    set data(lastEditIndex) "" ;#index of the last edited cell of type Entry
#    set data(lastValue) ""
#######################################
    set  data(w:scrollbarx) ""
    set  data(w:scrollbary) ""

    set data(undoRedoMode) 0 

    #indicates if Button 1 was already pressed before this in the cell 
    # if true Left/Right arrow move inside the cell,if false - move to the next cell    
    set data(incell_mode) false
    
    set data(menuWin) ""

    # holds the last active col/row
    set data(lastCol) ""
    set data(lastRow) ""
    set data(lastComRow) ""
    
    set data(clipData)  ""

    # holds the cell which is pointed by mouse button (B3)
    # after the selection, if occur, else select this cell
    set data(curCell) ""
    #holds list of not resizable columns
    #set data(fixColumnsList) ""
    # hold the list of cols that have check-button for 
    # embedded win, because except of the standard set for
    # the cell, need to put the right image !!
    set data(chkbtncollist) ""

    set data(btncollist) ""
    set data(btnColTagPairList) ""
    # points if to exec -command and -rowtagsetcommand and -rowcommand or not
    set data(activeCmd) 1
    #if insureRowTagCmd is 1 -rowtagsetcommand will be invoked even if row didnt't changed(needed for paste)
    set data(insureRowTagCmd) 0

    #create undo manager
    if { $data(-undo) } {
      set data(undoManager) [DoUndoCompound #auto -stackSize $data(-undoLimit) ]
    } else {
      set data(undoManager) ""
    }
      
    
    set data(traceProcName) ""

    global tcl_platform
    if { $::tcl_platform(platform) != "unix" } {
      set visual_font_title  "-*-Ms Sans Serif-bold-r-*-*-8-*-*-*-*-*-*-*"
    } else {
      set visual_font_title  -adobe-helvetica-bold-r-normal-*-14-*-*-*-*-*-*-*
    }
    if {($data(-rows) >= 0) && ($data(-cols) >= 0) } {
                         
                             
      set data(w:table) [table $w.table \
                             -variable $data(-variable) \
                             -rows $data(-rows) \
                             -cols $data(-cols) \
                             -titlerows $data(-titlerows)  \
                             -titlecols $data(-titlecols)  \
                             -roworigin $data(-roworigin)  \
                             -colorigin $data(-colorigin)  \
                             -width 0 -height 0 \
                             -rowheight 1 -colwidth 8 \
                             -selectmode extended \
                             -state $data(-state) \
                             -rowstretch none -colstretch unset \
                             -resizeborder col \
                             -coltagcommand "tixTable:colProc $w" \
                             -selecttitles 0  \
                             -drawmode compatible  \
                             -browsecommand "tixTable:ShowEmbWidget $w %S" \
                             -selectioncommand "tixTable:SelectCommand $w %S" \
                            -padx 0 \
                            -pady 1]



                             
	
      tixTable:AddYScrollBar $w
      
      tixTable:AddXScrollBar $w
      


	# Set Title
      ;#$data(w:table) height -1 2
      #specifying "dis" tag at the beginning so that it will have the highest priority
      $data(w:table) tag configure dis -bg gray76 -state disabled 
      $data(w:table) tag configure title -anchor c \
          -relief raised -bg gray -fg black -font $visual_font_title 
       $data(w:table) tag configure empty -anchor c \
          -relief raised -bg gray -fg black -image [::UI::getimage empty]
      $data(w:table) tag configure West -anchor w -bg white 
      $data(w:table) tag configure Center -anchor c -bg white 

      $data(w:table) tag configure sel -bg $data(-cellselectbackground) -fg white; #change to blue
      $data(w:table) tag configure active -bg white -fg black
	# keeps the row number of the first real row (not title)
	#set data(w:titleRow) [expr [$data(w:table) cget -roworigin] + [$data(w:table) cget -titlerows]]


	#set data(w:titleCol) [expr [$data(w:table) cget -colorigin] + [$data(w:table) cget -titlecols]]
	
	set originCol [$data(w:table) cget -colorigin]     
	set maxCol [expr $data(-cols) + $originCol]
      
	    
	$data(w:table) width $originCol 3
	for {set i $originCol } {$i < $maxCol} {incr i} {
	    set data(w:$i) {}
	    set data(w:menu_$i) {}
        }
      set data(w:menu_row) ""
      set data(w:menu_cell) ""
      set data(w:menu_cellfocus) ""
      
      
      
    }
    

    tixTable:Pack $w

}	
proc tixTable:AddXScrollBar { w  } {
  upvar #0 $w data
  if {$data(-xscroll) == "yes" && $data(w:scrollbarx) == "" } {
    set data(w:scrollbarx) [scrollbar $w.sx \
                                -command [list $data(w:table) xview] \
                                -orient horizontal  -takefocus 0 ]
    $data(w:table) config  -xscrollcommand  "$data(w:scrollbarx) set"
  }
}

proc tixTable:AddYScrollBar { w  } {
  upvar #0 $w data
  if {$data(-yscroll) == "yes" && $data(w:scrollbary) == ""} {
    set data(w:scrollbary) [scrollbar $w.sy \
                                -command [list $data(w:table) yview] -takefocus 0 ]
    $data(w:table) config -yscrollcommand  "$data(w:scrollbary) set"

  }
}
proc tixTable:Destructor { w } { 

    upvar #0 $w data
    destroy $data(w:table)
    if { $data(w:scrollbary) != ""} {
    destroy $data(w:scrollbary) 
    }
    if { $data(w:scrollbarx) != ""} {
    destroy $data(w:scrollbarx)
    }
    if { $data(undoManager)!="" } {
      delete object $data(undoManager)
      set $data(undoManager) ""
    }
    tixChainMethod $w Destructor
    

}

proc tixTable:colProc {w col} { 
    upvar #0 $w data
    if { [lsearch $data(-center) $col] != -1 } { 
	return Center 
    } else {
	return West
    }
}


# effects only on redrawing

proc tixTable:colcenter {w args} {
    
    upvar #0 $w data
    set  data(-center) $args

} 





# set the cell's text by the embedded window value 
proc tixTable:SaveLastCellData { w row col } {

    upvar #0 $w data
    #dbg tixTable "======SaveLastCellData========"
    set winType [winfo class $data(w:$col)]
    if { [$w canModifyCell $row,$col] && ( $data(var$col) != {} || $winType == "TixTable") } {
      if {$winType == "TixTable" } {
        set getDataCommand [$data(w:$col) cget -getDataCommand]
        dbg tixTable "getDataCommand=$getDataCommand"
        if { $getDataCommand != "" } {
          set val [eval $getDataCommand]
        }
      } else {
        if {[string first "@itcl" $data(var$col)] == -1} {
          variable $data(var$col)
        }
        if { $winType=="TixComboBox" && (![$data(w:$col) cget "-editable"] || [$data(w:$col) cget -validatecmd] != "") } {
          set val [set $data(var$col)] 
        } else {
          set val [string trim [set $data(var$col)] ]
        }
        if {$winType == "Checkbutton"} {
          
          if {[string compare $val [$data(w:$col) cget -offvalue]] == 0} {
            $data(w:table) tag cell data(offImg_$col) $row,$col
          } else {
            $data(w:table) tag cell data(onImg_$col) $row,$col
          }
        }
      }
      set oldVal [$data(w:table) get $row,$col]
      #dbg tixTable "SaveLastCellData: oldVal=$oldVal val=$val"
      if { [string compare $oldVal $val ]!= 0 } {
        $data(w:table) set $row,$col $val
        if { $data(-undo) } {
            tixTable:RegisterTypingDoUndo $w $row $col $oldVal $val         
        }
      }
    }
  }

#set the right image according to the cell value
proc tixTable:setchkbtnimg {w row col} {
  upvar #0 $w data

  if {![$w canModifyCell $row,$col] || ![info exists data(w:$col)] } {
    return
  }
    
    set val [$data(w:table) get $row,$col]

    #dbg tixTable "setchkbtnimg : row=$row col=$col val=$val"

  if { [string compare $val [$data(w:$col) cget -onvalue]] == 0 } {
#	if {[ $data(w:table) tag exists data(onImg_$col) ]} {
      
      #dbg tixTable "set tag onImg_$col ...."
      $data(w:table) tag cell data(onImg_$col) $row,$col
      #	}
    } else {
      #	if {[ $data(w:table) tag exists data(offImg_$col) ]} {	 
      #dbg tixTable "set tag offImg_$col ...."
      $data(w:table) tag cell data(offImg_$col) $row,$col
      $data(w:table) set $row,$col [$data(w:$col) cget -offvalue]
      #	} 
    }
}

# args - if exists should be : "col"/"row" 
proc tixTable:active {w args} {
    upvar #0 $w data

    if { $args == "" } {
	return [$data(w:table) index active]
    } else {
	return [$data(w:table) index active $args]
    }
}

proc tixTable:cursel { w } {
    upvar #0 $w data
    return [$data(w:table) cursel]
}

proc tixTable:activate { w {index ""}} {

    upvar #0 $w data
   
    if { $index == ""  } {

	#set to zero, so won't evaluate -command !!		
	set data(activeCmd) 0

	# set activate
	$data(w:table) activate @0,0

	#set back to TRUE		
	set data(activeCmd) 1

    } else {
	
	$data(w:table) activate $index
    }
}
#activates index without evaluating command
proc tixTable:ActivateSilently { w index} {
  upvar #0 $w data
  #set to zero, so won't evaluate -command !!		
  set data(activeCmd) 0
  catch {
    # set activate
    $data(w:table) activate $index
  }
  #set back to TRUE		
  set data(activeCmd) 1
}
    
# works only for tables with col-title
# mark row as selected
proc tixTable:selectrow { w row } {
  upvar #0 $w data
    # title row not allowed
    if {![tixTable:isValidRow $w $row 0]} {
	return
    }
    ::tk::table::BeginSelect $data(w:table) \
	$row,[$data(w:table) cget -colorigin]
    tixTable:invokeRowCommand $w $row
}
#private
proc tixTable:SelectColumn { w col {flag "select"}} {
  upvar #0 $w data

    # title col not allowed
    if {![tixTable:isValidCol $w $col 0]} {
	return
    }

    ::tk::table::BeginSelect $data(w:table) \
	[$data(w:table) cget -roworigin],$col $flag
}

#alexz: flag - "select" (causes unselect all before selection) or "extend"
proc tixTable:selectColumns { w collist {flag "select"} } {
  upvar #0 $w data
  set first 1
  foreach col $collist {
    # title col not allowed
    if {[tixTable:isValidCol $w $col 0]} {
      if {$first } {
	::tk::table::BeginSelect $data(w:table) \
	[$data(w:table) cget -roworigin],$col $flag
        set first 0
      } else {
        ::tk::table::BeginToggle $data(w:table) \
	[$data(w:table) cget -roworigin],$col 
      }
    }
  }
}

proc tixTable:SelectColumnByXInLabel { w x y labelWidget} {
  upvar #0 $w data
  set index [tixTable:GetIndexByXInLabel $w $x $y $labelWidget]
  if { $index!="" } {
    set col [lindex [split $index ,] 1]
    tixTable:SelectColumn $w $col
  }
}

proc tixTable:GetIndexByXInLabel { w x y labelWidget} {
  upvar #0 $w data

  #define column number from x,y
  set startCol ""
  set index ""
  foreach mergeTableItem $data(mergeTable) {
    set labelPath [lindex $mergeTableItem 2]
    if {$labelPath == $labelWidget } {
      set startCol [lindex $mergeTableItem 1]
    }
  }


  if { $startCol != "" } {
    #define x coord of label start
    set row [$data(w:table) cget -roworigin]
    set startX [expr  [lindex [$data(w:table)  bbox $row,$startCol] 0] +1 ]
    set colX [expr $x + $startX]
    set index [$data(w:table) index @$colX,$y]
  }
  return $index
}


proc tixTable:selectincell { w row col boffset eoffset } {
    upvar #0 $w data

    if {![tixTable:isValidRow $w $row]} {
	return
    }

    # don't allow title col
    if {![tixTable:isValidCol $w $col 0]} {
	return 
    }

    #alexz - fix for columns with toggle command
    if {$data(w:$col) != ""} {
      set win [tixTable:GetEntryWidget $data(w:$col)]
    } elseif { [info exists data($col:toggleWindowCommand)] && $data($col:toggleWindowCommand) !=""} {
      set wcmd $data($col:toggleWindowCommand)
      lappend wcmd $row $col
      set widget [eval $wcmd]
      set win [tixTable:GetEntryWidget $widget]
    }
    if {$win != "" } {

        # set activate
        #$data(w:table) activate $row,$col
        tixTable:ActivateSilently $w $row,$col
        update
        focus $win
    
        # set selection
        $win selection clear; $win selection from $boffset; $win selection to $eoffset
    }
}	

proc tixTable:replaceincell { w boffset eoffset newVal } {
    upvar #0 $w data
    set rowcol ""
    catch {
        set rowcol [$data(w:table) index active]
    }
    if { $rowcol == "" } { 
	return
    }

    set col [lindex [split $rowcol ,] 1]
    set win [tixTable:GetEntryWidget $data(w:$col)]
    if {$win!=""} {
        # replace
        $win delete $boffset $eoffset
        $win insert $boffset $newVal
    }
}	

proc tixTable:isdirty {w} {

    upvar #0 $w data

    set col [$data(w:table) index active col]

    if { $col != "" && $data(w:$col) != {} && \
	     [set $data(var$col)] !=  [$data(w:table) get active]} {
	return 1
    }
    return 0
    
}

proc tixTable:disablecell {w row col} {
   
    upvar #0 $w data

    # don't allow title row
    if {![tixTable:isValidRow $w $row 0]} {
	return
    }
    
    # don't allow title col
    if {![tixTable:isValidCol $w $col 0]} {
	return 
    }

    $data(w:table) window config $row,$col -window {}
    
    $data(w:table) tag cell dis $row,$col
}
proc tixTable:enablecell {w row col} {
   
    upvar #0 $w data

    # don't allow title row
    if {![tixTable:isValidRow $w $row 0]} {
	return
    }
    
    # don't allow title col
    if {![tixTable:isValidCol $w $col 0]} {
	return 
    }
   
   #remove disabled tag - clear tags
    $data(w:table) tag cell {} $row,$col
}
proc tixTable:enablerowrange {w beginrow endrow } {
  upvar #0 $w data
  if { $endrow != "end" } {
    incr endrow 1
  } else {
    set endrow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
  }
  for { set row $beginrow } { $row < $endrow } {incr row} {
    $data(w:table) tag row {} $row
  }
  
}
proc tixTable:disablerowrange {w beginrow endrow } {

    upvar #0 $w data

    # don't allow title row
  if {![tixTable:isValidRow $w $beginrow 0]} { return }

    if { $beginrow == $endrow } {
      $data(w:table) tag row dis $beginrow
      return
    } elseif { $endrow != "end" } {
      
      if {![tixTable:isValidRow $w $endrow 0]} { return }
      # so row number  endrow will be included
      incr endrow 1
    } else {
      set endrow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
    }
    for { set row $beginrow } { $row < $endrow } {incr row} {
      $data(w:table) tag row dis $row
    }
}

proc tixTable:saveactivedata { w {deactivate 1} } {

    upvar #0 $w data
    #add here check of disabled tag

    set col $data(lastCol)
    #dbg tixTable "saveactivedata : col=$col lastRow=$data(lastRow)"
    if { $col != "" } {
      if { $data(w:$col) != {} }   {
        #dbg tixTable "saveactivedata :actually save $data(lastRow),$col"
        tixTable:SaveLastCellData $w  $data(lastRow) $col
      }
      if {$deactivate} {
        $w activate ""
      }
    }
    
}



proc tixTable:canModifyCell {w index } {
  upvar #0 $w data
  if { ![$data(w:table) tag includes dis  $index ] && ![$data(w:table) tag includes title  $index ]} {
    return 1
  } else {
    return 0
  }
}



proc tixTable:canEditCell {w index {value ""} } {
  upvar #0 $w data

#check for not editable boxes
  set canEdit 0
  if { [$w canModifyCell $index] } {
    set col [lindex [split $index ,]  1]
    
    if { [winfo exists $data(w:$col)] &&  $data(w:$col)!= {} } {
      set winType [winfo class $data(w:$col)]
      if { $winType == "TixComboBox"} {
        if { [$data(w:$col) cget -editable] } {
          set canEdit  1
        } elseif { $value!=""} {
          if { [tixTable:IsLegalValueForCell $w $col $value]} { set  canEdit  1 }
        }
      } elseif { $winType == "Entry" } {
        if { [$data(w:$col) cget -state] == "normal" } {
          set canEdit  1
        }
      } elseif {$winType == "TixComboTable"} {
        set canEdit 0
      }  else {
        set canEdit  1
      }
    } else {
      set canEdit  1
    }
    
  }

  return $canEdit

}

# set the value of the embedded window by the value of the textual cell
proc tixTable:PutCurCellData { w } {
  #dbg tixTable "PutCurCellData"
  upvar #0 $w data
 
  catch { 
  
    if { [$w canModifyCell  [$data(w:table) index active]] } {
      
      set col [$data(w:table) index active col]
    
      
      if {$data(var$col) != {}} {
        
        #
        # eyalz: I added the next line for the new attributes:
        # it is just a temporary fix. The tixtable widget should
        # know how to work properly with [incr tcl] objects
        #
        if {[string first "@itcl" $data(var$col)] == -1} {
          variable $data(var$col)
        }
	set $data(var$col) [$data(w:table) get active]
	
      } else {
        set winType [winfo class $data(w:$col)]
        if { $winType == "TixTable" } {
          set table $data(w:$col)
          set setDataCommand [$data(w:$col) cget -setDataCommand]
          dbg tixTable "setDataCommand=$setDataCommand"
          if { $setDataCommand != "" } {
            eval [list $setDataCommand [$data(w:table) get active]]
          }
          
        }
      }
    }
  }
}


proc tixTable:SetCheckButtonTags { w col } {

    upvar #0 $w data

    #dbg tixTable "SetCheckButtonTags $col"
    $data(w:table) tag config data(onImg_$col) \
	-image [$data(w:$col) cget -selectimage]
#    dbg tixTable "SetCheckButtonTags : selectimage=[$data(w:$col) cget -selectimage]"
    $data(w:table) tag config data(offImg_$col) \
	-image [$data(w:$col) cget -image]
#    #dbg tixTable "PAY ATTENTION !!! : SetCheckButtonTags : image=[$data(w:$col) cget -image]"
	
    # the number from which we start to count the rows
    set originrow [$data(w:table) cget -roworigin]
    
    # the num of the last row 
    set lastRow [ expr $data(-rows) +  $originrow]
    
    # the first real row number (== not title)
    set beginRow [expr  $originrow + [$data(w:table) cget -titlerows]]
    
    for {set row $beginRow} { $row < $lastRow } { incr row } {
      #irena
      if { [string compare [$data(w:table) get $row,$col] [$data(w:$col) cget -onvalue]] != 0 } {
        $data(w:table) tag cell data(offImg_$col) $row,$col
        $data(w:table) set $row,$col [$data(w:$col) cget -offvalue]
      }
    }

    if { [lsearch -exact $data(chkbtncollist) $col] == -1 } {
	lappend data(chkbtncollist) $col
    }
} 
	






proc tixTable:SetBindings {w} {

    upvar #0 $w data
    tixChainMethod $w SetBindings
    if { $data(-undo) } {
      bind $data(w:table) <Control-z> "tixTable:undo $w;break"
      bind $data(w:table) <Control-Z> "tixTable:undo $w;break"
      bind $data(w:table) <Control-y> "tixTable:redo $w;break"
      bind $data(w:table) <Control-Y> "tixTable:redo $w;break"
    }
    
    if { $data(-state) != "disabled" } {
      if { ![string compare $data(-deleteMode)  "delete"] } {
        bind $data(w:table) <Delete> "$w deleteSelectedCellsOrRows"
      } elseif {  ![string compare $data(-deleteMode)  "clear"] } {
        bind $data(w:table) <Delete> "$w clearSelectedCells"
      } elseif {  ![string compare $data(-deleteMode)  "command"] } {
        bind $data(w:table) <Delete> "eval $data(-deleteCommand) $w"
      }
     
    }
}



proc tixTable:ShowEmbWidget { w rowcol args} {
    global tcl_platform
  
    upvar #0 $w data

    set data(incell_mode) false

    if { $data(-state) == "disabled" } return

    set row [lindex [split $rowcol ,] 0]
    set col [lindex [split $rowcol ,] 1]
    

    
    # the first real row number (== not title)
    set beginRow [expr [$data(w:table) cget -roworigin] \
		      + [$data(w:table) cget -titlerows]]



    
    if { $data(activeCmd) &&  $data(-rowtagsetcommand) != "" && $data(lastCol) != "" \
             && ($data(lastRow) >= $beginRow) } {
      #eval -rowtagsetcommand
      if  {$data(lastRow) != $row || $data(insureRowTagCmd)  } {
        eval $data(-rowtagsetcommand) $row
        set data(insureRowTagCmd) 0
      }
    }

    # check if cell is disabled
    set isDisable [$data(w:table) tag includes dis $rowcol]

    # if it's not the first time we click on cell &&
    # the last row we clicked on was not a title &&
    # the last column holds embedded window
    if { ($data(lastCol) != "" ) && ($data(lastRow) >= $beginRow ) && \
             ($data(w:$data(lastCol)) != {})} {
      # check if last cell was disabled
      set wasDisable [$data(w:table) tag includes dis \
                          $data(lastRow),$data(lastCol)]
      
      # the last cell is not disable
      if {$wasDisable == 0} {   
        
        if { !$data(undoRedoMode) } {
          tixTable:SaveLastCellData $w $data(lastRow)  $data(lastCol)
        }
	    # if cur row we clicked on is title ||
        # the cur col & last col are different ||
        # the cur col is disabled
        if {($row < $beginRow) || ($isDisable) || \
            ($data(lastCol) != $col)} { 
          #dbg tixTable "remove old win"
          $data(w:table) window config $data(lastRow),$data(lastCol) \
              -window {} -relief flat -bg white
        }
      }
    }

  if { $data(-cellCommand) != "" } {
#    eval [ list $data(-cellCommand) $w $row $col]
    eval $data(-cellCommand) $w $row $col
  }
  
  # if the cur row we clicked on is not a title &&
  # the cur column holds embedded window &&
  # the cur cell is not disable
  if { ($row >= $beginRow) && ($isDisable == 0)} {
    #if window's widget can be toggled
    if { [info exists data($col:toggleWindowCommand)] && $data($col:toggleWindowCommand) !=""} {
      #set widget [eval [list $data($col:toggleWindowCommand) $row $col] ] ;#alexz - replaced by the next:
      set wcmd $data($col:toggleWindowCommand)
      lappend wcmd $row $col
      set widget [eval $wcmd]
      if {$data(w:$col) != $widget} {
        #attach another widget to the window
        if { $data(lastRow) != "" } {
          $data(w:table) window config $data(lastRow),$data(lastCol) \
              -window {} -relief flat -bg white
        }
        $w window $col $widget
        tixTable:UpdateTraceForEmbeddededWinByCol $w $col; #fix bug 20624
      }
    }
    if { ($data(w:$col) != {}) } {
	
      tixTable:PutCurCellData $w
      $data(w:table) window config $rowcol \
	  -sticky news -padx 0 -pady 0 -window $data(w:$col) -relief flat -background white

      set winType [winfo class $data(w:$col)] 
     
      if {$winType == "FileChooser" || $winType == "DesignInstanceChooser"} {
        set win [$data(w:$col) component entry]
        update idle
        focus $win
        $win icursor end
      } elseif { $winType != "TixTable" } {
      #irena - add update
        update idle
        focus $data(w:$col)
      } else {
        #for TixTable
        $data(w:$col) activate 0,0
        focus [$data(w:$col) getEmbeddedWindow 0]
      }
      switch $winType {
        Entry {	    $data(w:$col) icursor end }
        
        Checkbutton -
        Button {
          if { $::tk::table::Priv(PressedIndex) == $rowcol } {
            update idletasks
            update
            $data(w:$col) invoke 
          }
        } 
        TixComboBox  { 
          catch {
            set tabValue [$data(w:table) get $rowcol] 
            if {[ $data(w:$col) cget -value ] != $tabValue } {
              $data(w:$col) config -value $tabValue
            } 
          }
          #irena : this is in order to fix problem with multiple selection for Comboboxes with Shift-1,contrlo-1 (fix bug 19725)
          $data(w:table) selection anchor $rowcol
        }
     }
    } 
  }
      ###########################

      
    
    set ::tk::table::Priv(PressedIndex) ""

    # if change row -> eval the command of tixTable if exists

    if { $data(activeCmd) && $data(lastCol) != "" &&
	 ($data(lastRow) >= $beginRow) && ($data(lastRow) != $row) } {
      if { $data(-command) != "" } {
        catch {
          eval [list $data(-command) $data(lastRow) ]
        }
      }
   }
  #invoke rowcommand if needed
  tixTable:invokeRowCommand $w $row
  
  
#     set data(prevRow) $data(lastRow)
#     set data(prevCol) $data(lastCol)

    set data(lastCol) $col
    set data(lastRow) $row

}

proc tixTable:invokeRowCommand { w row} {
  upvar #0 $w data
  
  dbg tixTable "tixTable:invokeRowCommand"
  catch {
    # check if valid row , title-row not allowed
    if { $data(-rowcommand)!="" && $data(activeCmd) && ($data(lastComRow)!=$row) && [tixTable:isValidRow $w $row 0 ]} {
      eval [list $data(-rowcommand) $data(lastComRow) $row]
      set data(lastComRow) $row
    }
  }
  dbg tixTable "rowCommand Error=$::errorInfo"
}
# check if the given column is vaild : 
# check if : numeric + exists in the table
# if (title == 0) ==>  don't allow title col 
proc tixTable:isValidCol { w val { title 1} } {
    upvar #0 $w data
    
    # the number from which we start to count the cols
    set origincol [$data(w:table) cget -colorigin]
    
    # the num of the last row 
    set lastCol [ expr $data(-cols) +  $origincol - 1 ]
    
    set result [catch { 
	if { ($val + 0) < $origincol || $val > $lastCol } { return false } }]
    
    switch $result {
	0 { 
	    # if val belong to title => not valid
	    if { $title == 0 } {
		set titleCol [expr $origincol + [$data(w:table) cget -titlecols]]
		if { $val < $titleCol } {
		    dbg tixTable "Column $val is out of range\n"
		    return 0 
		}
	    }   
	}
	1 { 	
	    #if val non-numeric
	    dbg tixTable "Expected integer but got $val\n"
	    return 0
	}
	2 {
	    # if col doesn't exists in table 
	    dbg tixTable "Column $val is out of range\n"
	    return 0
	}
    }
    return 1
}
    
# check if the given row is vaild : 
# check if : numeric + exists in the table
# if (title == 0) ==>  don't allow title row 
proc tixTable:isValidRow { w val {title 1} } {
    upvar #0 $w data

    # the number from which we start to count the rows
    set originrow [$data(w:table) cget -roworigin]

    # the num of the last row 
  
  set lastRow [ expr $data(-rows) +  $originrow - 1 ]

  set result [catch { 
	if { ($val + 0) < $originrow || $val > $lastRow } { return false } }]

    if { $result == 1 } {
	dbg tixTable "Expected integer but got $val\n"
	return 0
    } elseif { $result == 2 } { 
	dbg tixTable "Row $val is out of range\n"
	return 0	    
    } else {
	# if val belong to title => not valid
	if { $title == 0 } {
	    set beginOrdinaryRow [expr $originrow + [$data(w:table) cget -titlerows]]
	    if { $val <  $beginOrdinaryRow } {
		dbg tixTable "Row $val is out of range\n"
		return 0 
	    }
	}
    }

    return 1
}


# turn on tag in col-title by given row
proc tixTable:coltitletag { w row tagon } {
    
    upvar #0 $w data

    # check if valid row , title-row not allowed
    if {![tixTable:isValidRow $w $row 0 ]}  return

    if {![$data(w:table) tag exists $tagon]} {
	puts "Tag $tagon doesn't exist"
	return
    }
    
    # check if define title-cols
    if {![$data(w:table) cget -titlecols]} {
	puts "Title Colunm in Table $w doesn't exist"
	return
    }

    # get the first title col
    set col [$data(w:table) cget -colorigin]
	        
    # turn on the wanted row
    $data(w:table) tag cell $tagon $row,$col
	
    #set to zero, so won't evaluate -command !!		
    set data(activeCmd) 0
	
    # set activate
    $data(w:table) activate $row,$col
	
    #set back to TRUE		
    set data(activeCmd) 1
}

proc tixTable:NonNumeric { args } {
    return [catch { expr $args + 0 } ]
}

# check if the given value is numeric
# if numeric return 0 , else return 1 

proc tixTable:isNotNumric { val } {

    return [catch { expr $val }]

}
#ToggleWindowCommand  should return appropriate widget for window
proc tixTable:registerToggleWindowCommand {w col toggleWindowProc} {
  upvar #0 $w data
  set data($col:toggleWindowCommand) $toggleWindowProc
}
proc tixTable:window {w args} {
    upvar #0 $w data
#    dbg tixTable "tixTable:window w=$w args=$args"
    if { $args == "" } {
	puts "wrong # args: should be \"$w window colNum widget \[colNum widget...\]\""
	return
    }
    set listLen [llength $args]
    if {$listLen > 0} {
	if { [expr $listLen % 2] == 0 } {
	    for {set i 0} {$i < $listLen} {incr i} {
		set col [lindex $args $i]

		# check if the col is vaild
		# allow title col 
		if {![tixTable:isValidCol $w $col 1]} return
		    

		incr i 1	

		# get the embedded window pathname
		set data(w:$col) [lindex $args $i]

		# check if widget exist
		if { ![winfo exists $data(w:$col)] } {
		    puts "widget \"$data(w:$col)\" doesn't exist"
		    set data(w:$col) ""
		    return
		}

		# get the embedded window type
		set winType [winfo class $data(w:$col)]

		# get the embedded window var
		tixTable:GetWidgetVar $w $winType $col

		# set emb win bindings
		tixTable:SetWidgetBinds $w $winType $col

	    }
	} else {
	   puts "wrong # args: should be \"$w window colNum widget \[colNum widget...\]\""
         }
     }
}

proc tixTable:embwinsbind { w } {

    upvar #0 $w data


    set originCol [$data(w:table) cget -colorigin]     
    set maxCol [expr $data(-cols) + $originCol]
      
	   
    for {set i $originCol } {$i < $maxCol} {incr i} {
    
	if { $data(w:$i) != "" } {

	    # get the embedded window type
	    set winType [winfo class $data(w:$i)]

	    # set emb win bindings
	    tixTable:SetWidgetBinds $w $winType $i
	}
    }
}
    

proc tixTable:StoreClipboardOnRelease1 { w win } {
  upvar #0 $w data

  #dbg tixTable "========<StoreClipboardOnRelease1>========="
  if { [$win selection present] } {
    set prim ""
    catch {
      set prim [selection get -displayof $win -selection PRIMARY]
      #dbg tixTable  "<Release1> : prim=$prim"
    }
    if {$prim != "" && $prim!="{{}}" } {
      set data(clipData) $prim
      
    }

  }

}

proc tixTable:SetClipboardOnButton2 { w win } {
  upvar #0 $w data
  #dbg tixTable "========<SetClipboardOnButton2>========="
  if { $data(clipData) != "" } {
   #  clipboard clear  -displayof $data(w:table)
#     clipboard append -displayof $data(w:table) $data(clipData)
    clipboard clear  -displayof $w
    clipboard append -displayof $w $data(clipData)

    set data(clipData) ""

  }

}

proc tixTable:GetPasteData { w } {
  upvar #0 $w data
  #dbg tixTable "tixTable:GetPasteData "
  set prim ""   ;# primary buffer 
  set clip ""   ;# clipboard buffer

  set oneCellSelected 0
  if { [llength [$data(w:table) cursel]] <= 1 } {
    set oneCellSelected 1
  }
  catch {
    #dbg tixTable "PRIMARY selection =[selection get -selection PRIMARY]"
    set prim [selection get -selection PRIMARY]
    if { $prim == "{{}}" } {
      selection clear -displayof $w -selection PRIMARY
      set prim ""
    }
    if { $prim!="" } {
      #if nobody owns primary selection we save it to clipboard (it means it was selected outside the table)

      if {  [selection own -displayof $w -selection PRIMARY] == "" } {
        #store primary selection in clipboard"
        clipboard clear -displayof $w
        catch {
          clipboard append -displayof $w $prim
        } 
        selection clear -selection PRIMARY
      } 
      #dbg tixTable "prim=$prim\n"
      if { $oneCellSelected } {
        selection clear -displayof $w -selection PRIMARY
      }
      
      #dbg tixTable "new PRIMARY selection =[selection get -selection PRIMARY]"
    }
  }
  #dbg tixTable "error_prim=$::errorInfo"
  
  catch {
    set clip [selection get -selection CLIPBOARD]
    #dbg tixTable "clip=$clip"
    if  { $clip  == "{{}}" } {
        set clip ""
    }
  }
  #dbg tixTable "error_clip=$::errorInfo"

  set pasteData ""
  if {$clip != "" && $prim == ""} {
    set pasteData  $clip
  } elseif {$prim != ""  && $clip == ""} {
    set pasteData  $prim
  } elseif {  $clip != "" && $prim != ""} {
    #irena : to fix bug
    #dbg tixTable "clip=$clip prim=$prim clipData=$data(clipData)"
    if { ![string compare $data(clipData)  $prim] } {
      clipboard clear  -displayof $w
      clipboard append -displayof $w $data(clipData)
      set pasteData $data(clipData)
    } else {
      set pasteData $clip
    }
  }
  #dbg tixTable "clip=$clip"
  #dbg tixTable "pasteData=$pasteData"

  if { [string first "\n" $pasteData ] != -1 } { 
    tk_messageBox  -title Alert  -type ok \
        -icon error -message "Only one line of text must be selected for paste." -default ok
      return ""
  }
  
  return $pasteData
}
proc tixTable:PasteInCell { w win } {
  
  upvar #0 $w data
 #dbg tixTable "tixTable:PasteInCell  curValue=[$win get]"
  set pasteData [tixTable:GetPasteData $w]
  set changedCellsList {}
  catch {
    if { $pasteData !=""} {

      if { [string index $pasteData 0] == "{" && \
               [string index $pasteData  [expr [string length $pasteData] - 1 ]] =="}"  } {

        set changedCellsList  [tixTable:PasteLines $w]
        
      } else {

        $win insert insert $pasteData
      }
    }
  }
  #dbg tixTable "error_paste=$::errorInfo"
  return $changedCellsList
}
proc tixTable:ConfigWidgetDerivedFromLabelWidget { win } {
  #this is important in order to remove gray rectangle at the beginning of comboBox cell
  catch {
    pack forget [$win subwidget label]

  }
  [$win subwidget frame] config -borderwidth 0
  if {$::tcl_platform(platform) == "unix"} {
    $win config -borderwidth 1
  } else {
    $win config -borderwidth 1 -bg black  
  }
}

proc tixTable:SetEmbeddedTixTableBinds { w col} {
  upvar #0 $w data
  set table $data(w:$col)
  if {[$table cget -rows] != 1} { return }
  #bindings are currently for simple table - without titles, 1 row
  set lastCol  [expr [$table cget -cols]  + [$table cget -colorigin] -1]
  set firstWin [$table getEmbeddedWindow 0 ]
  set lastWin [$table getEmbeddedWindow $lastCol]
  
  bind $firstWin <Left>  "catch {::tk::table::MoveCell $data(w:table) 0 -1};break"
  bind $lastWin <Right>  "catch {::tk::table::MoveCell $data(w:table) 0 1};break"
  tixBind $lastWin <Tab> " ::tk::table::MoveCell $data(w:table)  0  1  ;break"
  tixBind $firstWin <Shift-Tab> "catch { ::tk::table::MoveCell $data(w:table)  0  -1 };break"
  
  for {set col 0} {$col<=$lastCol} {incr col} {
    set win [$table getEmbeddedWindow $col]
    bind $win <Up> "catch {::tk::table::MoveCell $data(w:table) -1 0; };break"
    bind $win <Down> "catch {::tk::table::MoveCell $data(w:table) 1 0; };break"
    bind $win <Return> "tixTable:MoveOrAddLine $w 1 0;break"

  }
}
proc tixTable:SetWidgetBinds { w winType col } {

    upvar #0 $w data

    switch $winType {
      Checkbutton -
      Button -
      Entry  { set win $data(w:$col)  } 
      TixFileEntry -
      TixFileField 
      {
        set win  [$data(w:$col) subwidget entry] 
        tixTable:ConfigWidgetDerivedFromLabelWidget $data(w:$col) 
      }
      FileChooser -  
      DesignInstanceChooser
      {
        set win [$data(w:$col) component entry]
      }
      TixComboBox  {
        set win  [$data(w:$col) subwidget entry] 
        set parent $data(w:$col)
        tixTable:ConfigWidgetDerivedFromLabelWidget $data(w:$col) 
      }
      TixComboTable { 
        set win  [$data(w:$col) subwidget entry] 
        set parent $data(w:$col)
         tixTable:ConfigWidgetDerivedFromLabelWidget $data(w:$col) 
      }
      TixTable {
        tixTable:SetEmbeddedTixTableBinds $w $col
        return ;
      }
      default { return }
    }
    bind $win <Escape>        "catch { tixTable:PutCurCellData $w }; break"

    if { [winfo class $win] == "Entry" } {
      set hasEntrySubwidget  true
    } else {
      set hasEntrySubwidget  false
    }
    
    bind $win <ButtonPress-1> "tixTable:SetIncellMode $w"
    if {  $hasEntrySubwidget} {
      bind $win <2> "tixTable:SetClipboardOnButton2 $w $win;tixTable:PasteInCell $w $win ;break" 
      bind $win <<Paste>> "tixTable:PasteInCell $w $win ;break" 
      
      bind $win <Control-v> "tixTable:PasteInCell $w $win ;break" 
      bind $win <Control-V> "tixTable:PasteInCell $w $win ;break" 
      bind $win <ButtonRelease-1> "tixTable:StoreClipboardOnRelease1 $w $win"
      bind $win <Delete> "tixTable:DeleteSelectedOnDeleteButton $w"
    }
    
	
    bind $win <3> "tixTable:ColPopUpMenuFromEmbeddedWindow $w $win  %X %Y "
    

   if { $winType == "TixComboBox" } {
     if { $data(-stayInCell) == "false"} {
       bind $win <Up>     "tixTable:SelectCombo $w $parent $win -1 0 $winType up ;break"
       bind $win <Down>   "tixTable:SelectCombo $w $parent $win 1 0 $winType down  ;break"
     }
     
     bind $win <Left>   "tixTable:SetAndMoveCombo $w $parent $win 0 -1 $winType left;break"
     bind $win <Right>  "tixTable:SetAndMoveCombo $w $parent $win 0 1 $winType right ;break"
     tixBind $win <Tab> "tixTable:SetAndMoveCombo $w $parent $win 0 1 $winType tab;break"
     tixBind $win <Shift-Tab> "catch {tixTable:SetAndMoveCombo $w $parent $win 0 -1 $winType tab }  ;break"
     bind $win <Return> "tixTable:ShowCombo $w $parent $win 1 0 $winType ;break"
   } else {
     
       if {$data(-stayInCell) == "false"} {
	   bind $win <Up>    "catch { ::tk::table::MoveCell $data(w:table) -1  0 };break"
	   bind $win <Down>  "catch {::tk::table::MoveCell $data(w:table)  1  0 };break"
       }

       
       bind $win <Left>  "tixTable:MoveLeftRight $w  $win 0 -1 ;break"
       bind $win <Right> "tixTable:MoveLeftRight $w  $win 0  1 ;break"
     

     tixBind $win <Tab> " ::tk::table::MoveCell $data(w:table)  0  1  ;break"
     tixBind $win <Shift-Tab> "catch { ::tk::table::MoveCell $data(w:table)  0  -1 };break"
     if {$winType == "Button" || $winType == "Checkbutton" } {
       bind $win <Return> "$win invoke ; break"
     } elseif {$winType == "TixComboTable"} { 
       ;
     } else  {
       bind $win <Return> "tixTable:MoveOrAddLine $w 1 0;break"
       #bind $win <Return> "catch {::tk::table::MoveCell $data(w:table) 1 0} ;break"
     } 
   }

  }
proc tixTable:SetIncellMode { w} {
upvar #0 $w data
#  #dbg tixTable "SetIncellMode"
  set data(incell_mode) true
}
proc tixTable:MoveLeftRight { w win dy dx } {
  upvar #0 $w data

  if { [winfo class $win] == "Entry" && ($data(incell_mode) || $data(-stayInCell)) } {
    tk::EntrySetCursor $win [expr {[$win index insert] + $dx } ]
  } else {
    catch {
      ::tk::table::MoveCell $data(w:table) $dy $dx
    }
  }
}



proc tixTable:MoveOrAddLine { w dy dx } {
  upvar #0 $w data
  #if we are in the last existing row in the table add empty row
  catch {
    set row [$data(w:table) index active row]
    set endrow [expr $data(-rows) + [$data(w:table) cget -roworigin] - 1 ]
    if { $row  == $endrow } {
      $w addrow $row
    } else {
      ::tk::table::MoveCell $data(w:table) 1 0 ;#CHECK THIS
    }
  }
}


proc tixTable:ShowCombo { w parent entry  dy dx winType} {
  upvar #0 $w data
#  dbg tixTable " -------->in ListBox =[wm state  [winfo toplevel [$parent subwidget listbox]]]"
  set top [winfo toplevel [$parent subwidget listbox]]
  set state [wm state $top]
  if { $state == "withdrawn" } {
    tixComboBox:ArrowDown $parent 
    tixComboBox:ArrowUp $parent 
  } else {
    tixComboBox:SetValue $parent [$entry get]
    tixTable:MoveCombo $w $parent $entry 0 0 $winType 
    
  }
  
}

proc tixTable:SelectCombo { w parent entry  dy dx winType dir} {
  
  set listbox [$parent subwidget listbox]
  set top [winfo toplevel $listbox]
  set state [wm state $top]

  if { $state == "normal" } {
    if { [$listbox  curselection] == "" && [$parent cget -editable]} {
      $listbox selection clear 0 end
      $parent config -selection [$listbox get 0]
      $listbox selection set 0
      $listbox selection anchor 0
      $listbox activate 0
      $listbox see 0
    } else {
      tixComboBox:EntDirKey $parent $dir
    }
  } else {
    tixTable:MoveCombo $w $parent $entry $dy $dx $winType 
  }
  
}


proc tixTable:SetAndMoveCombo { w parent entry  dy dx winType keyType } {
  upvar #0 $w data
  set top [winfo toplevel [$parent subwidget listbox]]
  set state [wm state $top]
  if { $state == "normal" } {
    tixComboBox:SetValue $parent [$entry get]
    tixTable:MoveCombo $w $parent $entry $dy $dx $winType 
  } else {
    #if left or right arrow
    if { $keyType != "tab" && ( $data(incell_mode) || $data(-stayInCell) ) } {
      tk::EntrySetCursor $entry [expr {[$entry index insert] + $dx } ]
    } else {
      tixTable:MoveCombo $w $parent $entry $dy $dx $winType 
    }
  }
}
proc tixTable:MoveCombo { w parent entry  dy dx winType {addHistory 1 }} {
  upvar #0 $w data
  set col [$data(w:table) index active col]
  set row [$data(w:table) index active row]
  set lastVal [$data(w:table) get $row,$col] 
  tixTable:SaveLastCellData $w $row $col

  #before escape save value in history if value changed

  set val [$entry get]
  if {$addHistory &&  $lastVal != $val && [$parent cget -editable] && [string trim $val] != "" } {
    $parent addhistory $val
    
  }
  tixComboBox:EscKey $parent
  tixTable:PutCurCellData $w;
  if { $dy != 0 || $dx != 0 } {
    ::tk::table::MoveCell $data(w:table) $dy $dx  
  }

}

proc tixTable:GetWidgetVar { w type col } {

  upvar #0 $w data
  
  if { $type == "Entry" } {
    set var [$data(w:$col) cget -textvariable]
    if { $var == {} } {
	    puts "Entry $data(w:$col) don't have variable to hold its value\n"
    } 
  } elseif {  $type == "TixComboBox" || $type == "TixComboTable" || $type == "TixFileEntry" || $type == "TixFileField" } {
    set var [[$data(w:$col) subwidget entry] cget -textvariable]
    
  } elseif { $type == "Checkbutton" } {
    
    set var [$data(w:$col) cget -variable]
    tixTable:SetCheckButtonTags $w $col
    
  } elseif { $type == "FileChooser" || $type == "DesignInstanceChooser"} {
     set var [[$data(w:$col) component entry] cget -textvariable]
  }  else {
    # deal also with button, which don't have variable
    if { $type == "Button" } {
      if { [lsearch -exact $data(btncollist) $col] == -1 } {
        lappend data(btncollist) $col
      }
    }
    set var ""
    
  }
  if { $var == {} && $type != "Button" } {
    puts "$type $data(w:$col) don't have variable to hold its value\n"
  } 
  set data(var$col) $var
  
}


proc tixTable:Pack {w} {
    upvar #0 $w data

  if { $data(w:scrollbary)!= "" } {
    grid $data(w:table) $data(w:scrollbary) -sticky news
  } else {
    grid $data(w:table)  -sticky news
  }
  if  { $data(w:scrollbarx)!= "" } {
    grid $data(w:scrollbarx) -sticky ew
  }
  

  grid columnconfig $w 0 -weight 1
  grid rowconfig    $w 0 -weight 1
  
    
}

proc tixTable:cellmenu {w menuPath} {
  upvar #0 $w data
  if { [winfo exists $menuPath] } {
    if { [winfo class $menuPath] == "Menu" } {
      set data(w:menu_cell) $menuPath
    } else {
      puts "$menuPath is not a Menu"
      return
    }
  } else {
    puts "$menuPath does not Exist"
    return
  }
}

proc tixTable:colmenu {w col menuPath} {
  
    upvar #0 $w data

    # allow title col 
    if {![tixTable:isValidCol $w $col 1]} {
	return
    }
    
    if { [winfo exists $menuPath] } {
	if { [winfo class $menuPath] == "Menu" } {
	    set data(w:menu_$col) $menuPath
	} else {
	    puts "$menuPath is not a Menu"
	    return
	}
    } else {
	puts "$menuPath does not Exist"
	return
    }

}
proc tixTable:rowmenu {w  menuPath} {
  
    upvar #0 $w data
   
    # allow title col 
    if { [winfo exists $menuPath] } {
	if { [winfo class $menuPath] == "Menu" } {
	    set data(w:menu_row) $menuPath
	} else {
	    puts "$menuPath is not a Menu"
	    return
	}
    } else {
	puts "$menuPath does not Exist"
	return
    }

}

# pointed cell by mouse button 3
# form which popUp the specified menu 
proc tixTable:pointedcell { w } {
    upvar #0 $w data
    return $data(curCell)
}

proc tixTable:IsTitleCol { w col } {
  upvar #0 $w data
  set origincol [$data(w:table) cget -colorigin]
  set firstNonTitleCol [expr $origincol + [$data(w:table) cget -titlecols]]
  if { $col < $firstNonTitleCol } {
    return 1
  } else {
    return 0
  }
}
proc tixTable:IsTitleRow { w row } {
  upvar #0 $w data
  set originrow [$data(w:table) cget -roworigin]
  set firstNonTitleRow [expr $originrow + [$data(w:table) cget -titlerows]]
  if { $row < $firstNonTitleRow } {
    return 1
  } else {
    return 0
  }
}



proc tixTable:ColPopUpMenuFromEmbeddedWindow { w win X Y} {
  upvar #0 $w data
  tixTable:colPopUpMenu $w [$data(w:table) index active] $X $Y $win
}

proc tixTable:colPopUpMenu {w cell X Y { win "" } } {
  upvar #0 $w data
  set data(menuWin) $win
  set data(curCell) $cell
  #for title column we allow menu even if it is disabled
  set col [lindex [split $cell ,] 1]    
  #if all row is selected by 
  set isTitleCol [tixTable:IsTitleCol $w $col]
  
  if { !$isTitleCol && ( $data(-state) == "disabled" || \
                             [$data(w:table) tag includes dis $cell])} return

  if { $data(-menuCallback) != "" } {
    
    set menuPath [ eval $data(-menuCallback) $cell]
    if { [winfo exists $menuPath] } {
      if { [winfo class $menuPath] == "Menu" } { 
        catch {
          tk_popup $menuPath $X $Y
        }
      } elseif { [winfo class $menuPath] == "TableMenu"} {
        $menuPath update_menu 
        $menuPath  raise $X $Y
      }

    } else {
      puts "Illegal menu path $menuPath.\n"
    }
  } elseif { $isTitleCol && $data(w:menu_row) != ""}  {
    if {[tixTable:isValidRow $w [lindex [split $cell ,] 0] 0]} {
      tk_popup $data(w:menu_row) $X $Y 
    }
  } elseif {[info exist data(w:menu_$col)] == 1 &&  $data(w:menu_$col) != "" } {
    tk_popup $data(w:menu_$col) $X $Y  
  } elseif { $data(w:menu_cell) != "" } {
    tk_popup $data(w:menu_cell) $X $Y  
  }
}



#returns number of selected rows
proc tixTable:deleteSelectedRows {w {deleteEmptyRows 1} } {
  upvar #0 $w data
  #dbg tixTable "+++++++++++++++deleteSelectedRows++++++++++++++"
  set  activeInd ""
  catch { set activeInd [$data(w:table) index active] }
  $w activate ""

  set cursel [$data(w:table) curselection]
  dbg tixTable "deleteSelectedRows : cursel=$cursel"
  #curselection is sorted list 

  set rowList ""
  set prevRow ""
  foreach index $cursel {
    set row [lindex [split $index ,] 0]
    if { $row != $prevRow  } {
      lappend  rowList $row
      set prevRow $row
    }
  }

  set i 0
  if { $data(-undo) } {
    $data(undoManager) StartCompoundCommand tixTable:delSelRows
  }
  set firstRow [lindex $rowList 0]
  catch {
    foreach row $rowList {
      
      if {$deleteEmptyRows || ![$w isEmptyRow [expr $row - $i]]} {
        tixTable:_DeleteRow $w [expr $row - $i]
        incr i
      }
    }
  }
  dbg tixTable "deleteSelectedRows error=$::errorInfo"
  if { $data(-undo) } {

    $data(undoManager) EndCompoundCommand tixTable:delSelRows
  }
#restoring  active index
  if { $activeInd != "" } {
    catch {
      tixTable:ActivateSilently $w $activeInd
    }
  }  
  
  if { $data(-rowcommand)!=""} {
    eval [list $data(-rowcommand)  $firstRow $firstRow]
  }
  return $i
}
#if you use this method for your table you should provide bind for <Delete> for the table
#if entire rows are selected deletes rows
#if group of cells (not entire rows ) is selected clears contents of the cells
proc tixTable:deleteSelectedCellsOrRows {w } {
  upvar #0 $w data
  dbg tixTable "-----------deleteSelectedCellsOrRows-------------"
  if { [llength [$data(w:table) curselection]] <= 1  && $data(menuWin) != "" } {
    catch {
      if { [$data(menuWin) selection present] } {
        event generate $data(menuWin) <<Clear>>
      }
    }
    set data(menuWin) ""
  } else {
    if { $data(-state) == "disabled" } { return 0 }
    set cursel [$data(w:table) curselection]
    #curselection is sorted list 
    
    set rowList [tixTable:GetWholeRowsSelected $w]
    #dbg tixTable "rowList=$rowList"
    set row [lindex $rowList 0]
    if { $row == "error" } {
      tk_messageBox  -title Alert  -type ok \
          -icon error \
          -message "That command cannot be used with selections that contain entire rows and also other cells.\nTry selecting only entire rows, or entire columns, or just groups of cells." \
          -default ok
      return 0
    }
    if { $row == "" } {
      $w clearSelectedCells 
      return 1
    }
    set  activeInd ""
    catch { set activeInd [$data(w:table) index active] }
    $w activate ""
    set i 0
    if { $data(-undo) } {
      $data(undoManager) StartCompoundCommand tixTable:delSel
    }
    set firstRow [lindex $rowList 0]
    catch {
      foreach row $rowList {
        tixTable:_DeleteRow $w [expr $row - $i]
        incr i
      }
    }
    
    #dbg tixTable "deleteSelectedCellsOrRows error=$::errorInfo"
    if { $data(-undo) } {
      
      $data(undoManager) EndCompoundCommand tixTable:delSel
    }
#restoring  active index
    if { $activeInd != "" } {
      catch {
        tixTable:ActivateSilently $w $activeInd
      }
    } 
    if { $data(-rowcommand)!=""} {
      eval [list $data(-rowcommand)  $firstRow $firstRow]
    }
  } 
  return 1
}

proc tixTable:DeleteSelectedOnDeleteButton { w } {
  upvar #0 $w data
  if { [llength [$data(w:table) curselection]]>1 } {
    
    if {  ![string compare $data(-deleteMode) "delete"] } {
      $w deleteSelectedCellsOrRows
    } elseif { ![string compare $data(-deleteMode) "clear"] } {
      $w clearSelectedCells
    } elseif { ![string compare $data(-deleteMode) "command"] } {
      eval $data(-deleteCommand) $w
    }
  }
}

proc tixTable:deleteRow {w row args} {
  upvar #0 $w data
  set  activeInd ""
  catch { set activeInd [$data(w:table) index active] }
  $w activate ""
  tixTable:_DeleteRow $w $row $args
  #restoring  active index
  if { $activeInd != "" } {
    catch {
      tixTable:ActivateSilently $w $activeInd
    }
  } 
}

    
proc tixTable:_DeleteRow {w row args} {

    upvar #0 $w data
    # check if valid row , title-row not allowed
    if {![tixTable:isValidRow $w $row 0]}  { return 0 }    

    dbg tixTable "tixTable:delete row=$row args=$args"
    if { $row == "end" || $args == "" || $args == "{}" } {
	set args 1
    } else {
      
      if { [tixTable:NonNumeric $args] } {
        puts "Expected integer but got $args\n"
        return 0
      }

      
      # the row-num from which we start counting
     
      set rowOrigin [$data(w:table) cget -roworigin]
      
      # check if row belong to title 
      set beginOrdinaryRow [expr $rowOrigin  + [$data(w:table) cget -titlerows]]
      
      if { $row < $beginOrdinaryRow } { 
        set row $beginOrdinaryRow
      }
      
      # cal the num of rows from the selected row (include) til end
      set numOfLeftRows [expr $data(-rows) - ($row - $rowOrigin)]
      
      if { $numOfLeftRows < $args } {
        set args $numOfLeftRows
      }
    }
    if { $data(-undo) } {
      set rowDataList [tixTable:GetRowDataAndTags $w $row]
    }
    $data(w:table) delete rows -- $row $args
    set data(-rows) [$data(w:table) cget -rows]
    tixTable:MoveHiddenData $w $row "up"
    
    if { $data(-undo) } {
      tixTable:RegisterDeleteRowDoUndo $w $row [lindex $rowDataList 0] [lindex $rowDataList 1]
    }
    return 1
}

proc tixTable:_DeleteCol {w col args} {

  upvar #0 $w data
  # check if valid row , title-row not allowed
  if {![tixTable:isValidCol $w $col 0]}  { return 0 }
  
  if { $col == "end" || $args == "" || $args == "{}" } {
    set args 1
  } else {
    
    if { [tixTable:NonNumeric $args] } {
      puts "Expected integer but got $args\n"
      return 0
    }
    # the col-num from which we start counting
    
    set colOrigin [$data(w:table) cget -colorigin]
    
    # check if col belong to title 
    set beginOrdinaryCol [expr $colOrigin  + [$data(w:table) cget -titlecols]]
    
    if { $col < $beginOrdinaryCol } { 
      set col $beginOrdinaryCol
    }
    
    # cal the num of cols from the selected col (include) til end
    set numOfLeftCols [expr $data(-cols) - ($col - $colOrigin)]
    
    if { $numOfLeftCols < $args } {
      set args $numOfLeftCols
    }
  }
  if { $data(-undo) } {
    set colDataList [tixTable:GetColDataAndTags $w $col]
  }
  $data(w:table) delete cols -- $col $args
  set data(-cols) [$data(w:table) cget -cols]
  
  if { $data(-undo) } {
    tixTable:RegisterDeleteColDoUndo $w $col [lindex $colDataList 0] [lindex $colDataList 1] $args
  }

  return 1
}

proc tixTable:_DeleteCols {w col num right} {
  upvar #0 $w data
  if {$right == 1 && $num > 1} { ;#fix for 'right' direction
    incr col
  }
  loop i 0 $num {
    tixTable:_DeleteCol $w $col
  }
}

proc tixTable:delete {w row args} {
  upvar #0 $w data
  set activeInd ""
  catch { set activeInd [$data(w:table) index active] }
  $w activate ""
  set res [tixTable:_DeleteRow $w $row $args]
  #restoring  active index
  if { $activeInd != "" } {
    catch {
      tixTable:ActivateSilently $w $activeInd
    }
  }
  return $res
}


# insert RowNo  NumOfRows (option else 1)

#  $data(w:table) insert rows index count

proc tixTable:insert {w row args} {

    upvar #0 $w data

    if { $row == "end" || $row == -1 && $data(-rows) == 1 } {
      eval $data(w:table) insert rows end $args
      set data(-rows) [$data(w:table) cget -rows]
      return 1
    }
  
    if { ![tixTable:isValidRow $w $row ] } { return 0 }
    if { [tixTable:NonNumeric $args] } { 
	puts "Expected integer but got $args\n"
	return 0 
    }

    # the row-num from which we start counting
    set rowOrigin [$data(w:table) cget -roworigin]
	
    # check if row belong to title 
    set beginOrdinaryRow [expr $rowOrigin  + [$data(w:table) cget -titlerows]]
	
    if { $row < $beginOrdinaryRow } {
	set row $beginOrdinaryRow
	    if { $args == "" } {
		set args -1
	    } else {
		set args [expr 0 - $args]
	    } 
    }
	

    
    $data(w:table) insert rows -- $row $args
    set data(-rows) [$data(w:table) cget -rows]
    return 1
}

proc tixTable:clearrow { w row } {

    upvar #0 $w data

    # title isn't valid
    if { ![tixTable:isValidRow $w $row 0 ] }  { return 0 } 

    # if active cell is in the chosen row unactivate it
    if { $data(lastRow) == $row } {
	$w activate ""
    }

    tixTable:ClearRow $w $row
    return 1
}

proc tixTable:UpdateCheckButtons { w cellList } {
  upvar #0 $w data
  #dbg tixTable "UpdateCheckButtons : cellList=$cellList"
  set lastCheckButtonCol ""
  
  foreach index $cellList {
    if {  ![$data(w:table) tag includes title  $index ] } {
      set col [lindex [split $index , ] 1 ]
      if { $col==$lastCheckButtonCol || [lsearch -exact $data(chkbtncollist) $col] != -1 } {
        ;#is Checkbutton column
        set row [lindex [split $index , ] 0 ]
        $w setchkbtnimg $row $col
        set lastCheckButtonCol $col
      } else {
        set lastCheckButtonCol ""
      }
      set result 1
    }
    
  } 
}


proc tixTable:clearSelectedCells { w } {

    upvar #0 $w data
    set result 0
    if { [llength [$data(w:table) curselection]] <= 1  && $data(menuWin) != "" } {
      catch {
        if { [$data(menuWin) selection present] } {
          event generate $data(menuWin) <<Clear>>
          set result 1
        }
        
      }
      set data(menuWin) ""
    } else {

    # if active cell is in the chosen row unactivate it 
    if { $data(-state) == "disabled" } { return 0 }

    
    set activeInd ""
    catch {set activeInd [$data(w:table) index active]}
    #unactivate active index
    if { [$data(w:table) selection includes $activeInd] } {
	$w activate ""
    } else {
      set  activeInd ""
    }
    set selectedList [$data(w:table) curselection]
    
    set lastCheckButtonCol ""

    if { $data(-undo) } {
      set oldData {}
      set newData {}
    }
     foreach index $selectedList {
      if {  ![$data(w:table) tag includes title  $index ] && ![$data(w:table) tag includes dis  $index ]} {
        if { $data(-undo) } {
          lappend oldData "$index [$data(w:table) get $index]"
          lappend newData " $index "
        }
        $data(w:table) set $index ""
        #set col [lindex [split $index , ] 1 ]
        
       #  #remove disabled tag
#         if { [$data(w:table) tag includes dis $index] } {
#           $data(w:table) tag cell {} $index
#           #set insureRowTagCmd in order to restore disabled tag afterwards if it is still needed
#           set data(insureRowTagCmd) 1
#         }
        set result 1
      }
    
     }
    tixTable:UpdateCheckButtons $w $selectedList

    if { $activeInd != "" } {
      tixTable:ActivateSilently $w $activeInd
    }
    if { $data(-undo) } {
      tixTable:RegisterFillCellsDoUndo $w [list $oldData] [list $newData]
    }
  }
    return $result
}



proc tixTable:clearcell { w row col } {
   upvar #0 $w data

   # don't allow title row
  if {![tixTable:isValidRow $w $row 0]} {
	return
    }
  # don't allow title col
    if {![tixTable:isValidCol $w $col 0]} {
	return 
    }
  $data(w:table) set $row,$col ""
}

# assuming valid row
proc tixTable:ClearRow { w row } {

    upvar #0 $w data

    # col-num from which we start the non-title cols
    # set beginCol [expr  [$data(w:table) cget -colorigin] +  [$data(w:table) cget -titlecols]]
    set beginCol [$data(w:table) cget -colorigin] 
    if { $data(-preserveRowTitles)} {
      incr beginCol [$data(w:table) cget -titlecols]
    }
    set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]
    
    for {set i $beginCol } {$i < $maxCol} {incr i} {
	$data(w:table) set $row,$i ""
    }

    foreach col $data(chkbtncollist) {
	$w setchkbtnimg $row $col
    }
}


proc tixTable:ClearCol { w col } {
  upvar #0 $w data

  #set beginRow [expr  [$data(w:table) cget -roworigin] + [$data(w:table) cget -titlerows]]
  set beginRow [$data(w:table) cget -roworigin]
  set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
  
  for {set i $beginRow } {$i < $maxRow} {incr i} {
    $data(w:table) set $i,$col ""
  }
}

 proc tixTable:copySelected { w } {
   upvar #0 $w data
   #dbg tixTable  "\\\\\\\\tixTable:copySelected\\\\\\\\"

   if { [llength [$data(w:table) curselection]] <= 1  && $data(menuWin) != "" } {
     catch {
       event generate $data(menuWin) <<Copy>>
     }
       set data(menuWin) ""
   } else {
     set  activeInd ""
     catch { set activeInd [$data(w:table) index active] }
     $w activate ""
     
     tk_tableCopy $data(w:table)
     
     #restoring  active index
     if { $activeInd != "" } {
       tixTable:ActivateSilently $w $activeInd
     }
   }
 }

 proc tixTable:cutSelected { w } {
   upvar #0 $w data
    #dbg tixTable "\\\\\\\\tixTable:cutSelected\\\\\\\\"
   if { [llength [$data(w:table) curselection]] <= 1  && $data(menuWin) != "" } {
     catch {
       event generate $data(menuWin) <<Cut>>
       $data(menuWin) selection clear
     }
     set data(menuWin) ""
   } else {
     set  activeInd ""
     catch { set activeInd [$data(w:table) index active] }
     $w activate ""
     tk_tableCut $data(w:table)
     #restoring  active index
     if { $activeInd != "" } {
       tixTable:ActivateSilently $w $activeInd
     }
   }
 

}

#returns the number of selected row if exists, else returns ""
# proc tixTable:GetOneWholeRowSelected { w } {
#   upvar #0 $w data
#   set cursel [$data(w:table) curselection]
#   set selrow ""
#   set selcol ""

#   set beginCol [expr  [$data(w:table) cget -colorigin] + \
#                     [$data(w:table) cget -titlecols]]
    
#   set lastCol [expr $data(-cols) + [$data(w:table) cget -colorigin] - 1]
#   set col $beginCol
  
#   foreach index $cursel {
#     scan $index %d,%d selrow selcol

#     if { $selcol!=$col } {
#       return ""
#     }
#     incr col
#   }

#   if { $selcol == $lastCol } {
#     return $selrow
#   } else {
#     return ""
#   }
# }
#returns list of selected rows from current selection - 
#even if not the whole row is selected
proc tixTable:getSelectedRowsList {w} {
  upvar #0 $w data
  return [tixTable:GetWholeRowsSelected $w 0]
}
#if number of whole rows are selected returns rowList
#if  group of cells(not whole rows) is selected returns ""
#if whole rows are selected and also group of other  cells is selected returns list {"error"}
#returns the list  of selected rows if exists, else returns ""
proc tixTable:GetWholeRowsSelected { w {onlyWholeRows 1}} {
  upvar #0 $w data
  set cursel [$data(w:table) curselection]
  set selrow ""
  set selcol ""

  set beginCol [expr  [$data(w:table) cget -colorigin] + \
                    [$data(w:table) cget -titlecols]]
    
  set lastCol [expr $data(-cols) + [$data(w:table) cget -colorigin] - 1]
  set col $beginCol

  set rowList ""
  set singleCells 0
  if { $beginCol < -1 } {
    set newCurSel ""
    set tmpList ""
    foreach index $cursel {
      scan $index %d,%d selrow selcol
      if {$selcol < 0} {
        lappend  tmpList $index
      } else {
        if {[llength $tmpList] > 0} {
          set length [llength $newCurSel]
          foreach tmpIndex $tmpList {
            set newCurSel [linsert $newCurSel $length  $tmpIndex]
          }
          set tmpList ""
        }
        lappend newCurSel $index
      }
    }
    set cursel $newCurSel
  }

  foreach index $cursel {

    scan $index %d,%d selrow selcol

    if { $selcol!=$col } {
      set singleCells 1
      set col $beginCol
      break
    }
    if {  $selcol == $lastCol } {
      lappend rowList $selrow
      set col $beginCol
    } else {
      incr col
    }
  }
  
  if { $singleCells } {
    if {!$onlyWholeRows  } {
      lappend rowList $selrow
    } elseif { $rowList != "" } {
      set rowList [list "error"]
    }
  }
  dbg tixTable "whole rowList=$rowList"
  return $rowList
}

#dir may be up ,down ,start,end
proc tixTable:moveRow { w  dir {rowSkip 0}} {

   upvar #0 $w data
   #define the number of selected row
   set rowList [tixTable:GetWholeRowsSelected $w]
   set row [lindex $rowList 0]

   if { $row == "" || $row == "error" || [llength $rowList] !=1 } {
     tk_messageBox  -title Alert  -type ok \
        -icon error -message "One line must be selected for this operation." -default ok
      return 0
   }

   # title row isn't valid
   if { ![tixTable:isValidRow $w $row 0 ] }  { return 0 } 
   # the first real row number (== not title)
   set originrow [$data(w:table) cget -roworigin]
   set beginRow [expr  $originrow + [$data(w:table) cget -titlerows] + $rowSkip]
   if { $beginRow==$row && ($dir=="start" || $dir=="up")} { return 0 }
   set lastRow [ expr $data(-rows) +  $originrow - 1 ]


   if { ($dir=="end" || $dir=="down")} {
     if { $lastRow == $row } { return 0 }
     set tagList [$data(w:table) tag row dis]

     #if the next row is disabled
     if { [lsearch -exact $tagList [expr $row + 1] ] !=-1 } {
       return 0
     } 
   }
   $w activate ""
   set movedRowDataList [tixTable:GetRowDataAndTags $w $row]
   #set movedRowData [tixTable:GetRowData $w $row]

   if { $data(-undo) } {
    $data(undoManager) StartCompoundCommand tixTable:moveRow
   }
   tixTable:_DeleteRow $w $row

   # #add check that it is not the upper row
   if { $dir=="up"} {
     
     set newrow [expr $row - 1]
     $w insertrow $newrow
   } elseif {  $dir=="down"} {
     set newrow $row
     $w addrow $newrow
     incr newrow
   } elseif { $dir == "start" } {
     set newrow $beginRow
     $w insertrow $newrow
   } elseif { $dir == "end" } {
     #define last not empty row
     set i [expr $lastRow - 1]

     while { $i>= $beginRow } {
       if { [$w isEmptyRow  $i] } {
         incr i -1
       } else { break }
     }
     set newrow $i
     
     $w addrow $newrow
     incr newrow
   } 
   #copy row data to the new row

   tixTable:SetRow $w $newrow [lindex $movedRowDataList 0] [lindex $movedRowDataList 1]


   #see new row
   $w selectrow $newrow
   #$data(w:table) see $newrow,0
   if { $data(-undo) } {

     tixTable:RegisterSetRowDoUndo $w $newrow  [lindex $movedRowDataList 0] [lindex $movedRowDataList 1]
     $data(undoManager) EndCompoundCommand tixTable:moveRow
   }

   return 1
}


#if number of whole cols are selected returns list of selected cols
#if  group of cells(not whole cols) is selected returns ""
#if whole cols are selected and also group of other  cells is selected returns list {"error"}
proc tixTable:GetWholeColsSelected { w } {
  upvar #0 $w data
  set cursel [$data(w:table) curselection]
  set selrow ""
  set selcol ""

  set beginRow [expr  [$data(w:table) cget -roworigin] + \
                    [$data(w:table) cget -titlerows]]

  set lastRow [expr $data(-rows) + [$data(w:table) cget -roworigin] - 1]
  set row $beginRow

  set colList ""
  set singleCells 0

  if { $beginRow < -1 } {
    set newCurSel ""
    set tmpList ""
    foreach index $cursel {
      scan $index %d,%d selrow selcol
      if {$selrow < 0} {
        lappend  tmpList $index
      } else {
        if {[llength $tmpList] > 0} {
          set length [llength $newCurSel]
          foreach tmpIndex $tmpList {
            set newCurSel [linsert $newCurSel $length  $tmpIndex]
          }
          set tmpList ""
        }
        lappend newCurSel $index
      }
    }
    set cursel $newCurSel
  }

  #calculate num of whole cols selected (by first row)
  set colIndices ""
  foreach index $cursel {
    scan $index %d,%d selrow selcol
    if { $selrow==$beginRow } {
      lappend colIndices $selcol
    }
  }

  #arrange cursel list according to cols index
  set curselByCol ""
  foreach colidx $colIndices {
    foreach index $cursel {
      scan $index %d,%d selrow selcol
      if {$selcol == $colidx} {
        lappend curselByCol $index
      }
    }
  }

  if {[llength $cursel] > [llength $curselByCol]} { ;#sign for cells not in whole col
    return "error"
  }
  
  foreach index $curselByCol {
    
    scan $index %d,%d selrow selcol
    if { $selrow!=$row } {
      set singleCells 1
      set row $beginRow
      break
    }

    if { $selrow == $lastRow } {
      lappend colList $selcol
      set row $beginRow
    } else {
      incr row
    }
  }

  if { $singleCells } {
    if { $colList != "" } {
      set colList [list "error"]
    }
  }

  return $colList
}


# if whole cols selected are merged with the same mergetitle - returns list of selected cols
# if whole cols selected are separate or only part of merged cols - return ""
proc tixTable:GetWholeMergedColsSelected { w } {
  upvar #0 $w data
  set colList [tixTable:GetWholeColsSelected $w]
  set firstCol [lindex $colList 0]
  
  if {$colList == "" || $colList == "error"} {
    return ""
  } else {
    set selIdx ""
    if {[info exists data(mergeTable)]} {
      set idx 0
      foreach mergeTableItem $data(mergeTable) {
        if {[lindex $mergeTableItem 1] == $firstCol} {
          set selIdx $idx ;#the index of the selected cols in the list of data(mergeTable)
          break
        }
        incr idx
      }
    }
    if {$selIdx != ""} { ;#check if all the merged rows are selected
      set selMergeTableItem [lindex $data(mergeTable) $selIdx]
      set numSelMergedCol [lindex $selMergeTableItem 0]
      set firstMergedCol [lindex $selMergeTableItem 1]
      
      if {[llength $colList] == $numSelMergedCol && 
          [lindex $colList end] == [expr $firstMergedCol + $numSelMergedCol -1]} {
        return $colList
      }
    } else {
      if {[llength $colList] == 1} {;#check option of 1 col selected with no merged cols
        if {![info exists data(mergeTable)]} {
          return $colList
        } else {
          if {[tixTable:IsColUnderMergeTitle $w $firstCol] != -1} {
            return ""
          } else {
            return $colList
          }
        } 
      } else { ;#more than 1 selected but not fit 1 merge title
        return ""      
      }
    }
  }
}

#util for GetWholeMergedColsSelected 
#if it is not under merged title returns -1
#if it is returns the item num in the data(mergeTable) list
proc tixTable:IsColUnderMergeTitle {w col} {
  upvar #0 $w data
  if {[info exists data(mergeTable)] } {
    set cnt 0
    foreach mergeTableItem $data(mergeTable) {
      set numOfCell [lindex $mergeTableItem 0]
      set firstCol [lindex $mergeTableItem 1]
      set idx $firstCol
      loop i 0 $numOfCell {
        if {$idx == $col} {
          return $cnt
        }
        incr idx
      }
      incr cnt
    }
    return -1
  } else {
    return -1
  }
}

# missing - support to data(w:$col), column widget is not moved.
# dir may be left, right, start, end
proc tixTable:moveCol { w dir {colSkip 0}} {

  upvar #0 $w data

  #define the number of selected col
  set colList [tixTable:GetWholeColsSelected $w]
  set col [lindex $colList 0]

  if { $col == "" || $col == "error" || [llength $colList] !=1 } {
     tk_messageBox  -title Alert  -type ok \
        -icon error -message "One colunm must be selected for this operation." -default ok
      return 0
   }
  # title col isn't valid
   if { ![tixTable:isValidCol $w $col 0 ] }  { return 0 } 

  # the first real col number (== not title)
  set origincol [$data(w:table) cget -colorigin]
  set beginCol [expr  $origincol + [$data(w:table) cget -titlecols] + $colSkip]
  if { $beginCol==$col && ($dir=="start" || $dir=="left")} { return 0 }
  set lastCol [ expr $data(-cols) +  $origincol - 1 ]
  
  if { ($dir=="end" || $dir=="right")} {
    if { $lastCol == $col } { return 0 }
    set tagList [$data(w:table) tag col dis]
    
    #if the next col is disabled
    if { [lsearch -exact $tagList [expr $col + 1] ] !=-1 } {
      return 0
    } 
  }
  
  $w activate ""
  set movedColDataList [tixTable:GetColDataAndTags $w $col]

  if { $data(-undo) } {
    $data(undoManager) StartCompoundCommand tixTable:moveCol
  }
  
  tixTable:_DeleteCol $w $col

  # #add check that it is not the left-most col
   if { $dir=="left"} {
     
     set newcol [expr $col - 1]
     $w addcols $newcol -1
   } elseif {  $dir=="right"} {
     set newcol $col
     $w addcols $newcol 1
     incr newcol
   } elseif { $dir == "start" } {
     set newcol $beginCol
     $w addcols $newcol -1
   } elseif { $dir == "end" } {
     #define last not empty col
     set i [expr $lastCol - 1]
     set newcol $i
     
     $w addcols $newcol 1
     incr newcol
   } 
  
  tixTable:SetCol $w $newcol [lindex $movedColDataList 0] [lindex $movedColDataList 1]

  #see new col
  tixTable:SelectColumn $w $newcol

  if { $data(-undo) } {
    
    tixTable:RegisterSetColDoUndo $w $newcol  [lindex $movedColDataList 0] [lindex $movedColDataList 1]
    $data(undoManager) EndCompoundCommand tixTable:moveCol
  }
  
  return 1
}

# supports move in cases of same-cols-num  !!!
proc tixTable:moveMergedCols { w dir {colSkip 0}} {
  upvar #0 $w data

  set colList [tixTable:GetWholeMergedColsSelected $w]
  set firstCol [lindex $colList 0]

  if { $firstCol == "" } {
    tk_messageBox  -title Alert  -type ok -icon error \
        -message "All colunms under one header must be selected for this operation." -default ok
    return 0
  }
  
  if { ![tixTable:isValidCol $w $firstCol 0 ] }  { return 0 } 

  # the first real col number (== not title)
  set origincol [$data(w:table) cget -colorigin]
  set beginCol [expr  $origincol + [$data(w:table) cget -titlecols] + $colSkip]
  if { $beginCol==$firstCol && ($dir=="start" || $dir=="left")} { return 0 }
  set lastCol [ expr $data(-cols) +  $origincol - 1 ]

  set numCols [llength $colList]
  
  if { ($dir=="end" || $dir=="right")} {
    if { $lastCol == [expr $firstCol + [llength $colList] -1]} { return 0 }
    set tagList [$data(w:table) tag col dis]
    #if the next col is disabled
    if { [lsearch -exact $tagList [expr $firstCol + $numCols] ] !=-1 } {
      return 0
    }  
  }
  $w activate ""
  set movedColsDataList "" ;# save the data
  foreach column $colList {
    lappend movedColsDataList [tixTable:GetColDataAndTags $w $column]
  }

  if { $data(-undo) } {
    $data(undoManager) StartCompoundCommand tixTable:moveMergedCols
  }

  foreach column $colList {
    tixTable:_DeleteCol $w $firstCol ;#was $colunm
  }

  if {$dir=="left"} {
    set newcol [expr $firstCol - $numCols]
    $w addcols $newcol -$numCols
  } elseif {$dir == "right"} {
    set newcol [expr $firstCol + $numCols -1];#(-1) fix for right direction (for undo)
    $w addcols $newcol $numCols 1
    incr newcol
  } elseif {$dir == "start"} {
    set newcol $beginCol
    $w addcols $newcol -$numCols
  } elseif {$dir == "end"} {
    set newcol [expr $lastCol - 1]
    $w addcols $newcol $numCols
  }

  set curcol $newcol
  set selectCols "" ;#list of new cols to select
  set cnt 0
  foreach column $colList {
    set movedColDataList [lindex $movedColsDataList $cnt]
    incr cnt
    tixTable:SetCol $w $curcol [lindex $movedColDataList 0] [lindex $movedColDataList 1]
    lappend selectCols $curcol
    if { $data(-undo) } {
      tixTable:RegisterSetColDoUndo $w $curcol  [lindex $movedColDataList 0] [lindex $movedColDataList 1]
    }
    incr curcol
  }
  $w selectColumns $selectCols

  #switch the mergetitle labels
  tixTable:ArrangeMergeTitleLabels $w $dir $firstCol $numCols $newcol
  if { $data(-undo) } {
    $data(undoManager) EndCompoundCommand tixTable:moveMergedCols
  }
}

# util for moveMergedCols
proc tixTable:ArrangeMergeTitleLabels {w dir origFirstCol numCols newcol} {
  upvar #0 $w data
 
  if {[info exists data(mergeTable)]} {
    if { $data(-undo) } {
      tixTable:RegisterArrangeMergeTitleLabelsDoUndo $w $dir $origFirstCol $numCols $newcol
    }

    set labelList "" ;#list of all merge title text label in original order
    set labelPathList "" ;#list of all merge title labelPath 
    foreach mergeTableItem $data(mergeTable) {
      set labelPath [lindex $mergeTableItem 2]
      lappend labelList [$labelPath cget -text]
      if {$labelList == ""} {
        set labelList [list {}]
      }
      lappend labelPathList $labelPath
    }
    set newMergeList {}
    
    if {$dir=="left" || $dir=="right"} {
      if {$dir=="left"} {
        set newFirstCol [expr $origFirstCol - $numCols]
      } else {
        set newFirstCol [expr $origFirstCol + $numCols]
      }
      
      # switch between 2 merge titles

      foreach mergeTableItem $data(mergeTable) {
        set numOfCell [lindex $mergeTableItem 0]
        set labelPath [lindex $mergeTableItem 2]
        set row [lindex $mergeTableItem 3]
        set firstCol [lindex $mergeTableItem 1]
        if {$firstCol == $origFirstCol} {
          lappend newMergeList [list $numOfCell $newFirstCol $labelPath $row]
          tixTable:MergeCellsByLabel $w $numOfCell $row $newFirstCol $labelPath ;#refresh GUI
        } elseif {$firstCol == $newFirstCol} {
          lappend newMergeList [list $numOfCell $origFirstCol $labelPath $row]
          tixTable:MergeCellsByLabel $w $numOfCell $row $origFirstCol $labelPath ;#refresh GUI
        } else {
          lappend newMergeList $mergeTableItem ;#keep the orig data
        }
      }
    } elseif {$dir=="start" || $dir=="end"} {
      
      foreach mergeTableItem $data(mergeTable) {
        set numOfCell [lindex $mergeTableItem 0]
        set labelPath [lindex $mergeTableItem 2]
        set row [lindex $mergeTableItem 3]
        set firstCol [lindex $mergeTableItem 1]
        if {$firstCol == $origFirstCol} { 
          lappend newMergeList [list $numOfCell $newcol $labelPath $row]
          tixTable:MergeCellsByLabel $w $numOfCell $row $newcol $labelPath
        } else {
          if {$dir=="start"} {
            if {$firstCol >= $newcol && $firstCol < $origFirstCol} { ;#move 1 step right
              set newFirstCol [expr $firstCol + $numOfCell]
              lappend newMergeList [list $numOfCell $newFirstCol $labelPath $row]
              tixTable:MergeCellsByLabel $w $numOfCell $row $newFirstCol $labelPath
            } else { ;# no change
              lappend newMergeList $mergeTableItem
            }
          } else { ;# "end"
            if {$firstCol > $origFirstCol} { ;#move 1 step left
              set newFirstCol [expr $firstCol - $numOfCell]
              lappend newMergeList [list $numOfCell $newFirstCol $labelPath $row]
              tixTable:MergeCellsByLabel $w $numOfCell $row $newFirstCol $labelPath
            } else { ;# no change
              lappend newMergeList $mergeTableItem
            }
          }
        }
      }
    }
    set data(mergeTable) $newMergeList
  }
}

proc tixTable:sortMergedTitleText {w colsInGroup {colSkip 0}} {
  upvar #0 $w data
  if {![info exists data(mergeTable)]} { return ""}
  
  set beginCol [expr  [$data(w:table) cget -colorigin] + \
                    [$data(w:table) cget -titlecols] + $colSkip]
  #set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]

  set origLabelList "" ;# label list in the original order - All
  set labelPathList "" ;#list of all merge title labelPath
  set emptyList "" ;#list of {{} col1} {{} col2} - Empty part 
  set origLabelWithText "";#list of {text1 col1} {text2 col2} - Text part

  foreach mergeTableItem $data(mergeTable) {
    if { [lindex $mergeTableItem 1] >= $beginCol } {
      set labelPath [lindex $mergeTableItem 2]
      set titleText [$labelPath cget -text]
      if {$titleText == ""} {
        set titleText [list {}]
        lappend emptyList "$titleText [lindex $mergeTableItem 1]"
      } else {
        lappend origLabelWithText "$titleText [lindex $mergeTableItem 1]"
      }
      lappend origLabelList "$titleText [lindex $mergeTableItem 1]"
      lappend labelPathList $labelPath
    }
  }

  set sortLabelList ""

  if {$origLabelList != ""} {
    if {$emptyList != ""} { ;#there are empty labels
      set sortText [lsort $origLabelWithText]
      set sortLabelList [concat $emptyList $sortText]
    } else {
      set sortLabelList [lsort $origLabelList]
    }

    if {$sortLabelList != $origLabelList} { ;#if need to sort
      
      set newMergeList {}
      set cnt 0
      set emptyCnt 0 ;#counter for empty labels

      foreach mergeTableItem $data(mergeTable) {
        if { [lindex $mergeTableItem 1] >= $beginCol } {
          set numOfCell [lindex $mergeTableItem 0]
          set labelPath [lindex $mergeTableItem 2]
          set row [lindex $mergeTableItem 3]
          set origFirstCol [lindex $mergeTableItem 1]
          set txt [$labelPath cget -text]
          if {$txt == "" || $txt == {}} {
            set newIdx $emptyCnt
            incr emptyCnt
          } else {
            set newIdx [lsearch $sortLabelList *$txt*]
          }
          set newFirstCol [expr $newIdx*$colsInGroup]
          
          lappend newMergeList [list $numOfCell $newFirstCol $labelPath $row]
          tixTable:MergeCellsByLabel $w $numOfCell $row $newFirstCol $labelPath ;#refresh the GUI
          incr cnt
        } else {
          lappend newMergeList $mergeTableItem
        }
      }
      set data(mergeTable) $newMergeList
    }
  }
}

proc tixTable:GetRowData {w row } {
  upvar #0 $w data

  set rowData ""
  # col-num from which we start the non-title cols
  #set beginCol [expr  [$data(w:table) cget -colorigin] +  [$data(w:table) cget -titlecols]]
  set beginCol [$data(w:table) cget -colorigin]
  if { $data(-preserveRowTitles)} {
    incr beginCol [$data(w:table) cget -titlecols]
  }
  set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin] +$data(-hiddenCols)]
  
  #dbg tixTable "-->tixTable:GetRowData : hiddenCols = $data(-hiddenCols) maxCol=$maxCol"

  for {set i $beginCol } {$i < $maxCol } {incr i} {
    
    if { [info exists  $data(-variable)($row,$i) ] && [set $data(-variable)($row,$i)] != "" } {
      lappend rowData [set $data(-variable)($row,$i)]
    } else {
      lappend rowData {}
    }
  }
  #dbg tixTable "row=$row rowData=$rowData"
  return $rowData
}

proc tixTable:GetRowDataAndTags {w row } {
  upvar #0 $w data
  set rowData ""
  set rowDis ""
  # col-num from which we start the non-title cols
#  set beginCol [expr  [$data(w:table) cget -colorigin] +  [$data(w:table) cget -titlecols]]
  set beginCol [$data(w:table) cget -colorigin]
  if { $data(-preserveRowTitles)} {
    incr beginCol [$data(w:table) cget -titlecols]
  }
  set maxTableCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]
  set maxCol [expr $maxTableCol + $data(-hiddenCols)]
  for {set i $beginCol } {$i < $maxCol } {incr i} {
    if { [info exists  $data(-variable)($row,$i) ] && [set $data(-variable)($row,$i)] != "" } {
      lappend rowData [set $data(-variable)($row,$i)]
    } else {
      lappend rowData {}
    }
    if {$i <$maxTableCol  && [$data(w:table) tag includes dis  $row,$i ] } {
      lappend rowDis $i
    }
  }
  if { $rowDis == "" } {
    set rowDis {}
  }
  dbg tixTable "GetRowDataAndTags: row=$row rowData=$rowData rowDis=$rowDis"
  return [list $rowData $rowDis]
  
}

proc tixTable:GetColDataAndTags {w col} {
  upvar #0 $w data
  set colData ""
  set colDis ""

  # row-num from which we start the non-title rows
  set beginRow [$data(w:table) cget -roworigin]
  set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
  
  for {set i $beginRow } {$i < $maxRow } {incr i} {
    if { [info exists  $data(-variable)($i,$col) ] && [set $data(-variable)($i,$col)] != "" } {
      lappend colData [set $data(-variable)($i,$col)]
    } else {
      lappend colData {}
    }
    if {$i <$maxRow  && [$data(w:table) tag includes dis  $i,$col ] } {
      lappend colDis $i
    }
  }

  if { $colDis == "" } {
    set colDis {}
  }
  return [list $colData $colDis]
}

proc  tixTable:pasteSelected { w { pasteIndex "" } } {
  upvar #0 $w data
  #dbg tixTable "\\\\\\\\tixTable:pasteSelected\\\\\\\\"
  set data(insureRowTagCmd) 1
  set changedCellsList {}
  if {  [llength  [$data(w:table) curselection]] <= 1 && $data(menuWin)!= ""} {
    set changedCellsList [tixTable:PasteInCell $w $data(menuWin)]
    set data(menuWin) ""
  } else {
    set changedCellsList [tixTable:PasteLines $w $pasteIndex]
    if {[string compare $data(-pasteCallback) "" ]} {
      eval [list $data(-pasteCallback) $changedCellsList ]
    }
  } 
  return $changedCellsList
}

proc tixTable:PasteLines { w {pasteIndex "" } } { 
  upvar #0 $w data
  #dbg tixTable "tixTable:PasteLines "
  set  activeInd ""
  catch { set activeInd [$data(w:table) index active] }
  $w activate ""
  if { $pasteIndex == "" } {
    set pasteIndex [lindex [$data(w:table) curselection] 0]
    if { $pasteIndex == ""} {
      set pasteIndex $activeInd
    }
  }
  set pasteData [ tixTable:GetPasteData $w]
  set changedCellsList {}

  set oldData ""
  set changedCellsDataList ""
  if { $pasteData != "" } {
    set changedCellsDataList [tk_tablePaste $data(w:table) $pasteIndex]
    set oldData [lindex $changedCellsDataList 0] 
    foreach el $oldData {
      lappend changedCellsList [lindex $el 0]
    }
    tixTable:UpdateCheckButtons $w $changedCellsList

  }
  if { $data(-undo) } {
    tixTable:RegisterFillCellsDoUndo $w [list $oldData] [list [lindex $changedCellsDataList 1]]
  }

  #restoring  active index
  if { $pasteIndex!=""} {
   tixTable:ActivateSilently $w $pasteIndex
  }
  dbg tixTable "changedCellsList=$changedCellsList"
  return $changedCellsList
}





proc tixTable:addrow { w row} {
  upvar #0 $w data

  tixTable:_AddRow $w $row 1
}
proc tixTable:insertrow { w row} {
  upvar #0 $w data
  if { ![ tixTable:IsTitleRow $w $row ] } { 
    tixTable:_AddRow $w $row -1
  }
}

# count - num cols to add, '-' before location, '+' after location
proc tixTable:addcols { w location count {right 0}} {
  upvar #0 $w data
  
  if {$count == 0} return
  set originCol [$data(w:table) cget -colorigin]     
  set oldCols $data(-cols)
  set maxCol [expr $oldCols + $originCol]
  $data(w:table) insert cols -- $location $count
  set data(-cols) [$data(w:table) cget -cols]

  set newMax [expr $maxCol + abs($count)]
  
  for {set i $maxCol} {$i < $newMax} {incr i} {
    set data(w:$i) {}
    set data(w:menu_$i) {}
  }

  if { $data(-undo) } {
    tixTable:RegisterAddColsDoUndo $w $location $count $right
  }
}

proc tixTable:removecols { w location count} {
  upvar #0 $w data
  
  if {$count == 0} return;#was $count <= 0
  set originCol [$data(w:table) cget -colorigin]     
  set oldCols $data(-cols)
  set maxCol [expr $oldCols + $originCol]

  if {[info exists data(mergeTable)]} {
    set remFinish [expr $location + abs($count)]
    set newMergeList {}
    foreach mergeTableItem $data(mergeTable) {
      set numOfCell [lindex $mergeTableItem 0]
      set firstCol [lindex $mergeTableItem 1]
      set labelPath [lindex $mergeTableItem 2]
      set row [lindex $mergeTableItem 3]
      set firstInside [expr $firstCol >= $location && $firstCol < $remFinish]
      set locInside [expr $location >= $firstCol && \
                         $location < [expr $firstCol + $numOfCell]]
      if {$firstInside || $locInside} {
        place forget $labelPath
      } else {
        if {$firstCol >= $remFinish} {
          set firstCol [expr $firstCol - abs($count)]
          lappend newMergeList [list $numOfCell $firstCol $labelPath $row]
        } else {
          lappend newMergeList $mergeTableItem
        }
      }
    }
    set data(mergeTable) $newMergeList
  }

  $data(w:table) delete cols -- $location $count
  set data(-cols) [$data(w:table) cget -cols]
  #set data(-cols) [expr $oldCols - $count]
  if { $data(-undo) } {
    tixTable:RegisterRemoveColsDoUndo $w $location $count
  }
}

proc tixTable:MoveHiddenData { w startRow dir} {
  upvar #0 $w data
  #dbg tixTable "tixTable:MoveHiddenData startRow=$startRow dir=$dir"
  if { $data(-hiddenCols)!= 0} {

    set beginHidCol [expr $data(-cols) + [$data(w:table) cget -colorigin] ]
    set maxHidCol [expr $beginHidCol + $data(-hiddenCols)]
    set endRow [expr $data(-rows) + [$data(w:table) cget -roworigin] - 1 ]
    if { $dir=="down"} {
      for { set row $endRow} {$row >$startRow } {incr row -1} {
        set fromRow [expr $row -1]
        for {set i $beginHidCol } {$i < $maxHidCol } {incr i} {
          if { [info exists  $data(-variable)($fromRow,$i) ]  } {
            set $data(-variable)($row,$i) [set $data(-variable)($fromRow,$i)]
          } elseif { [info exists $data(-variable)($row,$i)] } { 
            #irena: fix CR5421 : clear data if needed
            set $data(-variable)($row,$i) ""
          } 
        }  
      }
      #clear
      for {set i $beginHidCol } {$i < $maxHidCol } {incr i} {
        set $data(-variable)($startRow,$i) ""
      }

    } else {
      for { set row $startRow} {$row <$endRow } {incr row} {
        set fromRow [expr $row + 1]
        for {set i $beginHidCol } {$i < $maxHidCol } {incr i} {
          if { [info exists  $data(-variable)($fromRow,$i) ]  } {
            set $data(-variable)($row,$i) [set $data(-variable)($fromRow,$i)]
          } elseif { [info exists $data(-variable)($row,$i)] } { 
            #irena: fix CR5421 : clear data if needed
            set $data(-variable)($row,$i) ""
          } 
        }  
      }
    }
  }
}



#if count is 1 - add row , if it is -1 - insert row
proc tixTable:_AddRow { w row count} {
  upvar #0 $w data

  set activeIndCol ""
  catch {set activeIndCol [$data(w:table) index active col]}
  $w activate ""

  if {![$w insert $row $count]} return

  if {$row == "end"} {
    set row [expr $data(-rows) + [$data(w:table) cget -roworigin] - 1]
  }

  set oldRow $row
  if { $count == 1 } {
    incr row 1
    #move contents of  for hidden columns
    tixTable:MoveHiddenData $w $row "down"
  } else {
    tixTable:MoveHiddenData $w $row "down"
  }

  foreach col $data(chkbtncollist) {
    $w setchkbtnimg $row $col
  }

  if {$activeIndCol != ""} {
    tixTable:ActivateSilently  $w $row,$activeIndCol
  }
  if { $data(-undo) } {
    tixTable:RegisterInsertRowDoUndo $w $oldRow $count
  }
  dbg tixTable "_AddRow : row=$row"
  if { $data(-rowcommand)!=""} {
    if { $count == 1 } { 
      ;#add row 
      eval [list $data(-rowcommand)  [expr $row -1] $row]
    } else {
      ;#insert row
      eval [list $data(-rowcommand)  [expr $row +1] $row]
    }
  }

  #needed also for undo !
  $data(w:table) see $row,0
}

#irena:
proc tixTable:SetBtnImg { w row col } {
  upvar #0 $w data
  if {![$data(w:table) tag includes dis $row,$col]} {

    foreach val $data(btnColTagPairList) {

      if { [lindex $val 0] == $col } {
        set tag [lindex $val 1]
        if { [$data(w:table) tag exists $tag]} {
          $data(w:table) tag cell $tag $row,$col 
        }
      }
    }
    
    #$data(w:table) window config $row,$col -sticky news -window $data(w:$col) -relief flat -padx 0 -background white
    # causes problem in insert row
    #$w activate ""
  }
}

proc tixTable:colsort { w col {rowSkip 0}} {

    upvar #0 $w data

    # allow title col
    if {![tixTable:isValidCol $w $col 1]} return 

#saving active data
    $w saveactivedata    

    # holds a list of the sorted rows 
    # which had allready entered into the table 
    set enteredList ""

    # holds a list of rows which in the sorted col
    # don't have any value but they are not empty rows
    # these rows will be entered after the sorted ones
    set unSortedRowList ""

    # row-num from which we start the non-title rows
    set beginRow [expr  [$data(w:table) cget -roworigin] + \
		      [$data(w:table) cget -titlerows] + $rowSkip]

    set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]

    #dbg tixTable "colsort : beginRow =$beginRow  maxRow=$maxRow"

    set list {}
    if { $data(-undo)} {
      set savePosList {}
    }
    for {set i $beginRow } {$i < $maxRow } {incr i} {
      set val [$data(w:table) get $i,$col]
      #dbg tixTable "colsort : row=$i val=$val"
	if { $val != ""} {
	    lappend list "[lindex $val 0] $i"
          #dbg tixTable "colsort : list=$list"
	} elseif { ![$w isEmptyRow  $i] } {
          lappend unSortedRowList $i

          set save($i) [tixTable:GetRowDataAndTags $w $i]
	}
    }
    #dbg tixTable "list=$list"
    set sortList [lsort $list]
    #dbg tixTable "sortList=$sortList"

    set curRow $beginRow
    foreach val $sortList {
       
	set sortRow [lindex $val 1]

        #dbg tixTable "val =$val curRow=$curRow sortRow=$sortRow"
	if { $curRow != $sortRow } {
	    if { ![info exist save($curRow)] || \
		     [lsearch -exact $enteredList $curRow] == -1 } {

              set save($curRow) [tixTable:GetRowDataAndTags $w $curRow]
	    }
	    lappend enteredList $sortRow
	    if { $curRow > $sortRow } {
              tixTable:SetRow $w $curRow [lindex $save($sortRow) 0] [lindex $save($sortRow) 1]
	    } else {
		tixTable:SetRowByRow $w $curRow $sortRow
	    }
	}
        incr curRow
    } 
    if { $data(-undo) } {
      set emptyList {}
    }
    foreach row $unSortedRowList {
      tixTable:SetRow $w $curRow [lindex $save($row) 0] [lindex  $save($row) 1]
      if { $data(-undo) } {
        lappend emptyList "$row $curRow" 
      }
      incr curRow
    }
    #dbg tixTable "unSortedRowList=$unSortedRowList"
    if { $data(-undo) } {
      tixTable:RegisterSortDoUndo $w $col $list $emptyList
    }



    #dbg tixTable "clear rows :curRow=$curRow maxRow=$maxRow"
    for {set row $curRow} {$row < $maxRow } {incr row} {
	tixTable:ClearRow $w $row
    }
}


proc tixTable:isEmptyRow { w row } {

    upvar #0 $w data	    

    # col-num from which we start the non-title cols
    set beginCol [expr  [$data(w:table) cget -colorigin] + \
		      [$data(w:table) cget -titlecols]]

    set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]

    for {set col $beginCol } {$col < $maxCol } {incr col} {
       if { [lsearch -exact $data(chkbtncollist) $col] != -1 } {
         set isChckBtnCol 1
       } else {
         set isChckBtnCol 0
       }
       
      if {[$data(w:table) get $row,$col] != "" && $isChckBtnCol != 1 } {
        
        #dbg tixTable "row = $row : isEmptyRow: NO"
        return 0
      }
    }
    #dbg tixTable "row = $row : isEmptyRow: YES"


    return 1
}


proc tixTable:isTableEmpty { w } {
  upvar #0 $w data
  set beginRow [expr  [$data(w:table) cget -roworigin] + [$data(w:table) cget -titlerows]]
  set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
  for {set i $beginRow } {$i < $maxRow } {incr i} {
    if { ![$w isEmptyRow $i] } { return false}
  }
  return true
}




#mode = 1 - case sensitive,mode =0 - no case sensitive
proc tixTable:findWordInColumn { w word col { mode  0 } } {
  upvar #0 $w data	

  set beginRow [expr  [$data(w:table) cget -roworigin] + [$data(w:table) cget -titlerows]]
  set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
  if { $mode == 0 } {
    set word [string tolower $word]
  }
  for {set row $beginRow} {$row<$maxRow} {incr row} {
    set src [$data(w:table) get $row,$col] 
    #if nocase
    if { $mode == 0 } {
      set src [string tolower $src]
    }
    if { ![string compare $word $src] } {
      return $row
    }
  }
  return -1
}


proc tixTable:getBeginRow { w} {
  upvar #0 $w data
  return [expr  [$data(w:table) cget -roworigin] + [$data(w:table) cget -titlerows]]
}

proc tixTable:getMaxRow { w} {
  upvar #0 $w data
  return [expr $data(-rows) + [$data(w:table) cget -roworigin]]
}

proc tixTable:getMaxCol {w} {
  upvar #0 $w data
  return [expr $data(-cols) + [$data(w:table) cget -colorigin]]
}

#mode = 1 - case sensitive,mode =0 - no case sensitive
proc tixTable:find { w val mode {silent 0}} {

    upvar #0 $w data	  

    set data(searchVal) $val

    set data(searchIndex) 0

    set data(searchRow) [expr  [$data(w:table) cget -roworigin] + \
			     [$data(w:table) cget -titlerows]]
    set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
			     [$data(w:table) cget -titlecols]]

    set res [tixTable:findnext $w $data(searchVal) $mode $silent]
    return $res
}

#deltaSearchIndex can be used for Replace - increase start search index by deltaSearchIndex
proc tixTable:findnext { w val mode {silent 0} {deltaSearchIndex 0}} {

    upvar #0 $w data	  
    if { [info exist data(searchVal)] == 0 } { ;# eyal
      set res [tixTable:find $w $val $mode $silent]
      return $res
    }
    if { $val != $data(searchVal) } {
      set data(searchVal) $val
      set data(searchIndex) 0

      set data(searchRow) [expr  [$data(w:table) cget -roworigin] + \
                               [$data(w:table) cget -titlerows]]
      set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
                               [$data(w:table) cget -titlecols]]
    } else {
      
      set data(searchIndex) [expr $data(searchIndex) + $deltaSearchIndex]
    }
    
    if { $data(searchVal) == ""} {
      tk_messageBox  -title Alert  -type ok -icon error -message "No string is specified." -default ok -parent $w
      return 0
    }
    
    set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]
    set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]
     if { $mode == 0 } {
       set val [string tolower $data(searchVal)]
     } else {
       set val $data(searchVal)
     }
    for {set i $data(searchRow)} {$i<$maxRow} {incr i} {
      for {set j $data(searchCol)} {$j<$maxCol} {incr j} {
        set src [string range [$data(w:table) get $i,$j] \
                     $data(searchIndex) end]
        #if nocase
        if { $mode == 0 } {
          set src [string tolower $src]
        }
         
        set startRange $data(searchIndex)
	
        set data(searchIndex) [string first $val $src]
        if { $data(searchIndex) != -1 } {
            incr data(searchIndex) $startRange
            $data(w:table) see $i,$j
            tixTable:selectincell $w $i $j $data(searchIndex) \
                [expr $data(searchIndex) + [string length $val ]]
            incr data(searchIndex) [string length $val ];#!!!
            set data(searchRow) $i
            set data(searchCol) $j
          
            return 1
        } else {
          set data(searchIndex) 0
        }
      }
      set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
                               [$data(w:table) cget -titlecols]]
    }    
    
    if {$silent == 0} {
      tk_messageBox -title Alert  -type ok -icon error -message "String not found." -default ok -parent $w
    }

    set data(searchIndex) 0
    set data(searchRow) [expr  [$data(w:table) cget -roworigin] + \
			     [$data(w:table) cget -titlerows]]
    set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
			     [$data(w:table) cget -titlecols]]
    return 0
  }

proc tixTable:findprev { w val mode {silent 0} {deltaSearchIndex 0}} {

  upvar #0 $w data	  
  if { [info exist data(searchVal)] == 0 } { 
    set res [tixTable:find $w $val $mode $silent]
    return $res
  }
  
  if { $val != $data(searchVal) } {
    set data(searchVal) $val
    set data(searchIndex) 0
    
    set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
                                 [$data(w:table) cget -titlecols]]
    set data(searchRow) [$data(w:table) index active row]
  } else {
    set data(searchIndex) [expr $data(searchIndex) + $deltaSearchIndex]
  }
    
  if { $data(searchVal) == ""} {  
    tk_messageBox  -title Alert  -type ok -icon error -message "No string is specified." -default ok -parent $w
    return 0
  }

  set minCol [$data(w:table) cget -colorigin]
  set minRow [$data(w:table) cget -roworigin]
  
  if { $mode == 0 } {
    set val [string tolower $data(searchVal)]
  } else {
    set val $data(searchVal)
  }
  for {set i $data(searchRow)} {$i>=$minRow} {incr i -1} {
      for {set j $data(searchCol)} {$j>=$minCol} {incr j -1} {
        set src [string range [$data(w:table) get $i,$j] \
                     $data(searchIndex) end]
        if { $mode == 0 } {
          set src [string tolower $src]
        }
         
        set startRange $data(searchIndex)
	
        set data(searchIndex) [string first $val $src]
        if { $data(searchIndex) != -1 } {
          $data(w:table) see $i,$j
          incr data(searchIndex) $startRange
          tixTable:selectincell $w $i $j $data(searchIndex) \
              [expr $data(searchIndex) + [string length $val ]]
          incr data(searchIndex) [string length $val ];#!!!
          set data(searchRow) $i
          set data(searchCol) $j
          
          return 1
        } else {
          set data(searchIndex) 0
        }
      }
      set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
                               [$data(w:table) cget -titlecols]]
    }    
    
    if {$silent == 0} {
      tk_messageBox -title Alert  -type ok -icon error -message "String not found." -default ok -parent $w
    }

    set data(searchIndex) 0
    set data(searchRow) [expr  [$data(w:table) cget -roworigin] + \
			     [$data(w:table) cget -titlerows]]
    set data(searchCol) [expr  [$data(w:table) cget -colorigin] + \
			     [$data(w:table) cget -titlecols]]
    return 0
  }

proc tixTable:fillSelectedCells { w val {selectedCellsList "" } } {

  upvar #0 $w data
  
  set activeInd ""
  catch { set activeInd [$data(w:table) index active] }
 
  if {$selectedCellsList == "" } {
    set selectedCellsList [$data(w:table) curselection]
  }
  
  if { $selectedCellsList=="" && $activeInd!=""} {
    set selectedCellsList $activeInd
    #unactivate active index
    $w activate ""
  } else {
    #unactivate active index
    if { [$data(w:table) selection includes $activeInd] } {
      $w activate ""
    } else {
      set  activeInd ""
    }
  }

  set lastCheckButtonCol ""
  if { $data(-undo) } {
    set oldData {} 
    set newData {}
  }

    foreach index $selectedCellsList {
      if { [$w canEditCell $index $val] } {
        set oldVal [$data(w:table) get $index]

        $data(w:table) set $index $val
        

        scan $index %d,%d row col
        tixTable:RunCellWidgetCommand $w $row $col  $val
        if { $data(-undo) } {
          lappend oldData "$index $oldVal"
          lappend newData "$index $val"
          
        }

        
        if { $col==$lastCheckButtonCol || [lsearch -exact $data(chkbtncollist) $col] != -1 } {
          ;#is Checkbutton column
          set row [lindex [split $index , ] 0 ]
          $w setchkbtnimg $row $col
          set lastCheckButtonCol $col
        } else {
          set lastCheckButtonCol ""
        }
      }
    }
  if { $data(-undo) } {
    tixTable:RegisterFillCellsDoUndo $w [list $oldData] [list $newData]
  }

  if { $activeInd != "" } {
    tixTable:ActivateSilently $w $activeInd
  }
  
    
}

proc tixTable:RunCellWidgetCommand { w row col val} {
  upvar #0 $w data
  
  

  if { [winfo exists $data(w:$col)] &&  $data(w:$col)!= {} } {
    set winType [winfo class $data(w:$col)]
    if { $winType == "TixComboBox" } {
      if { [$data(w:$col) cget -command]!="" } {
        catch {
          tixTable:ActivateSilently $w $row,$col 
          $data(w:$col) config -value $val
        }
      }
    }
  }
}



proc tixTable:fillcolbytag { w col tag {beginRow "" } } {

    upvar #0 $w data

    if {![$data(w:table) tag exists $tag]} {
	puts "Tag $tag doesn't exist"
	return
    }
    
    $w activate ""
    #irena
    #storing tag of btnColumn
    lappend data(btnColTagPairList) [list $col $tag ]

    # set maxRow [expr $data(-rows) + [$data(w:table) cget -roworigin]]

#     # the first real row number (== not title)
#     if { $beginRow == "" } {
#       set beginRow [expr  [$data(w:table) cget -roworigin] + \
#                         [$data(w:table) cget -titlerows]]
#     }

#     for {set row $beginRow} { $row < $maxRow } { incr row } { 

# 	if {![$data(w:table) tag includes dis $row,$col]} {
#           dbg tixTable "fillcollbytag : row =$row "
# 	    $data(w:table) tag cell $tag $row,$col
# 	}
#     }
    $data(w:table) tag col $tag $col
    #remove this tag from title rows

    set titlerows [$data(w:table) cget -titlerows]
    
    if {$titlerows >0 } {
      set firstTitleRow [$data(w:table) cget -roworigin]
      set lastTitleRow [expr $firstTitleRow + $titlerows]
     
      for {set row $firstTitleRow} { $row < $lastTitleRow } { incr row } { 
        $data(w:table) tag cell empty $row,$col
      }
    }
    
    
}

proc tixTable:SetRow { w row rowData { rowDis "" }} {

    upvar #0 $w data	    
    #dbg tixTable "SetRow : row =$row  rowData=$rowData rowDis=$rowDis"
    # col-num from which we start the non-title cols
    #set beginCol [expr  [$data(w:table) cget -colorigin] +  [$data(w:table) cget -titlecols]]
    set beginCol [$data(w:table) cget -colorigin]
    if { $data(-preserveRowTitles)} {
      incr beginCol [$data(w:table) cget -titlecols]
    }
    set maxTableCol  [expr $data(-cols) + [$data(w:table) cget -colorigin]]
    set maxCol [expr $maxTableCol + $data(-hiddenCols) ]
    #dbg tixTable "tixTable:SetRow : maxCol=$maxCol rowData=$rowData"
    for {set col $beginCol; set i 0 } {$col < $maxCol } {incr col; incr i} {

      set $data(-variable)($row,$col) [lindex $rowData $i]
      if {$col <$maxTableCol && [$data(w:table) tag includes dis $row,$col]} {
        $data(w:table) tag cell {} $row,$col
      }
    }

    foreach col $data(chkbtncollist) {
	$w setchkbtnimg $row $col
    } 
    if { $rowDis != {} } {
      foreach col $rowDis {
        $data(w:table) tag cell dis $row,$col
      }
    }

    
}

#assumig curRow && otherRow exists!!
proc tixTable:SetRowByRow { w curRow otherRow } { 
    
    
    upvar #0 $w data	    
    #dbg tixTable "SetRowByRow : curRow=$curRow otherRow=$otherRow"
 
    # col-num from which we start the non-title cols
#    set beginCol [expr  [$data(w:table) cget -colorigin] + [$data(w:table) cget -titlecols]]
    set beginCol [$data(w:table) cget -colorigin] 
    if { $data(-preserveRowTitles)} {
      incr beginCol [$data(w:table) cget -titlecols]
    }
    set maxTableCol  [expr $data(-cols) + [$data(w:table) cget -colorigin]]
    set maxCol [expr $maxTableCol + $data(-hiddenCols)]


    for {set col $beginCol} {$col < $maxCol } {incr col} {

      if {$col <$maxTableCol } {
        set makeDis [$data(w:table) tag includes dis  $otherRow,$col ]
        set wasDis [$data(w:table) tag includes dis  $curRow,$col ]
        #add disable tag if needed 
        if { $makeDis && !$wasDis } {
          $data(w:table) tag cell dis $curRow,$col
        }
        #clear disable tag if needed
        if { $wasDis && !$makeDis } {
          $data(w:table) tag  cell {} $curRow,$col
        }
      }
      if { [info exists $data(-variable)($otherRow,$col)] } {
        set $data(-variable)($curRow,$col) [set $data(-variable)($otherRow,$col)]
      } else {
        set $data(-variable)($curRow,$col) ""
      }

    }

    foreach col $data(chkbtncollist) {
	$w setchkbtnimg $curRow $col
    }    
    
}

proc tixTable:SetCol { w col colData { colDis ""}} {
  
  upvar #0 $w data
  # row-num from which we start the non-title rows
  set beginRow [$data(w:table) cget -roworigin]
  set maxRow  [expr $data(-rows) + [$data(w:table) cget -roworigin]]

  for {set row $beginRow; set i 0 } {$row < $maxRow } {incr row; incr i} {

    set $data(-variable)($row,$col) [lindex $colData $i]
    if {$row <$maxRow && [$data(w:table) tag includes dis $row,$col]} {
      $data(w:table) tag cell {} $row,$col
    }
  }

  if { $colDis != {} } {
    foreach row $colDis {
      $data(w:table) tag cell dis $row,$col
    }
  }
}

proc tixTable:config-deleteMode { w value } {
  upvar #0 $w data
  if {  [string compare $value  $data(-deleteMode)] } {
    set data(-deleteMode) $value
    if {  ![string compare $value "delete"] } {
      bind $data(w:table) <Delete> "$w deleteSelectedCellsOrRows"
    } elseif {  ![string compare $value "clear"] } {
      bind  $data(w:table) <Delete> "$w clearSelectedCells"
    } elseif {  ![string compare $value "command"] } {
      bind  $data(w:table) <Delete> "eval $data(-deleteCommand) $w "
    }  else {
      bind  $data(w:table) <Delete> ""
    }
  }
}

proc tixTable:config-deleteCommand { w value } {
upvar #0 $w data
  if {  [string compare $value  $data(-deleteCommand)] } {
    set data(-deleteCommand) $value
    if {  ![string compare $data(-deleteMode) "command"] } {
      bind  $data(w:table) <Delete> "eval $data(-deleteCommand) $w "
    }
  }
}
proc tixTable:config-xscroll { w value } {
  upvar #0 $w data
  if { $value != $data(-xscroll) } {
    if { $value == "yes" } {
      set data(-xscroll) "yes"
      tixTable:AddXScrollBar $w
      grid $data(w:scrollbarx) -sticky ew
      update
    } elseif { $value == "no" } {
      set data(-xscroll) "no"
      if {  $data(w:scrollbarx)!= "" } {
        grid forget $data(w:scrollbarx)
        update
      }
    }
  }
  
}
proc tixTable:config-yscroll { w value } {
  upvar #0 $w data
  if { $value != $data(-yscroll) } {
    if { $value == "yes" } {
      set data(-yscroll) "yes"
      tixTable:AddYScrollBar $w
      grid forget $data(w:table)
      update
      grid $data(w:table) $data(w:scrollbary) -sticky news
      update
    } elseif { $value == "no" } {
      set data(-yscroll) "no"
      if {  $data(w:scrollbary)!= "" } {
        grid forget $data(w:scrollbary)
      }
    }
  }
}
proc tixTable:config-colorigin { w value } {
   
    upvar #0 $w data
    $data(w:table) config -colorigin $value	
}

proc tixTable:config-titlecols { w value } {
   
    upvar #0 $w data
    $data(w:table) config -titlecols $value	
}
proc tixTable:config-roworigin { w value } {
   
    upvar #0 $w data
    $data(w:table) config -roworigin $value	
    
}

proc tixTable:config-titlerows { w value } {
   
    upvar #0 $w data
    $data(w:table) config -titlerows $value	
}


proc tixTable:config-command { w value } {
   
    upvar #0 $w data
    set data(-command) $value
   
}
proc tixTable:config-rowtagsetcommand { w value } {
   
    upvar #0 $w data
    set data(-rowtagsetcommand) $value
   
}
proc tixTable:config-canAddRows { w value } {
   
    upvar #0 $w data
    set data(-canAddRows) $value
   
}

proc tixTable:config-variable { w value } {
   
    upvar #0 $w data
    set data(-variable) $value
    $data(w:table) config -variable $data(-variable)
}

proc tixTable:config-state { w value } {
   
    upvar #0 $w data

    if { $value == "disabled" && $data(-state) == "normal" && \
	     $data(lastCol) != "" } {
	$w activate ""
    }
    set data(-state) $value
    $data(w:table) config -state $value
}

proc tixTable:config-rows { w value } {
  upvar #0 $w data
  set data(-rows) $value

  $data(w:table) config -rows $value
}


proc tixTable:config-fixedColumns { w value } {
  upvar #0 $w data
  set data(-fixedColumns) $value
}
proc tixTable:config-stayInCell { w value } {
  upvar #0 $w data
  set data(-stayInCell) $value
}
proc tixTable:config-hiddenColsForPaste { w value } {
  upvar #0 $w data
  set data(-hiddenColsForPaste) $value
}


proc tixTable:onScroll { w args } {
  upvar #0 $w data
  
  if { [lindex $args 0] == "set" } {
    foreach mergeTableItem $data(mergeTable) {
      set numOfCell [lindex $mergeTableItem 0]
      set firstCol [lindex $mergeTableItem 1]
      set labelPath [lindex $mergeTableItem 2]
      set row [lindex $mergeTableItem 3]
      tixTable:MergeCellsByLabel $w $numOfCell $row $firstCol $labelPath
    }
  }

  return [eval RENAMED_SCROLLBAR_$w $args]
}

proc tixTable:mergetitle { w numOfCell firstCol labelPath {row -1} {numOfRows 1}} {
  upvar #0 $w data
  if { ![string compare [winfo manager $data(w:table)] "" ] } {
    puts "Error : tixTable should be packed before merge titles !!!"
  }
  # Append new merge title to per-widget merge table ...
  lappend data(mergeTable) [list $numOfCell $firstCol $labelPath $row]

  tixTable:SetBindingsForMergedLabel $w $labelPath

  # If command allready exists
  if {$data(w:scrollbarx)!= ""} {
    if { [info commands RENAMED_SCROLLBAR_$w] == "" } {
      rename  $data(w:scrollbarx) RENAMED_SCROLLBAR_$w
      proc $data(w:scrollbarx) { args } [list eval "eval tixTable:onScroll $w \$args"]
    }
  } else {
    ;#if there is no x-scrollbar
    tixTable:MergeCellsByLabel $w $numOfCell $row $firstCol $labelPath
  }
}

proc tixTable:canResizeColumn { w col } {
  # getting parent window 
  set parent [winfo parent $w]

  upvar #0 $parent data

  if { ![info exists data(-fixedColumns)] || [lsearch -exact  $data(-fixedColumns) $col] == -1 } {
    return true
  } else {
    return false
  }
}


####################

proc tixTable:SetBindingsForMergedLabel {w labelPath} {
  upvar #0 $w data 
  bind $labelPath <ButtonPress-1> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    #event generate $tableWidget.table <ButtonPress-1> -x $x -y $y
    #remove "event generate" in order to allow other bindings for label
    set col  [$tableWidget.table index @$x,$y col]
    tixTable:SelectColumn $tableWidget $col
  }
  
  bind $labelPath <ButtonRelease-1> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    event generate $tableWidget.table <ButtonRelease-1> -x $x -y $y
  }
  
  bind $labelPath <B1-Motion> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    event generate $tableWidget.table <B1-Motion> -x $x -y $y
  }

  bind $labelPath <Shift-1> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    event generate $tableWidget.table <Shift-1> -x $x -y $y
  }
  
  bind $labelPath <Control-1> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    event generate $tableWidget.table <Control-1> -x $x -y $y
  }
  bind $labelPath <3> {
    set tableWidget [winfo parent %W]
    set point [tixTable:GetTableCoords $tableWidget %x %y %W]
    set x [lindex $point 0]
    set y [lindex $point 1]
    event generate $tableWidget.table <3> -x $x -y $y
  }
}
proc tixTable:MergeCellsByLabel { w numOfCell row firstCol labelPath } {
  upvar #0 $w data 
  set lastCell [expr $firstCol + $numOfCell]
  
  for {set i $firstCol} {$i < $lastCell} {incr i} {	
    set cord($i) [$data(w:table)  bbox $row,$i]
  }
  
  set startlabel $firstCol
  while {($startlabel < $lastCell) && ($cord($startlabel) == {})} {
    incr startlabel
  }

  if { $startlabel < $lastCell } {
    set x [expr [lindex $cord($startlabel) 0] + 1]
    set y [expr [lindex $cord($startlabel) 1] + 1]
    set width 0
    for {set i $startlabel} {$i < $lastCell} {incr i} {
      if { [lindex $cord($i) 2] != "" } {
        #because bbox of columns with width 0 still has some width
        if {[$data(w:table) width $i] != 0} {
          incr  width  [lindex $cord($i) 2]
        }
      }
    }
    incr width -2
    set h [expr [lindex $cord($startlabel) 3] - 1 ];#was 10 	
    place $labelPath -x $x -y $y -width $width -height $h


  } else {
    place forget $labelPath
  }
} 

proc tixTable:GetTableCoords {w x y labelWidget} {
  upvar #0 $w data
  #Translate x,y to table's x,y
  set tableX -1
  set tableY -1
  set startCol ""
  foreach mergeTableItem $data(mergeTable) {
    set labelPath [lindex $mergeTableItem 2]
    if {$labelPath == $labelWidget } {
      set startCol [lindex $mergeTableItem 1]
      set row [lindex $mergeTableItem 3]
    }
  }
  if { $startCol != "" } {
    #define x coord of label start
    set row [$data(w:table) cget -roworigin]
    set bbox [$data(w:table) bbox $row,$startCol]
    set startX [expr [lindex $bbox 0] +1]
    set startY [expr [lindex $bbox 1] +1]
    set tableX [expr $x + $startX]
    set tableY [expr $y + $startY]
  }
  
  return "$tableX $tableY"
}

#if window is Entry or has subwidget entry returns this Entry, else returns ""
proc tixTable:GetEntryWidget { win } {
  set class [winfo class $win]
  switch $class {
    Entry  { set entry $win  } 
    TixComboBox  -
    TixComboTable -
    TixFileField -
    TixFileEntry  { set entry [$win subwidget entry] }
    TixFileChooser { set entry [$win component entry] }
    default { set entry "" }
  }
  #	TixPointsEntry { set entry [$win subwidget entry] }
  return $entry
}

proc tixTable:SelectCommand { w s} {
  upvar #0 $w data

  if { $data(-hiddenCols) == 0 } { return $s }
  set selectedList [$data(w:table) curselection]


  if { $selectedList != "" } {
    set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin] - 1]
    set beginHidCol [expr $maxCol + 1]
    set maxHidCol [expr $beginHidCol + $data(-hiddenCols)]

    set s ""
    set rowData ""
    set prevRow [lindex [split [lindex $selectedList  0] ,] 0]
    foreach index $selectedList { 

      scan $index %d,%d row col
      if { $prevRow != $row } {
        if { [llength $rowData] ==1 && $rowData != "{}" } {
          set rowData "{$rowData}"
        }
        lappend s $rowData
        set rowData ""
        set prevRow $row
      }

      if { [info exists $data(-variable)($index) ]} {
        lappend rowData [set $data(-variable)($index)]
      } else {
        lappend rowData  {}
      }

      if {$col ==  $maxCol} { 
        for { set i $beginHidCol} { $i < $maxHidCol} {incr i} {
          if { [info exists $data(-variable)($row,$i) ]} {
            lappend rowData  [set $data(-variable)($row,$i)]
          } else {
            lappend rowData {}
          }
        }
      }
           

    }
#append last row data
    if { [llength $rowData ] == 1 && $rowData != "{}"  } {
      set rowData "{$rowData}"
    }
    lappend s $rowData
  }
  #dbg tixTable  "SelectCommand : s=$s"
  return $s
}

proc tixTable:IsLegalValueForCell { w col value } {
  upvar #0 $w data
  set isLegal true
  set win ""
  if { [info exists data(w:$col)] && $data(w:$col)!= "" } {
    set win $data(w:$col)
    set winType [winfo class $win]
    if { $winType == "TixComboBox" && ![ $win cget -editable] } {
      set valueList [[$win subwidget listbox] get 0 end]
      if { [lsearch -exact $valueList $value] == -1 } {
        set isLegal false
        dbg tixTable "NOT LEGAL VALUE !!! : value =$value"
      }
    }
        
  }

  return $isLegal

}
###############################################################################################################
#Undo Support
###############################################################################################################
#call to this in SaveLastCellData
proc tixTable:RegisterTypingDoUndo { w row col oldVal newVal} {
  upvar #0 $w data
  dbg tixTable "RegisterTypingDoUndo : oldVal=$oldVal newVal=$newVal"
  # if { $oldVal == ""} {
#     set oldVal "{}"
#   }
#   if { $newVal == ""} {
#     set newVal "{}"
#   }
  
  catch {
    $data(undoManager) Add [list tixTable:SetCellData $w $row $col $newVal] \
        [list tixTable:SetCellData $w $row $col $oldVal] 
  }
  dbg tixTable "TypingDoUndo error=$::errorInfo"
}
#should be  used only for undo
proc tixTable:SetCellData {w row col value} {
  upvar #0 $w data

  if { [$w canModifyCell $row,$col] } {
    dbg tixTable "------- >start SetCellData "

    tixTable:ActivateSilently $w $row,$col
    dbg tixTable "------> activeInd = [$data(w:table) index active]"
    $data(w:table) set $row,$col $value 
    $w ShowEmbWidget  $row,$col
    
    set $data(var$col) $value 
   dbg tixTable "------- >end SetCellData "
  }
}
#=================================================================#
proc tixTable:RegisterFillCellsDoUndo { w oldData newData} {
  upvar #0 $w data
  dbg tixTable "RegisterFillCellsDoUndo : oldData=$oldData \n newData=$newData"
  catch {
    $data(undoManager) Add "tixTable:SetCellsData $w $newData" "tixTable:SetCellsData $w $oldData"
  }
  dbg tixTable "RegisterFillCellsDoUndo error=$::errorInfo"
}

proc tixTable:SetCellsData { w cellData} {
  upvar #0 $w data
  foreach item $cellData {
    set index [lindex $item 0]
    set val [lrange $item 1 end]
    set $data(-variable)($index) $val 
  }
  #check Checkbuttons !!!!
}

#=================================================================#

proc tixTable:RegisterSetRowDoUndo {w row rowData {rowDis ""}} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "tixTable:SetRow  $w $row [list $rowData] [list $rowDis]" "tixTable:ClearRow $w $row"
  }
}

#==================================================================#

proc tixTable:RegisterSetColDoUndo {w col colData {colDis ""}} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "tixTable:SetCol  $w $col [list $colData] [list $colDis]" "tixTable:ClearCol $w $col"
  }
}


#=================================================================#
proc tixTable:RegisterDeleteRowDoUndo { w row rowData rowDis } { 
  upvar #0 $w data
  dbg tixTable "RegisterDeleteRowDoUndo:row=$row rowData=$rowData"
  catch {
    $data(undoManager) Add "$w delete $row" "tixTable:AddRowData  $w $row [list $rowData] [list $rowDis]"
  }
}
#rowDis is the list of columns that should have tag disabled
proc tixTable:AddRowData { w row rowData {rowDis ""} } {
  upvar #0 $w data
  
  set rowNum [ expr $row - 1]
  $w addrow $rowNum;
  tixTable:SetRow $w $row $rowData $rowDis
}
#=================================================================#

proc tixTable:RegisterDeleteColDoUndo { w col colData colDis args} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "tixTable:_DeleteCol $w $col $args" "tixTable:AddColData  $w $col [list $colData] [list $colDis]"
  }
}

proc tixTable:AddColData { w col colData {colDis ""} } {
  upvar #0 $w data
  set colNum [ expr $col - 1]
  $w addcols $colNum 1
  tixTable:SetCol $w $col $colData $colDis
}
#=================================================================#

proc tixTable:RegisterInsertRowDoUndo { w row count } {
  upvar #0 $w data
  dbg tixTable "RegisterInsertRowDoUndo : row=$row count=$count"
  if { $count == 1 } {
    set rowNum [expr $row + 1]
  } else {
    set rowNum $row
  }
  catch {
    $data(undoManager) Add "tixTable:_AddRow $w $row $count" \
        "$w delete $rowNum"

  }
  dbg tixTable "InsertRowDoUndo error=$::errorInfo"
}
#==================================================================#

proc tixTable:RegisterAddColsDoUndo {w col count right} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "$w addcols $col $count $right" \
        "tixTable:_DeleteCols $w $col abs($count) $right"
  }
}

#==================================================================#
#has to be checked  !!!
proc tixTable:RegisterRemoveColsDoUndo {w col count} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "$w removecols $col $count" \
        "$w addcols $col -$count"
  }
}

#==================================================================#
proc tixTable:RegisterArrangeMergeTitleLabelsDoUndo {w dir origFirstCol numCols newcol} {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "tixTable:ArrangeMergeTitleLabels $w $dir $origFirstCol $numCols $newcol"\
        "tixTable:ReverseMergeTitleLabels $w $dir $origFirstCol $numCols $newcol"
  }
}

proc tixTable:ReverseMergeTitleLabels {w dir origFirstCol numCols newcol} {
  upvar #0 $w data
  switch $dir {
    left {
      set reverseDir right
    }
    right {
      set reverseDir left
    }
    start {
      set reverseDir end
    }
    end {
      set reverseDir start
    }
  }
  tixTable:ArrangeMergeTitleLabels $w $reverseDir $newcol $numCols $origFirstCol
}

#==================================================================#
proc tixTable:RegisterSortDoUndo { w col rowPairList emptyPairList } {
  upvar #0 $w data
  catch {
    $data(undoManager) Add "$w colsort $col" "tixTable:UndoSort $w $col [list $rowPairList] [list $emptyPairList]"
  }
}

proc tixTable:UndoSort {w col rowPairList emptyPairList } {
  upvar #0 $w data
  dbg tixTable "UndoSort : col=$col \nrowPairList=$rowPairList\nemptyPairList=$emptyPairList"
  foreach pair $emptyPairList {
    set row [lindex $pair 0]
    set curRow [lindex $pair 1]
    if { $row !=$curRow } {
      set rowDataList [tixTable:GetRowDataAndTags $w $row]
      tixTable:SetRowByRow $w $row $curRow
      tixTable:SetRow $w $curRow [lindex $rowDataList 0] [lindex $rowDataList 1]
    }
  }
  foreach pair $rowPairList {
    dbg tixTable "pair=$pair"
    set name [lindex $pair 0]
    set row  [lindex $pair 1]
    set curRow [$w findWordInColumn $name $col 1]
    set val [$data(w:table) get $row,$col]
    dbg tixTable "row=$row curRow=$curRow"
             if { $curRow!="" && $row !=$curRow && [string compare $name $val] } {
      set rowDataList [tixTable:GetRowDataAndTags $w $row]
      tixTable:SetRowByRow $w $row $curRow
      tixTable:SetRow $w $curRow [lindex $rowDataList 0] [lindex $rowDataList 1]
    }
  }
}

#==================================================================#
proc tixTable:undo { w  } { 
  upvar #0 $w data
  dbg tixTable "\n---------------tixTable:undo--------------\n"
  set data(undoRedoMode) 1
  catch {
    $w saveactivedata
    if {$data(-undo) } {
      $data(undoManager) Undo
    }
  }
  dbg tixTable "undoError= $::errorInfo"
  #$data(undoManager) PrintStack
  set data(undoRedoMode) 0
}

proc tixTable:redo { w  } { 
  upvar #0 $w data
  set data(undoRedoMode) 1
  catch {

    if {$data(-undo) } {
      $w saveactivedata
      $data(undoManager) Redo
    }
  }
  dbg tixTable "redoError= $::errorInfo"
#  $data(undoManager) PrintStack
  set data(undoRedoMode) 0
}
proc tixTable:startCompoundCommand { w commandName } { 
  upvar #0 $w data
  if { $data(-undo) } {
    $data(undoManager) StartCompoundCommand $commandName
  }
}
proc tixTable:endCompoundCommand { w commandName } { 
  upvar #0 $w data
  if { $data(-undo) } {
    $data(undoManager) EndCompoundCommand $commandName
  }
}


proc tixTable:setTraceForEmbeddededWin { w procName} {
  upvar #0 $w data
  set varList [tixTable:GetVariablesList $w]
  #dbg tixTable "tixTable:setTraceForEmbeddededWin : varList=$varList"
  foreach var $varList {
    if { [trace vinfo $var] == "" } {
      trace variable $var w $procName
    }
  }
  set data(traceProcName) $procName
}

proc tixTable:UpdateTraceForEmbeddededWinByCol { w col} {
  upvar #0 $w data
  catch {
    if { $data(traceProcName) != ""  && [info exists  data(var$col)]} {
    set var $data(var$col)
      if { [trace vinfo $var] == "" } {
        trace variable $var w $data(traceProcName)
      }
    }
  }
}

proc tixTable:removeTraceForEmbeddededWin { w procName} {
  upvar #0 $w data
  set varList [tixTable:GetVariablesList $w]
  #dbg tixTable "tixTable:removeTraceForEmbeddededWin : varList=$varList"
  foreach var $varList {
    trace vdelete $var w $procName
  }
}

proc tixTable:GetVariablesList {w } {
  upvar #0 $w data
  set beginCol [expr  [$data(w:table) cget -colorigin] + \
		      [$data(w:table) cget -titlecols]]
   set maxCol [expr $data(-cols) + [$data(w:table) cget -colorigin]]
  set varList ""  
  for {set col $beginCol } {$col < $maxCol} {incr col} {
    if { [info exists  data(var$col)] } {
      set var $data(var$col)
      lappend varList $var
    }
    
  }
  return $varList
}

proc tixTable:getEmbeddedWindow { w col} {
  upvar #0 $w data
  if { [info exists data(w:$col)]} {
    return  $data(w:$col)
  } else {
    return ""
  }
}

#private : explicitly sets  value of table cell , supports undo - registrates typing information for undo
proc tixTable:ChangeCellValue { w ind val } {
  upvar #0 $w data
  set oldVal [$data(w:table) get $ind]
  if { [string compare $oldVal $val ]!= 0 } {
    $data(w:table) set $ind $val
    
    if { $data(-undo) } {
      set indList [split $ind ,]
      tixTable:RegisterTypingDoUndo $w [lindex $indList 0] [lindex $indList 1] $oldVal $val
    }
  }
}

#explicitly sets  value of table cells , supports undo - registrates typing information for undo

proc tixTable:changeCellsValues { w indexValuePairsList } {
  upvar #0 $w data
  dbg tixTable " tixTable:changeCellsValues  $indexValuePairsList"
  if { $data(-undo) && ([llength $indexValuePairsList] > 1) } {
    $data(undoManager) StartCompoundCommand tixTable:changeCellsValues
    set compound 1
  }
  catch {
    foreach item $indexValuePairsList {
      set ind [lindex $item 0] 
      set value [lindex $item 1] 
      tixTable:ChangeCellValue $w $ind $value
    }
  }
  if { $compound == "1" } {

    $data(undoManager) EndCompoundCommand tixTable:changeCellsValues
  }
}

proc tixTable:getPrevActiveIndex { w } {
  upvar #0 $w data
  return "$data(lastRow),$data(lastCol)"
}

proc tixTable:getUndoManager {w} {
  upvar #0 $w data
  return $data(undoManager)
}
