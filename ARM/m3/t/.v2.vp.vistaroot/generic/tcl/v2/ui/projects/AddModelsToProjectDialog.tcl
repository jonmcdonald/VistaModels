namespace eval ::v2::ui::projects {

  class AddModelsToProject {
    inherit ::UI::BaseDialog

    private variable selected_projects
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args
      
      wm minsize $itk_interior 420 0
      draw
    }

    protected method create_body {} {
      set top [get_body_frame]
      label $top.l_projects -text "Select project(s):"
      itk_component add projects_frame {
        frame $top.projects_fr
      } {}
      pack $top.l_projects -side top
      pack $itk_component(projects_frame) -side top -fill both -expand 1
     
      set projects_list [$document get_variable_value Projects]
      
      if {[llength $projects_list] == 0} {
        label $top.l_no_project -text "Warning: no project is currently open!"
        pack $top.l_no_project -side top
      } else {
        
        create_listbox $itk_component(projects_frame) projects_listbox Projects SelectedProjects
        pack $itk_component(projects_listbox) -anchor nw -padx 5 -pady 5 -fill both -expand 1
      }

    }
    
  } ;#class AddModelToProject

} ;# namespace
