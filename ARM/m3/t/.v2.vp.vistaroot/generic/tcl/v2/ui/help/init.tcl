summit_begin_package v2:ui:help

summit_package_require UI:help

namespace eval ::UI::help {
  proc get_help_command_line {} {
    set varname "V2_HELP_COMMAND_LINE"
    if {[info exists ::env($varname)]} {
      if {[catch {set res  $::env($varname)}]} {
        set res ""
      } 
      return $res
    } else {
      return ""
    }
  }

  proc get_help_root {} {
    set varname "V2_HELP_ROOT"
    if {[info exists ::env($varname)]} {
      return $::env($varname)
    } else {
      return "http://www.summit-design.com"
    }
  }

  ::UI::help::helpManager registerHandler \
      [objectNew ::UI::help::StandardHelpHandler "[::UI::help::get_help_root]/[set ::env(V2_HELP_PRODUCT_NAME)]_Online_Documentation.htm#" [::UI::help::get_help_command_line]]
}

summit_end_package
