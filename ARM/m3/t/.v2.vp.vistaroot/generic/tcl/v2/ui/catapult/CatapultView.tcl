namespace eval ::v2::ui::catapult {
  class CatapultView {
    inherit ::UI::SWidget

    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args
      
      # create top Pane Container
      itk_component add pane_ver {
        ::UI::PaneContainer $itk_interior.pane_ver $document -orient vertical -isselected 1 \
            -withsashbitmap 0
      } { }
      
      set winwidth [$document get_variable_value WindowWidthSC]


      set itk_component(catapult) \
          [$itk_component(pane_ver) add pane catapult -minimum 50 \
               -thickness [expr $winwidth / 13 * 5 ] \
               -withtitle 1 -showInCreate 1]
      
      set itk_component(pane_right) \
          [$itk_component(pane_ver) add container right \
               -minimum 0  -orient horizontal -withsashbitmap 0]
      set winheight [$document get_variable_value WindowHeightSC]
      set itk_component(fifo) \
          [$itk_component(pane_right) add pane fifo -minimum 50 \
               -thickness [expr $winheight / 13 * 5] \
               -withtitle 1 -showInCreate 1]


      pack $itk_component(pane_ver) -side top -fill both -expand 1 -anchor nw
      
      create_components
    }

    private method create_components {} {
      itk_component add catapult_tree {
        ::v2::ui::catapult::CatapultTreeView [$itk_component(pane_ver) childsite catapult].tree \
            [$document create_tcl_sub_document DocumentTypeCatapultTreeView]
      } {}

      pack $itk_component(catapult_tree) \
          -fill both -anchor nw -side left -expand 1 
      
      itk_component add fifo_tree {
        ::v2::ui::catapult::FifoTreeView [$itk_component(pane_right) childsite fifo].fifo_tree \
            [$document create_tcl_sub_document DocumentTypeFifoTreeView]
      } {}
#       ::UI::auto_trace_with_init variable [$document get_variable_name CurrentFifoData] w $itk_interior [::itcl::code $this update_fifo_tree_title]

      pack $itk_component(fifo_tree) \
          -fill both -anchor nw -side left -expand 1 

      $document set_variable_value FlatCatapultTree 1
    }

    private method update_fifo_tree_title { } {
#      $itk_component(fifo_tree) update_title "Fifo:  [$document get_variable_value CurrentFifoData]"
    }
  }
}
