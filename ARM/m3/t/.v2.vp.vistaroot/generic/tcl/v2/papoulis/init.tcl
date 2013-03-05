summit_begin_package v2:papoulis

namespace eval ::v2 {
  namespace eval papoulis {
    proc source/esl/core/user_procs.tcl {} {
      if {![info exists ::env(MODEL_BUILDER_HOME)]} {
        return
      }
      if {![file exists $::env(MODEL_BUILDER_HOME)/include/esl/core/user_procs.tcl]} {
        return
      }
      $::mgc_vista_api_interpreter eval {
        namespace eval ::papoulis {}
        rename ::package ::package_orig
        proc ::package {args} {}
        rename ::proc ::proc_orig
        catch {
          proc_orig ::proc {proc_name proc_args proc_body} {
            ::proc_orig $proc_name args "::v2::papoulis::eval_papoulis \[concat [list $proc_name] \$args\]"
          }
          source $::env(MODEL_BUILDER_HOME)/include/esl/core/user_procs.tcl
        } msg
        rename ::proc ""
        rename ::proc_orig ::proc
        rename ::package ""
        rename ::package_orig ::package
      }
    }
  }
}

# load papoulis api into application interpreter
catch {
  ::v2::papoulis::source/esl/core/user_procs.tcl
}

catch {
  interp alias $::mgc_vista_api_interpreter ::v2::papoulis::eval_papoulis "" ::v2::papoulis::eval_papoulis
  interp alias $::mgc_vista_api_interpreter ::v2::papoulis::exec_papoulis "" ::v2::papoulis::exec_papoulis
  interp eval $::mgc_vista_api_interpreter {
    proc mbconsole {} {
      ::v2::papoulis::exec_papoulis ::esl::ui::papoulis_client::open_console
    }
    proc mb {Args} {
      if {$Args == ""} {
        mbconsole
        return
      }
      ::v2::papoulis::eval_papoulis $Args
    }

  }
}


summit_end_package
