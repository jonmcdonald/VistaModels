namespace eval ::UI {
   proc create_view {class docID} {

    set view ""
    if {[catch {
      set view [::Utilities::tkObjectNewInit $class \
                    [::Utilities::objectNew ::Document::Document $docID]]
      $view show
    }]} {
      puts "::v2::ui::factory::create_view $class $docID caught error:"
      puts $::errorInfo
    }
    if {[winfo exists $view]} {
      catch {tkwait visibility $view}
    }
    update
    $view on_visible
    raise [$view component hull]
    #puts "::Document::isCommandName $docID \"HelpCommand\""
    if {[::Document::isCommandName $docID "HelpCommand"]} {
      #puts "bind [$view component hull] <F1>"
      bind [$view component hull] <F1> [list "::Document::runCommand" $docID "HelpCommand"]
    }
    return $view
  }

  proc create_dialog_view {class docID} {
    ::Document::disableRecording
    set catchStatus [ catch {
      set view [create_view $class $docID]
    } result ]
    set errorInfo $::errorInfo
    set errorCode $::errorCode
    
    ::Document::enableRecording
    if {$catchStatus} {
      error $result $errorInfo $errorCode
    }
    ::Utilities::with_grab [$view component hull] {
      vwait [$view get_cancel_variable_name]
    }
  }
  
  proc create_help_about {class} {
    set view [$class .\#auto]
    ::Utilities::with_grab [$view component hull] {
      vwait [$view get_cancel_variable_name]
    }
  }
}
