usual TableView {}
namespace eval ::v2::ui::analysis::window {

  class PowerSummaryTableView {
    inherit ::UI::SWidget
    constructor {_document args} {
      ::UI::SWidget::constructor $_document

    } {
      eval itk_initialize $args
      create_view
      show
    }
    private method create_view {} {
      itk_component add summary_table {
        ::v2::ui::analysis::window::PowerSummaryTable $itk_interior.summary_table [$document create_tcl_sub_document DocumentTypePowerSummary]
      }
    }
    public method show {} {
      pack $itk_component(summary_table) -anchor nw -side left -fill both -expand 1
    }

  }
}
