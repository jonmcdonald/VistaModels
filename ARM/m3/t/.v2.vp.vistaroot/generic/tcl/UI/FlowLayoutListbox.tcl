usual FlowLayoutListbox {}
namespace eval ::UI {
  class FlowLayoutListbox {
    inherit itk::Widget

    ::UI::ADD_VARIABLE list List 
    ::UI::ADD_VARIABLE selectedList SelectedList
    
    itk_option define -foreground foreground Foreground black
    itk_option define -font font Font fixed
    itk_option define -state state State normal
    itk_option define -padx padX PadX 5
    itk_option define -pady padY PadY 5

    private variable var_namespace {}
    
    constructor {args} {
      construct_variable list
      construct_variable selectedList
      
      set top [::Widgets::ScrolledWindow $itk_interior.swl -relief sunken -bd 2 -scrollbar both -auto both]
      itk_component add text {
        text $top.text -takefocus 0 -highlightthickness 0 -borderwidth 0 -relief flat \
            -height 0 -state disabled
      } { 
        keep -background -foreground -font
      }
      
      eval itk_initialize $args

      $top setwidget $itk_component(text)
      
      pack $top -fill both -expand 1 -pady 0
      
      bind text-config-$this <Configure> [code $this _pwConfigureEventHandler %w %h]
      bindtags $itk_component(text) \
          [linsert [bindtags $itk_component(text)] 0 text-config-$this]
    }

    private method _pwConfigureEventHandler {width height} {
      puts "$this Configure $width $height"
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
      set var_namespace ::UI::FlowLayoutListboxVariables[createUniqueIdentifier]
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

  ::itcl::class FlowLayoutListbox/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document tagList tagSelectedlist args} {
      set list_variable_name [$document get_variable_name $tagList]
      set selectedList_variable_name [$document get_variable_name $tagSelectedlist]
      $widget configure -listvariable $list_variable_name
      $widget configure -selectedListvariable $selectedList_variable_name
    }
  }
  FlowLayoutListbox/DocumentLinker FlowLayoutListbox/DocumentLinkerObject
}

body ::UI::FlowLayoutListbox::clean_gui/list {} {
  set [cget -selectedListvariable] {}
  foreach widget [$itk_component(text) window names] {
    catch { destroy $widget}
  }
  DeleteVar_Namespace
}

body ::UI::FlowLayoutListbox::update_gui/list {} {
  set counter 0
  CreateVar_Namespace
  foreach item $list {
    set widget_name $itk_component(text).item_$counter
    set var_name [set var_namespace]::check_$counter
    $itk_component(text) window create end \
        -window [::UI::Checkbutton $widget_name -text "$item" \
                     -variable $var_name  -font $itk_option(-font) \
                     -foreground $itk_option(-foreground) -background $itk_option(-background) \
                     -command [code $this updateSelectedList $widget_name]] \
        -padx $itk_option(-padx) -pady $itk_option(-pady)  
    incr counter
 } 
}

body ::UI::FlowLayoutListbox::clean_gui/selectedList {} {
  foreach widget [$itk_component(text) window names] {
    set [$widget cget -variable] 0
  }
}

body ::UI::FlowLayoutListbox::update_gui/selectedList {} {
  foreach widget [$itk_component(text) window names] {
    set item_text [$widget cget -text]
    set index [ lsearch -exact $selectedList $item_text]
    if {$index != -1} {
      set [$widget cget -variable] 1
    }
  }
}

configbody ::UI::FlowLayoutListbox::state {
  foreach widget [$itk_component(text) window names] {
    $widget configure -state $itk_option(-state)
  }
}
