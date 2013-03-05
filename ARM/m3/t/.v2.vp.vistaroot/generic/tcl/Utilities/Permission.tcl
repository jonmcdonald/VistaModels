namespace eval ::Utilities {
  
  proc getPermissionStr {permissionStr {curValue 0}} {
	set found [regexp {^([ugoa])[ ]*([+-])[ ]*([rwx]*)} $permissionStr all ugoa plusminus rwx]
	if {!$found} {
	  error "Invalid permission: $permissionStr"
	}
	
	if {"$plusminus" == "+"} {
	  set op |
	} elseif {"$plusminus" == "-"} {
	  set op &~
	} else {
	  error "Invalid permission: $permissionStr"
	}
	
	set length [string length $rwx]
	set rwxBit 0
	for {set i 0} {$i < $length} {incr i} {
	  set symbol [string index $rwx $i]
	  switch $symbol {
		r {set rwxBit [expr $rwxBit | 4]}
		w {set rwxBit [expr $rwxBit | 2]}
		x {set rwxBit [expr $rwxBit | 1]}
	  }
	}
	switch $ugoa {
	  u {set curValue [expr $curValue $op ($rwxBit << 6)]}
	  g {set curValue [expr $curValue $op ($rwxBit << 3)]}
	  o {set curValue [expr $curValue $op $rwxBit]}
	  a {set curValue [expr ($curValue $op (($rwxBit << 6) + ($rwxBit << 3) + $rwxBit))]}
	  default { error "Invalid permission: $permissionStr" }
	}
	
	return $curValue
  }

  proc isUserExecutable {octPermission} {
	return [expr $octPermission & 00100]
  }

  proc isUserWritable {octPermission} {
	return [expr $octPermission & 00200]
  }

  proc isUserReadable {octPermission} {
	return [expr $octPermission & 00400]
  }

  proc setUserExecutable {octPermission} {
	return [expr $octPermission | 00100]
  }

  proc setUserWritable {octPermission} {
	return [expr $octPermission | 00200]
  }

  proc setUserReadable {octPermission} {
	return [expr $octPermission | 00400]
  }

  proc unsetUserExecutable {octPermission} {
	return [expr $octPermission & 07677]
  }

  proc unsetUserWritable {octPermission} {
	return [expr $octPermission & 07577]
  }

  proc unsetUserReadable {octPermission} {
	return [expr $octPermission & 07377]
  }


}

