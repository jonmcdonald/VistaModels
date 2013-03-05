namespace eval ::v2::ui::workwindow {
  class WorkWindow {
    inherit ::UI::SWidget

    private variable current_pane ""
    private variable console_object ""
    private variable emacs_compilation ""
    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args
      $document set_variable_value WidgetName $itk_interior

      # create top Pane Container
      itk_component add pane_hor {
        ::UI::PaneContainer $itk_interior.pane_hor $document -orient horizontal -isselected 1 \
            -withsashbitmap 0
      } { }
      pack $itk_component(pane_hor) -side top -fill both -expand 1 -anchor nw
      
      # create components
      create_components
      
      ::UI::auto_trace_with_init variable [$document get_variable_name CurrentPane] \
          w $itk_interior [code $this change_current_pane]
      
    }

    destructor {
      if {$console_object != ""} {
        catch {objectDelete $console_object}
      }
      foreach name [component] {
        catch {
          if {[find objects $itk_component($name)] != {}} {
            delete object $itk_component($name)
          }
        }
      }
      
    }
    
    public method accept_console_output {output} {
      catch {
        $console_object ConsoleOutput stdout $output
      }
    }

    public method show_pane {pane} {
      [get_parent_pane $pane] show $pane
    }

    public method hide_pane {pane} {
      [get_parent_pane $pane] hide $pane
    }

    public method placeof {packed_pane unpacked_pane} {
      set packed_pane_parent [get_parent_pane $packed_pane]
      set unpacked_pane_parent [get_parent_pane $unpacked_pane]
      if {$packed_pane_parent != $unpacked_pane_parent} {
        return
      }
      $packed_pane_parent placeof $packed_pane $unpacked_pane
    } 
    

    public method restore_tree_view {} {
      catch {
        $itk_component(pane_ver) restorePane tree
      }
    }
    
    public method update_title {} {
      catch {
        set current_pane_name [$document get_variable_value CurrentPane]
        set current_pane_widget ""
        
        if {$current_pane_name == "tree"} {
          set current_pane_widget [$itk_component(pane_ver) component tree] 
        } elseif {$current_pane_name == "texts"} {
          set current_pane_widget [$itk_component(pane_ver) component texts]
        } elseif {$current_pane_name == "compilation"} {
          set current_pane_widget [$itk_component(pane_hor) component compilation]
        } elseif {$current_pane_name == "mbconsole"} {
          set current_pane_widget [$itk_component(pane_hor) component mbconsole]
        }

        set title_text "Mentor Graphics"
        if {$current_pane_widget != ""} {
          set titlevariable [$current_pane_widget cget -titlevariable]

          if { $titlevariable !="" && [info exists titlevariable] && [set $titlevariable] != ""} {
            set title_text [set $titlevariable]
          }
        }
        $document set_variable_value Title $title_text
      }
    }

    public method focus_in {pane} {
      switch $pane {
        "tree" {
          $itk_component(tree) focus_in table
        }
        "texts" {
          if {[focus] != $itk_component(texts)} {
            focus $itk_component(texts)
          }
        }
        "compilation" {
          if {[focus] != $itk_component(compilation)} {
            focus $itk_component(compilation)
          }
        }
        "mbconsole" {
          if {[focus] != $itk_component(mbconsole)} {
            focus $itk_component(mbconsole)
          }
        }
      }
    }

    public method get_component_document_ID {component} {
      return [$itk_component($component) get_document_ID]
    }

    public method on_toplevel_click {clicked_widget} {
      if {![::UI::is_parent_of $itk_interior $clicked_widget]} {
        return
      }
      set clicked_pane ""
      if {[::UI::is_parent_of $itk_component(pane_tree) $clicked_widget]} {
        set clicked_pane "tree"
      }
      if {[::UI::is_parent_of $itk_component(pane_texts) $clicked_widget]} {
        set clicked_pane "texts"
      }
      if {[::UI::is_parent_of $itk_component(pane_compilation) $clicked_widget]} {
        set clicked_pane "compilation"
      }
      if {[::UI::is_parent_of $itk_component(pane_mbconsole) $clicked_widget]} {
        set clicked_pane "mbconsole"
      }
      if {[::UI::is_parent_of $itk_component(pane_filtering) $clicked_widget]} {
        set clicked_pane "tree"
      }
      if {$clicked_pane != ""} {
        $document set_variable_value CurrentPane $clicked_pane
      }
    }

    private method create_components {} {
      set itk_component(pane_ver) \
          [$itk_component(pane_hor) add container top \
               -minimum 0  -orient vertical -withsashbitmap 0]
      
      set itk_component(pane_compilation) \
          [$itk_component(pane_hor) add pane compilation -minimum 50 -thickness 240 -withtoolbar 1 \
               -showInCreate [$document get_variable_value ShowCompilationView]]
      
      attach [$itk_component(pane_hor) component compilation] ShowCompilationView

      if {[$document get_variable_value HasMBConsole]} {
        set itk_component(pane_mbconsole) \
            [$itk_component(pane_hor) add pane mbconsole -minimum 50 -thickness 240 -withtoolbar 1 \
                 -showInCreate [$document get_variable_value ShowMBConsoleView]]
        
        attach [$itk_component(pane_hor) component mbconsole] ShowMBConsoleView
      }
      
      create_tree_view
      create_compilation_view
      if {[$document get_variable_value HasMBConsole]} {
        create_mbconsole_view
      }
      create_textual_view 
      create_filtering_view
    }

    private method create_tree_view {} {
      # projects/design/code view
      set itk_component(pane_tree) \
          [$itk_component(pane_ver) add pane tree  -minimum 150 -thickness 180 -withtoolbar 1 \
               -titlevariable [$document \
                               get_variable_name {DocumentTypeProjectsTree PaneLabelText}]  \
               -toolbarheight 18 \
               -showInCreate [$document get_variable_value ShowTreeView]]
      attach [$itk_component(pane_ver) component tree] ShowTreeView
      
      # fill tree pane toolbar
      fill_tree_view_toolbar

      # create tree view
      itk_component add tree {
        ::v2::ui::projects::ProjectsTree [$itk_component(pane_ver) childsite tree].tree \
            [$document create_tcl_sub_document DocumentTypeProjectsTree]
      } {}
      
      ::UI::set_widget_actual_parent $itk_component(tree) [$itk_component(pane_ver) childsite tree]
      
      pack $itk_component(tree) \
          -fill both -anchor nw -side left -expand 1 
    }
    
    private method create_compilation_view {} {
      set has_vista_console [$document get_variable_value HasConsole]
      set compilation_frame [$itk_component(pane_hor) childsite compilation].compilation
      if {$has_vista_console} {
        itk_component add compilation {
          ::UI::Notebook $compilation_frame $document
        }
        set tabs_component [$itk_component(compilation) component tabs]
        $tabs_component configure -side bottom
        set emacs_compilation $tabs_component.emacs_compilation
        attach $itk_component(compilation) CurrentCompilationTab
        
        set console_frame [$itk_component(compilation) add_custom_tab [list frame $tabs_component.console] console "Vista Console"]
        set console_object [::UI::console::create_console $console_frame $::mgc_vista_api_interpreter]
        $console_object configure -ExpandCustomnameProc [list ::v2::papoulis::exec_papoulis ::vfs::expand_vfs_path]

        $itk_component(compilation) add_custom_tab [list ::v2::emacs::component::new_compile_frame $emacs_compilation] emacs_compilation "Compile Output"

        pack $tabs_component -side top -fill both -expand 1 -anchor nw

      } else {
        itk_component add compilation {
          ::v2::emacs::component::new_compile_frame $compilation_frame
        }
        set emacs_compilation $itk_component(compilation)
      }

      bind $itk_component(compilation) <FocusIn> "+[code $this compilation_in_focus]"
        # vladimir: please do not change relief and borderwidth.
        # for emacs frame
#        $itk_component(compilation) configure -relief flat -borderwidth 0
        $emacs_compilation configure -relief flat -borderwidth 0

      pack $itk_component(compilation) -fill both -anchor nw -expand 1

      $document set_variable_value CompileFrame $emacs_compilation
    }

    private method create_mbconsole_view {} {
      itk_component add mbconsole {
        set console_frame [frame [$itk_component(pane_hor) childsite mbconsole].mbconsole -border 4]
#        set console_object [::UI::console::create_console $console_frame $::mgc_vista_api_interpreter]
#        catch {
#          $console_object configure -ExpandCustomnameProc [list ::v2::papoulis::exec_papoulis ::vfs::expand_vfs_path]
#        }
        set console_frame
      }
      bind $itk_component(mbconsole) <FocusIn> "+[code $this mbconsole_in_focus]"
      # vladimir: please do not change relief and borderwidth.
      # for emacs frame
      $itk_component(mbconsole) configure -relief flat -borderwidth 0 -bg white
      
      pack $itk_component(mbconsole) -fill both -anchor nw -expand 1

#      $document set_variable_value MBConsoleFrame $itk_component(mbconsole)
    }

    private method compilation_in_focus {} {
      $document set_variable_value CurrentPane compilation
    }

    private method mbconsole_in_focus {} {
      $document set_variable_value CurrentPane mbconsole
    }

    
    private method create_textual_view {} {
      set itk_component(pane_texts) \
          [$itk_component(pane_ver) add pane texts -minimum 100 -withtoolbar 1 \
               -toolbarheight 18 \
               -showInCreate [$document get_variable_value ShowTextualView]]
      attach [$itk_component(pane_ver) component texts] ShowTextualView
      fill_text_view_toolbar
      itk_component add texts {
        ::v2::emacs::component::new_file_frame [$itk_component(pane_ver) childsite texts].texts $emacs_compilation
      }
      bind $itk_component(texts) <FocusIn> "+[code $this texts_in_focus]"
      # vladimir: please do not change relief and borderwidth.
      # for emacs frame
      $itk_component(texts) configure -relief flat -borderwidth 0
      pack $itk_component(texts) -fill both -anchor nw -expand 1

      $document set_variable_value FileFrame $itk_component(texts)
    }

    private method create_filtering_view {} {
      set itk_component(pane_filtering) \
          [$itk_component(pane_ver) add pane filtering -withtoolbar 1 -minimum 350 \
               -showInCreate [$document get_variable_value ShowFilteringView]]
      attach [$itk_component(pane_ver) component filtering] ShowFilteringView
      itk_component add filtering {
        ::v2::ui::filterdialog::FilterDialog [$itk_component(pane_ver) childsite filtering].fltr \
            [$document create_tcl_sub_document {DocumentTypeProjectsTree DocumentTypeFiltering}]
      } {}
      
      pack $itk_component(filtering) -fill both -anchor nw -expand 1
    } 

    private method texts_in_focus {} {
      $document set_variable_value CurrentPane texts
    }

    private method get_parent_pane {tag} {
      set parent_pane pane_ver
      switch $tag {
        "compilation" {
          set parent_pane pane_hor
        }
        "mbconsole" {
          set parent_pane pane_hor
        }
      }
      return $itk_component($parent_pane)
    }

    private method fill_text_view_toolbar {} {
      
      set toolbar [$itk_component(pane_ver) component texts toolbar]
      set buttons [$toolbar get_frame]
      $toolbar addButton $buttons open "open"  EmacsOpenFileCommand "Open"
      $toolbar addButton $buttons save "saveu" EmacsSaveBufferCommand "Save" 
      $toolbar addButton $buttons print "print" EmacsPrintBufferCommand "Print Text File";#PrintFileCommand
      $toolbar addSeparator $buttons sep_files
      $toolbar pack_left $buttons open save print sep_files

      # standart edit commands
      $toolbar addButton $buttons cut   "cut"   CutOrCopyCommand   "Cut" IsCutID 1
      $toolbar addButton $buttons copy  "copy"  CutOrCopyCommand  "Copy" IsCutID 0;
      $toolbar addButton $buttons paste "paste" PasteCommand "Paste";
      $toolbar addSeparator $buttons sep3
      $toolbar pack_left $buttons cut copy paste sep3

      $toolbar addButton $buttons emacsmenu "toggle_emacs_menu" EmacsToggleMenuBarCommand "Toggle XEmacs Menu";
      $toolbar addSeparator $buttons sep_emacs
      $toolbar pack_left $buttons emacsmenu sep_emacs

      if {[info exists ::env(VISTA_EXTERNAL_EDITOR)] && $::env(VISTA_EXTERNAL_EDITOR) != ""} {
        $toolbar addButton $buttons externaleditor "externaleditor" EmacsInvokeExternalEditorCommand "Invoke External Editor";
        $toolbar addSeparator $buttons sep_ext
        $toolbar pack_left $buttons externaleditor sep_ext
      }


      $toolbar addButton $buttons undo "undo" EmacsUndoCommand "Undo" ;
      $toolbar addButton $buttons redo "redo" EmacsRedoCommand "Redo";
      $toolbar addSeparator $buttons sep4
      $toolbar pack_left $buttons undo redo sep4
      
      #Small help should be changed according to the current layout to the opposit layout name
      
      # searching
      $toolbar addButton $buttons find "find" EmacsFindCommand  Find IsFindNext 0;
      #$toolbar addButton $buttons find_in_tree "find_in_tree" ""  "Find In Tree";#FindInTreeCommand
      
      $toolbar addButton $buttons findnext "find_next"  "EmacsFindCommand" "Find Next" IsFindNext 1;
      #      $toolbar addButton $buttons replace "find_replace"  OpenReplaceDialog "Replace";
#      $toolbar addButton $buttons replace "find_replace"  EmacsReplaceCommand "Replace";
      $toolbar addSeparator $buttons sep6
      $toolbar pack_left $buttons find findnext sep6 
    } 

    private method fill_tree_view_toolbar {} {
      set toolbar [$itk_component(pane_ver) component tree toolbar]
        # back and forward

      $toolbar addButtonWithMenuButton [$toolbar get_frame] back "back" BackCommand "Back" \
          "::v2::ui::projects::BackButtonMenu" BackArrowCommand
      
      $toolbar addButtonWithMenuButton [$toolbar get_frame] forward  "forward" ForwardCommand \
          "Forward" "::v2::ui::projects::ForwardButtonMenu" ForwardArrowCommand
      

      $toolbar addSeparator [$toolbar get_frame] sep_bf


      $toolbar addButton [$toolbar get_frame] project_view "project_view" \
          {DocumentTypeProjectsTree ProjectTreeViewCommand} "Full View"
      $toolbar addButton [$toolbar get_frame] design_view "design_view" \
          {DocumentTypeProjectsTree DesignTreeViewCommand} "Design View"
      $toolbar addButton [$toolbar get_frame] code_view "code_view" \
          {DocumentTypeProjectsTree CodeTreeViewCommand} "Code View"
      
      $toolbar addSeparator [$toolbar get_frame] sep1
      $toolbar addCheckButton [$toolbar get_frame] filter "filter" \
          0 {DocumentTypeProjectsTree ShowFilteringView} "Options Pane"
      
      $toolbar pack_left [$toolbar get_frame] back forward sep_bf sep_bf project_view design_view code_view sep1 filter
    }

    public method change_current_pane {args} {
      set new_current_pane [$document get_variable_value CurrentPane]

      if {[lsearch {"tree" "texts" "compilation" "mbconsole"} $new_current_pane] == -1} {
        $document set_variable_value CurrentPane $current_pane
        return
      }
      if {$new_current_pane == $current_pane} {
        return
      }

      if {$new_current_pane == "tree" } {
        $document set_variable_value ShowTreeView 1
      }

      if {$new_current_pane == "texts" } {
        $document set_variable_value ShowTextualView 1
      }
      
      if {$new_current_pane == "compilation" } {
        $document set_variable_value ShowCompilationView 1
      }

      if {$new_current_pane == "mbconsole" } {
        $document set_variable_value ShowMBConsoleView 1
      }
      
      if {$current_pane != ""} {
        [get_parent_pane $current_pane] unselectPane $current_pane
      }
      set current_pane $new_current_pane
      if {$current_pane != ""} {
        [get_parent_pane $current_pane] selectPane $current_pane
      }
      
      focus_in $current_pane
      update_title
    }
  }
}

