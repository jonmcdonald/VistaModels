namespace eval ::List {
  
  proc usePackage {} {}


  proc removeItem { lstRef item } {
    upvar $lstRef lst
    set index [lsearch -exact $lst $item]
    if { $index != -1 } {
      set lst [lreplace $lst $index $index]
    }
  }

  proc lastElement { lst {ind 1}} {
    return [lindex $lst [expr [llength $lst] - $ind]]
  }

  proc addElement { lst element } {
    if { [lsearch -exact $lst $element] < 0 } {
      return [concat $lst $element]
    } else {
      return $lst
    }
  }
  
  proc addElements { lst args } {
    set localLst $lst
    foreach element $args {
      addElementRef localLst $element
    }
    return $localLst
  }
  
  proc addElementRef { lstRef element } {
    upvar $lstRef lst
    if { [lsearch -exact $lst $element] < 0 } {
      lappend lst $element
    }
    return ""
  }
  
  proc addElementsRef { lstRef args } {
    upvar $lstRef lst
    foreach element $args {
      addElementRef lst $element
    }
    return ""
  }
  
  
  # Remove Element From List (if contains)
  
  proc removeElement { lst element } {
    set position [lsearch -exact $lst $element]
    if { $position >= 0 } {
      return [lreplace $lst $position $position]
    } else {
      return $lst
    }
  }
  
  proc removeElements { lst args } {
    set localLst $lst
    foreach element $args {
      removeElementRef localList $element
    }
    return $localLst
  }
  
  proc removeElementRef { lstRef element } {
    upvar $lstRef localLst
    set localLst [removeElement $localLst $element]
    return ""
  }
  
  proc removeElementsRef { lstRef args } {
    upvar $lstRef localLst
    foreach element $args {
      removeElementRef localLst $element
    }
    return ""
  }
  
  proc listLength { lst } {
    return [llength $lst]
  }
  
  proc listDelete { lst index } {
    return [concat [lrange $lst 0 [expr $index -1]] [lrange $lst [expr $index + 1] end]]
  }
  
  proc listInsert { lst index element } {
    return [linsert $lst $index $element]
  }
  
  proc listReplace { lst index element } {
    if { [llength $element] > 1 } {
      set element [list $element]
    }
    return [concat [lrange $lst 0 [expr $index -1]] $element [lrange $lst [expr $index + 1] end]]
  }
  
  proc listHead { lst } {
    return [lindex $lst 0]
  }
  
  proc listTail { lst } {
    return [lrange $lst [expr { [llength $lst] - 1 }] end]
  }
  
  
  proc uniqlinsertList {sourceLst ind destLst} {
    if {$ind=="end"} { set ind [llength $sourceLst] }
    foreach i $destLst {
      if { [lsearch -exact $sourceLst $i] == -1 } {
        set sourceLst [linsert $sourceLst $ind $i]
        incr ind
      }
    }
    return $sourceLst
  }
  
  # insert 1 time each element from args into sourceLst from position ind
  # example uniqlinsertList {11 22 33} end 44 55 66 => 11 22 33 44 55 66
  proc uniqlinsert { lst ind args } {
    if {$ind=="end"} { set ind [llength $lst] }
    return [uniqlinsertList $lst $ind $args]
  }
  
  # as uniqlinsert
  proc uniqlinsertArgs { lst ind args } {
    if {$ind=="end"} { set ind [llength $lst] }
    return [uniqlinsertList $lst $ind $args]
  }
  
  # delete range from lst
  # example ldelete {11 22 33 44 55} 3 end => 11 22 33
  proc ldelete { lst from to } {
    if {$from=="end"} { set from [llength $lst] }
    if {$to=="end"} { set to [llength $lst] }
    return [concat [lrange $lst 0 [expr $from -1]] [lrange $lst [expr $to + 1] end] ]
  }
  
  # delete all items in destLst from sourceLst
  # example: ldeleteList {11 22 33 44 55} {11 00 44} => 22 33 55
  # destLst can be pattern. 
  # example: ldeleteList {gcc.exe lcc.exe gdb.exe readme.doc} *.exe => readme.doc
  proc ldeleteList { sourceLst destLst }  {
    foreach i $destLst {
      while 1 { 
        set ind [lsearch $sourceLst $i]
        if {$ind == -1} { break }
        set sourceLst [ldelete $sourceLst $ind $ind]
      }
    }
    return $sourceLst
  }
  
  
  # delete args-elements from lst
  # example ldeleteArgs {11 22 33 44 55} 11 00 44 => 22 33 55
  # destLst can be pattern, like in ldeleteList
  proc ldeleteArgs { lst args } {
    return [ldeleteList $lst $args]
  }

  proc _lsearchAll {mode list pattern} {
    set retLst ""
    set from 0
    
    while 1 {
      set ret [lsearch $mode [lrange $list $from end] $pattern]
      if {$ret == -1} {
        break
      }
      set from [expr $from + $ret]
      lappend retLst $from
      incr from
    }
    return $retLst
  } 
  
  # return list of elements, matched the pattern
  # example lsearchAll {gcc.exe lcc.exe gdb.exe readme.doc gdb.exe} *.exe => gcc.exe lcc.exe gdb.exe gdb.exe
  proc lsearchAll {args} {
    if {[llength $args] == 2} {
      set args [concat -glob $args]
    }
    return [eval _lsearchAll $args]
  }

  proc bsearch {list element compareFunction {compareArgs ""}} {
	set from 0
	set to [expr [llength $list] -1]
	while {$to > $from} {
	  set divIndex [expr ($from + $to) / 2 ]
	  set compareResult [$compareFunction $element [lindex $list $divIndex] $compareArgs]
	  if {$compareResult == 0} {
		return $divIndex
	  } elseif {$compareResult < 0} {
		incr to -1
	  } else {
		incr from 1
	  }
	}
	if {$from == $to && [$compareFunction $element [lindex $list $from] $compareArgs] == 0} {
	  return $to
	} else {
	  return -1
	}
  }
  
  proc bsearchInsert {list element compareFunction {compareArgs ""}} {
	set from 0
	set to [expr [llength $list] -1]
	while {$to > $from} {
	  set divIndex [expr ($from + $to) / 2 ]
	  set compareResult [$compareFunction $element [lindex $list $divIndex] $compareArgs]
	  if {$compareResult == 0} {
		return $divIndex
	  } elseif {$compareResult < 0} {
		incr to -1
	  } else {
		incr from 1
	  }
	}
	if {$from == $to} {
	  if {[$compareFunction $element [lindex $list $from] $compareArgs] < 0} {
		return $from
	  } else {
		return [expr $from +1]
	  }
	} else {
	  return $from
	}
  }


  proc lindexesArgs {lst args} {
    set retLst ""
    set ln [llength $lst]
    foreach i $args {
      if {$i < $ln} {
        lappend retLst [lindex $lst $i]
      }
    }
    return $retLst
  }
  
  proc lindexesList {lst indLst} {
    return [eval lindexesArgs {$lst} $indLst]
  }
  
  proc stringCompare {str1 str2 deep isConsiderLength} {
    if {$isConsiderLength} {
      return [expr [string compare $str1 $str2] == 0]
    } else {
      return [expr [string first $str1 $str2] == 0]
    }
  }
  
  proc listcompare {list1 list2 {deep 1} {isConsiderLength 1} } {
    set len1 [llength $list1]
    if {$isConsiderLength && ($len1 != [llength $list2])} {
      return 0
    }
    if {$deep == 0} {
      set comparator stringCompare
    } else {
      set comparator listcompare
    }
    incr deep -1
    for {set i 0} {$i < $len1} {incr i} {
      if {![$comparator [lindex $list1 $i] [lindex $list2 $i] $deep $isConsiderLength]} {
        return 0
      }
    }
    return 1
  }
  
  proc reverse {lst} {
    set resList ""
    set lastIndex [expr [llength $lst] -1]
    while {$lastIndex >= 0} {
      lappend resList [lindex $lst $lastIndex]
      incr lastIndex -1
    }
    return $resList
  }
  
  proc _listGetItem {list path} {
    if {$path == "" || $list == ""} {
      return ""
    }
    set children  [getOption $list -children]
    set child [lindex $children [lindex $path 0]]
    if {[llength $path] == 1} {
      return $child
    }
    return [_listGetItem $child [lrange $path 1 end]]
  }
  
  proc listGetItem {list path} {
    if {$path == "" || $list == ""} {
      return ""
    }
    if {[llength $path] == 1} {
      return [lindex $list $path]
    }
    set ind [lindex $path 0]
    return [_listGetItem [lindex $list $ind] [lrange $path 1 end]]
  }
  
  proc _listIterator {list applyFunction path args} {
    if {$list==""} {
      return ""
    }
    
    set result [string tolower [eval {$applyFunction $list 1 $path} $args]]
    
    if {[string compare $result "break"] == 0} {
      return "break"
    }
    
    set children [getOption $list -children]
    set childIndex 0
    foreach child $children {
      set result [string tolower [eval {_listIterator $child $applyFunction "$path $childIndex"} $args]]
      if {[string compare $result "break"] == 0} {
        return "break"
      }
      incr childIndex
    }
    
    set result [string tolower [eval {$applyFunction $list 0 $path} $args]]
    if {[string compare $result "break"] == 0} {
      return "break"
    }
  }
  
  proc listIterator {list applyFunction args} {
    if {$list==""} {
      return ""
    }
    set path 0
    foreach child $list {
      set result [string tolower [eval {_listIterator $child} $applyFunction $path $args]]
      if {[string compare $result "break"] == 0} {
        return ""
      }
      incr path
    }
  }
}
