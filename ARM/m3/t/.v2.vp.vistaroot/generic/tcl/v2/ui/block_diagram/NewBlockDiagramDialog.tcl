
namespace eval ::v2::ui::block_diagram {
  catch {delete class NewBlockDiagram}
  class NewBlockDiagram {
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
#      create_element "Library:" [::UI::BwidgetCombobox $top.library] LibraryName Libraries
      create_element "Library:" [entry $top.library] LibraryName Libraries
      $top.library configure -state readonly
      create_element "Module:"  [entry $top.unit] UnitName
      create_element "Project:" [::UI::BwidgetCombobox $top.project] ProjectName Projects
      create_element "IP-XACT Vendor:" [entry $top.ipxact_vendor] IpXactVendor
      create_element "IP-XACT Version:" [entry $top.ipxact_version] IpXactVersion
    }
  }
}

