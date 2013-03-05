namespace eval ::Utilities {

  proc copy_namespace_variables_to_namespace {from_ns to_ns} {
    if {![namespace exists $from_ns]} {
      return
    }
    namespace eval [set to_ns] {} 
    foreach full_var_name [info var [set from_ns]::*] {
      set var_name [namespace tail $full_var_name]
      if {[array exists $full_var_name]} {
        array set [set to_ns]::[set var_name] [array get [set full_var_name]]
        continue
      }
      set [set to_ns]::[set var_name] [set [set full_var_name]]
    }
  }

  proc copy_namespace_variables_to_script {from_ns} {
    if {![namespace exists $from_ns]} {
      return {}
    }
    set script ""
    foreach full_var_name [info var [set from_ns]::*] {
      set var_name [namespace tail $full_var_name]
      append script "variable [list [set var_name]]\n"
      if {[array exists $full_var_name]} {
        append script "array set [list [set var_name]] [list [array get [set full_var_name]]]\n"
        continue
      }
      append script "set [list [set var_name]] [list [set [set full_var_name]]]\n"
    }
    return $script
  }


}

