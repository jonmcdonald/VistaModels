
namespace import -force ::itcl::*

namespace eval ::v2::ui::analysis_database_dialogue {

  class AnalysisDatabaseDialogue {

    inherit ::UI::BaseDialog
    #private variable abortVariableName 
    private variable simulationDir
    private variable finishVariableName
    private variable insideAbort 0
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      #set abortVariableName [$document get_variable_value AbortVariableName]
      set simulationDir [$document get_variable_value SimulationDir]
      set finishVariableName [$document get_variable_value FinishVariableName]

      #puts "simulationDir=$simulationDir finishVariableName= $finishVariableName"
      create_body
      create_buttons

      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onDelete]

      eval itk_initialize $args
      draw
    }
    
    protected method create_body {}
    protected method create_buttons {}
    protected method set_geometry {}
    public method AbortDatabaseCreationCommand {}
    public method FinishCommand { args }
    public method onDelete {}
  } ;#class

  body AnalysisDatabaseDialogue::create_body {} {

    set main_fr [get_body_frame]
    frame $main_fr.fr  -relief sunken -bd 2 

    itk_component add msg_label {
      label $main_fr.fr.msg_label -text "Creating analysis database. Please wait."
    }

#     $itk_component add abort_button {
#       button  $main_fr.fr.abort_button -text 
#     }
    
    pack $itk_component(msg_label) -side top -anchor w -padx 5 -pady 5 -fill x
    pack $main_fr.fr -side top -anchor w -fill both -pady 5

    ::Utilities::ff_trace variable $finishVariableName w [code $this [namespace current]::FinishCommand]
    #::Utilities::ff_trace variable $finishVariableName w [itcl::code $document run_command DestroyCommand]
    
    catch {raise $itk_interior}
  }

  body AnalysisDatabaseDialogue::create_buttons {} {
    add_button "" -text "Abort" -width 5 -underline 0 -command [itcl::code $this AbortDatabaseCreationCommand]
    
#    add_common_buttons
  }


  body AnalysisDatabaseDialogue::FinishCommand { args } {
    #puts "FinishCommand $args"
    $document run_command DestroyCommand
  }

  body AnalysisDatabaseDialogue::onDelete {} {
    #do nothing
  }



  body AnalysisDatabaseDialogue::set_geometry {} {
    wm minsize $itk_interior 300 0
    wm resizable $itk_interior 1 0

    set width  [expr round([winfo screenwidth $itk_interior]*0.2)]
     set height [expr round([winfo screenheight $itk_interior]*0.2)]
     wm geometry $itk_interior \
        [format "+%s+%s" [expr  [winfo vrootx $itk_interior] + round([winfo vrootwidth $itk_interior]*0.3)]\
              [expr  [winfo vrooty $itk_interior] + round([winfo vrootheight $itk_interior]*0.3)]]
  }

  body AnalysisDatabaseDialogue::AbortDatabaseCreationCommand {} {
    #puts "AbortDatabaseCreationCommand"
    if {$insideAbort} {
      return
    }
    set response [UI::Message::okcancel "Are you sure you want to abort the analysis database creation?"]
    if {$response == "0" } {
      return
    }
    set insideAbort 1
    $itk_component(msg_label) config -text "Aborting. Please wait."
    #puts "really ABORT" 
    #incr $abortVariableName
    #puts "$abortVariableName = [set $abortVariableName]"
    catch { $document run_command AbortDatabaseCreationCommand SimulationDirArg $simulationDir}
    
    #puts "called AbortDatabaseCreationCommand, errorInfo = $::errorInfo"
  }


}
