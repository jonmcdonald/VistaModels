namespace eval ::Utilities {

  proc splitre {str {regexp {[\t \r\n]+}}} {
    set total_length [string length $str]
    if {$total_length == 0} {
      return {}
    }
    if {[string length $regexp] == 0} {
      return [split $str ""]
    }
    set list  {}
    set start 0
    while {[regexp -start $start -indices -- $regexp $str match]} {
      foreach {matchStart matchEnd} $match break ;# Not a loop -- just an assignment.
      incr matchEnd
      if {$start >= $matchEnd} {
        lappend list [string range $str $start $start]
        incr start
      } else {
        lappend list [string range $str $start [expr {$matchStart - 1}]]
        set start $matchEnd
      }
      if {$start >= $total_length} {
        break
      }
    }
    if {$start < $total_length} {
      lappend list [string range $str $start end]
    }
    return $list
  }

  proc getFirstSyntaxItem { str position } {
    set tail [string range $str $position end]
    set item [lindex $tail 0]
    set begin [expr $position + [string first $item $tail]]
    set end [expr $begin + [string length $item] - 1]
    set isList 0
    if { [string index $str [expr $begin - 1]] == "\{" } {
      set isList 1
    }
    if { [string index $str [expr $end + 1]] == "\}" } {
      set isList 1
    }
    return [list $begin $end $isList]
  }

  proc stringReplace { strRef begin end replaceStr } {
    upvar $strRef str
    set s1 [string range $str 0 [expr $begin - 1]]
    set s2 [string range $str [expr $end + 1] end]
    return "$s1$replaceStr$s2"
  }


  proc tmpFun { str } {
    set result ""
    set length [string length $str]
    set dotNumb 0
    for { set i 0 } { $i < $length } { incr i } {
      set ch [string index $str $i]
      if { $ch == "." } {
        incr dotNumb
        if { [expr $dotNumb % 2] == 0 } {
          set result "$result "
          continue
        }
      }
      set result "$result$ch"
    }
    return $result
  }
  
  
  proc stringFilter { charRegExp str } {
    set result ""
    set length [string length $str]
    for { set i 0 } { $i < $length } { incr i } {
      set ch [string index $str $i]
      if { [string match $charRegExp $ch] } {
        set result "[set result][set ch]"
      }
    }
    return $result
  }
  
  proc stringIntegerFilter { str } {
    return [::Utilities::stringFilter "\[0-9\]" $str]
  }

  proc guiInputToValidTclString {str} {
    set str [string trim $str]
    set len [string length $str]
    set result ""
    for {set i 0} {$i < $len} {incr i} {
      set symb [string index $str $i]
      switch -exact -- $symb {
        "\]" -
        "\[" -
        "\"" -
        "\$" -
        "\{" -
        "\}" -
        "\\" { append result "\\$symb" }
        default { append result $symb }
      }
    }
    return $result
  }

  proc trimFromSpaces {str} {
    set ind 0
    while { 1 } {
      set ind [string first " " $str $ind]
      if { $ind < 0 } {
        break
      } 
      set str [string replace $str $ind $ind ""]
    }
    return $str
  }

  proc get_boolean_if_possible {value} {
    set trimmed [string trim $value]
    if {![string compare $trimmed 1]} {
      return 1
    }
    if {![string compare $trimmed 0]} {
      return 0
    }
    set lower [string tolower $trimmed]
    if {$lower == "yes" || $lower == "y"} {
      return 1
    }
    if {$lower == "no" || $lower == "n"} {
      return 0
    }
    return $trimmed;
  }
}



