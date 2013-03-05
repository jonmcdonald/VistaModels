namespace eval ::v2::ui::projects {
  class HistoryButtonMenu {
    inherit  ::UI::PopupMenu
    
    protected variable historyCurrentIndex -1
    protected variable historyList {}
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    public method update_menu {} {
      $itk_component(menu) delete 0 end
      set historyCurrentIndex [$document get_variable_value HistoryCurrentIndex]
      set historyList [$document get_variable_value HistoryList]
    }
    
    protected method activateCommand {historyIndex} {
      $document set_variable_value HistoryCurrentIndex $historyIndex
      $document run_command HistoryCommand
    }
    
    protected method createItemMenu {historyIndex placeItem} {
      set typeView [lindex [lindex $historyList $historyIndex] 0]
      set typeViewTitle [string totitle $typeView 0 0]
      set nameView [concat [lindex [lindex $historyList $historyIndex] 1]]
      
      set label {}
      if {$typeView == "project"} {
        set label [string totitle $nameView 0 0]
      } else {
        set label "$typeViewTitle: [join $nameView]"
      }
      
      if {$label != {}} {
          insertItemMenu $itk_component(menu) command $placeItem -label $label \
              -command [code $this activateCommand $historyIndex]
      }
    }
  }

  class BackButtonMenu {
    usual BackButtonMenu {}
    inherit  HistoryButtonMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }
    
    public method update_menu {} {
      chain
      for { set historyIndex 0} {$historyIndex < $historyCurrentIndex} { incr historyIndex} {
        createItemMenu $historyIndex 0
      }
    }
  }
  
  class ForwardButtonMenu {
    usual ForwardButtonMenu {}
    inherit  HistoryButtonMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }
    
    public method update_menu {} {
      chain
      for {set historyIndex [expr $historyCurrentIndex + 1] } \
          {$historyIndex < [llength $historyList] } { incr historyIndex} {
            createItemMenu $historyIndex end
          }
    }
  }
}
