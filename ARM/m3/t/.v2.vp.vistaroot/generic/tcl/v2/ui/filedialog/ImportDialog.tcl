
namespace eval ::v2::ui::filedialog {
  class ImportDialog {
    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      
      set_title "Import Makefile"
      wm minsize $itk_interior 300 0
      wm resizable $itk_interior 1 0
      
      draw
    }
    
    protected method create_buttons {} {
      add_ok_button "Import"
      add_common_buttons
    }

    protected method create_body {} {
      set top [get_body_frame]

      label $top.label_path -text "Import Makefile Path:"
      itk_component add path {
        ::UI::FileChooser $top.path -buttoncmdtype openfile -dialogtitle "Select Makefile" \
            -filetypes {{"All Files" "*"}} \
            -filenamevariable [$document get_variable_name ImportMakefilePath]
      } {}

      label $top.label_obj -text "Objects List Variable:"
      itk_component add objects {
        entry $top.objects
      } {}
      attach $itk_component(objects) ImportObjectsList

      label $top.label_src -text "Sources List Variable:"
      itk_component add sources {
        entry $top.sources
      } {}
      attach $itk_component(sources) ImportSourcesList

      label $top.label_name -text "Project Name:"
      itk_component add prj_name {
        entry $top.prj_name
      } {}
      attach $itk_component(prj_name) ImportProjectName

      pack $top.label_path -anchor w -pady 6
      pack $itk_component(path) -anchor w -fill x
      pack $top.label_obj -anchor w -pady 6
      pack $itk_component(objects) -anchor w -fill x
      pack $top.label_src -anchor w -pady 6
      pack $itk_component(sources) -anchor w -fill x
      pack $top.label_name -anchor w -pady 6
      pack $itk_component(prj_name) -anchor w -fill x
    }

  };#class

};#namespace
