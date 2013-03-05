
namespace eval ::v2::ui::path_variables_adder {
  class CreatePathVariableDialog {
    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      
      eval itk_initialize $args
      set_title "Create Path Variable"

      wm minsize $itk_interior 170 0
      wm resizable $itk_interior 1 0
      
      draw
    }
    
    protected method create_buttons {} {
      add_ok_button
      add_cancel_button
    }

    protected method create_body {} {

      set top [get_body_frame]
      set parentWidgetName [$document get_variable_value ParentWidgetName]

      #Variable Name
      label $top.label_varName -text "Variable Name:"
      itk_component add variableName {
        entry $top.variableName
      } {}
      attach $itk_component(variableName) VariableName

      #Path
      label $top.label_path -text "Path:"
      itk_component add path {
        ::UI::FileChooser  $top.path -filenamevariable [$document get_variable_name PathVarDirectoryName] \
            -browsetype directory -dialogtitle "Select Directory" -path_variable_document $document 
      } {}
      attach $itk_component(path) PathVarDirectoryName

      
      pack $top.label_varName -anchor w
      pack $itk_component(variableName) -anchor w -pady 6 -fill x
      pack $top.label_path -anchor w
      pack $itk_component(path) -anchor w -pady 5 -fill x
    }

    destructor {
      catch {::grab release $itk_interior}
    }

  };#class

};#namespace
