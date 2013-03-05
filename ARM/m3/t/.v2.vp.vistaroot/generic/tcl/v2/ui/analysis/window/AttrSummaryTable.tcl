
usual AttrSummaryTable {}

namespace eval ::v2::ui::analysis::window {
  class AttrSummaryTable {
    inherit ::v2::ui::analysis::window::SummaryTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::SummaryTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)

    }

    protected method configure_table {} {
      $itk_component(table) column insert end attr_avg attr_max attr_min
      set names [$itk_component(table) column names]
      $itk_component(table) column configure [lindex $names 0] -command [code $this sort_by_column alpha]

      $itk_component(table) column configure attr_avg -title "Average" -command [code $this sort_by_column attr_avg]
      $itk_component(table) column configure attr_max -title "Maximum" -command [code $this sort_by_column attr_max]
      $itk_component(table) column configure attr_min -title "Minimum" -command [code $this sort_by_column attr_min]

    }


  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/AttrSummaryTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/AttrSummaryTable/DocumentLinker v2/ui/analysis/window/AttrSummaryTable/DocumentLinkerObject
}
