namespace eval ::v2::ui::profilingwindow {

  class TableView {
    inherit ::UI::SWidget
    constructor {_document args} {
      ::UI::SWidget::constructor $_document

    } {
      eval itk_initialize $args
      create_view
      show
    }
    private method create_view {} {
      itk_component add statistics_table {
        ::v2::ui::profilingwindow::ProfilingStatisticsTable $itk_interior.statistics_table $document
      }
    }
    public method show {} {
      pack $itk_component(statistics_table) -anchor nw -side left -fill both -expand 1
    }
  }
}
