
namespace eval ::v2::ui::analysis::window {

  class AttrReportTableView {
    inherit ::UI::SWidget
    constructor {_document args} {
      ::UI::SWidget::constructor $_document

    } {
      eval itk_initialize $args
      create_view
      show
    }
    private method create_view {} {
      itk_component add report_table {
        ::v2::ui::analysis::window::AttrReportTable $itk_interior.report_table [$document create_tcl_sub_document DocumentTypeAttrReportTable]
      }
    }
    public method show {} {
      pack $itk_component(report_table) -anchor nw -side left -fill both -expand 1
    }

  }
}
