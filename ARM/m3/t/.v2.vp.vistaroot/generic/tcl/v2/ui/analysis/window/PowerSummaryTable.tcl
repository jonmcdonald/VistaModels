
usual PowerSummaryTable {}

namespace eval ::v2::ui::analysis::window {
  class PowerSummaryTable {
    inherit ::v2::ui::analysis::window::SummaryTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::SummaryTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      
      set [$document get_variable_name Tree] $itk_component(table)

    }

    protected method configure_table {} {
      $itk_component(table) column insert end overall_power dynamic_power clock_power leakage_power
      set names [$itk_component(table) column names]
      $itk_component(table) column configure [lindex $names 0] -command [code $this sort_by_column alpha]

      #set mu [encoding convertfrom utf-8 "\xc2\xb5"]
      set mu $::LETTER_MU

      $itk_component(table) column configure overall_power -title "Power, mW" -command [code $this sort_by_column overall_power]
      $itk_component(table) column configure dynamic_power -title "Dynamic" -command [code $this sort_by_column dynamic_power]
      $itk_component(table) column configure clock_power -title "Clock" -command [code $this sort_by_column clock_power]
      $itk_component(table) column configure leakage_power -title "Leakage" -command [code $this sort_by_column leakage_power]

    }

  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/PowerSummaryTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/PowerSummaryTable/DocumentLinker v2/ui/analysis/window/PowerSummaryTable/DocumentLinkerObject
}
