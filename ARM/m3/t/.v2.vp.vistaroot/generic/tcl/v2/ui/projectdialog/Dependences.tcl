namespace eval ::v2::ui::projectdialog {
  class Dependences {
    inherit itk::Widget ::UI::DocumentUIBuilder

    ::UI::ADD_VARIABLE projectsList ProjectsList 
    ::UI::ADD_VARIABLE projectsSelectedList ProjectsSelectedList
    ::UI::ADD_VARIABLE packagesList PackagesList 
    ::UI::ADD_VARIABLE packagesSelectedList PackagesSelectedList

    itk_option define -foreground foreground Foreground black
    itk_option define -font font Font fixed
    itk_option define -state state State normal
    itk_option define -padx padX PadX 0
    itk_option define -pady padY PadY 0

    private variable var_namespace_projects {}
    private variable var_namespace_packages {}

    private variable projects_widget_list {}
    private variable packages_widget_list {}
    
    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {

      construct_variable projectsList
      construct_variable projectsSelectedList
      construct_variable packagesList
      construct_variable packagesSelectedList
      
      set top [::Widgets::ScrolledWindow $itk_interior.swl -relief sunken \
                   -bd 2 -scrollbar both -auto both]

      itk_component add text {
        text $top.text -takefocus 0 -highlightthickness 0 -borderwidth 0 -relief flat \
            -height 0 -cursor top_left_arrow 
      } { 
        keep -background -foreground -font
      }
      $top setwidget $itk_component(text)
      
      $itk_component(text) configure -state disabled
      pack $top -fill both -expand 1 -pady 0 
      eval itk_initialize $args
      
    }

    destructor {
      destruct_variable projectsList
      destruct_variable projectsSelectedList
      destruct_variable packagesList
      destruct_variable packagesSelectedList
      DeleteVar_Namespace projects
      DeleteVar_Namespace packages
    }

    public method updateSelectedList {type widget} {
      if {$widget == ""} {
        return
      }
      if {$type != "projects" && $type != "packages"} {
        error "Type must be projects or packages"
      }
      
      set state [set [$widget cget -variable]]
      set item_text [$widget cget -text]
      set index [ lsearch -exact [set [set type]SelectedList] $item_text]
      if {!$state} {
        set [cget -[set type]SelectedListvariable] [lreplace [set [set type]SelectedList] $index $index]
      } else {
        if {$index == -1} {
          lappend [cget -[set type]SelectedListvariable] $item_text
        }
      }
    }

    private method CreateVar_Namespace {type} {
      set var_namespace_$type ::v2::ui::DependencesVariables[createUniqueIdentifier]
      namespace eval [set var_namespace_$type] {}
    }
    
    private method DeleteVar_Namespace {type} {
      if {[set var_namespace_$type] != "" } {
        catch { namespace delete [set var_namespace_$type] }
      }
    }

    private method local_clean_gui_list {type} {
      set [cget -[set type]SelectedListvariable] {}
      foreach widget [set [set type]_widget_list] {
        catch { destroy $widget}
      }
      if {$type == "projects"} {
        set end_pos 2.end
        if {$packages_widget_list == {}} {
          set end_pos end
        }
        $itk_component(text) delete 1.0 $end_pos
      }
      
      if {$type == "packages"} {
        set line 3
        if {$projects_widget_list == {}} {
          set line 1
        }
        $itk_component(text) delete $line.0 end
      }

      set [set type]_widget_list {}
      DeleteVar_Namespace $type
      
    }

    private method local_update_gui_list {type line title} {
      set counter 0
      CreateVar_Namespace $type
      if {[set [set type]List] != {}} {
        $itk_component(text) configure -state normal
      }
      set pos $line.end
      if {$line == 0} {
        set pos "end"
      }
      $itk_component(text) insert $pos "\n"
      if {$line} {
        incr line 
        set pos $line.end
      }
      $itk_component(text) insert $pos $title
      $itk_component(text) insert $pos "\n"
      if {$line} {
        incr line
        set pos $line.end
      }
      set type_lists [set [set type]List]
      set number_of_lists [llength $type_lists]
      set list_counter 1
      foreach element [set [set type]List] {
        foreach item $element {
          set widget_name $itk_component(text).item_[set type]_$counter
          set var_name [set var_namespace_[set type]]::check_$counter
          set widget [::UI::Checkbutton $widget_name -text "$item" \
                          -variable $var_name  -font $itk_option(-font) \
                          -foreground $itk_option(-foreground) -background $itk_option(-background) \
                          -command [code $this updateSelectedList [set type] $widget_name]]
          lappend [set type]_widget_list $widget
          $itk_component(text) window create $pos \
              -window  $widget -padx $itk_option(-padx) -pady $itk_option(-pady)  
          incr counter
        } 
   #adds many unneeded empty lines     
   #      if {$list_counter < $number_of_lists} {
#           $itk_component(text) insert $pos "\n"
#           incr list_counter
#         }
      }

      if {$type == "projects"} {
        $itk_component(text) insert $pos "\n"
      }
      $itk_component(text) configure -state disabled
    }

    private method local_clean_gui_selectedlist {type} {
      foreach widget [set [set type]_widget_list] {
        set [$widget cget -variable] 0
      }
    }

    private method local_update_gui_selectedlist {type} {
      foreach widget [set [set type]_widget_list] {
        set item_text [$widget cget -text]
        set index [ lsearch -exact [set [set type]SelectedList] $item_text]
        if {$index != -1} {
          set [$widget cget -variable] 1
        }
      }
    }
  }

  namespace eval ::UI {
    ::itcl::class v2/ui/projectdialog/Dependences/DocumentLinker {
      inherit ::UI::DataDocumentLinker
      
      protected method attach_to_data {widget document projectsList projectsSelectedList \
                                           packagesList packagesSelectedList args} {
        foreach type {projects packages} {
          $widget configure -[set type]Listvariable \
              [$document get_variable_name [set [set type]List]]
          $widget configure -[set type]SelectedListvariable \
              [$document get_variable_name [set [set type]SelectedList]]
        }
      }
    }
    v2/ui/projectdialog/Dependences/DocumentLinker v2/ui/projectdialog/Dependences/DocumentLinkerObject
  }
}

body ::v2::ui::projectdialog::Dependences::clean_gui/projectsList {} {
  local_clean_gui_list projects
}

body ::v2::ui::projectdialog::Dependences::clean_gui/packagesList {} {
  local_clean_gui_list packages
}

body ::v2::ui::projectdialog::Dependences::update_gui/projectsList {} {
  if {$projectsList != {}} {
    local_update_gui_list projects 1 " Depend on Projects:"
  }
}

body ::v2::ui::projectdialog::Dependences::update_gui/packagesList {} {
  if {$packagesList != {}} {
    local_update_gui_list packages 0 " Vista Packages:"
  }
}

body ::v2::ui::projectdialog::Dependences::clean_gui/projectsSelectedList {} {
  local_clean_gui_selectedlist projects
}

body ::v2::ui::projectdialog::Dependences::clean_gui/packagesSelectedList {} {
  local_clean_gui_selectedlist packages
}

body ::v2::ui::projectdialog::Dependences::update_gui/projectsSelectedList {} {
  local_update_gui_selectedlist projects
}

body ::v2::ui::projectdialog::Dependences::update_gui/packagesSelectedList {} {
  local_update_gui_selectedlist packages
}

configbody ::v2::ui::projectdialog::Dependences::state {
  foreach widget [$itk_component(text) window names] {
    $widget configure -state $itk_option(-state)
  }
}
