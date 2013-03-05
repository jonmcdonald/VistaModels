
namespace eval ::v2::ui::analysis::window {

  class PopupMenu {
    inherit  ::UI::PopupMenu
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    public method fill_menu {} {
      
    }
    public method update_menu {} {
      $itk_component(menu) delete 0 end
      switch [$document get_type] {
        "DocumentTypeNewAnalysisWindow" -
        "DocumentTypePowerSummary" -
        "DocumentTypeTreeSummary" -
        "DocumentTypeSocketSummary" -
        "DocumentTypeAttrSummary"
        {
          add_menu_item $itk_component(menu) AddObjectsCommand command -label "Add to Graph"
        }
      }
      switch [$document get_type] {
        "DocumentTypeReportTable"
        {
          add_menu_item $itk_component(menu) DetailThroughputTransactionsCommand command -label "Detail Throughput Transactions Graph"
          add_menu_item $itk_component(menu) DetailThroughputDataCommand command -label "Detail Throughput Data Graph"
        }
      }          
      switch [$document get_type] {
        "DocumentTypePowerReportTable"
        {
          add_menu_item $itk_component(menu) DetailPowerCommand command -label "Show Distributed Power Graph"
        }
      }          

      add_menu_item $itk_component(menu) RemoveSelectedObjectsCommand command -label "Remove from Graph"
    }
  } ;# class

} ;# namespace
