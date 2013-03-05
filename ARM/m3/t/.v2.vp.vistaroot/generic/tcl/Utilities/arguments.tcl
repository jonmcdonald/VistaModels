
namespace eval ::Utilities {
  
  ;# command arguments parser

  proc parse_arguments { specification {params "@null"} } {

    ;# extact proc_name and proc_params
    set info_level_1 "[info level -1]"
    set proc_name [lindex $info_level_1 0]
    if { $params == "@null" } {
      set proc_params [lrange $info_level_1 1 end]
    } else {
      set proc_params $params
    }
    set proc_param_count [llength $proc_params]
    
    ;# prepare arguments table
    set arg_defs {}
    array set opt_defs {}
    set specification_length [llength $specification]
    for { set i 0 } { $i < $specification_length } { incr i } {
      set kind [lindex $specification $i]
      switch $kind {
        "arg" {
          incr i; set arg_name [lindex $specification $i]
          incr i; set arg_desc [lindex $specification $i]
          lappend arg_defs [list $arg_name $arg_desc]
          upvar $arg_name user_arg_${arg_name}
        }
        "opt" {
          incr i; set opt_name [lindex $specification $i]
          if { [string index $opt_name 0] != "-" } {
            error "invalid option name: ${opt_name}; must start with dash"
          }
          set opt_name [string range $opt_name 1 end]
          if { $opt_name == "usage" } {
            error "\"usage\" is a predifined implicit option"
          }
          if { $opt_name == "help" } {
            error "\"help\" is a predifined implicit option"
          }
          incr i; set opt_desc [lindex $specification $i]
          incr i; set opt_default [lindex $specification $i]
          set opt_defs($opt_name) [list $opt_desc $opt_default]
          upvar $opt_name user_opt_${opt_name}
          if { $opt_default == "-" } {
            set user_opt_${opt_name} 0
          } else {
            set user_opt_${opt_name} $opt_default
          }
        }
        default {
          error "invalid specifier: $kind; use \"arg\" or \"opt\""
        }
      }
    }
    
    ;# add -help option
    set opt_defs(help) [list "print arguments help" -]
    set opt_defs(usage) [list "print arguments usage" -]
    
    ;# prepare usage line
    set usage $proc_name
    foreach opt_name [array names opt_defs] {
      set opt_user [translit "_" "-" $opt_name]
      set opt_char [string index $opt_name 0]
      set opt_default [lindex $opt_defs($opt_name) 1]
      if { $opt_default != "-" } {
        append usage " \[-$opt_user/-$opt_char value\]"
      } else {
        append usage " \[-$opt_user/-$opt_char\]"
      }
    }
    foreach arg_def $arg_defs {
      append usage " [lindex $arg_def 0]"
    }
    
    set help_requested 0
    set usage_requested 0
    
    set arg_index 0 
    set arg_count [llength $arg_defs]
    for { set i 0 } { $i < $proc_param_count } { incr i } {
      set param [lindex $proc_params $i]
      if { [string index $param 0] != "-" } {

        ;# argument processing
        if { $arg_count == 0 } {
          error "no arguments allowed: $param\nusage: $usage"
        }
        if { $arg_index >= $arg_count } {
          error "superfluous argument specified\nusage: $usage"
        }
        set arg_name [lindex [lindex $arg_defs $arg_index] 0]
        set user_arg_${arg_name} $param
        incr arg_index

      } else {

        ;# option processing
        set param [string range $param 1 end]

        ;# translate minuses into underscores in option name
        set opt_user $param
        set param [translit "-" "_" $opt_user]
        
        set opt_name {}
        if { [array names opt_defs $param] == $param } {
          set opt_name $param
        } elseif { [string length $param] == 1 } {
          foreach name [array names opt_defs] {
            if { [string index $name 0] == $param } {
              lappend opt_name $name
            }
          }
          if { [llength $opt_name] != 1 } {
            set opt_name {}
          }
        }
        if { $opt_name == {} } {
          error "unrecognized or ambiguous option: -${opt_user}\nusage: $usage"
        }
        
        if { [lindex $opt_defs($opt_name) 1] != "-" } {
          incr i; set param [lindex $proc_params $i]
          if { $i < $proc_param_count && [string index $param 0] != "-" } {
            set value $param
          } else {
            error "a value must be specified for option: -${opt_user}\nusage: $usage"
          }
        } else {
          set value 1
        }
        
        switch $opt_name {
          "help" {
            set help_requested 1
          }
          "usage" {
            set usage_requested 1
          }
          default {
            set user_opt_${opt_name} $value
          }
        }
        
      }
    }
    
    ;# throw help message if requested
    if { $help_requested } {
      set help_lines {}
      foreach arg_def $arg_defs {
        set arg_name [lindex $arg_def 0]
        set arg_desc [lindex $arg_def 1]
        append help_lines "  $arg_name: $arg_desc\n"
      }
      foreach opt_name [array names opt_defs] {
        set opt_user [translit "_" "-" $opt_name]
        set opt_char [string index $opt_name 0]
        set opt_desc [lindex $opt_defs($opt_name) 0]
        set opt_default [lindex $opt_defs($opt_name) 1]
        if { $opt_default != "-" } {
          append help_lines "  -$opt_user/-$opt_char: $opt_desc\n"
        } else {
          append help_lines "  -$opt_user/-$opt_char: $opt_desc\n"
        }
      }
      set help_lines [string range $help_lines 0 end-1]
      error "usage: $usage\n$help_lines"
    }

    ;# throw usage message if requested
    if { $usage_requested } {
      error "$usage"
    }

    ;# check that all arguments are assigned
    if { $arg_index < $arg_count } {
      set names {}
      for { } { $arg_index < $arg_count } { incr arg_index } {
        set arg_name [lindex [lindex $arg_defs $arg_index] 0]
        lappend names $arg_name
      }
      error "arguments are missing: $names\nusage: $usage"
    }
  }

  proc a_test_proc { args } {
    
    parse_arguments {
      arg source_file "source file name"
      arg target_file "target file name"
      opt -verbose_mode "increase verbosity level" -
      opt -output_file "output file name" /dev/null
    }
    
    puts "source_file: $source_file"
    puts "target_file: $target_file"
    puts "verbose: $verbose_mode"
    puts "output: $output_file"
  }

  proc a_test_proc_null { args } {
    
    parse_arguments {
    }
    
  }

}
