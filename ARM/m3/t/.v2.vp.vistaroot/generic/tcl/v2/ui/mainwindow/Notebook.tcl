namespace eval ::v2::ui::mainwindow {
  class Notebook {
    inherit ::UI::Notebook
    
    private variable counter 0
        
    constructor {_document args} {
      ::UI::Notebook::constructor $_document
    } {
      eval itk_initialize $args
       
      set_binding
      create_popup_menu "::v2::ui::mainwindow::PopupMenu"
    }
    
    protected method set_binding {} {
      bind [winfo toplevel $itk_interior] <F4> [code $document run_command NextWindowCommand]
      bind [winfo toplevel $itk_interior] <Control-F4> \
          [code $document run_command PreviousWindowCommand]
    }

    public method update_title {workWindowID title} {
      set tab_name [lindex [$itk_component(tabs) tab names] [get_tab_index $workWindowID]]
      $itk_component(tabs) tab configure $tab_name -text $title
    }

    protected method tab_select_command {args} {
      set select_index [$itk_component(tabs) index select]
      set current_tab_name [lindex [$itk_component(tabs) tab names] $select_index]
      if {$currentTabIsHandled} {
        return
      }
      set [cget -currentTabvariable] $itk_component($current_tab_name)
    }
    
    public method run_RemoveWorkWindowCommand {tab_name} {
      $document run_command RemoveWorkWindowCommand WorkWindowName $itk_component($tab_name)
    }

    public method add_workwindow {name_text docID} {
      set name work_window$counter

      # create new tab
      itk_component add [set name]_frame {
        frame $itk_interior.tabs.[set name]_frame
      }
      $itk_component(tabs) insert end $name -text $name_text \
          -window  $itk_component([set name]_frame) \
          -fill both -anchor n -background {} -selectbackground {} \
          -selectforeground {} -padx 0 -pady 0
      itk_component add $name {
        ::v2::ui::workwindow::WorkWindow $itk_interior.$name \
            [::Utilities::objectNew ::Document::Document $docID]
      } {}

      #pack this tab
      set tabs_size [$itk_component(tabs) size]

      if {$tabs_size > 1} {
        pack $itk_component($name) -side top -fill both -expand 1 -anchor nw \
          -in $itk_component([set name]_frame)
        
        if {$tabs_size == 2} {
          set first_tab_name [lindex [$itk_component(tabs) tab names] 0]
          pack forget $itk_component($first_tab_name)
        }
        pack $itk_component(tabs) -side top -fill both -expand 1 -anchor nw
        
        if {$tabs_size == 2} {
          update
          pack $itk_component($first_tab_name) -side top -fill both -expand 1 -anchor nw \
              -in $itk_component([set first_tab_name]_frame) 
        }
      } else {
        pack $itk_component($name) -side top -fill both -expand 1 -anchor nw 
      }

      $itk_component(tabs) bind $name <3> "[code $this select_tab [get_tab_index $itk_component($name)]]"
      if {$counter} {
        $itk_component(tabs) bind $name <ButtonRelease-3> "[code $this on_RMB]"
        create_tab_image_with_command $name [::UI::getimage tab_close] [::UI::getimage tab_close_raised] [code $this run_RemoveWorkWindowCommand $name]
      } 
      incr counter

      return $itk_component($name)
    }

    public method is_undeletable_tab {workWindowID} {
      set index [get_tab_index $workWindowID]
      if {$index <= 0} {
        return 1
      } 
      return 0
    }
    
    public method remove_workwindow {workWindowID} {
      set index [get_tab_index $workWindowID]
      
      if {$index <= 0} {
        return
      }

      set tab_names [$itk_component(tabs) tab names]
      set name [lindex $tab_names $index]
      
      # if removed tab is selected, then select previous tab
      set select_index [$itk_component(tabs) index select]
      if {$select_index == $index} {
        set prev_index [expr $index - 1]
        select_tab $prev_index
      }

      set size [$itk_component(tabs) size]
      if {$size == 2} {
        set first_tab_name [lindex $tab_names 0]
        pack forget $itk_component(tabs)
        pack $itk_component($first_tab_name) -in $itk_interior
        if {[focus] != $itk_component($first_tab_name)} {
          focus $itk_component($first_tab_name)
        }
      } else {
        set prev_index [expr $index - 1]
        select_tab $prev_index
      }
      catch {destroy $itk_component([set name]_frame)}
      catch {$itk_component(tabs) delete $index}
      catch {delete object $itk_component($name)}
    }
  }
}

namespace eval ::UI {
  ::itcl::class v2/ui/mainwindow/Notebook/DocumentLinker {
    inherit UI/Notebook/DocumentLinker
  }
  v2/ui/mainwindow/Notebook/DocumentLinker v2/ui/mainwindow/Notebook/DocumentLinkerObject
}
