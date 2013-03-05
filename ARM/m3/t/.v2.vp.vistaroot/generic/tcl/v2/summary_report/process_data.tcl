
namespace eval ::v2::summary_data {

  proc collect_summary_data {primary_report_file} {

    variable summary_array
    catch {
      array unset summary_array
    }
    namespace eval ::v2::summary_data [list source $primary_report_file]
    return [array get summary_array]
  }

  proc get_simulation_time_units {primary_report_file} {
    variable time_units

    namespace eval ::v2::summary_data [list source $primary_report_file]
    return $time_units
  }

  proc header { txt } { }

  proc time_units {value} {
    variable time_units
    set time_units $value
  }
  
  proc instance { name script } {
    variable current_instance
    
    if {[llength $script] > 0} {
      set current_instance $name
      uplevel $script
    }
  }

  proc tlm_socket { socket_list } {
    
    variable current_instance
    variable summary_array
    if {$current_instance == "."} {
      foreach {socket info} $socket_list {
        set current_info {}
        foreach {option values} $info {
          lappend current_info [list $option $values]
        }
        set summary_array([set socket]) $current_info
      }
    } else {
      foreach {socket info} $socket_list {
        set current_info {}
        foreach {option values} $info {
          lappend current_info [list $option $values]
        }
        set summary_array($current_instance.[set socket]) $current_info
      }
    }
  }

  proc power { list } {
    variable current_instance
    variable summary_array

    foreach {kind values} $list {
      switch $kind {
        "dynamic" { set power_key dynamic_power }
        "clock" { set power_key clock_power }
        "leakage" { set power_key leakage_power }
        default {set power_key overall_power}
      }
      if {[info exists summary_array($current_instance)]} {
        set curr_info $summary_array($current_instance)
        foreach field $curr_info {
          keylset K [lindex $field 0] [lindex $field 1] ;# temp keyed list for this object fields
        }
        keylset K $power_key $values ;# add or update total power values
        set summary_array($current_instance) $K
      } else {
        set summary_array($current_instance) [list [list $power_key $values]]
      }
    }
  }

  proc attribute { list } {
    variable current_instance
    variable summary_array

    foreach {name values} $list {
      set summary_array($current_instance.[set name]) [list [list attribute $values]]
    }
  }


} ;# namespace
