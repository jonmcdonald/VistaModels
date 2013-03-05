namespace eval ::UI {
  proc visit_hierarchy {roots visitor_function args} {
    foreach root $roots {
      if {![winfo exists $root]} {
        continue
      }
      uplevel [list $visitor_function] $root "previsit" $args
      eval [list visit_hierarchy [winfo children $root] $visitor_function] $args
      uplevel [list $visitor_function] $root "postvisit" $args
    }
  }

#test
  proc test_print_hierarchy {roots} {
    proc test_print_widget {w previsit_or_postvisit} {
      if {$previsit_or_postvisit == "postvisit"} {
        return
      }
      puts $w
    }
    visit_hierarchy $roots ::UI::test_print_widget
  }

  proc test_blink_hierarchy {roots} {
    proc ::UI::test_blink_widget {w previsit_or_postvisit blink_variable blink_mutex} {
      if {$previsit_or_postvisit == "postvisit"} {
        return
      }
      set $blink_variable $w
      set should_stop 0
      catch {
        catch {set old_background [$w cget -background]}
        catch {set old_foreground [$w cget -foreground]}
        catch {set old_borderwidth [$w cget -borderwidth]}
        catch {$w configure -background yellow}
        catch {$w configure -foreground red}
        catch {$w configure -borderwidth 3}
        set should_stop [catch {::Mutex::waitOnMutex $blink_mutex}]
        catch {$w configure -background $old_background}
        catch {$w configure -foreground $old_foreground}
        catch {$w configure -borderwidth $old_borderwidth}
      }
      if {$should_stop} {
        error "ok"
      }
    }
    set top .blink_hierarchy
    toplevel $top
    set ::test_blink_variable ""

    pack [entry $top.e -textvariable ::test_blink_variable] -fill x
    pack [button $top.continue -text "continue" -command {::Mutex::notifyMutex ::test_blink_mutex}] -fill x
    pack [button $top.stop -text "stop" -command {::Mutex::notifyMutexError ::test_blink_mutex "stop"}] -fill x
    catch {visit_hierarchy $roots ::UI::test_blink_widget ::test_blink_variable ::test_blink_mutex}
    destroy $top
  }

}

