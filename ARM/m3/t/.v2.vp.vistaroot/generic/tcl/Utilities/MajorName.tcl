namespace eval ::Utilities::MajorName {


  # returns a list of 2 elements {majorName minorName}
  proc splitName {fullName} {
    if {[regexp {^([^@]*)(@(.*)@)?$} $fullName all majorName dummy minorName]} {
      return [list $majorName $minorName]
    } else {
      return [list $fullName ""]
    }
  }

  proc getMajorName {fullName} {
    return [lindex [splitName $fullName] 0]
  }

  proc getMinorName {fullName} {
    return [lindex [splitName $fullName] 1]
  }

  proc makeFullName {majorName minorName} {
    return "$majorName@$minorName@"
  }

  proc getObjectGroup {pObjectArray fullName} {
    upvar $pObjectArray objectArray
    set nameList [getNamesInGroup [array names objectArray] $fullName]
    set resList {}
    foreach name $nameList {
      lappend resList $objectArray($name)
    }
    return $resList
  }

  proc getNamesInGroup {nameList fullName} {
    set majorName [::Utilities::MajorName::getMajorName $fullName]
    set resLst {}
    foreach name $nameList {
      if {![string compare [::Utilities::MajorName::getMajorName $name] $majorName]} {
        lappend resLst $name
      }
    }
    return $resLst
  }

}
