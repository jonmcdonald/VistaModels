
namespace eval ::v2::ui::conffromipxact_dialog {
  class ConfigFromIpXact {
    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 400 400

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      set type_frame [pack_topic [frame $top.type]]

      itk_component add type_label {
        label $type_frame.type_label -text "Model Type:" 
      } {}
      pack_left $itk_component(type_label)
      itk_component add model_type {
        ::UI::BwidgetCombobox $type_frame.model_type -editable 0
      } {}
      attach [pack_left $itk_component(model_type)] ModelType SupportedTypes ModelTypeIndex

      set ipxact_source [pack_framed_topic $top.source "IP-XACT Source" -fill both -expand 1]
      
      itk_component add name_label {
        label $ipxact_source.name_label -text "Model Name:" 
      } {}
      itk_component add model_name {
        entry $ipxact_source.model_name 
      } {}
      attach $itk_component(model_name) ModelName

      itk_component add ipxact_path_label {
        label $ipxact_source.ipxact_path_label -text "IP-XACT Root Path:" 
      } {}
      itk_component add ipxact_root_path {
        ::UI::FileChooser $ipxact_source.ipxact_path \
            -browsetype directory \
            -dialogtitle "Select IP-XACT Root Directory" \
            -filenamevariable [$document get_variable_name IpXactRootPath] \
          } {}
      attach $itk_component(ipxact_root_path) IpXactRootPath

      set target [pack_framed_topic $top.target "Target" -fill both -expand 1]
      
      itk_component add target_lib_label {
        label $target.target_lib_label -text "Library:" 
      } {}
      itk_component add target_library {
        ::UI::BwidgetCombobox $target.target_library -editable 0
      } {}
      attach $itk_component(target_library) TargetLibrary Libraries

      itk_component add project_label {
        label $target.project_label -text "Add To Project (optional):" 
      } {}
      itk_component add project {
        ::UI::BwidgetCombobox $target.project -editable 0
      } {}
      attach $itk_component(project) VistaProject Projects

      pack $itk_component(name_label)        -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(model_name)        -side top -anchor nw -padx 5 -pady 5 -fill x -expand 1
      pack $itk_component(ipxact_path_label) -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(ipxact_root_path)  -side top -anchor nw -padx 5 -pady 5 -fill x -expand 1
      pack $itk_component(target_lib_label)  -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(target_library)    -side top -anchor nw -padx 5 -pady 5 -fill x -expand 1
      pack $itk_component(project_label)     -side top -anchor nw -padx 5 -pady 5
      pack $itk_component(project)           -side top -anchor nw -padx 5 -pady 5 -fill x -expand 1
    }

    private method pack_topic {el args} {
      eval [list pack $el -side top -anchor w -fill x -pady 5] $args
      return $el
    }

    private method pack_framed_topic {el text args} {
      eval [list pack_topic [labelframe $el -labelanchor nw -text $text]] $args
      return $el
    }
    
    private method pack_subtopic {el args} {
      eval [list pack $el -side top -anchor w -fill x -pady 2] $args
      return $el
    }

    private method pack_left {el args} {
      eval [list pack $el -side left -anchor w -fill x -padx 5] $args
      return $el
    }
  }
}
