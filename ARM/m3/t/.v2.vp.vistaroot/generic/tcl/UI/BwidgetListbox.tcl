usual BwidgetListbox {}
namespace eval ::UI {
  class BwidgetListbox {
    inherit itk::Widget

    ::UI::ADD_VARIABLE list List 
    ::UI::ADD_VARIABLE selectedList SelectedList
    
    itk_option define -foreground foreground Foreground black
    itk_option define -font font Font fixed
    itk_option define -state state State normal

    private variable var_namespace {}
    
    constructor {args} {
      construct_variable list
      construct_variable selectedList
      
      set top [::Widgets::ScrolledWindow $itk_interior.swl -relief sunken -bd 2 -scrollbar both -auto both]
      itk_component add listbox {
        ListBox $top.lb -takefocus 0
      } {
        keep -height -highlightthickness -deltay -borderwidth -relief -padx -background -selectmode
      }
      $itk_component(listbox).c configure -takefocus 0
      eval itk_initialize $args

      $top setwidget $itk_component(listbox)
      
      pack $top -fill both -expand 1 -pady 5
    }
    
    destructor {
      destruct_variable list
      destruct_variable selectedList
      DeleteVar_Namespace
    }

    public method updateSelectedList {widget} {
      if {$widget == ""} {
        return
      }
      set state [set [$widget cget -variable]]
      set item_text [$widget cget -text]
      set index [ lsearch -exact $selectedList $item_text]
      if {!$state} {
        set [cget -selectedListvariable] [lreplace $selectedList $index $index]
      } else {
        if {$index == -1} {
          lappend [cget -selectedListvariable] $item_text
        }
      }
    }

    private method CreateVar_Namespace {} {
      set var_namespace ::UI::BwidgetListboxVariables[createUniqueIdentifier]
      namespace eval $var_namespace {}
    }

    private method DeleteVar_Namespace {} {
      catch { 
        if {[namespace exists $var_namespace]} {
          namespace delete $var_namespace 
        }
      }
    }
  }

  ::itcl::class BwidgetListbox/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document tagList tagSelectedlist args} {
      set list_variable_name [$document get_variable_name $tagList]
      set selectedList_variable_name [$document get_variable_name $tagSelectedlist]
      $widget configure -listvariable $list_variable_name
      $widget configure -selectedListvariable $selectedList_variable_name
    }
  }
  BwidgetListbox/DocumentLinker BwidgetListbox/DocumentLinkerObject
}

body ::UI::BwidgetListbox::clean_gui/list {} {
 # set [cget -selectedListvariable] {}
  foreach item [$itk_component(listbox) items] {
    set widget [$itk_component(listbox) itemcget $item -window]
    catch { destroy $widget}
    $itk_component(listbox) delete $item
  }
  DeleteVar_Namespace
}

body ::UI::BwidgetListbox::update_gui/list {} {
  set counter 0
  CreateVar_Namespace
  foreach item $list {
    set widget_name $itk_component(listbox).item_$counter
    set var_name [set var_namespace]::check_$counter
    $itk_component(listbox) insert end item_$counter \
        -window [::UI::Checkbutton $widget_name -text "$item" \
                     -variable $var_name  -font $itk_option(-font) \
                     -foreground $itk_option(-foreground) -background $itk_option(-background) \
                     -command [code $this updateSelectedList $widget_name]] 
    set index [ lsearch -exact $selectedList $item]
    if {$index != -1} {
      set $var_name 1
    }
    incr counter
 } 
}

body ::UI::BwidgetListbox::clean_gui/selectedList {} {
  foreach item [$itk_component(listbox) items] {
    set widget [$itk_component(listbox) itemcget $item -window]
    set [$widget cget -variable] 0
  }
}

body ::UI::BwidgetListbox::update_gui/selectedList {} {
  foreach item [$itk_component(listbox) items] {
    set widget [$itk_component(listbox) itemcget $item -window]
    set item_text [$widget cget -text]
    set index [ lsearch -exact $selectedList $item_text]
    if {$index != -1} {
      set [$widget cget -variable] 1
    }
  }
}

configbody ::UI::BwidgetListbox::state {
  foreach item [$itk_component(listbox) items] {
    set widget [$itk_component(listbox) itemcget $item -window]
    $widget configure -state $itk_option(-state)
  }
}
