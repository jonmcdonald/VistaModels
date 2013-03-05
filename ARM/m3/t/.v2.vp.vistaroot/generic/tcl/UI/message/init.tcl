summit_begin_package UI:message

namespace eval ::UI {

  class Message {
    common applicationExit "Do you really want to exit?"
    
    proc okMessage {args} {
      tk_messageBox -icon info -message [eval concat $args] -type ok
    }

    proc libraryGeneratedMessage {} {
      okMessage "Library generated successfully."
    }

    proc notExistFile {{text ""}} {
      set message [concat "Couldn't open \n \"$text\" :\n" " no such file"]
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }
    
    proc errorMessage {args} {
      tk_messageBox -icon error -message [eval concat $args] -type ok -title "Error"
    }
    proc warningMessage {args} {
      tk_messageBox -icon warning -message [eval concat $args] -type ok -title "Warning"
    }
    proc errorInfoMessage {args {token "\n"} } {
      
      set ind [string first $token $::errorInfo]
      if {$ind!=-1} {
        append args [string range  $::errorInfo 0 [expr $ind -1]] "."
      } 
      
      UI::Message::errorMessage $args
    }

    proc okCancelErrorMessage {args} {
      return [::UI::Message::okcancel [eval concat $args] "error" "cancel"]
    }
    
    proc wantToExit {} {
      return [::UI::Message::okcancel "Do you really want to exit?"]
    }
    proc okcancel {message {icon "question"} {default "ok"}} {
      set res [tk_messageBox -icon $icon -message $message -type okcancel -title "Question" -default $default ]
      if {$res == "ok"} {
        return 1
      }
      return 0
    }

    proc yesnocancel {message {icon "question"} {default "yes"}} {
      return [tk_messageBox -icon $icon -message $message -type yesnocancel -title "Question" -default $default ]
    }

    proc yesno {message {icon "question"} {default "yes"}} {
      return [tk_messageBox -icon $icon -message $message -type yesno -title "Question" -default $default ]
    }

    proc yesno_all_script {w varname args} {
      tk_messageBox_append_buttons $w $varname yesall {-text "Yes to All"} \
          noall {-text "No to all"} cancel {-text "Cancel"}
    }

    proc yesno_all_cancel {message {icon "question"} {default "yes"}} {
      return [tk_messageBox -icon $icon -message $message -type yesno -title "Question" \
                  -default $default -script ::UI::Message::yesno_all_script]
    }

    proc notExistVariable {varname} {
      set message "There is no $varname variable"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc fileIsADirectory {file} {
      set message "Cannot procede: $file is a directory"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc directoryDoesNotExist {file} {
      set message "Cannot procede: directory $file does not exist"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc fileIsARegularFile {file} {
      set message "Cannot procede: $file is a regular file"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc fileIsNotAnExecutable {file} {
      set message "Cannot procede: $file is not an executable"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc couldNotRemoveFile {file} {
      set message "Cannot procede: could not remove $file"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc couldNotCreateDirectory {file} {
      set message "Cannot procede: could not create directory $file"
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc simulationAlreadyExists {simulationDirectory} {
      set message "You already have simulation opened with simulaton directory $simulationDirectory.\nPlease close it first."
      tk_messageBox -icon error -message $message -type ok -title "Error"
    }

    proc overrideFileQuestion {file} {
      if {[file isdirectory $file]} {
        set type "Directory"
      } else {
        set type "File"
      }
      set message "$type \"$file\" already exists.\nDo you want to overwrite it ?"
      set res [tk_messageBox -icon question -message $message -type yesno -title "Question"]
      if {$res == "yes"} {
        return 1
      }
      return 0
    }
  }
}

summit_end_package
