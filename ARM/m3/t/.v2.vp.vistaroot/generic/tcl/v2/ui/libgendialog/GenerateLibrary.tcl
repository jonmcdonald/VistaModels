
namespace eval ::v2::ui::libgendialog {
  class GenerateLibrary {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      create_body
      create_buttons
      eval itk_initialize $args

      wm minsize $itk_interior 400 320

      add_state_trace ModuleNamesSource
      add_state_trace IsTargetLibrary

      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      set target [pack_framed_topic $top.target "Target"]

      pack_subtopic [frame $target.choose]
      attach [pack_left [radiobutton $target.choose.library \
                             -text "Library" -value 1]] IsTargetLibrary
      attach [pack_left [radiobutton $target.choose.directory \
                             -text "Directory" -value 0]] IsTargetLibrary
     
      itk_component add target_library {
        ::UI::BwidgetCombobox $target.target_library -editable 0
      } {}
      attach $itk_component(target_library) TargetLibrary Libraries
 
      itk_component add target_directory {
        ::UI::FileChooser $target.directory \
            -browsetype directory \
            -dialogtitle "Select Target Directory" \
            -filenamevariable [$document get_variable_name TargetDirectory] \
          } {}
      
      attach $itk_component(target_directory) TargetDirectory

      # label $top.directives_label -text "Directives file:"
#       itk_component add directives_file_path {
#         ::UI::FileChooser $top.directives_path \
#             -filenamevariable [$document get_variable_name DirectivesFilePath] \
#             -browsetype file \
#             -buttoncmdtype openfile \
#             -dialogtitle "Select File" \
#             -filetypes {{"All Files" "*"}}
#       } {}

      set source_modules [pack_framed_topic $top.source "Source Modules" -fill both -expand 1]
      
      itk_component add modules_all {
        radiobutton $source_modules.modules_rb_all -text "All modules" -value 0 \
            -highlightthickness 1 -highlightbackground [cget -background]
      } {}
      attach $itk_component(modules_all) ModuleNamesSource
      
      itk_component add modules_file {
        radiobutton $source_modules.modules_rb_file -text "Load modules names from file" -value 2 \
            -highlightthickness 1 -highlightbackground [cget -background]
      } {}
      attach $itk_component(modules_file) ModuleNamesSource
      
      itk_component add modules_file_path {
        ::UI::FileChooser $source_modules.modules_file_path \
            -buttoncmdtype openfile \
            -filetypes {{"All Files" "*"}} \
            -filenamevariable [$document get_variable_name ModuleNamesFile] \
            -browsetype file \
            -dialogtitle "Select File"
      } {}

      itk_component add modules_list {
        radiobutton $source_modules.modules_rb_list -text "Select modules from list" -value 1 \
            -highlightthickness 1 -highlightbackground [cget -background]
      } {}
      attach $itk_component(modules_list) ModuleNamesSource

      create_listbox $source_modules modules_listbox AllModuleNames SelectedModuleNames

      pack $itk_component(modules_all)       -anchor nw -padx 5 -pady 5
      #pack $itk_component(modules_file)      -anchor nw -padx 5 -pady 5
      #pack $itk_component(modules_file_path) -anchor nw -padx 5 -pady 5 -fill x
      pack $itk_component(modules_list)      -anchor nw -padx 5 -pady 5
      pack $itk_component(modules_listbox)   -anchor nw -padx 5 -pady 5 -fill both -expand 1 
    }
    
    private method change_state {args} {
      set variable_name [lindex $args 0]
      if {$variable_name == "ModuleNamesSource"} {
        set moduleNamesSource [$document get_variable_value ModuleNamesSource]
        switch $moduleNamesSource {
          0 {
            $itk_component(modules_listbox) configure -state disabled
            $itk_component(modules_file_path) configure -state disabled
          }
          1 {
            $itk_component(modules_listbox) configure -state normal
            $itk_component(modules_file_path) configure -state disabled
          }
          2 {
            $itk_component(modules_listbox) configure -state disabled
            $itk_component(modules_file_path) configure -state normal
          }
        }
      } else {
        # IsTargetLibrary
        if {[$document get_variable_value IsTargetLibrary]} {
          pack forget $itk_component(target_directory) 
          pack $itk_component(target_library) -side top -padx 5 -pady 5 -fill x
        } else {
          pack forget $itk_component(target_library)
          pack $itk_component(target_directory) -side top -padx 5 -pady 5 -fill x
        }
      }
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
