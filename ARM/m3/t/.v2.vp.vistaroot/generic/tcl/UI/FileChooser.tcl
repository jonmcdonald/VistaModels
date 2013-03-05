namespace eval ::UI {
  usual ::UI::FileChooser {
  }
  
  class FileChooser {
    inherit itk::Widget 
    public variable openFileViaBrowserPostHook {}
    #changing this variable will cause changing directory on the fly
    public variable buttoncmdtype savefile ; # savefile openfile
    public variable dialogtitle "Select File"
    public variable filetypes {{"All Files" "*"}} ;# {{{Design} {.dgn}}}
    public variable browsetype "any";#show all files or only directories or advanced mode, may be "any" or "directory" or "directory_advanced" or "file_advanced"
    public variable mustexist 1 ;#directory must exist or not
    public variable initialdir "" ;#initial directory
    public variable path_variable_document ;#document for advanced mode (for path variables adder)
    public variable isOnFileSelectionDisabled 0
    public variable with_multiple_select 0

    ::UI::ADD_VARIABLE directory DirectoryName ;#the value of the initial directory

    constructor {args} {
      construct_variable directory
      frame $itk_interior.fr -relief sunken -bd 1
      
      ### entry
      itk_component add entry {
          entry $itk_interior.fr.ent -highlightthickness 1 -relief sunken -background white -bd 1 \
              -disabledbackground \#bfbfbf
      } {
        keep -state -takefocus
        rename -background -entrybackground entrybackground Background
        rename -textvariable -filenamevariable filenamevariable Filenamevariable
      }
      configure -entrybackground white

      ### button
      itk_component add button {
        button $itk_interior.fr.dots -image [::UI::getimage dots] -bd 1 -highlightthickness 1 \
            -command [code $this OpenFileDialog]
      } {
        keep -state -takefocus
      }
      
      eval itk_initialize $args
      
      pack $itk_component(button) -side right -anchor ne
      pack $itk_component(entry) -side left -fill x -expand 1 -anchor nw
      pack $itk_interior.fr -fill x -anchor nw
    }

    destructor {
      destruct_variable  directory
    }
    public method get_entry { } {
      return $itk_component(entry)
    }
    public method insert {index text} {
      $itk_component(entry) insert $index $text
    }
    private method DefineInitialPath {} {
      set dir $initialdir
      if {$dir == ""} {
        set dir [$itk_component(entry) get]
      }
      if {$path_variable_document != ""} {
        catch {
          $path_variable_document run_command {DocumentTypePathVariablesAdder SubstitutePathVariablesCommand} PathArg $dir
          set dir [$path_variable_document get_variable_value {DocumentTypePathVariablesAdder SubstitutePathVariablesResult}]
        }
      }
      return $dir
    }
    
    public method OnFileSelection {selection} {
#      puts "isOnFileSelectionDisabled=$isOnFileSelectionDisabled selection=$selection"
      if {$isOnFileSelectionDisabled || $path_variable_document==""} { return true}
      set isOnFileSelectionDisabled 1
      catch {
        set [$path_variable_document get_variable_name {DocumentTypePathVariablesAdder FileSelectionList}] $selection
      }
#      puts "FileChooser::OnFileSelection : error=$::errorInfo"
      set isOnFileSelectionDisabled 0
      return true
    }
    
    private method OpenFileDialog {} {

      if {$browsetype == "directory_advanced" ||  $browsetype == "file_advanced"} {
        if {![::v2::ui::IsAdvancedFileDialog $itk_interior]} {
          error "Parent widget name for browsetype \"$browsetype\" should include string \"__advanced__\" :\n $itk_interior"
        } elseif { $path_variable_document==""} {
          error "Path_variable_document should be specified for browsetype $browsetype"
        } 
#        puts "this=$this"
        ::v2::ui::Advanced_file_dialog_create $path_variable_document $this
      }
      if {$browsetype == "directory" || $browsetype == "directory_advanced"} {
        set file_name [::UI::open_directory_dialog tk_chooseDirectory [DefineInitialPath] $dialogtitle $mustexist $itk_interior]
      } else {
        switch $buttoncmdtype {
          "savefile" {
            set cmdname tk_getSaveFile
          } 
          "openfile" { 
            set cmdname tk_getOpenFile
          }
          
          default {
            error "There is wrong button command name"
          }
        }
#        puts "FileChooser called: ::UI::open_file_dialog $cmdname [DefineInitialPath] $dialogtitle $filetypes $itk_interior $with_multiple_select"
        set file_name [::UI::open_file_dialog $cmdname [DefineInitialPath] $dialogtitle $filetypes $itk_interior "" $with_multiple_select]
        

      }
      if {$browsetype == "directory_advanced" ||  $browsetype == "file_advanced"} {
        catch {
          $path_variable_document run_command {DocumentTypePathVariablesAdder GetPathWithPathVariableCommand} PathArg $file_name
          set file_name [$path_variable_document get_variable_value {DocumentTypePathVariablesAdder PathWithPathVariableResult}]
        }
#        puts "FileChoser error=$::errorInfo"
      }

      if {$file_name != ""} {
        set [cget -filenamevariable] $file_name
        if {$openFileViaBrowserPostHook != ""} {
          uplevel \#0 $openFileViaBrowserPostHook [list $file_name]
        }
      }
    }
  } ;# class FileChooser
};#namespace UI

  body ::UI::FileChooser::check_new_value/directory {value} {
    return;
  }
  
  body ::UI::FileChooser::update_gui/directory {} {


    if {$directory == "" } { return }
    set isOnFileSelectionDisabled 1

    namespace eval ::tk::dialog::file {}
    #add support to file also
    catch {
      if {$browsetype == "directory" || $browsetype=="directory_advanced"} {
        set dataName __tk_choosedir
      } else {
        set dataName __tk_filedialog
      }
      if {[winfo exists $itk_interior.$dataName]} {

        upvar ::tk::dialog::file::$dataName data
        #      set data(selectPath) $directory
        if {![string equal $data(selectPath) $directory]} {
#          puts "::UI::FileChooser::update_gui/directory : directory=$directory isOnFileSelectionDisabled=$isOnFileSelectionDisabled"
          set dirname [file dirname $directory]
          set data(selectPath) $dirname
          set file [file tail $directory]
#          puts "====> ListInvoke : $itk_interior.$dataName $file"
          ::tk::dialog::file::ListInvoke $itk_interior.$dataName $file
        }
      }
    }
    set isOnFileSelectionDisabled 0
#    puts "update_gui/directory: isOnFileSelectionDisabled=$isOnFileSelectionDisabled"
  }

  namespace eval ::UI {
    ::itcl::class UI/FileChooser/DocumentLinker {
      inherit DataDocumentLinker
      protected method attach_to_data {widget document tag args} {
        
        if {[string first "DirectoryName" $tag]!=-1} {
          catch {
            set variableName [[$widget cget -path_variable_document] get_variable_name $tag]
            $widget configure -directoryvariable $variableName
          }
        } else {
          set variableName [$document get_variable_name $tag]
          $widget configure -filenamevariable $variableName
        }
      }
#      puts "error=$::errorInfo"

      
    }
    UI/FileChooser/DocumentLinker UI/FileChooser/DocumentLinkerObject
  }



