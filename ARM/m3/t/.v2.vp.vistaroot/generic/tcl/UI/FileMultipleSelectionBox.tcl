#irena :
# this widget supports multiple file select,
#inherits from iwiidgets::Fileselectionbox
#option selectmode extended or multiple should be used for multiple select

#
# Usual options.
#
itk::usual FileMultipleSelectionBox {
}

namespace eval ::UI {
  
  # ------------------------------------------------------------------
  #                          FILEMULTIPLESELECTIONBOX
  # ------------------------------------------------------------------
  class FileMultipleSelectionBox {
    inherit iwidgets::Fileselectionbox 
    ::UI::ADD_VARIABLE directory Directory ;#the value of the directory - can be changed in order to set directory
    
    constructor {args} { 
      construct_variable directory

      #
      # Initialize the widget based on the command line options.
      #
      set current_directory [pwd]
      eval itk_initialize $args

      $itk_component(files) component vertsb configure -width 12 -highlightthickness 0 -takefocus 0
      $itk_component(dirs) component vertsb configure -width 12 -highlightthickness 0 -takefocus 0
      $itk_component(files) component horizsb configure -width 12 -highlightthickness 0 -takefocus 0 
      $itk_component(dirs) component horizsb configure -width 12 -highlightthickness 0 -takefocus 0
      grid columnconfigure $itk_component(files).lwchildsite 1 -minsize 0
      grid columnconfigure $itk_component(dirs).lwchildsite 1 -minsize 0
      grid rowconfigure $itk_component(files).lwchildsite 1 -minsize 0
      grid rowconfigure $itk_component(dirs).lwchildsite 1 -minsize 0
      configure -selectborderwidth 0
    }
    destructor {
      destruct_variable  directory
    }
    
    itk_option define -selectmode selectmode Selectmode "extended"
    itk_option define -dirchangecommand dirchangecommand Dirchangecommand  ""

    public  method _selectFile {}
    public  method filter {}
    public  method get {}
    public variable current_directory

    private method _setFileSelection {}
    
  }
}
#
# Provide a lowercased access method for the FileMultipleSelectionBox class.
# 
proc ::UI::filemultipleselectionbox {pathName args} {
  uplevel ::UI::FileMultipleSelectionBox  $pathName $args
}
configbody ::UI::FileMultipleSelectionBox::selectmode {
  [$itk_component(files) component listbox]  configure -selectmode $itk_option(-selectmode)
}
#overwrites base class method
body ::UI::FileMultipleSelectionBox::_selectFile {} {
  
  _setFileSelection
  
  if {$itk_option(-selectfilecommand) != {}} {
    uplevel #0 $itk_option(-selectfilecommand)
  }
}

body ::UI::FileMultipleSelectionBox::filter {} {
  set newfile [$itk_component(filter) get]
  if { [file isdirectory $newfile]} {
    $itk_component(filter) delete 0 end
    $itk_component(filter) insert 0 [file join $newfile "*"]
    #
    # Make sure insertion cursor is at the end.
    #
    $itk_component(filter) icursor end

    #
    # Make sure the right most text is visable.
    #
    $itk_component(filter) xview moveto 1

  }
  #calling base class method
  chain
  set current_directory [file dirname [$itk_component(filter) get]]
  catch {
    if { [$this cget -directoryvariable] != ""} {
      set [$this cget -directoryvariable]  $current_directory
    }
  }

  if {$itk_option(-dirchangecommand) != {}} {
    uplevel #0 $itk_option(-dirchangecommand) $current_directory
  }
}

body ::UI::FileMultipleSelectionBox::get {} {
  set data [$itk_component(selection) get]
  set result {}
  foreach path $data {

    if {[file pathtype $path] == "relative" && [string index $path 0]!="$"} {
      set path [file join $current_directory $path]
    } 
    lappend result $path
  }
  return $result
}

body ::UI::FileMultipleSelectionBox::_setFileSelection {} {
  global tcl_platform
  $itk_component(selection) delete 0 end
  
  if {$itk_option(-fileson)} {
    set listbox [$itk_component(files) component listbox]
    set selections [$listbox cursel]
    
    set allselection ""
    
    
    foreach index $selections {
      
      set selection [$listbox get $index]

      if {$selection != $itk_option(-nomatchstring)} {
        if {[file pathtype $selection] != "absolute"} {
          set selection [file join $current_directory $selection]
        }
        #
        # Remove automounter paths.
        #
        if {$tcl_platform(platform) == "unix"} {
          if {$itk_option(-automount) != {}} {
            foreach autoDir $itk_option(-automount) {
              # Use catch because we can't be sure exactly what strings
              # were passed into the -automount option
              catch {
                if {[regsub ^/$autoDir $selection {} selection] != 0} {
                  break
                }
              }
            }
          }
        }

      }  
#      if {$allselection != "" } {
        lappend allselection "$selection"
#      } else {
#        lappend allselection "$selection"
#      }
      

    }
    if {$allselection != $itk_option(-nomatchstring)} {
      $itk_component(selection) insert 0 $allselection
      
    } else {
      $itk_component(files) selection clear 0 end
    }
  } 
}

body ::UI::FileMultipleSelectionBox::check_new_value/directory {value} {
  return;
}
#initial_directory variable should be used for changing current directory 
body ::UI::FileMultipleSelectionBox::update_gui/directory {} {
  catch {
    if {![string equal $current_directory $directory]} {
      $this config -directory $directory
    }
  }
#  puts "error=$::errorInfo"
}


namespace eval ::UI {
  ::itcl::class UI/FileMultipleSelectionBox/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document Directory  } {
#      puts "attach to data: directoryvariable= [$document get_variable_name $Directory]"
      $widget configure -directoryvariable [$document get_variable_name $Directory]
    }
  }
  UI/FileMultipleSelectionBox/DocumentLinker UI/FileMultipleSelectionBox/DocumentLinkerObject
}

