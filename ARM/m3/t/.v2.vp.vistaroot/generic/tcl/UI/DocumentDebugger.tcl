namespace eval ::UI {

  class ChangingProcess {
    inherit ::Utilities::NativeListener
    private variable elementConfiguration
    private variable transactionStarted 0
    private variable addedToModel 0

    public method registerChange {document tag label} {
      if {!$addedToModel} {
        set addedToModel 1
        ::Document::replayEnabledModel addListener $this
      }
      if {!$transactionStarted} {
        set transactionStarted 1
        revert
      }
      elementChanged $label
    }
    
    public method ON_REPLAY_ENABLED {model data} {
      set transactionStarted 0
    }

    private method revert {} {
      foreach label [array names elementConfiguration] {
        catch {revertElement $label}
      }
      if {[info exists elementConfiguration]} {
        unset elementConfiguration
      }
    }

    private method elementChanged {label} {
      if {![info exists elementConfiguration($label)]} {
        set elementConfiguration($label) [$label cget -background]
      }
      # For blinking
      $label config -background $elementConfiguration($label)
      after 100 [list catch [list $label config -background red]]
    }

    private method revertElement {label} {
      $label config -background $elementConfiguration($label)
      unset elementConfiguration($label)
    }
  }

  ChangingProcess changingProcessObject


  class DocumentDebugger {
    inherit itk::Toplevel ::UI::DocumentOwner
    constructor {docID args} {
      set _document [objectNew ::Document::Document $docID]
      ::UI::DocumentOwner::constructor $_document
    } {
      eval itk_initialize $args
      show_document_data $docID

      wm geometry $itk_interior 800x600
    }

    private method make_tag_usable_for_tcl {tag} {
      regsub -all -expanded :: $tag __ tag
      return $tag
    }

    private method show_document_data {docID} {
      set top $itk_interior

      itk_component add menu {
        ::UI::FrameMenu $top.menu $document
      }
      $itk_component(menu) show
      pack $itk_component(menu) -side top -anchor nw -fill x
      
      ::Widgets::ScrolledWindow $top.scrolled -auto both -scrollbar both
      pack $top.scrolled -anchor w -fill both -expand 1

      ScrollableFrame $top.scrolled.sf
      $top.scrolled setwidget $top.scrolled.sf

      set sf [$top.scrolled.sf getframe]

      label $sf.doc_id -text "Document ID: $docID Type: [::Document::getDocumentType $docID]" -fg blue
      grid $sf.doc_id -column 0 -row 0 -columnspan 2

      frame $sf.data_panel1 -bd 4 -relief raise
      frame $sf.data_panel2 -bd 4 -relief raise
      frame $sf.commands_panel1 -bd 4 -relief raise
      frame $sf.commands_panel2 -bd 4 -relief raise
      grid $sf.data_panel1 -column 0 -row 3
      grid $sf.data_panel2 -column 1 -row 3
      grid $sf.commands_panel1 -column 0 -row 4
      grid $sf.commands_panel2 -column 1 -row 4

      set numberOfModels 0
      set numberOfOwnCommands 0
      set numberOfInheritedCommands 0
      set names_list [$document get_interface_names]
      foreach tag $names_list {
        if {[$document is_model_name $tag]} {
          incr numberOfModels
        }

        if {[$document is_own_command_name $tag]} {
          incr numberOfOwnCommands
        }
        if {[$document is_inherited_command_name $tag]} {
          incr numberOfInheritedCommands
        }
      }

      set splitAfter [expr {($numberOfModels + 3) / 2}]
      set lineCounter 0
      set widget $sf.data_panel1

      pack [label $widget.own_data_l -text "Own Data:" -fg red]
      incr lineCounter
      foreach tag $names_list {
        if {[$document is_own_model_name $tag]} {
          set f $widget.data_[make_tag_usable_for_tcl $tag]
          pack [frame $f] -fill x -expand yes
          pack [label $f.l -text $tag] -side left
          #puts "Creating ::UI::FlushEntry $f.e"
          pack [::UI::FlushEntry $f.e] -side right
          catch {
            attach $f.e $tag
            ::UI::auto_trace variable [$document get_variable_name $tag] w $f [list ::UI::DocumentDebugger::blink_on_change $document $tag $f.l]
          }
          incr lineCounter
          if {$lineCounter >= $splitAfter} {
            set widget $sf.data_panel2
            set lineCounter -10
            pack [label $widget.own_data_l -text "More Own Data:" -fg red]
            incr lineCounter
          }
        }
      }
      pack [label $widget.inherited_data_l -text "Inherited Data:" -fg red]
      incr lineCounter
      foreach tag $names_list {
        if {[$document is_inherited_model_name $tag]} {
          set f $widget.data_[make_tag_usable_for_tcl $tag]
          pack [frame $f] -fill x -expand yes
          pack [label $f.l -text $tag] -side left
          #puts "Creating ::UI::FlushEntry $f.e"
          pack [::UI::FlushEntry $f.e] -side right
          catch {
            attach $f.e $tag
            ::UI::auto_trace variable [$document get_variable_name $tag] w $f [list ::UI::DocumentDebugger::blink_on_change $document $tag $f.l]
          }
          incr lineCounter
          if {$lineCounter >= $splitAfter} {
            set widget $sf.data_panel2
            set lineCounter -10
            pack [label $widget.inherited_data_l2 -text "More Inherited Data:" -fg red]
            incr lineCounter
          }
        }
      }

      set all_doc_list [::Document::getDocumentIDs]
      set inherited_doc_list [$document get_inherited_document_ids]

      set menu_inhdocs [$itk_interior.menu createHeaderMenu "Inherited Documents"]
      foreach id $inherited_doc_list {
        $menu_inhdocs insert end command -label  "Doc $id: [::Document::getDocumentType $id]" \
            -command "::UI::run_document_debugger $id"
      }

      set menu_docs [$itk_interior.menu createHeaderMenu "Other Documents"]
      foreach id $all_doc_list {
        if {[lsearch $inherited_doc_list $id] == -1} {
          $menu_docs insert end command -label  "Doc $id: [::Document::getDocumentType $id]" \
              -command "::UI::run_document_debugger $id"
        }
      }

      if {$numberOfOwnCommands > 0} {
        set menu_own [$itk_interior.menu createHeaderMenu "Own Commands"]
        if {$numberOfOwnCommands > 10} {
          set menu_own2 [$itk_interior.menu createHeaderMenu "More Own Commands"]
          set counter 0
        }
        foreach tag $names_list {
          if {[$document is_own_command_name $tag]} {
            if {$numberOfOwnCommands > 10} {
              incr counter
              if {[expr {$counter < $numberOfOwnCommands / 2}]} {
                add_menu_item $menu_own $tag command -label $tag
              } else {
                add_menu_item $menu_own2 $tag command -label $tag
              }
            } else {
              add_menu_item $menu_own $tag command -label $tag
            }
          }
        }
      }

      if {$numberOfInheritedCommands > 0} {
        set menu_inherited [$itk_interior.menu createHeaderMenu "Inherited Commands"]
        if {$numberOfInheritedCommands > 10} {
          set menu_inherited2 [$itk_interior.menu createHeaderMenu "More Inherited Commands"]
          set counter 0
        }
        foreach tag $names_list {
          if {[$document is_inherited_command_name $tag]} {
            if {$numberOfInheritedCommands > 10} {
              incr counter
              if {[expr {$counter < $numberOfInheritedCommands / 2}]} {
                add_menu_item $menu_inherited $tag command -label $tag
              } else {
                add_menu_item $menu_inherited2 $tag command -label $tag
              }
            } else {
              add_menu_item $menu_inherited $tag command -label $tag
            }
          }
        }
      }
    }

    proc blink_on_change {document tag label widget variable_name args} {
      ::UI::changingProcessObject registerChange $document $tag $label
#      catch {
#        set old_background [$label cget -background]
#
#        $label config -bg red
#        after 1000 [list catch [list $label config -background $old_background]]
#      }
    }
    
  }


  proc run_document_debugger {docID} {
    if {[catch {
      set w .documentDebugger_$docID
      if {[winfo exists $w]} {
        ::raise $w
      } else {
        return [::UI::DocumentDebugger $w $docID]
      }
    }]} {
      puts $::errorInfo
    }
  }
  proc run_all_document_debuggers {} {
    foreach docID [::Document::get_document_ids] {
      run_document_debugger $docID
    }
  }
}
