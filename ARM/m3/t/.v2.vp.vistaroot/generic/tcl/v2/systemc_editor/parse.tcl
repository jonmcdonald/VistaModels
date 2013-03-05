# Any *END* is optional: next VISTA* cancels BEGIN
# bug with escaping and shift line

#source $env(V2_HOME)/tcl/Basics/init.tcl
#source $env(V2_HOME)/tcl/Utilities/init.tcl
#package require Itcl
#package require Tclx


#set body [read_file "bd2.h"]

namespace eval ::v2::systemc_editor::parser {

  variable initialized
  set initialized 0
  variable tokens
  variable tokensOR
  proc init_language {} {
    variable tokens
    variable tokensOR
    variable initialized
    if {$initialized} {
      return
    }
    set initialized 1

    set expr0 {^[ \t;]*}
    set expr1 {^[ \t\(]*\"([^\"]+)\"[; \t\)]*}
    set expr1_with_comma {^[ \t\(]*\"([^\"]+)\"[;, \t\)]*}
    set expr2 {^[ \t\(]*\"([^\"]+)\"[ \t]*,[ \t]*\"([^\"]+)\"[; \t\)]*}

    # 0 parameters
    set tokens(\$includes_begin) $expr0
    set tokens(\$includes_end) $expr0
    set tokens(\$initialization_begin) $expr0
    set tokens(\$initialization_end) $expr0
    set tokens(\$elaboration_begin) $expr0
    set tokens(\$elaboration_end) $expr0
    set tokens(\$destructor_begin) $expr0
    set tokens(\$destructor_end) $expr0
    set tokens(\$bind_end) $expr0
    set tokens(\$ports_begin) $expr0
    set tokens(\$ports_end) $expr0
    set tokens(\$fields_begin) $expr0
    set tokens(\$fields_end) $expr0
    set tokens(\$vlnv_assign_begin) $expr0
    set tokens(\$vlnv_assign_end) $expr0
    set tokens(\$vlnv_decl_begin) $expr0
    set tokens(\$vlnv_decl_end) $expr0
    set tokens(\$module_end) $expr0
    set tokens(\$schematics_begin) $expr0
    set tokens(\$schematics_end) $expr0
    set tokens(\$end) $expr0

    # 1 pareameter
    
    set tokens(\$module_begin) $expr1
    set tokens(\$create_component) $expr1
    set tokens(\$destruct_component) $expr1
    set tokens(\$init) $expr1_with_comma
    set tokens(\$field) $expr1
    set tokens(\$port) $expr1
    set tokens(\$export) $expr1
    set tokens(\$socket) $expr1
    set tokens(\$channel) $expr1
    set tokens(\$component) $expr1

    # 2 parameters
    set tokens(\$bind) $expr2
    
    set tokensOR [join [array names tokens] "|"]
    regsub -all {\$} $tokensOR {\\$} tokensOR

  }

  proc my_regexp {expr line args} {
    set indexes {}
    foreach arg $args {
      upvar $arg $arg
      upvar ind_$arg ind_$arg
      lappend indexes ind_$arg
    }
    set result [eval regexp [list -nocase -indices] [list $expr] [list $line] $indexes]
    if {!$result} {
      return 0
    }
    #  foreach ind $indexes {
    #    puts $ind=[set $ind]
    #  }

    foreach arg $args {
      set $arg [string range $line [lindex [set ind_$arg] 0] [lindex [set ind_$arg] 1]]
    }
    return $result
  }

  proc listn {n args} {
    return [lrange $args 0 [expr $n -1]]
  }

  proc parse_file {filename} {
    parse [read_file -nonewline $filename]
  }

  proc parse {body}  {
    set catchStatus [catch {
      init_language
      variable tokens
      variable tokensOR
      
      set lines [split $body \n]
      
      # noparameters
      set length [llength $lines]
      set continue_line 0
      for {set i 0} {$i < $length} {incr i} {
        if {!$continue_line} {
          set line [lindex $lines $i]
        }
        set continue_line 0

        set ::v2::systemc_editor::parser::last_token_for_debug "TEXT"

        if {![my_regexp "\(\[ \t\]*\)\($tokensOR\)" $line all spaces token]} {
          if {$i < [expr $length - 1]} {
            append line \n
          }
          \$text $line
          continue
        }
        set text [string range $line 0 [expr [lindex $ind_all 0] -1]]
        if {$text != ""} {
          \$text $text
        }
        set token_data $all
        set line [string range $line [expr [lindex $ind_all 1] + 1] end]
        if {[my_regexp $tokens($token) $line all param1 param2]} {
          append token_data "[string range $line 0 [lindex $ind_all 1]]"
          set new_line [string range $line [expr [lindex $ind_all 1] + 1] end]
        } else {
          set new_line [string range $line [string length $token_data] end]
        }
        if {$new_line != ""} {
          set line $new_line
          set continue_line 1
          incr i -1
        } else {
          if {$i < [expr $length - 1]} {
            append token_data \n
          }
        }
        set ::v2::systemc_editor::parser::last_token_for_debug $token
        $token $token_data $param1 $param2
      }
    } msg]
    set savedCode $::errorCode
    set savedInfo $::errorInfo

    if {$catchStatus} {
      error $msg $savedInfo $savedCode
    }
    return ""
  }

}
