namespace eval ::UI {

  ::itcl::class FileCombobox/DocumentLinker {
    inherit BwidgetCombobox/DocumentLinker
    protected method attach_to_data {widget document tag sourceTag {openCommandTag ""}} {
      chain $widget $document $tag $sourceTag
      if {$openCommandTag != ""} {
        if {![$document is_command_name $openCommandTag]} {
          error "$openCommandTag is not a command name"
        }
        $widget configure -opencmd [list $document run_command $openCommandTag]
      }
    }
  }
  FileCombobox/DocumentLinker FileCombobox/DocumentLinkerObject
}

