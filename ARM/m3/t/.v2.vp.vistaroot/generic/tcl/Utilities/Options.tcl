namespace eval ::Utilities {
  ##
  # Looks for an option in an optionList.
  # Option names must begin with "-".
  # Values cannot begin with "-".
  #
  # Returns 1 if the option was found, 0 otherwise.
  # If foundValueVar provided, sets foundValueVar to the found value
  # or to default.
  ##
  proc getOption {optionList key {foundValueVar ""} {default ""}} {
    if {$foundValueVar != ""} {
      upvar $foundValueVar foundValue
    }
    set index [lsearch -regexp $optionList "^\($key\)\$"]
    if {$index == -1 } {
      return 0
    }
    set foundValue $default
    set length [llength $optionList]
    if {$index == [expr {$length - 1}] } {
      return 1
    }
    set value [lindex $optionList [expr {$index + 1}]]
    if {[string range $value 0 0] == "-"} {
      return 1
    }
    set foundValue $value
    return 1
  }

  ##
  # Looks for an argument by index, if found & not an option return 1, otherwise 0.
  # argList contains arguments & options.
  # If foundValueVar provided, sets foundValueVar to the found value
  # or to default.
  ##
  proc getArgument {argList idx {foundValueVar ""} {default ""}} {
    if {$foundValueVar != ""} {
      upvar $foundValueVar foundValue
    }
    if {$idx < 0 || $idx >= [llength $argList]} {
      return 0
    }
    set foundValue $default
    set value [lindex $argList $idx]
    if {[string range $value 0 0] == "-"} { ;# is an option
      return 0
    } else {
      set idx_before [expr $idx -1]
      if {$idx_before >= 0} {
        set value_before [lindex $argList $idx_before]
        if {[string range $value_before 0 0] == "-"} { ;# is an option value
          return 0
        }
      }
    }
    set foundValue $value
    return 1
  }


} ;# namespace


