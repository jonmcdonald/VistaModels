namespace eval ::UI {

  proc set_widget_client_data {widget dataTag value} {
    set sub_window [set widget]._[set dataTag]
    if {![winfo exists $sub_window]} {
      label $sub_window
    }
    $sub_window configure -text $value
    return $value
  }
  
  proc get_widget_client_data {widget dataTag} {
    set sub_window [set widget]._[set dataTag]
    if {[winfo exists $sub_window]} {
      return [$sub_window cget -text]
    }
    return ""
  }

  proc exist_widget_client_data {widget dataTag} {
    set sub_window [set widget]._[set dataTag]
    return [winfo exists $sub_window]
  }

  proc set_widget_actual_parent {widget actualParent} {
    set_widget_client_data $widget ActualParent $actualParent
  }

  proc get_widget_actual_parent {widget} {
    if {[exist_widget_client_data $widget ActualParent]} {
      return [get_widget_client_data $widget ActualParent]
    }
    if {![winfo exists $widget]} {
      return ""
    }
    return [winfo parent $widget]
  }

  proc is_parent_of {wouldbeParent wouldbeChild} {
    if {$wouldbeChild == $wouldbeParent} {
      return 1
    }
    if {$wouldbeChild == ""} {
      return 0
    }
    if {$wouldbeChild == "."} {
      return 0
    }
    return [is_parent_of $wouldbeParent [get_widget_actual_parent $wouldbeChild]]
  }

  proc common_set_state_using_option {widget isEnable} {
    if {$isEnable == "1"} {
      set state normal
    } else {
      set state disabled
    }
    if {[string first "-state" [$widget configure]] > -1} {
      $widget configure -state $state
    }
  }
  
  proc common_set_state_using_bindtags {widget isEnable} {
    if {$isEnable} {
      if {[exist_widget_client_data $widget default_binds]} {
        set default_binds [get_widget_client_data $widget default_binds]
        bindtags $widget $default_binds
      }
    } else {
      if {![exist_widget_client_data $widget default_binds]} {
        set default_binds [bindtags $widget]
        set_widget_client_data $widget default_binds $default_binds
      }
      set default_binds [bindtags $widget]
      bindtags $widget {no_events}
    }
  }

  proc common_set_menu_entry_state {menu entryIndex value} {
    if {$value == "1"} {
      set state normal
    } else {
      set state disabled
    }
    $menu entryconfigure $entryIndex -state $state
  }

  proc auto_trace_with_init {option var_name operation widget user_script} {
    uplevel \#0 $user_script [list $widget $var_name "" $operation]
    auto_trace $option $var_name $operation $widget $user_script
  }

  proc auto_trace {option var_name operation widget user_script} {
    set trace_script [list ::UI::auto_trace_callback $widget $var_name $user_script]
    uplevel \#0 [list ::Utilities::ff_trace $option $var_name $operation $trace_script]
  }
  
  proc auto_trace_callback {widget var_name user_script bad_var_name element_name operation} {
    if {[winfo exists $widget]} {
      uplevel \#0 $user_script [list $widget $var_name $element_name $operation]
    } else {
      set trace_script [list ::UI::auto_trace_callback $widget $var_name $user_script]
      ::Utilities::ff_trace vdelete $var_name $operation $trace_script
    }
  }

  proc _eval_if_viewable {w script} {
    if {[winfo viewable $w]} {
      catch {uplevel \#0 $script}
    }
  }

  proc _on_map_callback {w script bindTag} {
    bindtags $w [::List::removeElement [bindtags $w] $bindTag]
    after idle [list ::UI::_eval_if_viewable $w $script]
  }

  proc eval_when_viewable {w script} {
    if {[winfo viewable $w]} {
      catch {uplevel \#0 $script}
      return
    }
    set bindTag EvalWhenViewable_$w
    bind $bindTag <Map> [list ::UI::_on_map_callback $w $script $bindTag]
    bindtags $w [linsert [bindtags $w] end $bindTag]
  }

  proc eval_when_viewable_old {w script {break_condition ""} {interval_ms 1}} {
    if {$break_condition == ""} {
      set break_condition "expr { !\[winfo exists [list $w]\] }"
    }
    set condition [list winfo viewable $w]
    ::Utilities::eval_when $condition $script $break_condition $interval_ms
  }

  proc eval_when_flipflop_free {script {break_condition ""} {interval_ms 1}} {
    set condition [list ::Utilities::ff_is_not_charged]
    ::Utilities::eval_when $condition $script $break_condition $interval_ms
  }

  proc pane_forget_destroy_callback {required_window current_window} {
    if {[string compare $required_window $current_window]} {
      return
    }
    catch {cwidgets::pane forget $current_window}
  }

  proc pane_forget_when_destroy {args} {
    foreach w $args {
      bind $w <Destroy> "+[list ::UI::pane_forget_destroy_callback $w %W]"
    }
  }

  proc cwidgets_pane {args} {
    set window_list {}
    foreach argument $args {
      if {[winfo exists $argument]} {
        lappend window_list $argument
      } else {
        break
      }
    }
    set pane_args [lrange $args [llength $window_list] end]
    set result [uplevel cwidgets::pane $window_list $pane_args]
    eval pane_forget_when_destroy $window_list
    return $result
  }

  proc find_menu_entry_index_by_label {menu entryLabel} {
    set first [$menu index 0]
    if {$first == "none"} {
      return ""
    }
    set last [$menu index end]
    if {$last == "none"} {
      return ""
    }
    for {set index $first} {$index <= $last} {incr index} {
      set result 0
      catch {
        if {![string equal [$menu type $index] "separator"] && [string equal [$menu entrycget $index -label] $entryLabel]} {
          set result 1
        }
      }
      if {$result} {
        return $index
      }
    }
    return ""
  }

  proc beUnderGlass {w} {
    if {[is_cygwin] || [is_mingw]} {
      return
    }
    if {[winfo exists $w] && [blt::busy isbusy $w] == ""} {
      set cursor ""
      catch {set cursor [$w cget -cursor]}
      blt::busy $w
      blt::busy configure $w -cursor $cursor
      set busy_window "[set w]_Busy";
      bind $busy_window "<ButtonRelease>" "::UI::busy_window_touched $w"
    }
  }
  
  proc busy_window_touched {w} {
    ::UI::breakGlass $w
    if {[winfo exists $w]} {
      catch {focus $w}
    }
  }
  
  proc breakGlass {w} {
    if {[is_cygwin] || [is_mingw]} {
      return
    }
    if {[blt::busy isbusy $w] != ""} {
      blt::busy release $w
    }
  }

  proc raiseWindow.old {widget} {
    if {[winfo exists $widget]} {
      set toplevel [winfo toplevel $widget]
      catch {wm deiconify $toplevel}
      catch {raise $toplevel}
      catch {focus -force $toplevel}
    }
  }

  proc hideWindow {toplevel} {
    catch {wm withdraw $toplevel}
  }

  proc silentDestroyWidget {toplevel} {
    catch { destroy $toplevel}
  }

  proc _doRaiseWindow {toplevel raiser} {
    catch {
      wm transient $toplevel $raiser
      focus -force $toplevel
    }
    after 1000 [list catch [list destroy $raiser]]
    after 1001 [list catch [list wm title $toplevel [wm title $toplevel]]]
  }

  proc raiseWindow {widget} {
    if {[::info exists ::env(VISTA_OLD_WM)] && $::env(VISTA_OLD_WM) != "0"} {
      return [raiseWindow.old $widget]
    }
    if {[winfo exists $widget]} {
      set toplevel [winfo toplevel $widget]
      catch {wm deiconify $toplevel}
      catch {raise $toplevel}
      
      set raiser [toplevel .raiser_[createUniqueIdentifier] ]
      set x 0
      set y 0
      catch {
        set x [winfo x $toplevel]
        set y [winfo y $toplevel]
      }
      
      wm geometry $raiser 0x0+[set x]+[set y]
      wm title $raiser ""
      ::UI::eval_when_viewable $raiser [list [namespace current]::_doRaiseWindow $toplevel $raiser]
    }
   
  }

  proc beAlwaysOnTop {W boolean} {
    set bindtags [bindtags $W]
    set index [lsearch $bindtags bind$W]
    if { $boolean } {
      if { $index == -1 } {
        bindtags $W [linsert $bindtags 0 bind$W]
        bind bind$W <Visibility> [list [namespace current]::beAlwaysOnTop:state %W %s]
      }
    } else {
      if { $index != -1 } {
        bindtags $W [lreplace $bindtags $index $index]
        bind bind$W <Visibility> {}
      }
    }
  }
  
  
  proc beAlwaysOnTop:state {W state} {
    if { ![string equal [winfo toplevel $W] $W] } {
      return
    }
    #   if { ![string equal $state VisibilityUnobscured] } { raise $W }
    
    set is_hidden [string equal $state VisibilityFullyObscured]
    #   set is_vieable [string equal $state VisibilityPartiallyObscured]
    #   set is_partialy_hidden [string equal $state VisibilityPartiallyObscured]
    
    #   if { [string equal $state VisibilityFullyObscured] } { myraise $W }
    if { $is_hidden }  {
      ::UI::raiseWindow $W
    }
    
  }
  
}

