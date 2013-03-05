
namespace eval ::v2::ui::path_variables_adder {
  class PathVariablesAdder {
    inherit ::UI::SWidget 

    public variable frame {}
    private variable addCreateButton 1

    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args
      create_body $frame
    }

    public method postInit {_document args} {}

    proc getComponents {frame} {
      return  [winfo children $frame]
    }

    protected method create_body {frame} {

      catch {
        #if path variables adder is opened from path variables table don't add "Create Path Variable" button
        if {[info exists ::v2::ui::projectdialog::ProjectSetting::path_variables_frame_name ] && \
                [string first $::v2::ui::projectdialog::ProjectSetting::path_variables_frame_name $frame]!=-1} {
          set addCreateButton 0
        }
        
        set top $frame
        set [$document get_variable_name WidgetName] $itk_interior
        
        #Use Path Variable
        itk_component add top_frame {
          frame $top.top_frame
        } {}

        itk_component add usePathVars {
        radiobutton $itk_component(top_frame).usePathVars -text "Use Path Variable" -value 1 \
            -command "$this OnUsePathVariables" -width 15 -anchor nw
        } {}
        attach $itk_component(usePathVars) IsUsePathVariables   

        itk_component add pathVariablesCombo {
          ::UI::BwidgetCombobox  $itk_component(top_frame).pathVariablesCombo -editable 0
        } {}
        attach $itk_component(pathVariablesCombo) UsedPathVariable PathVariablesList

        pack $itk_component(usePathVars) -side left -anchor nw
        pack $itk_component(pathVariablesCombo) -side left -anchor nw -fill x -expand 1
        
        #Use Full Path
        itk_component add bottom_frame {
          frame $top.bottom_frame
        } {}

        itk_component add useFullPath {
          radiobutton $itk_component(bottom_frame).useFullPath  -text "Use Full Path" -value 0 \
              -command "$this OffUsePathVariables" -width 15 -anchor nw
        } {}
        attach $itk_component(useFullPath) IsUsePathVariables

        if {$addCreateButton} {
          itk_component add createButton {
            button $itk_component(bottom_frame).createButton -text "Create Path Variable" -bd 2 \
                -command "$this CreateCommand $frame" -width 20
          } {}
        }

        pack $itk_component(useFullPath) -side left -anchor nw
        if {$addCreateButton} {
          pack $itk_component(createButton) -side right -anchor ne
        }
        pack $itk_component(top_frame) -side top -anchor nw  -pady 5 -fill x 
        pack $itk_component(bottom_frame)  -side top -anchor nw -fill x -expand 1
        
      }
    }

    public method CreateCommand {frame} {
      set withChooser 1
      if {[::v2::ui::IsAdvancedFileDialog $frame]} {
        set withChooser 0
      }
      $document run_command OpenCreatePathVariableDialogCommand HasBrowseDirectoryArg $withChooser
    }

    public method OnUsePathVariables {} {
      $itk_component(pathVariablesCombo) configure -state normal
      if {$addCreateButton} {
        $itk_component(createButton) configure -state normal
      }
    }

    public method OffUsePathVariables {} {
      $itk_component(pathVariablesCombo) configure -state disabled
      if {$addCreateButton} {
        $itk_component(createButton) configure -state disabled
      }
    }
    
  };#class

};#namespace
