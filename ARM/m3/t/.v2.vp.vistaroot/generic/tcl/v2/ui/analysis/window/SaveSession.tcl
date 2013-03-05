
namespace eval ::v2::ui::analysis::window {

  class SaveSession {
    inherit ::UI::BaseDialog

    private variable analysis_win

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set analysis_win [$document get_variable_value ParentAnalysisWindow]
      create_body
      create_buttons
      eval itk_initialize $args
      set_title [$document get_variable_value Title]
      wm minsize $itk_interior 300 0
      wm resizable $itk_interior 1 0
      draw
    }

    private method create_body {}
    private method create_buttons {}
    private method click_action {}
    private method target_directory_changed {args}

  } ;# class


  body SaveSession::create_body {} {
    set main_fr [get_body_frame]
    
    label $main_fr.l_dir -text "Target directory:"
    label $main_fr.l_name -text "Analysis session name:"

    itk_component add traget_directory {
        ::UI::FileChooser $main_fr.chooser -browsetype directory -dialogtitle "Select Target Directory" -takefocus 0 \
          -filenamevariable [$document get_variable_name TargetSaveDirectory] ;#-initialdir $simDir
      } {}

    ::UI::auto_trace_with_init variable [$document get_variable_name TargetSaveDirectory] \
        w $itk_interior [code $this target_directory_changed]
    #trace variable target_save_dir w [itcl::code $this target_directory_changed]

    itk_component add session_name {
      entry $main_fr.session_name
    } {}
    attach $itk_component(session_name) SessionName

    grid $main_fr.l_dir      -row 0 -column 0 -sticky nw -padx 10 -pady 10
    grid $itk_component(traget_directory) -row 0 -column 1 -sticky ew -padx 10 -pady 10
    grid $main_fr.l_name     -row 1 -column 0 -sticky nw -padx 10 -pady 10
    grid $itk_component(session_name) -row 1 -column 1 -sticky ew -padx 10 -pady 10
    
    grid rowconfig $main_fr 0 -weight 1
    grid columnconfig $main_fr 1 -weight 1

    pack $main_fr -side top -padx 10 -pady 5 -fill x
  }

  body SaveSession::create_buttons {} {
    set ok_button [add_ok_button]
    $ok_button configure -command [code $this click_action] ;#-borderwidth 1 -relief solid
    add_cancel_button
  }

  body SaveSession::click_action {} {
    
    set target [$document get_variable_value TargetSaveDirectory]
    set session_name [$document get_variable_value SessionName]
    if {$target == ""} {
      set msg "Please specify target directory"
      tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
      return
    }

    if {[file isdirectory $target] == 0} {
      set msg "$target is not a directory"
      tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
      return
    }

    if {[file writable $target] == 0} {
      set msg "$target is write protected"
      tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
      return
    }

    if {$session_name == ""} {
      set msg "Please specify analysis session name"
      tk_messageBox -parent $itk_interior -title "ERROR"\
                      -type ok -message $msg
      return
    }

    set save_dir [file join $target [set session_name].ans]
    if {[file exist $save_dir] == 1 } {
      regsub %s "Analysis session %s already exist \n Do you want to overwrite it ?" $session_name msg
      set answer [tk_messageBox -parent $itk_interior -title "Overwrite Confirmation" \
                      -type yesno -icon question -message $msg]
      if {$answer == "no"} {
        return
      }
    }

    $analysis_win saveSession $target $session_name
    $document run_command DestroyCommand
  }

  body SaveSession::target_directory_changed {args} {
    set target_save_dir [$document get_variable_value TargetSaveDirectory]
    set target_tail [file tail $target_save_dir]
    if {[string match "*.ans" $target_tail]} {
      $document set_variable_value TargetSaveDirectory [file dirname $target_save_dir]
      $document set_variable_value SessionName [lindex [split $target_tail '.'] 0]
    }
  }

} ;# namespace
