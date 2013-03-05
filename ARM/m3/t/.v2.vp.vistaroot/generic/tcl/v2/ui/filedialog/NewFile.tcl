
namespace eval ::v2::ui::filedialog {
  class NewFile {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 220 0
      wm resizable $itk_interior 1 0
      add_state_trace AddToProject
      draw
    }

    protected method create_body {} {
      set top [get_body_frame]
      itk_component add add_checkbutton {
        ::UI::Checkbutton $top.add_checkbutton -text "Add to Project"
      } {}
      attach $itk_component(add_checkbutton) AddToProject
      
      itk_component add project_combo {
        ::UI::BwidgetCombobox $top.project_combo
      } {}
      
      attach $itk_component(project_combo) NewFileProject AllProjectsNames
#      set currentProjectName [ $document get_variable_value NewFileProject]

      label $top.directory -text "Directory:"
      itk_component add directory_path {
        ::UI::FileChooser $top.directory_path___advanced___  \
            -filenamevariable [$document get_variable_name NewFileDirectory] \
            -browsetype directory_advanced -dialogtitle "Select Directory"  -path_variable_document $document 
      } {}
      $document set_variable_value ChooseDirectoryDialogWidgetName $itk_component(directory_path).__tk_choosedir
      attach $itk_component(directory_path) ProjectDirectoryName

      
      label $top.file -text "File Name:"
      itk_component add file_name {
        entry $top.file_name
      } {}
      attach $itk_component(file_name) NewFileName

      


      pack $itk_component(add_checkbutton) -side top -anchor nw -pady 5
      pack $itk_component(project_combo) -side top -anchor nw -pady 5 -fill x
      pack $top.directory -side top -anchor nw -pady 5
      pack $itk_component(directory_path) -side top -anchor nw -pady 5 -fill x
      pack $top.file -side top -anchor nw -pady 5
      pack $itk_component(file_name) -side top -anchor nw -pady 5 -fill x
    }

    public method change_state {args} {
      if {[$document get_variable_value AddToProject] == 1} {
        $itk_component(project_combo) configure -state normal
      } else {
        $itk_component(project_combo) configure -state disabled
      }
    }     
  }
}

