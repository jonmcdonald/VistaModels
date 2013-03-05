namespace eval ::v2::ui {
  class SimulationInterface {
    protected variable sub_document_name ""

    public constructor {} {
    }

    protected method get_command_string {command_name} {
      if {$sub_document_name != {}} {
        return [list $sub_document_name $command_name]
      }
      return $command_name
    }
  }
}
