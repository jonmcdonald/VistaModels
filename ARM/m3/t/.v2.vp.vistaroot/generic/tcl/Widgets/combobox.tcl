namespace eval ::Widgets {
  proc fixBwidget_ComboBox_mapliste {} {
    auto_load ComboBox
    set body [info body ::ComboBox::_mapliste]
    set arguments [info args ::ComboBox::_mapliste]
    if {[llength $arguments] < 1} {
      puts "Error: Failed to fix ComboBox"
      return
    }
    set arg1 [lindex $arguments 0]
    regsub -all {\[winfo width \$path\]} $body "\[::Widgets::resolveComboboxWidth \$[set arg1]\]" newBody
    proc ::ComboBox::_mapliste { path } $newBody
    
    proc ::Widgets::resolveComboboxWidth {path} {
      set listb $path.shell.listb
      set values [$listb get 0 end]
      set width [winfo width $path]
      set size 0
      foreach value $values {
        if {[set newSize [font measure [$path cget -font] abc$value]] > $size} {
          set size $newSize
        }
      }
      if {$size < $width } {
        set size $width
      }
      #in order to fix problem with blue listbox
      $path.shell.listb config -bg white -fg black
      return $size
    }
  }
}

