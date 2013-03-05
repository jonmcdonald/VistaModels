namespace eval ::v2::ui {
  set mti_prompt_image ""
  proc get_modelsim_tcl_bitmaps_root {} {
    set tcl_root [::v2::mti::get_modelsim_tcl_root]
    if {$tcl_root == ""} {
      return ""
    }
    set candidate $tcl_root/bitmaps
    if {[file isdirectory $candidate]} {
      return $candidate
    }
    return ""
  }


  proc get_mti_prompt_image {} {
    variable mti_prompt_image
    if {$mti_prompt_image != ""} {
      return $mti_prompt_image
    }
    if {![::Utilities::tkInitialized]} {
      return ""
    }
    set bitmaps_root [get_modelsim_tcl_bitmaps_root]
    if {$bitmaps_root != ""} {
      catch {
        image create photo ::Images::mti_prompt -file $bitmaps_root/break.gif
      }
    }
    set mti_prompt_image [::UI::getimage mti_prompt 0]
    return $mti_prompt_image
  }


}
