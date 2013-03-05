
namespace eval ::v2::ui::analysis_report_dialog {

  usual ::v2::ui::analysis_report_dialog::DesignInstanceChooser {
  }

  # entry + button that opens design browser

  class DesignInstanceChooser {
    inherit itk::Widget 

    public variable parent_document
    public variable simulation_dir

    constructor {args} {
      frame $itk_interior.fr -relief sunken -bd 1

      ### entry
      itk_component add entry {
          entry $itk_interior.fr.ent -highlightthickness 1 -relief sunken -background white -bd 1 \
              -disabledbackground \#bfbfbf
      } {
        keep -state -takefocus 
        rename -background -entrybackground entrybackground Background
        rename -textvariable -instancevariable instancevariable Instancevariable
      }
      configure -entrybackground white

      ### button
      itk_component add button {
        button $itk_interior.fr.dots -image [::UI::getimage dots] -bd 1 -highlightthickness 1 \
            -command [code $this OpenDesignBrowser]
      } {
        keep -state -takefocus
      }
      
      eval itk_initialize $args
      
      pack $itk_component(button) -side right -anchor ne
      pack $itk_component(entry) -side left -fill x -expand 1 -anchor nw
      pack $itk_interior.fr -fill x -anchor nw
    }

    private method OpenDesignBrowser {} {
      if {$parent_document == ""} {
        set msg "Parent document is missing"
        tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
        return
      }
      if {$simulation_dir == "" || ![file exists $simulation_dir]} {
        set msg "Simulation directory is not valid"
        tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
        return
      }
      $parent_document run_command OpenDesignBrowserCommand WidgetNameArg $itk_interior SimulationDirectoryArg $simulation_dir
    }

    public method enable {} {
      $itk_component(entry) configure -state normal
      $itk_component(button) configure -state normal
    }

    public method disable {} {
      $itk_component(entry) configure -state disabled
      $itk_component(button) configure -state disabled
    }


  } ;# class

} ;# namespace


# linker for enrty with InstancePath doc variable

namespace eval ::UI {
  class v2/ui/analysis_report_dialog/DesignInstanceChooser/DocumentLinker {
    inherit DataDocumentLinker

    protected method attach_to_data {widget document instancePathTag} {
      $widget configure -instancevariable [$document get_variable_name $instancePathTag]
    }

  }
  v2/ui/analysis_report_dialog/DesignInstanceChooser/DocumentLinker v2/ui/analysis_report_dialog/DesignInstanceChooser/DocumentLinkerObject
}
