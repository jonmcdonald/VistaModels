namespace eval ::UI::help {

  class StandardHelpHandler {
    inherit HelpHandler

    private variable helpRoot 
    private variable userCommandLine ""

    constructor {_helpRoot {_commandLine ""}} {
      set helpRoot $_helpRoot
      set userCommandLine $_commandLine
    }

    public method setHelpRoot {_helpRoot} {
      set helpRoot $_helpRoot
    }

    public method getHelpRoot {} {
      return $helpRoot
    }

    public method setCommandLine {_userCommandLine} {
      set userCommandLine $_userCommandLine
    }

    public method getCommandLine {} {
      return $userCommandLine
    }

    public method show {topic} {
      set helpFilePath "[set helpRoot][set topic]"
      show_url helpFilePath
    }
    public method show_url {helpFilePath} {
      set old $::env(LD_LIBRARY_PATH)
      set ::env(LD_LIBRARY_PATH) $::env(V2_ORIGINAL_LD_LIBRARY_PATH)
      set st [catch {
        show_url2 $helpFilePath
      } msg]
      set ::env(LD_LIBRARY_PATH) $old
      if {$st} {
        error $msg $::errorInfo $::errorCode
      }
      return $msg
    }
    public method show_url2 {helpFilePath} {
      if {$::tcl_platform(platform) == "windows"} {
        set assoc [exec cmd /c assoc .html]
        set list [split $assoc =]
        set assoc [lindex $list 1]
        set ftype [exec cmd /c ftype $assoc]
        set list [split $ftype =]
        set ftype [lindex $list 1]
        set firstChar [string index $ftype 0]
        if {$firstChar == "\""} {
          set list [split $ftype "\""]
          set ftype [lindex $list 1]
        } else {
          set list [split $ftype " "]
          set ftype [lindex $list 0]
        }
        if { $ftype != "" } {
          exec $ftype $helpFilePath &
        } else {
          exec explorer $helpFilePath &
        }
      } elseif {$userCommandLine != ""} {
        # append .html extension if needed. 
        # in case, when helpFilePath exists - do nothing
        regsub -all "%s" $userCommandLine $helpFilePath fullCommandLine
#        puts "exec $fullCommandLine &"
        eval exec $fullCommandLine &
      } else {
        # First try to guess mozilla's like executable and to run it with '-remote' option
        # In case, when the user already has some browser opened, the one will be used
        set mozilla_candidates {}
        set netscape_candidates {}
        set firefox_candidates {}
        
        if {[info exists ::env(MOZILLA_HOME)]} {
          lappend mozilla_candidates $::env(MOZILLA_HOME)/mozilla
          lappend mozilla_candidates $::env(MOZILLA_HOME)/mozilla-remote-client
        }
        lappend mozilla_candidates mozilla
        lappend mozilla_candidates mozilla-remote-client
        lappend mozilla_candidates /usr/bin/mozilla/mozilla
        lappend mozilla_candidates /usr/bin/mozilla/mozilla-remote-client
        
        lappend netscape_candidates netscape 
        
        lappend firefox_candidates firefox
        lappend firefox_candidates /usr/bin/firefox
        lappend firefox_candidates /usr/local/firefox/firefox
        
        set candidates [concat $firefox_candidates $mozilla_candidates $netscape_candidates]
        
        # Try to open using running browser. Firefox has some bug when connecting to the existing browser.
        # So, put it at the end of the list to let chance to mozilla do the job.
        foreach candidate $candidates {
          if {![catch {exec $candidate -remote "ping()"}]} {
            exec $candidate -remote "openurl($helpFilePath,new-window)" &
            return
          }
        }
        
        # There is no running browser on this display. 
        # So, try to run it. In case of Linux we change priority, so that firefox will be ran
        # if possible. 
        if {$::tcl_platform(platform) == "unix"} {
          if {$::tcl_platform(os) == "Linux"} {
            set candidates [concat $firefox_candidates $mozilla_candidates $netscape_candidates]
          }
        } else {
          # Try to run firefox for Windows also.
          set candidates $firefox_candidates
        }
        
        foreach candidate $candidates {
          if {![catch {exec $candidate $helpFilePath &}]} {
            return
          }
        }

        if {$::tcl_platform(platform) == "windows"} {
          # for Windows: use "cmd /C assoc .htm" and "cmd /C ftype on result of assoc command"
          # to determinate the path to IExplorer.
        }
        #openHelpUsingTcl
        error "There is no tool for show '$helpFilePath'"
      }
    }
  }
}
