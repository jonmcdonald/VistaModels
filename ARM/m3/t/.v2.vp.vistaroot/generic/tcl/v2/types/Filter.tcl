namespace eval ::v2::types {
  proc global_variables_filter { varname {filename "" } } {
    if {[regexp {^sc_(core|dt|snps)::} $varname all]} {return 0}
    if {[regexp {^(s|S)ummit(_|Tcl|tcl)} $varname all]} {return 0}
    if {[regexp {^_sc_} $varname all]} {return 0}
    if {[regexp {^tcl} $varname all]} {return 0}
    if {[regexp {_mgc_vista_} $varname all]} {return 0}
    if {[regexp {^std::} $varname all]} {return 0}
    if {[regexp {^_IO_stdin} $varname all]} {return 0}
    if {[regexp {^__(free|malloc|memalign|realloc|ctype)} $varname all]} {return 0}
    if {[regexp {^_(IO|nl_C)_} $varname all]} {return 0}
    if {[regexp {__default_alloc_} $varname all]} {return 0}
    if {[regexp {type( |_)?info} $varname all]} {return 0}
    if {[regexp {virtual table} $varname all]} {return 0}
    if {[regexp {anonymous namespace} $varname all]} {return 0}
    if {[regexp {[^ ]+ [^ ]+ [^ ]+} $varname all]} {return 0}
    if {[regexp {.*summit_sc.*}  $filename all]} {return 0}
    if {[regexp {.*qemu[^ ]sources.*}  $filename all]} {return 0}
    if {[regexp {.*systemc.*(sysc|datatypes|kernel).*} $filename all]} {return 0}
    if {[regexp {.*tcl[^ ]loader.*}  $filename all]} {return 0}
    if {[regexp {.*gcc.*include.*} $filename all]} {return 0}
    if {[regexp {.*include/systemc.*} $filename all]} {return 0}
    if {$::tcl_platform(platform) == "windows"} {
      if {[regexp {^ZT(I|S)} $varname all]} {return 0}
      if {[regexp {^ZN[0-9].*E$} $varname all]} {return 0}
    } else {
      if {[regexp {^/usr/include.*} $filename all]} {return 0}
    }
    #puts "global_variables_filter : $varname $filename"
    return 1
  }
  proc functions_filter { function_name function_mangled_name } {
    if {[regexp {^global (constructors|destructors)} $function_name all]} {return 0}
    if {[regexp {^__static_initial} $function_name all]} {return 0}
    if {[regexp {^virtual} $function_name all]} {return 0}
    if {[regexp {^non-virtual} $function_name all]} {return 0}
    if {[regexp {_GLOBAL__(D|I)_} $function_mangled_name all]} {return 0}
    if {[regexp {_mgc_vista_} $function_name all]} {return 0}
    if {[regexp {^(s|S)ummit(_|Tcl|tcl)} $function_name all]} {return 0}
    return 1;
  }
  proc types_filter { name } {
    if {[regexp {type_info_pseudo} $name all]} {return 0}
    return 1;
  }
}
