namespace eval ::v2::ui {
  proc eval_filter_impl {directory file} {
    if {![file isfile $file]} {
      return ""
    }
    if {![file readable $file]} {
      puts "File: $file is not readable. Ignored."
      return ""
    }
    set catchStatus [catch {
      namespace eval ::v2::ui::tmp_namespace {}
      namespace delete ::v2::ui::tmp_namespace
      namespace eval ::v2::ui::tmp_namespace {}
      foreach varname {directory dir DIRECTORY} {
        set ::v2::ui::tmp_namespace::[set varname] $directory
      }
      namespace eval ::v2::ui::tmp_namespace [list source $file]
    } result]
    if {$catchStatus} {
      puts "Error: $result occurred when evaluating $file. Ignored."
      return ""
    }
    return $result
  }
  
  proc eval_custom_filter {directory} {
    set name ".vista_code_view_filter.tcl"
    if {[info exists ::env(HOME)] && $::env(HOME) != ""} {
      return [eval_filter_impl $directory  "$::env(HOME)/$name"]
    }
    if {[info exists ::env(LOGNAME)] && $::env(LOGNAME) != ""} {
      return [eval_filter_impl $directory  "/home/$::env(LOGNAME)/$name"]
    }
    if {[info exists ::env(USERNAME)] && $::env(USERNAME) != ""} {
      return [eval_filter_impl $directory  "/home/$::env(USERNAME)/$name"]
    }
    return ""
  }
  
  proc eval_installation_filter {directory} {
    return [eval_filter_impl $directory "$::env(VISTA_ROOT)/.vista_code_view_filter.tcl"]
  }
  
  proc code_view_file_filter {path} {
    if {![file exists $path]} {
      return 0
    }

    set result [eval_custom_filter $path]
    if {[string match -nocase "*include*" $result]} {
      return 1
    }

    if {[string match -nocase "*exclude*" $result]} {
      return 0
    }

    set result [eval_installation_filter $path]
    if {[string match -nocase "*include*" $result]} {
      return 1
    }

    if {[string match -nocase "*exclude*" $result]} {
      return 0
    }


    if {[string first "$::env(VISTA_ROOT)/" $path] != -1} {return 0;}
    if {[regexp {gcc.*/include[/]?.*$}  $path all]} {return 0;}
    if {[regexp {include/c\+\+/3\.[0-9]\.[0-9]}  $path all]} {return 0;}
    if {[regexp {sys(tem)?c/communication} $path all]} {return 0;}
    if {[regexp {sys(tem)?c/datatypes}     $path all]} {return 0;}
    if {[regexp {sys(tem)?c/kernel}        $path all]} {return 0;}
    if {[regexp {sys(tem)?c/tracing}       $path all]} {return 0;}
    if {[regexp {sys(tem)?c/utils}         $path all]} {return 0;}
    if {[regexp {sys(tem)?c/cosim}         $path all]} {return 0;}
    if {[regexp {^/usr}                 $path all]} {return 0;}
    if {[regexp {sysdeps/unix}          $path all]} {return 0;}
    if {[regexp {sysdeps/gnu}           $path all]} {return 0;}
    if {[regexp {sysdeps/pthread}       $path all]} {return 0;}
    if {[regexp {/iconv/}               $path all]} {return 0;}
    if {$path == "../iconf"} {return 0}
    if {$path == "iconf"} {return 0}
    return 1;
  }
}
