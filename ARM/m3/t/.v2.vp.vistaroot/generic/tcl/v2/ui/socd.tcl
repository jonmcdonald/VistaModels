namespace eval ::v2::ui {
  set socd_prompt_image ""

  proc get_socd_prompt_image {} {
    variable socd_prompt_image
    if {$socd_prompt_image != ""} {
      return $socd_prompt_image
    }
    if {![::Utilities::tkInitialized]} {
      return ""
    }
    set socd_prompt_image [::UI::getimage socd_prompt 0]
    return $socd_prompt_image
  }


}
