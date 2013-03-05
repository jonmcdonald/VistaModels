namespace eval ::v2::summary_report {

  proc process_primary_report {primary_report_file output_file {name_pattern_value ""} } {

    variable output_fd
    variable name_pattern $name_pattern_value

#    puts "primary_report_file: name_pattern_value = $name_pattern_value "

    if {$output_file == "stderr" || $output_file == "stdout"} {
      set output_fd $output_file
    } else {
      set output_fd [open $output_file w]
    }
    namespace eval ::v2::summary_report [list source $primary_report_file]
    if {$output_fd != "stderr" || $output_fd != "stdout"} {
      close $output_fd
    }
  }

  proc limited_string {str char_count} {
    variable limit
    set real_count [string length $str]
    if { $real_count > $char_count} {
      set char_count $real_count
      set limit $real_count
    }    
    format "%-*.*s" $char_count $char_count $str
  }
  
  proc formatDouble2String {value width after_dot} {
    format "%*.*f" $width $after_dot $value
  }
  
  proc header { txt } {
    variable output_fd
    puts $output_fd "\nSummary Report:"
    puts $output_fd $txt
  }

  proc time_units {value} {
    variable time_units
    set time_units $value
    #upvar $value time_units
  }

  proc instance { name script } {
    if {[llength $script] > 0} {
      variable name_pattern

      if {$name_pattern != "" && ![string match $name_pattern $name]} {
        return
      }

      if {$name != "."} {

        variable output_fd
        puts $output_fd "\nInstance: $name"
        puts $output_fd "*********************"
      }

      uplevel $script
    }
  }


  proc tlm_socket { socket_list } {
    variable time_units
    variable output_fd
    variable limit 20
    puts $output_fd "TLM Sockets:"
    puts $output_fd "^^^^^^^^^^^^"
    
    set sockets {}
    set arbitration_sockets {}

    foreach {socket info} $socket_list {
      if { [string first "arbitration" $socket] == 0 } {
        lappend arbitration_sockets $socket
      } else {
        lappend sockets $socket
      }
      foreach {option values} $info {
        keylset socket_data($socket) $option $values
      }

    }
    
    set sorted_arbitration_sockets [lsort $arbitration_sockets]
    set sorted_sockets [lsort $sockets]

    set kind_str [limited_string "Transaction Throughput:" 24]
    set avg_str [limited_string "Average (trans/$time_units)" 20]
#   set max_str [limited_string "Maximal (trans/$time_units)" 20]
    puts $output_fd "$kind_str \t\t $avg_str\n"
    
    foreach socket $sorted_sockets {
      set values [keylget socket_data($socket) throughput]
      puts $output_fd "\t[limited_string $socket: $limit]\t\t [formatDouble2String [lindex $values 0] 16 8]"
    }
    puts $output_fd "\n"

    set kind_str [limited_string "Transaction Data:" 24]
    set avg_str [limited_string "Average (bytes/$time_units)" 20]
#    set max_str [limited_string "Maximal (bytes/$time_units)" 20]
    puts $output_fd "$kind_str \t\t $avg_str\n"
    foreach socket $sorted_sockets {
      set values [keylget socket_data($socket) data]
      puts $output_fd "\t[limited_string $socket: $limit]\t\t [formatDouble2String [lindex $values 0] 16 8]"
    }
    puts $output_fd "\n"

    set kind_str [limited_string "Latency:" 24]
    set avg_str [limited_string "Average ($time_units)" 20]
    set max_str [limited_string "Maximal ($time_units)" 20]
    set weighted_str [limited_string "Average weighted by data($time_units/bytes)" 42]
    puts $output_fd "$kind_str \t\t$avg_str \t\t$max_str \t$weighted_str\n"
    foreach socket $sorted_sockets {
      set values [keylget socket_data($socket) latency]
      puts $output_fd "\t[limited_string $socket: $limit]\t [formatDouble2String [lindex $values 0] 16 8] \t\t[formatDouble2String [lindex $values 1] 16 8] \t\t[formatDouble2String [lindex $values 2] 16 8]"
    }
    puts $output_fd "\n"

    if { [llength $sorted_arbitration_sockets] != 0 } {
      set kind_str [limited_string "Arbitration:" 24]
      set avg_str [limited_string "Average ($time_units)" 20]
      set max_str [limited_string "Maximal ($time_units)" 20]
      
      puts $output_fd "$kind_str \t\t\t\t$avg_str \t\t$max_str\n" 
      set prefix_length [string length "arbitration"]
      foreach socket $sorted_arbitration_sockets {
        set values [keylget socket_data($socket) latency]
        set short_name [string range $socket $prefix_length end] 
        puts $output_fd "\t[limited_string $short_name: $limit]\t [formatDouble2String [lindex $values 0] 16 8] \t\t[formatDouble2String [lindex $values 1] 16 8]"
      }
      puts $output_fd "\n"
    }

#    set kind_str [limited_string "Utilization:" 24]
#    set avg_str [limited_string "Average (%)" 20]
#    puts $output_fd "$kind_str \t\t $avg_str\n"
#    foreach socket $sockets {
#      set values [keylget socket_data($socket) utilization]
#      puts $output_fd "\t[limited_string $socket: 20]\t [formatDouble2String [lindex $values 0] 16 3]"
#    }
#    puts $output_fd "\n"
    
  }

  proc power { list } {

    variable output_fd

    puts $output_fd "Power:"
    puts $output_fd "^^^^^^"
    puts $output_fd "\t\t\t\t Average (mW) \t\t Maximal (mW)"
    foreach {kind values} $list {
      puts $output_fd "\t[limited_string $kind: 10]\t [formatDouble2String [lindex $values 0] 16 8]\t [formatDouble2String [lindex $values 1] 16 8]"
    }
    puts $output_fd "\n"
  }

  proc attribute { list } {

    variable output_fd
    variable limit 20

    set attributes_list {}
    set contention_attributes_list {}
    foreach {name values} $list {
      if { [string first "contentionAddress_Phase:" $name] == 0 || [string first "contentionData_Phase:" $name] == 0} {
        lappend contention_attributes_list $name $values
      } else {
        lappend attributes_list $name $values
      }
    }

    if { [llength $contention_attributes_list] != 0} {
      set kind_str [limited_string "Contention:" 24]
      set min_str [limited_string "Minimal" 20]
      set avg_str [limited_string "Average" 20]
      set max_str [limited_string "Maximal" 20]

      puts $output_fd "$kind_str \t\t\t\t$min_str \t\t$avg_str \t\t$max_str\n" 
      set prefix_length [string length "contention"]
      foreach {name values} $contention_attributes_list {
        set short_name [string range $name $prefix_length end]
        puts $output_fd "\t[limited_string $short_name: $limit]\t [formatDouble2String [lindex $values 0] 16 8] \t\t[formatDouble2String [lindex $values 1] 16 8] \t\t[formatDouble2String [lindex $values 2] 16 8]"
      }
      puts $output_fd "\n"
    }  

    if { [llength $attributes_list] != 0} {
      puts $output_fd "Attributes:"
      puts $output_fd "^^^^^^^^^^^"
      puts $output_fd "\t\t\t\t\t Minimal \t\t Average  \t\t Maximal"
      foreach {name values} $attributes_list {
        if {[llength $values] == 1} {
           puts $output_fd "[limited_string $name: 30]\t \t\t\t [formatDouble2String [lindex $values 0] 16 8]"
        } else {
          puts $output_fd "[limited_string $name: 30]\t [formatDouble2String [lindex $values 0] 16 8]\t [formatDouble2String [lindex $values 1] 16 8]\t [formatDouble2String [lindex $values 2] 16 8]"
        }

      }
      puts $output_fd "\n"
    }
  }

} ;# namespace
