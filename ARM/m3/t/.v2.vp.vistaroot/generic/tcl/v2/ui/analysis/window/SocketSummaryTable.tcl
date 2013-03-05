
usual SocketSummaryTable {}

namespace eval ::v2::ui::analysis::window {
  class SocketSummaryTable {
    inherit ::v2::ui::analysis::window::SummaryTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::SummaryTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)
      
    }

    protected method configure_table {} {
      $itk_component(table) column insert end throughput_trans throughput_data latency arbitration contention
      # UTILIZATION TEMPORARY DISABLED: removed "utilization" above. Should be after "latency"
      set names [$itk_component(table) column names]
      $itk_component(table) column configure [lindex $names 0] -command [code $this sort_by_column alpha]

      #set mu [encoding convertfrom utf-8 "\xc2\xb5"]
      set mu $::LETTER_MU

      $itk_component(table) column configure throughput_trans -title "trans/[set mu]s" -command [code $this sort_by_column throughput_trans]
      $itk_component(table) column configure throughput_data -title "bytes/[set mu]s" -command [code $this sort_by_column throughput_data]
      $itk_component(table) column configure latency -title "Latency ns" -command [code $this sort_by_column latency]
      $itk_component(table) column configure arbitration -title "Arbitration ns" -command [code $this sort_by_column arbitration]
      $itk_component(table) column configure contention -title "Contention" -command [code $this sort_by_column contention]
      #$itk_component(table) column configure utilization -title "Utilization %" 
      # UTILIZATION TEMPORARY DISABLED: removed the line above
    }

  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/SocketSummaryTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/SocketSummaryTable/DocumentLinker v2/ui/analysis/window/SocketSummaryTable/DocumentLinkerObject
}
