proc fix_tk_messageBox {} {
  rename ::tk_messageBox ::__tk_messageBox_orig__
  set ::tk_messageBox_current_script {}
  set ::tk_messageBox_current_args {}

  proc exit_from_current_tk_messageBox {with_answer} {
    set $::tk_messageBox_vwait_varname $with_answer
  }

  proc tk_messageBox_append_buttons {msg_box_widget varname args} {
    set column_index 10
    foreach {b buttonArgs} $args {
      eval {button $msg_box_widget.$b} $buttonArgs [list -command [list set $varname $b]]
      grid $msg_box_widget.$b -in $msg_box_widget.bot -row 0 -column $column_index -padx 3m -pady 2m -sticky ew
      grid columnconfigure $msg_box_widget.bot $column_index -uniform buttons
      incr column_index 1
    }
  }
  #example proc myscript {w varname args} {tk_messageBox_append_buttons $w $varname all {-text "All" -bg red} notall {-text "NotAll"}}
  #example tk_messageBox -type ok -script ::myscript -message "test me please"
  proc tk_messageBox {args} {
    
    catch {rename vwait ::tk_messageBox_vwait_orig}

    set script_ind [lsearch -exact $args "-script"]
    set ::tk_messageBox_current_script {}
    if {$script_ind != -1} {
      set ::tk_messageBox_current_script [lindex $args [expr $script_ind + 1]]
      set args [concat [lrange $args 0 [expr $script_ind - 1]] [lrange $args [expr $script_ind + 2] end]]
      set ::tk_messageBox_current_args $args
    }
    
    
    proc ::vwait {varname} {
      set ::tk_messageBox_vwait_varname $varname
      rename ::vwait ""
      rename ::tk_messageBox_vwait_orig ::vwait

      catch {
        if {$::tk_messageBox_current_script != ""} {
          set the_script $::tk_messageBox_current_script
          set the_args $::tk_messageBox_current_args
          set ::tk_messageBox_current_script {}
          set ::tk_messageBox_current_args {}
          uplevel \#0 $the_script [list [grab current] $varname] $the_args
        }
      }

      uplevel ::vwait $varname
    }
    
    after 200 {
      catch {
        if {[grab current] != ""} {
          catch {wm deiconify [winfo toplevel [grab current]]}
          catch {raise [winfo toplevel [grab current]]}
        }
      }
    }
  
    if {[lsearch -exact $args "-parent"] != -1} {
      return [ uplevel __tk_messageBox_orig__ $args ]
    }
    set parentWindow ""
    if {[catch {
      set parentWindow [winfo toplevel [focus]]
    } found] != 0} {
      if {[info exists ::errorInfo]} {
        set ::errorInfo ""
      }
    }
    set catchStatus [catch {
      if {$parentWindow == ""} {
        set result [ uplevel __tk_messageBox_orig__ $args ]
      } else {
        set result [ uplevel __tk_messageBox_orig__ $args [list -parent $parentWindow] ]
      }
    } msg]
    set ::tk_messageBox_current_script {}
    set ::tk_messageBox_current_args {}
    if {$catchStatus} {
      error $msg $::errorInfo $::errorCode
    }
    return $result
  }
}
