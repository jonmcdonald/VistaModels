summit_begin_package UI:console

namespace eval ::UI {
  proc loadConsole {} {
    if {![consoleInitialized]} {
      set root .console
      withVariable ::argv [list -root $root ] {
        withVariable ::argc [llength $::argv] {
          summit_source_file UI/console/tkcon.tcl
          ::tkcon attach Main
          after idle {wm protocol $::tkcon::PRIV(root) WM_DELETE_WINDOW ::UI::hideConsole}
          after idle {wm title $::tkcon::PRIV(root) "Tcl console"}
          after idle {
            set ::tkcon::OPT(prompt1) "\\\[\[history nextid\] console\\\] "
            clear
            tkcon::Prompt
          }
        }
      }
    }
  }
  
  proc consoleInitialized {} {
    return [expr {[namespace children :: tkcon] != ""}]
  }
  
  proc showConsole {} {
    loadConsole
    ::tkcon show
  }
  
  proc hideConsole {} {
    if {[consoleInitialized]} {
      ::tkcon hide
    }
  }
}
#simple console
namespace eval ::UI {
  namespace eval console {
    variable counter
    set counter -1

    proc create_console {console_frame {interpreter ""}} {
      variable counter
      incr counter
      if {$interpreter == ""} {
        set interpreter [interp create]
      }
      impl::setup_interpreter_for_console $interpreter

      set ns ::UI::console::space_$counter
      namespace eval $ns "variable console_interp $interpreter"

      proc [set ns]::interp_proc {sub cmd} {
        variable console_interp
        withVariable ::UI::console::impl::current_console_object [namespace current]::console_object {
          switch -exact -- $sub {
            eval {
              #uplevel \#0 $cmd
              $console_interp eval $cmd
              
            }
            record {
              $console_interp eval [list history add $cmd]
              #      history add $cmd
              #      set status [catch {uplevel \#0 $cmd} retval]
              catch {
                $console_interp eval $cmd
              } retval
              #      raw_puts "STATUS: $status RETVAL: $retval"
              return $retval
            }
            default {
              error "bad option \"$sub\": should be eval or record"
            }
          }
        }
      }
      
      ::UI::console::Console [set ns]::console_object $console_frame [set ns]::interp_proc

      return [set ns]::console_object
    }

    namespace eval impl {
      variable current_console_object ""
      proc interpeter_puts {interpreter args} {
        variable current_console_object
        set channel stdout
        set count [llength $args]
        switch -exact -- [llength $args] {
          1 {
            set str [lindex $args 0]
            append str \n
          }
          2 {
            set str [lindex $args 1]
            if {[lindex $args 0] != "-nonewline"} {
              set channel [lindex $args 0]
              append str \n
            }
          }
          3 {
            if {[lindex $args 0] != "-nonewline"} {;# let tcl throw the error
              return [eval ::puts $args]
            }
            append str \n
            set channel [lindex $args 1]
            set str [lindex $args 2]
          }
          default {;# let tcl throw the error
            return [eval ::puts $args]
          }
        }
        if {$channel != "stdout" && $channel != "stderr"} {
          return [$interpreter eval ::output $args]
        }
        if {$current_console_object == ""} {
          return [$interpreter eval ::output $args]
        }
        $current_console_object ConsoleOutput $channel $str
        return ""
      }
      
      proc setup_interpreter_for_console {interpreter} {
        set console_setup_done [$interpreter eval {
          expr {[info exists console_setup_done] && $console_setup_done == 1}
        }]
        if {$console_setup_done} {
          return
        }
        $interpreter eval {
          proc ls {{str "."}} {
            return [glob -nocomplain -tails -directory $str *]
          }
          proc kuku {} {puts kuku!!!}
        }

        $interpreter eval {
          set console_setup_done 1
          rename puts output
        }
        interp alias $interpreter "puts" "" ::UI::console::impl::interpeter_puts $interpreter
#        interp expose $interpreter "pwd"
#        interp expose $interpreter "file"
#        interp expose $interpreter "history" "" ::history
      }
    }
  }
}





summit_end_package
