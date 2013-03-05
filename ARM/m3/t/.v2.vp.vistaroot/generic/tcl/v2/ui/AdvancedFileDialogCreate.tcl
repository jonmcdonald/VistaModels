

namespace eval ::tk::dialog::file {
  namespace import -force ::tk::msgcat::*
}
namespace eval ::v2::ui {
  variable _path_variable_document_ 
  variable file_chooser

  proc Advanced_file_dialog_create {path_variable_document fileChooser} {
 
    variable _path_variable_document_ $path_variable_document
    variable file_chooser $fileChooser

    namespace eval ::tk::dialog::file {   

      catch {
        if {[info proc Create_orig] == ""} {
          auto_load Create
          rename Create Create_orig
          #puts "RENAME performed" 
        } else {
          #puts "RENAME not performed - Create already exists."
        }
      }
    }
    #puts "AFTER RENAME : error=$::errorInfo"
    namespace eval ::tk::dialog::file {   

      proc  Create {w class}  {
        #puts "**************CREATE================class=$class w=$w===============**************"        
        catch {
          Create_orig $w $class
          if { ![::v2::ui::IsAdvancedFileDialog $w] } {
            return;
          }
          set dataName [lindex [split $w .] end]
          #puts "dataName=$dataName"
          upvar ::tk::dialog::file::$dataName data
          


          set buttons_frame $w.f2
          set adder_frame [frame $buttons_frame.adder_frame]

#          set more_button [button $buttons_frame.more_button -text "More >"]
#          $more_button configure -command "::v2::ui::OnAdvancedCommand $w"
          ::v2::ui::CreatePathVariables $w

#           if {[string equal $class TkChooseDir]} {
#             grid forget $data(cancelBtn)
#             grid $more_button x $data(cancelBtn) -padx 4 -sticky ew
#           } else  {
#             #add packing for file here
#             grid x x $more_button -padx 8 -sticky ew
#           }
          grid $adder_frame -columnspan 5  -sticky new -padx 10          

          $data(ent) configure -validate all -validatecommand "::v2::ui::OnFileSelection $data(ent) $dataName %P"
          #directories canvas list
          upvar ::tk::$w.icons iconlist_data
          set orig_command $iconlist_data(-command)
          #puts "orig_command=$orig_command"
          set iconlist_data(-command) "$orig_command;::v2::ui::OnListFileSelection $data(ent) $dataName"
        }
        #puts "===Create error=$::errorInfo"
      }
      
    }
  }

  proc CreatePathVariables {w {forceRecreation 0}} {
    #catch is must here as the command may be called before _path_variable_document is defined
    catch {
      set adder_frame $w.f2.adder_frame
      set components [::v2::ui::path_variables_adder::PathVariablesAdder::getComponents $adder_frame]
      #puts "CreatePathVariables $w adder_frame=$adder_frame components=$components "
      if { ![winfo exists [lindex $components 0]] || $forceRecreation} {
        if {$forceRecreation} {
          foreach component $components {
            catch {destroy $component}
          }
          update idle
          grid forget $adder_frame 
          
        }
#        puts "call OpenPathVariableAdderCommand"
        variable _path_variable_document_

        if {[info exists _path_variable_document_]} {
          $_path_variable_document_  run_command OpenPathVariableAdderCommand FrameArgument $adder_frame      
          if {[winfo exists [lindex $components 0]]} {
            grid $adder_frame -columnspan 5  -sticky new -padx 10
          }
        }
      }
    }
    #puts "CreatePathVariables error=$::errorInfo"
  }

  proc OnListFileSelection {entry dataName} { 
    set selection [$entry get]
    OnFileSelection $entry $dataName $selection
  }
  proc OnFileSelection { entry dataName selection} { 
    
    if {$dataName == "__tk_filedialog"} {
      upvar ::tk::dialog::file::$dataName data
      set selection [::tk::dialog::file::JoinFile $data(selectPath) $selection] 
    }
    variable file_chooser
#    puts "Advanced_file_dialog_create: OnFileSelection : $selection"
    catch {
      $file_chooser OnFileSelection $selection
    }
#    puts "error=$::errorInfo"
    return true
  }

  proc IsAdvancedFileDialog { w } {
    if {[string first "__advanced__" $w ]==-1} {
      return 0;
    }
    return 1;
  }
}

  

