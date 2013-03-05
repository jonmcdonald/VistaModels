
usual PowerReportTable {}

namespace eval ::v2::ui::analysis::window {
  class PowerReportTable {
    inherit ::v2::ui::analysis::window::ReportTableBase
    constructor {_document args} {
      ::v2::ui::analysis::window::ReportTableBase::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)

    }

    protected method configure_table {} {
      $itk_component(table) column insert end overall_power dynamic_power clock_power leakage_power

      set names [$itk_component(table) column names]

      set mu $::LETTER_MU

      $itk_component(table) column configure overall_power -title "Power, mW"
      $itk_component(table) column configure dynamic_power -title "Dynamic"
      $itk_component(table) column configure clock_power -title "Clock"
      $itk_component(table) column configure leakage_power -title "Leakage"

    }


  } ;# class
} ;#namespace

namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/PowerReportTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis/window/PowerReportTable/DocumentLinker v2/ui/analysis/window/PowerReportTable/DocumentLinkerObject
}
