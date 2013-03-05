namespace eval ::v2::ui {
  catch {delete class LibraryManagerDialog}
  catch {delete class LibraryManagerDialogMenu}
  catch {delete class LibraryManagerDialogToolbar}
  catch {delete class ::UI::v2/ui/LibraryManagerDialogMenu/DocumentLinker}

  
  class LibraryManagerDialogMenu {
    inherit ::UI::FrameMenu
    constructor {_document args} {
      ::UI::FrameMenu::constructor $_document
    } {
      eval itk_initialize $args
      configure -height 30
      fill_menu
    }
    
    destructor {
    }


    private method fill_menu {} {
      fill_file_menu
#      fill_edit_menu
      fill_help_menu
    }

    private method fill_file_menu {} {
      set topMenu [createHeaderMenu "File"]
      add_menu_item $topMenu DestroyCommand command -label "Close" -underline 1 
    }

    private method fill_edit_menu {} {
      set topMenu [createHeaderMenu "Edit"]

      add_menu_item $topMenu DebugCommand command -label "Undo"  -underline 0 -accelerator "Ctrl+Z"
      add_menu_item $topMenu DebugCommand command -label "Redo"  -underline 0
      addSeparator $topMenu
      add_menu_item $topMenu DebugCommand command -label "Cut"  -underline 2 -accelerator "Ctrl+X"
      add_menu_item $topMenu DebugCommand command -label "Copy"  -underline 0 -accelerator "Ctrl+C"
      add_menu_item $topMenu DebugCommand command -label "Paste"  -underline 0 -accelerator "Ctrl+V"
      addSeparator $topMenu
      #add_menu_item $topMenu SelectAllCommand command -label "Select All"  -underline 0  -accelerator "Ctrl+A"
      add_menu_item $topMenu DebugCommand command -label "Clear"  -underline 4
    }


    protected method fill_help_menu {} {
      set topMenu [createHeaderMenu "Help" 1]
      add_menu_item $topMenu HelpCommand command -label "Help Topics..." -underline 0
      add_menu_item $topMenu AboutCommand command -label "About [set ::env(THIS_PRODUCT_NAME)]..." -underline 0
    }
  }



  namespace eval ::UI {
    ::itcl::class v2/ui/LibraryManagerDialogMenu/DocumentLinker {
      inherit DataDocumentLinker
    }
    
    v2/ui/LibraryManagerDialogMenu/DocumentLinker v2/ui/LibraryManagerDialogMenu/DocumentLinkerObject
  }


  class LibraryManagerDialogToolbar {
    inherit ::UI::Toolbar
    
    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30
    
      ### Buttons
      
      fill_toolbar
      eval itk_initialize $args

    }
    private method fill_toolbar {} {
      create_left
    }
    private method create_left {} {
      set sepCounter 1
      set buttons [frame [get_frame].buts -bg $itk_option(-background)]
      addButton $buttons validate   "validate"   ValidateCommand  "Validate"
      addButton $buttons delete  "delete"  DeleteSelectedRowsCommand  "Delete Selected Lines"
      addButton $buttons refresh "refresh" ResetDataCommand  "Reset Data"
      addSeparator $buttons sep[incr sepCounter]
      pack_left $buttons validate delete refresh
      pack $buttons -side top -anchor w
    }

  }



  class LibraryManagerDialog {
    inherit ::UI::BaseDialog
    private variable textFrame
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      
      create_body

      create_buttons
      eval itk_initialize $args
      set_title "Library Manager"
      draw
    }
    protected method set_geometry {} {
      wm minsize $itk_interior 350 350
      set geometry [format "%sx%s+%s+%s" \
                        [expr round([winfo vrootwidth $itk_interior]*0.7)]\
                        [expr round([winfo vrootheight $itk_interior]*0.7)]\
                        [expr  [winfo vrootx $itk_interior] + round([winfo vrootwidth $itk_interior]*0.15)]\
                        [expr  [winfo vrooty $itk_interior] + round([winfo vrootheight $itk_interior]*0.15)]]
      wm geometry $itk_interior $geometry
    }
    protected method create_buttons {} {
      add_button "" -text "OK" -width 5 -underline 0 -command [code $this SettingOKCommand]
      add_button "" -text "Apply" -width 5 -underline 0 -command [code $this SettingApplyCommand]
      add_common_buttons
    }

    public method setNiceLimit {} {
      set length [llength [array names [$document get_variable_name LibraryManagerTable]]]
      catch {$itk_component(libraries_table).table configure -rows [expr (100 + $length)/100 * 100]}
    }

    public method deleteSelectedRows {} {
      setNiceLimit
      $itk_component(libraries_table) deleteSelectedRows
      $itk_component(libraries_table).table configure -rows 100
    }

    public method SettingOKCommand {} {
      saveActiveData
      $document run_command OKCommand
    }
    
    public method SettingApplyCommand {} {
      saveActiveData
      $document run_command ApplyCommand
    }
    
    public method saveActiveData {} {
      $itk_component(libraries_table) saveactivedata
      update idle
    }
    
    public method CancelCommand {} {
      $document run_command DestroyCommand
    }
    
    protected method create_body {} {
      set top [get_body_frame]

      itk_component add menu {
        ::v2::ui::LibraryManagerDialogMenu $itk_interior.menu $document 
      } {}
      itk_component add toolbar {
        ::v2::ui::LibraryManagerDialogToolbar $itk_interior.toolbar $document 
      } {}
      $itk_component(menu) show
      pack $itk_component(menu) -side top -fill x -anchor nw 
      $itk_component(toolbar) show
      pack $itk_component(toolbar) -side top -fill x -anchor nw 

      itk_component add table { 
        frame $top.table
      } { }
      itk_component add libraries_table {
        tixTable $itk_component(table).table \
            -cols 3  -titlerows 1 -xscroll no
      } {}

      pack $itk_component(libraries_table) -fill both -expand 1
      itk_component add library_name {
        entry  $itk_component(table).library_name \
            -textvariable [namespace current]::library_name_var -bd 1 -bg white -takefocus 0
      } {}
      itk_component add library_path {
        ::UI::FileChooser $itk_component(table).library_path___advanced___  \
            -filenamevariable [namespace current]::library_path_var \
            -browsetype directory_advanced -path_variable_document $document  -dialogtitle "Select Directory" \
            -takefocus 0
        
      } {}
      itk_component add delete_selected_row {
        button $itk_component(table).delete -text "delete" -command [list $itk_component(libraries_table) deleteSelectedRows] \
            -takefocus 0
      } {}

      #    attach  $itk_component(library_path) DirectoryName
      $itk_component(libraries_table) window 0 $itk_component(library_name) 1 $itk_component(library_path)
      
      attach $itk_component(libraries_table) LibraryManagerTable
      
      #configuring for predefined path variables
      
      set titleRow [$itk_component(libraries_table).table cget -roworigin]
#      $itk_component(libraries_table).table configure -rowstretch fill
      $itk_component(libraries_table).table configure -rows 100

      $itk_component(libraries_table).table set $titleRow,0 "Logical Name"
      $itk_component(libraries_table).table set $titleRow,1 "Physical Path"


      set textFrame [get_body_frame].textFrame
      frame $textFrame 
      set text [text $textFrame.text -height 5 -bg white -fg red]
      attach $text LastErrorText
      $text configure -state disabled
      scrollbar $textFrame.scroll -command "$textFrame.text yview"
      $textFrame.text configure -yscrollcommand "$textFrame.scroll set"

#      pack $text -fill both -expand y
      pack $textFrame -fill both -expand y -side bottom
      ::UI::auto_trace_with_init variable [$document get_variable_name LastErrorText] \
          w $itk_interior [::itcl::code $this on_error_message]
      pack $itk_component(table) -fill both -expand 1 -side top
      setNiceLimit
    }

    private method on_error_message {args} {
      set errors [$document get_variable_value LastErrorText]
      if {$errors != ""} {
        pack $textFrame.text -fill both -expand y -side left
        pack $textFrame.scroll -side left -fill y 
      } else {
        pack forget $textFrame.scroll
        pack forget $textFrame.text
        $textFrame configure -height 1
      }
    }

    
  }
}


