namespace eval ::UI {

  ::itcl::class BwidgetCombobox/DocumentLinker {
    inherit DataDocumentLinker
    
    protected method attach_to_data {widget document tag sourceTag args} {
      set data_variable_name [$document get_variable_name $tag]
      set source_variable_name [$document get_variable_name $sourceTag]
      $widget configure -datavariable $data_variable_name
      $widget configure -listvariable $source_variable_name
      if {[llength $args]} {
        set currentIndex_variable_name [$document get_variable_name [lindex $args 0]]
        $widget configure -currentIndexvariable $currentIndex_variable_name
      }

    }
  }
  BwidgetCombobox/DocumentLinker BwidgetCombobox/DocumentLinkerObject
}
