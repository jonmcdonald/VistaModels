namespace eval ::UI {
  # This binding is used to raise File dialog
  # when there is a click in any application window.
  bind RaiseFileDialogBind <Button-1> {raise %W}

  proc calculateFileDialogIndex  {} {
    set i 0
    while {[info exists ::UI::grabbed_window$i]} {
      incr i
    }
    if {$i >0 } { set i [expr $i -1]}
    return $i
  }
  proc traceFileDialogPath {args } {
    variable ::tk::Priv
    set i [calculateFileDialogIndex]

    set Priv(selectFilePath$i) $Priv(selectFilePath)
    if {$i==0} {
      trace remove variable ::tk::Priv(selectFilePath) write "::UI::traceFileDialogPath"
#      puts "==========trace info:=========== AFTER\n [trace info variable  Priv(selectFilePath)]"
    }
  }
  # This function is called to divine the name of the file dialog window.
  # Arguments are just like the arguments of grab.
  proc grab_filter {i arg1 args} {

    set window $arg1
#    puts "grab_filter i=$i arg1=$arg1 args=$args window=$window"
    if {$arg1 == "current" || $arg1 == "release" || $arg1 == "status"} {
      return
    } elseif { $arg1 == "set" } {
      set window [lindex $args 1]
      if {$window == "-global"} {
        set window [lindex $args 2]
      }
    } elseif {$arg1 == "-global"} {
      set window [lindex $args 1]
    }
    if {[string first "__tk_choosedir" $window]!=-1 || [string first "__tk_filedialog" $window]!=-1} {
      set ::UI::grabbed_window$i $window
#      puts "set ::UI::grabbed_window$i=$window"
    }
  }
  
  if {[::Utilities::isUnix]} {
    # On UNIX, File dialog is implemented in Tcl.
    proc show_file_dialog {whichDialog parentWindow args} {
#      puts "show_file_dialog: whichDialog=$whichDialog parentWindow=$parentWindow args=$args"
      if {[info commands ::UI::tmp_grab]==""} {
      # Overlay the function grab to divine the file dialog window.
#        puts "renaming  ::grab ::UI::tmp_grab"
        rename ::grab "::UI::tmp_grab"
      #Overlay vwait so that each file dialog will vwait to it's own variable (allows open file dialog from another file dialog)
#        puts "renaming ::vwait ::UI::tmp_vwait"
        rename ::vwait "::UI::tmp_vwait"
        

      }
      set i 0
      while {[info exists ::UI::grabbed_window$i]} {
        incr i
      }
      if {$i > 0} {
        
        set dataName __tk_filedialog
        if {$whichDialog=="tk_chooseDirectory"} {
         set dataName __tk_choosedir
        }
        upvar ::tk::dialog::file::$dataName data
#        puts "dataName=$dataName DATA=[array get data]"
#        puts "==========trace info:=========== \n [trace info variable data(selectPath)]"
#        puts "saving trace"
        set ::UI::saved_file_dialog_trace$i  [trace info variable data(selectPath)]
        array set ::UI::saved_file_dialog_data$i [array get data]
#        puts "saving array ::UI::saved_file_dialog_data$i"
      }
      set ::UI::grabbed_window$i ""
      set ::UI::grabbed_window_tags$i ""
      
      proc ::grab {args} {
        set i [::UI::calculateFileDialogIndex]
        eval ::UI::grab_filter $i $args
#        puts "grab calls : ::UI::tmp_grab  $args"
        return [eval ::UI::tmp_grab  $args]
      }

      proc ::vwait { arg } {
        variable ::tk::Priv
        if { $arg == "::tk::Priv(selectFilePath)"} {
          set i [::UI::calculateFileDialogIndex]
#          puts "vwait i=$i"
          set arg ::tk::Priv(selectFilePath$i)
          if {$i==0} {
            trace add variable ::tk::Priv(selectFilePath) write "::UI::traceFileDialogPath"
#            puts "ADD TRACE  ::tk::Priv(selectFilePath)"
          }
        }
#        puts " eval ::UI::tmp_vwait $arg"
        eval ::UI::tmp_vwait $arg
      }
      
      
      # Wait for the dialog to come up and call grab.
      # Then do bindtags on that dialog.
      # The binding is used to raise File dialog
      # when there is a click in any application window.

      set afterID [after 1 {
        set i 0
        while {[info exists ::UI::grabbed_window$i]} {
          incr i
        }
        if {$i >0 } { set i [expr $i -1]}

        if {[set ::UI::grabbed_window$i] != ""} {

          catch {
            set ::UI::grabbed_window_tags$i [bindtags [set ::UI::grabbed_window$i]]
            if {[lsearch -exact [set ::UI::grabbed_window_tags$i] RaiseFileDialogBind] == -1} {
              ::bindtags [set ::UI::grabbed_window$i] \
                  [concat [list RaiseFileDialogBind] [set ::UI::grabbed_window_tags$i]]
            }
          }
#          puts "errorInfo=$::errorInfo"
        }
      }]
      if { $parentWindow == "" } {
        set parentWindow [focus]
      }
      # Show the dialog
#      puts "show the dialog : parentWindow=$parentWindow whichDialog=$whichDialog"

      if {[catch {
        if { $parentWindow == "" } {
          set result [eval {$whichDialog} $args]
        } else {
          set result [::Utilities::with_grab $parentWindow {
            eval {$whichDialog} $args {-parent $parentWindow}
          }]
        }
      }]} {
        puts "::UI::show_file_dialog caught error:"
        puts $::errorInfo
        set result ""
      }
      catch {after cancel $afterID}
      # Restore grab function.
#      puts "Restore grab function: i=$i"
      if {[info commands "::UI::tmp_grab"] != "" } {
        rename ::grab ""
        rename "::UI::tmp_grab" ::grab
      }
#      puts "Restore vwait function: i=$i"
      if {[info commands "::UI::tmp_vwait"] != "" } {
        rename ::vwait ""
        rename "::UI::tmp_vwait" ::vwait
      }



      if {$i > 0} {
        catch {
          set dataName __tk_filedialog
          if {$whichDialog == "tk_chooseDirectory"} {
            set dataName __tk_choosedir
          }
          upvar ::tk::dialog::file::$dataName data
#          puts "dataName=$dataName BEFORE DATA=[array get data]\n"
#          puts "restoring array ::UI::saved_file_dialog_data$i"                
          
          array set data [array get ::UI::saved_file_dialog_data$i]
#          puts "DATA=[array get data]"
          
#          puts "==========trace info BEFORE:=========== \n [trace info variable data(selectPath)]"
          #restore trace 
          set info [lindex [set ::UI::saved_file_dialog_trace$i] 0]
          if {$info!=""} {
            set options [lindex $info 0] 
            set command [lindex $info 1]
            trace add variable data(selectPath) $options $command 
            set ::UI::saved_file_dialog_trace$i ""
#            puts "==========trace info AFTER:=========== \n [trace info variable data(selectPath)]"
          }
          array unset ::UI::saved_file_dialog_data$i
        }
      }
#      puts "error=$::errorInfo"
      
      unset ::UI::grabbed_window_tags$i
      unset ::UI::grabbed_window$i

      return $result
    }
  } else {
    # On Windows, File dialog is native.
    proc show_file_dialog {whichDialog parentWindow args} {
      # Create invisible toplevel window to be a parent to the File dialogs.
      set invisible_toplevel .father_of_file_windows
      if {![winfo exists $invisible_toplevel]} {
        toplevel $invisible_toplevel
        wm withdraw $invisible_toplevel
        # The binding is used to raise File dialog
        # when there is a click in any application window.
        ::bindtags $invisible_toplevel [concat [list RaiseFileDialogBind] [bindtags $invisible_toplevel]]
      }
      return [::Utilities::with_grab $invisible_toplevel {
        eval {$whichDialog} $args {-parent $invisible_toplevel}
      }]
    }
  }
  proc get_dialog_parent_window {} {
    # Determine parent window for the dialog
    set parentWindow ""
    if {$::Document::Document::currentDocument != ""} {
      if {[catch {
        set parentWindow [$::Document::Document::currentDocument get_variable_value WidgetName]
      }]} {
        set parentWindow .
      }
    }
    return $parentWindow
  }
  proc open_file_dialog {whichDialog initialfile title filetypes {parentWindow {}} {initialdir ""} {multiple 0} {defaultext {}}} {
    if {$initialdir != ""} {
      set initialdir_option [list -initialdir $initialdir]
      set initialfile_option [list -initialfile [file tail $initialfile]]
    } else {
      if {$initialfile != ""} {
        set initialfile_option [list -initialfile $initialfile]
        set initialdir_option [list -initialdir [file dirname $initialfile]]
      } else {
        set initialfile_option {}
        set initialdir_option {}
      }
    }

    if { $parentWindow == {} } {
      set parentWindow [get_dialog_parent_window]
    }

    if { $whichDialog == "tk_getOpenFile" } {
      set multiple_option [ list -multiple $multiple]
    } else {
      set multiple_option {}
    }

    if { $whichDialog == "tk_getSaveFile" && $defaultext != {} } {
      set defaultext_option [ list -defaultextension $defaultext]
    } else {
      set defaultext_option {}
    }

    set file_name [eval ::UI::show_file_dialog \
                       $whichDialog {$parentWindow} \
                       {-filetypes $filetypes} \
                       $initialdir_option $initialfile_option \
                       {-title $title} \
                       $multiple_option \
                       $defaultext_option]
    add_to_SearchDirList $file_name
    return $file_name
  }
  
  proc open_file_command {initialfile title filetypes} {
    return [open_file_dialog tk_getOpenFile $initialfile $title $filetypes]
  }
  
  proc open_source_command {{initialfile ""}} {
    open_file_command $initialfile "Open Source File" {
      {"All Files" "*"}
    }
  }
  proc save_as_file_command { {initialfile ""} {title "Save As File"} {filetypes { {"All Files" "*"}}} {initialdir ""} {defaultext ""}} {
    return [open_file_dialog tk_getSaveFile $initialfile $title $filetypes "" $initialdir "" $defaultext]
  }
  
  proc add_to_SearchDirList {file_name} {
    catch {
      if {$file_name != ""} {
        set dir_name [file dirname $file_name]
        
        set searchDirList [set [$::main_doc get_variable_name SearchDirList]]
        set index [lsearch -exact $searchDirList $dir_name]
        if {$index != -1} {
          set searchDirList [lreplace $searchDirList $index $index]
        }
        set searchDirList [linsert $searchDirList 0 $dir_name]
        set [$::main_doc get_variable_name SearchDirList] $searchDirList
      }
    } 
  }
  
  proc open_directory_command { initialdir title mustexist} {
    return [open_directory_dialog tk_chooseDirectory $initialdir $title $mustexist]
  }
  
  proc open_directory_dialog {whichDialog initialdir title mustexist {parentWindow {}}} {

    if {$initialdir != "" && [::Utilities::canBeReadable $initialdir] } {

      set initialdir_option [list -initialdir $initialdir]
    } else {
      set initialdir_option {}
    }

    if { $parentWindow == {} } {
      set parentWindow [get_dialog_parent_window]
    }
    set dir_name [eval ::UI::show_file_dialog \
                      $whichDialog {$parentWindow} \
                      $initialdir_option {-title $title}\
                      {-mustexist $mustexist}]
    add_to_SearchDirList $dir_name
    return $dir_name
  }
}
