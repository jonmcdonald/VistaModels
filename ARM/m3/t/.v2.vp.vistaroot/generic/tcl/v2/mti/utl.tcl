namespace eval ::v2::mti {
  proc is_mti_active {} {
    if {[info exists ::env(VISTA_MODEL_TECH)]} {
      return 1
    }
    if {[info exists ::env(MODEL_TECH_TCL)]} {
      return 1
    }
    if {[info exists ::env(MODEL_TECH)]} {
      return 1
    }
    return 0
  }

  proc get_modelsim_tcl_root {} {
    if {[info exists ::env(MODEL_TECH_TCL)]} {
      set candidate $::env(MODEL_TECH_TCL)
      if {[file isdirectory $candidate]} {
        return $candidate
      }
    }
    if {[info exists ::env(VISTA_MODEL_TECH)]} {
      set candidate $::env(VISTA_MODEL_TECH)/../tcl
      if {[file isdirectory $candidate]} {
        return $candidate
      }
    }

    if {[info exists ::env(MODEL_TECH)]} {
      set candidate $::env(MODEL_TECH)/../tcl
      if {[file isdirectory $candidate]} {
        return $candidate
      }
    }
    return ""
  }

}
