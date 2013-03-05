usual BwidgetCombobox {}
namespace eval ::UI {
  class BwidgetCombobox {
    inherit itk::Widget

    ::UI::ADD_VARIABLE list List 
    ::UI::ADD_VARIABLE data Data
    ::UI::ADD_VARIABLE currentIndex CurrentIndex

    constructor {args} {
      construct_variable list
      construct_variable data
      construct_variable currentIndex

      set side "left"
      set index [lsearch -exact $args "-side"]
      if  {$index != -1} {
        set side [lindex $args [ incr index]]
      }

      itk_component add combobox {
        ComboBox $itk_interior.cb -bd 1
      } {
        keep -state -editable 
        keep -width 
        keep -font -foreground -background
        keep -highlightthickness -highlightbackground
        keep -helptext
      }

      eval itk_initialize $args
      pack $itk_component(combobox) -fill x -expand 1
      $itk_component(combobox) configure -modifycmd [::itcl::code $this on_element_chosen] \
          -height 0 
    }

    destructor {
      destruct_variable list
      destruct_variable data
      destruct_variable currentIndex
    }

    protected method on_element_chosen {} {
      setNewData [$itk_component(combobox) cget -text]
      setNewCurrentIndex [$itk_component(combobox) getvalue]
    }
    
    protected method setNewData {newValue} {
      set _varname $itk_option(-datavariable)
      if {[info exists $_varname]} {
        set $_varname $newValue
      } else {
        setShowData $newValue
      }
    }

    protected method setNewCurrentIndex {newIndex} {
      set _varname $itk_option(-currentIndexvariable)
      if {[info exists $_varname]} {
        set $_varname $newIndex
      }
    }

    protected method setShowData {showData} {
      $itk_component(combobox) configure -text [getDataForShow $showData]
    }

    protected method getListForShow {origList} {
      return $origList
    }

    protected method getDataForShow {origData} {
      return $origData
    }

  }
}


body ::UI::BwidgetCombobox::clean_gui/list {} {
  $itk_component(combobox) configure -values {}
  setShowData $data
}

body ::UI::BwidgetCombobox::setup_data/list {} {
  $itk_component(combobox) configure -values [getListForShow $list]
  if {$currentIndex != "" && $currentIndex != "-1" && !$itk_option(-editable) } {
    setNewData [lindex [$itk_component(combobox) cget -values] $currentIndex]
  } 
#  setShowData $data
}

body ::UI::BwidgetCombobox::clean_gui/data {} {
  if {!$itk_option(-editable)} {
    $itk_component(combobox) configure -text ""
  }
#  config -currentIndex [$itk_component(combobox) getvalue]
}

body ::UI::BwidgetCombobox::setup_data/data {} {
  setShowData $data
#  config -currentIndex [$itk_component(combobox) getvalue]
}

body ::UI::BwidgetCombobox::clean_gui/currentIndex {} {
  $itk_component(combobox) configure -text ""
#  config -currentIndex [$itk_component(combobox) getvalue]
}

body ::UI::BwidgetCombobox::setup_data/currentIndex {} {
  if {$currentIndex != ""} {
    setNewData [lindex [$itk_component(combobox) cget -values] $currentIndex]
  }
#  setShowData [lindex [$itk_component(combobox) cget -values] $currentIndex]
#  config -currentIndex [$itk_component(combobox) getvalue]
}
