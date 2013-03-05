#tcl-mode
if {[::Utilities::tkInitialized]} {
  option add *font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
  option add *background \#e0e0e0 widgetDefault
  
  bind WaitWindowBind <Button-1> {raise %W}
}

namespace eval ::Application {
  proc run_application {exe {arguments {}} {envArray ""} {pwd ""} {ampersand "&"} } {
    withVariable ::env(MASTER_SERVER_HOST) [::Net::TcpIp::server getServerHost] {
      withVariable ::env(MASTER_SERVER_PORT) [::Net::TcpIp::server getServerPort] {
        withVariable ::env(MASTER_APP_NAME) [::Application::getCurrentApplicationName] {
          if {$envArray == ""} {
            set envArray [array get ::env]
          }
          if {$pwd == ""} {
            set pwd [pwd]
          }
          
          return [Utilities::runProcess $exe $arguments $envArray $pwd $ampersand]
        }
      }
    }
  }
   
  class WaitDialog {
    inherit ::Utilities::Grabable
    private variable connectionName
    private variable connectionVariable
    private variable top
    private variable cancelVarName

    constructor {_connectionName _connectionVariable} {
      set connectionName $_connectionName
      set connectionVariable $_connectionVariable
      set top .[::Utilities::createUniqueIdentifier]
      set cancelVarName ::[::Utilities::createUniqueIdentifier]
      set $cancelVarName ""
    }

    destructor {
      catch {unset $cancelVarName}
      catch {dispose}
    }

    common connection_visible_names
    array set connection_visible_names {}
    
    proc setConnectionVisibleName {connectionName visibleName} {
      set connection_visible_names($connectionName) $visibleName
    }
    
    proc getConnectionVisibleName {connectionName} {
      set visibleName $connectionName
      if {[info exists connection_visible_names($connectionName)]} {
        set visibleName [set connection_visible_names($connectionName)]
      }
      return [regsub -all {([A-Z])|_} $visibleName " \\1"]
    }
    
    public method show {} {
      waitState
      update
    }

    private method dispose {} {
      if {[winfo exists $top]} {
        catch {ungrab}
        destroy $top
      }
    }

    private method createWaitWindow {} {
      dispose
      toplevel $top -class Dialog
      wm geometry $top +100+100
      ::bindtags $top [concat [list WaitWindowBind] [bindtags $top]]
      wm title $top " "
      wm iconname $top Waiting
      wm protocol $top WM_DELETE_WINDOW { }
      wm resizable $top 0 0
    }

    private method showWaitWindow {} {
      wm deiconify $top
      raise $top
      catch {grabLocally $top}
#      grab release [grab current]
    }

    public method getTop {} {
      return $top
    }

    private method waitState {} {
      if {[info exists ::env(THIS_PRODUCT_NAME_AND_VERSION)]} {
        set label_text $::env(THIS_PRODUCT_NAME_AND_VERSION)
      }
      set need_logo [expr {[info exists ::Application::SHOW_LOGO] && $::Application::SHOW_LOGO}]
      if {$need_logo} {
        set need_logo [expr {[Net::Ipc::connectionManager peekConnection $connectionName] == ""}]
      }

      if {!$need_logo || ![info exists label_text]} {
        set label_text "Starting [getConnectionVisibleName $connectionName]. Please Wait ..."
      }

      if {[info exists ::env(THIS_PRODUCT_COPYRIGHT)]} {
        set copyright_text $::env(THIS_PRODUCT_COPYRIGHT)
      }

      createWaitWindow

      if {$need_logo && [info exists ::env(THIS_PRODUCT_LOGO)]} {
        set logo_bitmap ::THIS_PRODUCT_LOGO
        if {[lsearch [image names] ::THIS_PRODUCT_LOGO] == -1} {
          if {[::Utilities::isUnix]} {
            image create pixmap $logo_bitmap -file $::env(THIS_PRODUCT_LOGO)
          } else {
            image create photo $logo_bitmap -file $::env(THIS_PRODUCT_LOGO)
          }
        }
        set logo_canvas $top.canvas
        canvas $logo_canvas -bd 0
        set logo_bbox [$logo_canvas bbox [$logo_canvas create image 0 0 -image $logo_bitmap -anchor nw]]

        set logocolor white
        if {[info exists ::env(THIS_PRODUCT_LOGO_COLOR)]} {
          set logocolor $::env(THIS_PRODUCT_LOGO_COLOR)
        }

        set copyrightcolor white
        if {[info exists ::env(THIS_PRODUCT_COPYRIGHT_COLOR)]} {
          set copyrightcolor $::env(THIS_PRODUCT_COPYRIGHT_COLOR)
        }

        set logofont {Helvetica 10 bold}
        if {[info exists ::env(THIS_PRODUCT_LOGO_FONT)]} {
          set logofont $::env(THIS_PRODUCT_LOGO_FONT)
        }

        set copyrightfont {Helvetica 6}
        if {[info exists ::env(THIS_PRODUCT_COPYRIGHT_FONT)]} {
          set copyrightfont $::env(THIS_PRODUCT_COPYRIGHT_FONT)
        }


        eval [list $logo_canvas create text] \
            $::env(THIS_PRODUCT_NAME_LOCATION_ON_LOGO) \
            [list -text $label_text -anchor nw -fill $logocolor -font $logofont]
        if {[info exists copyright_text]} {
          eval [list $logo_canvas create text] \
              $::env(THIS_PRODUCT_COPYRIGHT_LOCATION_ON_LOGO) \
              [list -text $copyright_text -anchor nw -fill $copyrightcolor -font $copyrightfont]
        }
        $logo_canvas conf -width [lindex $logo_bbox 2]
        $logo_canvas conf -height [lindex $logo_bbox 3]
        pack $logo_canvas
      } else {
        pack [frame $top.fr  -relief raised -borderwidth 2]
        pack [frame $top.fr.fr -relief raised -borderwidth 0] -pady 8 -padx 8
        pack [label $top.fr.fr.lb -font "*-arial-bold-r-normal-*-12-120-*"] \
            -anchor center -padx 1 -pady 4
        $top.fr.fr.lb configure -text $label_text

        pack [button $top.fr.fr.cancel \
                  -text "Cancel" \
                  -borderwidth 1 \
                  -command [list ::Mutex::notifyMutexError $connectionVariable "Canceled by User"]] \
            -anchor center -padx 1 -pady 4
      }
      wm withdraw $top
      wm overrideredirect $top 1
      showWaitWindow
    }
    
    private method askState {} {
      createWaitWindow
      pack [frame $top.fr  -relief raised -bd 2]
      pack [label $top.fr.lb -font "*-arial-bold-r-normal-*-12-120-*"] \
          -anchor center -padx 10 -pady 10
      $top.fr.lb configure -text "Timeout expired"
      frame $top.fr.buttons
      pack [button $top.fr.buttons.cancel -borderwidth 1 -text "Cancel" -command [list set $cancelVarName cancel]] \
          -side left -padx 10 -pady 10
      pack [button $top.fr.buttons.continue -borderwidth 1 -text "Continue" -command [list set $cancelVarName continue]] \
          -side left -padx 10 -pady 10
      pack $top.fr.buttons -fill x
      showWaitWindow
    }
    
    private method connectDuringAsk {args} {
      set $cancelVarName "continue"
    }

    public method ask {} {
      askState
      trace variable $connectionVariable w [itcl::code $this connectDuringAsk]
      vwait $cancelVarName
      if {[set $cancelVarName] != "cancel"} {
        waitState
      }
      return [set $cancelVarName]
    }

  }

  variable waitDialogs
  proc defaultTimeOutScript {connectionName connectionVariable} {
    variable waitDialogs
    if {![info exists waitDialogs($connectionVariable)]} {
      return "continue" ; #should not reach here
    }
    return [$waitDialogs($connectionVariable) ask]
  }

  proc waitPrehook {connectionName connectionVariable} {
    variable waitDialogs
    set dialog [::Utilities::objectNew WaitDialog $connectionName $connectionVariable]
    set waitDialogs($connectionVariable) $dialog
    $dialog show
  }

  proc waitPostHook {connectionName connectionVariable} {
    deleteWaitDialog $connectionName $connectionVariable
  }
  
  proc run_and_wait_for_connection {connectionName exe {arguments {}} {envArray ""} {pwd ""}} {
    run_application $exe $arguments $envArray $pwd
    set connection [::Net::Ipc::connectionManager waitForConnection $connectionName]
    return $connection
  }

  proc deleteWaitDialog {connectionName connectionVariable} {
    variable waitDialogs
    if {![info exists waitDialogs($connectionVariable)]} {
      return
    }
    set dialog $waitDialogs($connectionVariable)
    unset waitDialogs($connectionVariable)
    catch { objectDelete $dialog }
  }

  proc wait_for_connection {connectionName {timeOut 60000}} {
    if {![::Utilities::tkInitialized]} {
      return [::Net::Ipc::connectionManager waitForConnection $connectionName $timeOut]
    }
    set catchStatus [catch {
      ::Net::Ipc::connectionManager waitForConnection $connectionName \
          $timeOut \
          [list [namespace current]::defaultTimeOutScript] \
          [list [namespace current]::waitPrehook] \
          [list [namespace current]::waitPostHook]
    } connection_or_error]
    set savedErrorInfo $::errorInfo
    set savedErrorCode $::errorCode
    if {$catchStatus} {
      error $connection_or_error $savedErrorInfo $savedErrorCode
    }
    return $connection_or_error
  }

  proc run_and_wait_for_connection_interactive {connectionName exe {arguments {}} {envArray ""} {pwd ""} {timeOut 60000}} {
    run_application $exe $arguments $envArray $pwd
    return [wait_for_connection $connectionName $timeOut]
  }

}
