namespace eval ::v2::ui::projectdialog {
  class CreateFolderDialog {
    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      set_title "Create Folder"

      wm minsize $itk_interior 170 0
      wm resizable $itk_interior 1 0
      
      draw
      focus $itk_interior
    }
    
    protected method create_buttons {} {
      add_ok_button
      add_cancel_button
    }

    protected method create_body {} {

      set top [get_body_frame]
      set parentWidgetName [$document get_variable_value ParentWidgetName]
      label $top.label_folderName -text "Folder Name:"
      label $top.label_ext -text "Files Extension:"
      itk_component add folderName {
        entry $top.folderName
      } {}
      attach $itk_component(folderName) FolderName

      itk_component add ext {
          entry $top.ext 
      } {}
      attach $itk_component(ext) Extensions

      pack $top.label_folderName -anchor w
      pack $itk_component(folderName) -anchor w -pady 6 -fill x
      pack $top.label_ext -anchor w
      pack $itk_component(ext) -anchor w -pady 5 -fill x
    }

  };#class

};#namespace
