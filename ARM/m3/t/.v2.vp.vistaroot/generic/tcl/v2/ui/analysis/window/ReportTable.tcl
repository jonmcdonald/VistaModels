
option add *TreeView.Column.titleFont { Helvetica 9 }

usual ReportTable {}

namespace eval ::v2::ui::analysis::window {
  class ReportTable {
    inherit ::v2::ui::analysis::window::ReportTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::ReportTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)

    }
    
    protected method configure_table {} {
      
      $itk_component(table) column insert end count throughput_trans throughput_data unused_throughput_data latency arbitration contention
      set names [$itk_component(table) column names]
      $itk_component(table) column configure [lindex $names 0] -command [code $this clear_selection]
      
      # UTILIZATION TEMPORARY DISABLED: removed "utilization" above. Should be after "latency"
      $itk_component(table) column configure count -title "trans count"
      #set mu [encoding convertfrom utf-8 "\xc2\xb5"]
      set mu $::LETTER_MU
      $itk_component(table) column configure throughput_data -title "bytes/[set mu]s"
      $itk_component(table) column configure unused_throughput_data -title "unused bytes/[set mu]s"
      $itk_component(table) column configure throughput_trans -title "trans/[set mu]s"
      $itk_component(table) column configure latency -title "Latency ns"
      $itk_component(table) column configure arbitration -title "Arbitration ns"
      $itk_component(table) column configure contention -title "Contention"
      #$itk_component(table) column configure utilization -title "Utilization %"  
      # UTILIZATION TEMPORARY DISABLED: removed the line above
    }
    

  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/ReportTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/ReportTable/DocumentLinker v2/ui/analysis/window/ReportTable/DocumentLinkerObject
}
