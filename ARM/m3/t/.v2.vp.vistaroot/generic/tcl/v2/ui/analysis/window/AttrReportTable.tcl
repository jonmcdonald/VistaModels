
usual AttrReportTable {}

namespace eval ::v2::ui::analysis::window {
  class AttrReportTable {
    inherit ::v2::ui::analysis::window::ReportTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::ReportTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)
      
      #set names [$itk_component(table) column names]
      
    }

    protected method configure_table {} {
      $itk_component(table) column insert end attr_avg attr_max attr_min
      set names [$itk_component(table) column names]
      $itk_component(table) column configure attr_avg -title "Average"
      $itk_component(table) column configure attr_max -title "Maximum"
      $itk_component(table) column configure attr_min -title "Minimum"
    }
    

  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/AttrReportTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/AttrReportTable/DocumentLinker v2/ui/analysis/window/AttrReportTable/DocumentLinkerObject
}
