namespace eval ::UI {
  proc get_body_for_safe_file_dialog {orig_proc_name} {
    set body {
      set original_pwd $::env(PWD)
      try_eval {
        ::Utilities::withProcedure ::pwd {args} {
          return $::env(PWD)
        } {
          ::Utilities::withProcedure ::cd {{directory ""}} {
            if {$directory == ""} {
              set directory [::Utilities::HOME]
            }
            set ::env(PWD) [exec $::env(V2_SHELL) -c "cd \"$directory\" && $::env(V2_PWD)"]
            $orig_proc $::env(PWD) ;# Calls original cd
          } {
            uplevel $orig_proc_name $args
          }
        }
      } {
        error $errorResult $errorCode $errorInfo
      } {
        set ::env(PWD) $original_pwd
        cd $original_pwd
      }
    }
    return "set orig_proc_name $orig_proc_name; $body"
  }
}
#rename tk_getOpenFile ::UI::tk_getOpenFile_orig
#proc tk_getOpenFile {args} [::UI::get_body_for_safe_file_dialog ::UI::tk_getOpenFile_orig]
#rename tk_getSaveFile ::UI::tk_getSaveFile_orig
#proc tk_getSaveFile {args} [::UI::get_body_for_safe_file_dialog ::UI::tk_getSaveFile_orig]
