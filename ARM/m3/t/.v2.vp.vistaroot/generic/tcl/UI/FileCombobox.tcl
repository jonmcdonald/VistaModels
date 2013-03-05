usual FileCombobox {}

namespace eval ::UI {
  class FileCombobox {
    inherit ::UI::BwidgetCombobox
    
    public common ALL_FILES {{All Files} *}

    public variable typelist [list $ALL_FILES] 
    public variable opencmd ""

    constructor {args} {
      eval itk_initialize $args

      $itk_component(combobox) configure -values "Open..." \
          -editable 0
    }
    
    public method insert {args} {
      set values [concat $args [$itk_component(combobox) cget -values]]
      $itk_component(combobox) configure -values $values
    }

    public method setValues {args} {
      set values [concat $args [list "Open..."]]
      $itk_component(combobox) configure -values $values
    }

    public method setCurrent {name} {
      return
      if {$name != ""} {
        set index [GetIndexByName $name]
        if {$index == -1} {
          insert $name
          set index 0
        }
        $itk_component(combobox) setvalue @$index
      } else {
        $itk_component(combobox) configure -text "" 
      }
    }

    public method setFileTypes {args} {
      set typelist {}
      eval addFileTypes $args
    }

    public method addFileTypes {args} {
      foreach type $args {
        lappend typelist $type
      }
    }

    private method GetIndexByName {name} {
      if {$name != ""} {
        return [lsearch -exact [$itk_component(combobox) cget -values] $name]
      } 
      return -1
    }

    private method runOpenCmd {} {
      if {$opencmd != ""} {
        return [uplevel $opencmd]
      }
    }

    protected method on_element_chosen {} {
      set _varname $itk_option(-datavariable)
      set length [llength [$itk_component(combobox) cget -values]]
      set index [$itk_component(combobox) getvalue]
      set newValue ""
      if {$index == [expr {$length -1}]} {
        runOpenCmd
        if {[info exists $_varname]} {
          $itk_component(combobox) configure -text [getDataForShow [set $_varname]]
        }
        return
      }
      set newValue [$itk_component(combobox) cget -text]
      if {[info exists $_varname]} {
        set $_varname $newValue
      } else {
        setShowData $newValue
      }
    }

    protected method getListForShow {origList} {
      return [concat $origList [list "Open..."]]
    }
    
    protected method getDataForShow {origData} {
      return [file tail $origData]
    }
    
  }

}
