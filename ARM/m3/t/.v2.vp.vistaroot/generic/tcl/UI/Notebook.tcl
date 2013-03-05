# tcl-mode
option add *Notebook.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Notebook.background \#e0e0e0 widgetDefault
option add *Notebook.foreground black widgetDefault

usual Notebook {}
namespace eval ::UI {
  class Notebook {
    inherit itk::Widget ::UI::DocumentUIBuilder

    ::UI::ADD_VARIABLE currentTab  CurrentTab ""

    itk_option define -font font Font ""
    itk_option define -foreground foreground Foreground black

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {

      construct_variable currentTab
     
      itk_component add tabs {
        blt::tabset $itk_interior.tabs -side bottom \
            -relief flat -outerpad 0 -bd 0 -highlightthickness 0 \
            -selectcommand "[code $this tab_select_command]" \
            -side top -selectpad 0 -samewidth no -gap 0 -selectforeground blue -tearoff 0
      } {
        keep -background 
        rename -tabforeground -foreground foreground Foreground 
        rename -tabbackground  -background background Background
        rename -activebackground -background background Background
        rename -activeforeground -foreground foreground Foreground 
        rename -selectbackground -background background Background
      }

      $itk_component(tabs) configure -perforationcommand {}
      eval itk_initialize $args
    }

    destructor {
      catch { 
        destruct_variable currentTab 
      }
    }
    
    public method show {} {}

    protected method set_binding {} {}

    protected method create_popup_menu {class} {
      itk_component add popup_menu {
        $class $itk_interior.popup_menu $document
      }
    }
    protected method on_RMB {} {
      if {[info exists itk_component(popup_menu)]} {
        $itk_component(popup_menu) raise [winfo pointerx .] [winfo pointery .]
      }
    }

    protected method tab_select_command {args} {
      set select_index [$itk_component(tabs) index select]
      set current_tab_name [lindex [$itk_component(tabs) tab names] $select_index]
      if {$currentTabIsHandled} {
        return
      }
      set [cget -currentTabvariable] $current_tab_name
    }

    protected  method select_tab {index} {             
      if {$index == [$itk_component(tabs) index select]} {
        return
      }
      catch {
        blt::SelectTab $itk_component(tabs) $index
      }
    }

    protected method add_tab {class_name tab_name text_name doc} {
      return [add_custom_tab [list $class_name $itk_component(tabs).$tab_name $doc] $tab_name $text_name]
    }
    
    public method add_custom_tab {creation_script tab_name text_name} {
      itk_component add $tab_name {
        uplevel $creation_script
      } {}
      
      $itk_component(tabs) insert end $tab_name -text $text_name \
          -window  $itk_component($tab_name) \
          -fill both -anchor n -background {} -selectbackground {} \
          -selectforeground {} -padx 0 -pady 0

      $itk_component(tabs) bind $tab_name <3> "[code $this select_tab [get_tab_index $itk_component($tab_name)]]"
      $itk_component(tabs) bind $tab_name <ButtonRelease-3> "[code $this on_RMB]"

      return $itk_component($tab_name)
    }

    private variable image_commands_table
    private variable label_metrics_method_exists 1
    private method is_image_selected {tab_name x y} {
      if {!$label_metrics_method_exists} {
        return 0
      }
      set index [get_tab_index $tab_name]
      set image tab_close
      set label_metrics_method_exists [expr {![catch {
        set metrics [$itk_component(tabs) tab label_metrics $index]
      }]}]
      if {!$label_metrics_method_exists} {
        return 0
      }
      set image_x [lindex $metrics 0]
      if {$x < $image_x} {
        return 0
      }
      set image_y [lindex $metrics 1]
      if {$y < $image_y} {
        return 0
      }
      set x2 [expr [lindex $metrics 2] + $x]
      if {$x > $x2} {
        return 0
      }
      set y2 [expr [lindex $metrics 3] + $y]
      if {$y > $y2} {
        return 0
      }
      set image tab_close_raised
      return 1
    }

    protected method on_TabButton1 {tab_name x y} {
      set image [$itk_component(tabs) tab cget $tab_name -image]
      if {$image == ""} {
        return
      }
      if {![info exists image_commands_table($tab_name)]} {
        return
      }
      if {[is_image_selected $tab_name $x $y]} {
        uplevel \#0 [lindex $image_commands_table($tab_name) 2]
      }
    }
    
    protected method on_TabMotion {tab_name x y} {
      set image [$itk_component(tabs) tab cget $tab_name -image]
      if {$image == ""} {
        return
      }
      if {![info exists image_commands_table($tab_name)]} {
        return
      }
      if {[is_image_selected $tab_name $x $y]} {
        $itk_component(tabs) tab configure $tab_name -image  [lindex $image_commands_table($tab_name) 1]
      } else {
        $itk_component(tabs) tab configure $tab_name -image  [lindex $image_commands_table($tab_name) 0]
      }
    }

    protected method on_TabLeave {tab_name} {
      set image [$itk_component(tabs) tab cget $tab_name -image]
      if {$image == ""} {
        return
      }
      if {![info exists image_commands_table($tab_name)]} {
        return
      }
      $itk_component(tabs) tab configure $tab_name -image [lindex $image_commands_table($tab_name) 0]
    }

    public method create_tab_image_with_command {tab_name regular_image selected_image script} {
      set image_commands_table($tab_name) [list $regular_image $selected_image $script]
      $itk_component(tabs) tab configure $tab_name -image $regular_image
      $itk_component(tabs) bind $tab_name <Motion> "[code $this on_TabMotion $tab_name %x %y]"
      $itk_component(tabs) bind $tab_name <Leave> "[code $this on_TabLeave $tab_name]"
      $itk_component(tabs) bind $tab_name <Button-1> "[code $this on_TabButton1 $tab_name %x %y]"
    }
    
    protected method get_tab_index { workWindowID } {
      if {$workWindowID == ""} {
        return -1
      }
      
      set tab_names [$itk_component(tabs) tab names]
      if {[string is digit -strict $workWindowID ]} {
        if {$workWindowID < [llength $tab_names]} {
          return $workWindowID
        } else {
          return -1
        }
      }

      set full_tab_name [split $workWindowID "."]
      if {[llength $full_tab_name] > 1 && ![winfo exists $workWindowID]} {
        return -1
      }
      
      set tab_name [lindex $full_tab_name  end]
      return [lsearch -exact $tab_names $tab_name]
    }
    
    public method get_tab_ids {} {
      set tab_ids {}
      
      foreach tab_name [$itk_component(tabs) tab names] {
        lappend tab_ids $itk_component($tab_name)
      }
      return $tab_ids
    } 
  }
}

body ::UI::Notebook::check_new_value/currentTab {workWindowID} {
  if {[get_tab_index $workWindowID] == -1} {
    error "$workWindowID not exist"
  }
}

body ::UI::Notebook::update_gui/currentTab {} {
  select_tab [get_tab_index $currentTab]
}

namespace eval ::UI {
  ::itcl::class UI/Notebook/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document CurrentTab} {
      $widget configure \
          -currentTabvariable [$document get_variable_name $CurrentTab]
    }
  }

  UI/Notebook/DocumentLinker UI/Notebook/DocumentLinkerObject
}
