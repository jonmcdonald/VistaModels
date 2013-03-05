namespace eval ::v2::ui::library {
  catch {delete class LibraryBaseDialog}
  class LibraryBaseDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 220 0
      wm resizable $itk_interior 1 0
      draw
    }

    private method create_element {label element args} {
      pack [label [set element]_label -text $label] -side top -anchor nw -pady 5 
      pack $element -side top -anchor nw -pady 5 -fill x
      eval [list attach $element] $args
    }

    protected method create_body {} {
      set top [get_body_frame]
      create_element "Library:" [entry $top.library] LibraryLogicalName
      create_element "Path:" [::UI::FileChooser $top.path \
                                  -browsetype "directory" \
                                  -buttoncmdtype openfile \
                                  -dialogtitle "Select Library Physical Path"] LibraryPhysicalPath

    }
  }
}
