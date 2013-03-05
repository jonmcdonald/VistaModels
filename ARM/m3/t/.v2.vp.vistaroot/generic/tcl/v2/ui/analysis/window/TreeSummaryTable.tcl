
usual TreeSummaryTable {}

namespace eval ::v2::ui::analysis::window {
  class TreeSummaryTable {
    inherit ::v2::ui::analysis::window::SummaryTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::SummaryTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)
    }

    protected method configure_table {} {

      $itk_component(table) column insert end overall_power throughput_trans arbitration contention
      set names [$itk_component(table) column names]
      $itk_component(table) column configure [lindex $names 0] -command [code $this sort_by_column alpha]
      #set mu [encoding convertfrom utf-8 "\xc2\xb5"]
      set mu $::LETTER_MU

      $itk_component(table) column configure overall_power -title "Power, mW" -command [code $this sort_by_column overall_power]
      $itk_component(table) column configure throughput_trans -title "trans/[set mu]s" -command [code $this sort_by_column throughput_trans]
      $itk_component(table) column configure arbitration -title "Arbitration, ns" -command [code $this sort_by_column arbitration]
      $itk_component(table) column configure contention -title "Contention" -command [code $this sort_by_column contention]
      

    }


  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/TreeSummaryTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/TreeSummaryTable/DocumentLinker v2/ui/analysis/window/TreeSummaryTable/DocumentLinkerObject
}
