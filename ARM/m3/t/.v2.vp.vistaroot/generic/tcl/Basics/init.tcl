if {[catch {package present summit:Basics}]} {

  proc basics_is_pure_tcl {} {
    if {![info exists ::env(V2_IS_PURE_TCL)]} {
      set result 0
    } else {
      set value [string trim $::env(V2_IS_PURE_TCL)]
      if {[string equal $value ""] || [string equal $value "0"]} {
        set result 0
      } else {
        set result 1
      }
    }
    proc basics_is_pure_tcl {} "return $result"
    return $result
  }

  proc NOT_SUPPORTED_ON_PURE_TCL {} {
    if {[basics_is_pure_tcl]} {
      error "Not supported on pure tcl"
    }
  }


### BEGIN PROFILING STUFF
proc is_cygwin {} {
  if {[info exists ::env(V2_IS_CYGWIN)] && $::env(V2_IS_CYGWIN) != "0"} {
    proc is_cygwin {} {return 1}
    return 1
  }
  proc is_cygwin {} {return 0}
  return 0
}
proc is_mingw {} {
  if {[info exists ::env(V2_IS_MINGW)] && $::env(V2_IS_MINGW) != "0"} {
    proc is_mingw {} {return 1}
    return 1
  }
  proc is_mingw {} {return 0}
  return 0
}
set ::traceall 0
proc dump_proc_call {name proc_new_clock proc_new_after_clock} {
  if {![info exists ::times($name)]} {
    set ::times($name) 0
  }
  incr ::times($name) [expr $proc_new_after_clock - $proc_new_clock]
}
proc proc_new {name arglist body} {
  set save_clock {set proc_new_clock [clock clicks -milliseconds]}
  set after_clock {set proc_new_after_clock [clock clicks -milliseconds]}
  set eval_body "set proc_new_result \[eval {$body}]"
  uplevel [list proc_orig $name $arglist \
               "if [list \$::traceall] {$save_clock} ; $eval_body; if [list \$::traceall] {$after_clock; dump_proc_call $name \$proc_new_clock \$proc_new_after_clock}; return \$proc_new_result"]
}
proc null_proc {args} {
}

#rename proc proc_orig
#rename proc_new proc
#after 100 {rename null_proc history}

### END PROFILING STUFF

if {![basics_is_pure_tcl]} {
  
  package require Itcl
  package require Tclx

  namespace eval :: {
    namespace import -force itcl::*
  }
}

namespace eval ::Basics {
  set INSTALLATION_ROOT $::env(V2_HOME)
  set bootstrapfilename ""
  set shortnameofexecutable ""
  catch {
    if {[info exists ::env(V2_BOOTSTRAP_FILE_NAME)]} {
      set bootstrapfilename $::env(V2_BOOTSTRAP_FILE_NAME)
    } else {
      set shortnameofexecutable [file tail [info nameofexecutable]]
      regsub {(.purify)?(\.dyn)?(\.exe)?$} $shortnameofexecutable "" shortnameofexecutable
      regsub -all {\.} $shortnameofexecutable "/" bootstrapfilename
      set bootstrapfilename "[set bootstrapfilename].tcl"
    }
  }

  set current_package {}
  set current_package_path {}
  set packages_stack {}
}

if {![info exists ::env(SUMMIT_DOC_MODE)] || $::env(SUMMIT_DOC_MODE) == 0} {
  proc ::doc {name body args} {
    if {[string range $name 0 1] == "::"} {
      set fullName $name
    } else {
      set ns [ uplevel "namespace current" ]
      if {$ns == "::"} {
        set ns ""
      }
      set fullName "[set ns]::[set name]"
    }
    set fullName [string range $fullName 2 end]
    set ::doc($fullName) $body
    foreach alias $args {
      set ::doc($alias) "=>$fullName"
    }
  }

  proc ::procd {names arguments body {documentation ""}} {
    foreach name $names {
      uplevel [list proc $name $arguments $body]
    }
    if {$documentation != ""} {
      uplevel [list doc [lindex $names 0] $documentation] [lrange $names 1 end]
    }
  }

  foreach what {
    method
    variable
    protected
    common
    public
    private
    class
    constructor
    destructor
    inherit
    namespace
    proc
  } {
    set What [string toupper [string range $what 0 0]][string range $what 1 end]
    proc ::$What {args} "[list uplevel $what] \$args"
  }

  if {[basics_is_pure_tcl]} {
    #create empty itcl procedures
    namespace eval ::itcl {}
    foreach p {body class code configbody delete ensemble find local scope} {
      proc $p {args} {}
      proc ::itcl::$p {args} {}
    }
  }

} else {
  # doc mode.
}

proc summit_get_package_relative_path {package} {
  regsub -all {:} $package {/} package_path
  return $package_path
}

proc summit_get_package_path {package} {
  return $::env(V2_HOME)/tcl/[summit_get_package_relative_path $package]
}

proc summit_package {package} {
  return "summit:$package"
}

proc summit_source_file {file} {
  uplevel \#0 [list source $::env(V2_HOME)/tcl/$file]
}

proc summit_add_tclindex {file} {
  summit_source_file $file
}

proc summit_source {file} {
  return [summit_source_file [summit_get_package_relative_path $::Basics::current_package]/$file]
}

proc summit_get_source_path {package file} {
  return [summit_get_package_path $package]/$file
}

set ::summit_list_of_loaded_packages {}
proc summit_package_provide {package args} {
  set package [summit_package $package]
  set result [eval [list package provide $package] $args]
  if {[lsearch -exact $::summit_list_of_loaded_packages $package] == -1} {
    lappend ::summit_list_of_loaded_packages $package
  } 
  return $result
}

proc summit_set_current_package {current_package} {
  set ::Basics::current_package $current_package
  set ::Basics::current_package_path [summit_get_package_relative_path $current_package]
}

proc summit_clear_current_package {} {
  set ::Basics::current_package ""
  set ::Basics::current_package_path ""
}

proc summit_push_package {current_package} {
  if {$current_package == ""} {
    error "No current package"
  }
  if {$::Basics::current_package != ""} {
    lappend ::Basics::packages_stack $::Basics::current_package
  }
  summit_set_current_package $current_package
}

proc summit_begin_package {current_package} {
  summit_push_package $current_package
}

proc summit_pop_package {} {
  if {$::Basics::current_package == ""} {
    error "No current package"
  }
  set current_package [lindex $::Basics::packages_stack end]
  if {$current_package != ""} {
    set ::Basics::packages_stack [lrange $::Basics::packages_stack 0 end-1]
    summit_set_current_package $current_package
  } else {
    summit_clear_current_package
  }
}

proc summit_end_package {} {
  set package_to_provide $::Basics::current_package
  summit_pop_package
  summit_package_provide $package_to_provide 1.0
}

proc summit_package_present {package} {
  if {[lsearch -exact $::summit_list_of_loaded_packages [summit_package $package]] == -1} {
    return 0
  } 
  return 1
}

proc summit_package_require {package} {
  if {![summit_package_present $package]} {
    if {[file exists "[summit_get_package_path $package]/init.tcl"]} {
      summit_push_package $package
      summit_source tclIndex
      summit_source init.tcl
      summit_pop_package
    } else {
      summit_begin_package $package
      summit_source tclIndex
      summit_end_package
    }
    package present [summit_package $package]
  }
}

summit_package_provide Basics 1.0
}
