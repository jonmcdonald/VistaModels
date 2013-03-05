#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::simulation_control {
  
  class Toolbar {
    inherit ::v2::ui::SimulationToolbar

    constructor {_document args} {
      ::v2::ui::SimulationToolbar::constructor $_document
    } {
      eval itk_initialize $args
      fill_toolbar
    }

    private method fill_toolbar {} {
      create_left
      create_right
    }
    
    private method create_left {} {
      create_sim_buttons

      addCheckButton $sim_buttons flat_process_tree "process_list" 1 \
          {DocumentTypeProcessesView FlatProcessTree} "Toggle Flat/Hierarchical Process View"
      set with_catapult 0
      if {[info exists ::env(VISTA_WITH_CATAPULT)] && $::env(VISTA_WITH_CATAPULT) != ""} {
        addCheckButton $sim_buttons flat_catapult_tree "process_list" 1 {DocumentTypeCatapultView FlatCatapultTree} "Toggle Flat/Hierarchical Fifo View"
        set with_catapult 1
      }
      addSeparator $sim_buttons sep_flat
      if {$with_catapult} {
        pack_left $sim_buttons flat_process_tree flat_catapult_tree sep_flat
      } else {
        pack_left $sim_buttons flat_process_tree sep_flat
      }

      fill_common_simulation_toolbar

      
      if {[info exists ::env(V2_LOG_ZOOMS)]} {
        pack_left $sim_buttons zoom
      }
      pack $sim_buttons -side top -anchor w
    }
    
    private method create_right {} {
    }
  }
}
