if {[is_cygwin] || [is_mingw]} {
  option add *Hiertable.ResizeCursor size_we 100
  option add *TreeView.ResizeCursor size_we 100
}

namespace eval ::UI {
  class TreeTableBase {
    inherit ::UI::SWidget

    ::UI::ADD_VARIABLE selectedNodeIDs SelectedNodeIDs ""
    
    itk_option define -treebackground treeBackground TreeBackground white
    public variable withtooltip 0 {
      if {$withtooltip} {
        create_tooltip
      }
    }
    
    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {

      construct_variable selectedNodeIDs

      #create table view
      create_table_view $itk_interior
      create_horizontal_scrollbar

      eval itk_initialize $args
      
      create_popup_menu
      
      set_binding

      set [$document get_variable_name TreeTableWidget] $itk_interior 
    }

    destructor {
      TRY_EVAL { destruct_variable selectedNodeIDs }
      if {$withtooltip} {
        catch {after cancel $show_tooltip_request}
        catch { destroy $itk_component(tooltip) }
      }
    }
    
    public method focus_in {component} {
      if {[info exists itk_component($component)] && [winfo exists $itk_component($component)] && \
              [winfo manager $itk_component($component)] != "" && ([focus] != $itk_component($component))} {
        catch {focus $itk_component($component)}
      }
    }

    private method create_table_view {frame} {
      itk_component add table {
        blt::hiertable $frame.table \
            -borderwidth 2 -highlightthickness 0 -relief sunken \
            -selectcommand [code $this on_selection] \
            -separator "." -height 0 -width 0 \
            -opencommand [code $this on_opennode %\#] \
            -closecommand [code $this on_closenode %\#] \
            -selectmode multiple
      } {
        keep -tree -font -foreground -background
        rename -selectbackground -selectbackground selectbackground Selectbackground
        rename -selectforeground -selectforeground selectforeground Selectforeground 
      }
      
      $itk_component(table) column configure treeView -background white
      $itk_component(table) button configure -background white
    }

    private method create_horizontal_scrollbar {} {
            ### Horizontal scrolling
      itk_component add hscroll {
        scrollbar $itk_interior.hsb -orient horizontal -width 12 -highlightthickness 0 -takefocus 0 \
            -command [code $itk_component(table) xview]
      }
      $itk_component(table) configure -xscrollcommand [code $itk_component(hscroll) set] 
      
      grid $itk_component(table) -column 1 -row 1 -sticky nesw
      grid $itk_component(hscroll) -column 1 -row 2 -sticky ew
      grid columnconfigure $itk_interior 1 -weight 1
      grid rowconfigure $itk_interior 1 -weight 1
      grid rowconfigure $itk_interior 2 -weight 0
    }

    protected method on_selection {} {
      set currentIdxs [$itk_component(table) curselection]
      set indexCurrent [$itk_component(table) index current]
      #puts "currentIdxs=$currentIdxs indexCurrent=$indexCurrent"
      #fix backward/forward problem
      if {$currentIdxs == "" && $indexCurrent == ""} { 
        TRY_EVAL { configure -selectedNodeIDs $currentIdxs } ;# with no recording
        return 
      }
      if {$currentIdxs == "" && $indexCurrent != ""} {
        set currentIdxs $indexCurrent
      }
      ::Document::enableRecording
      TRY_EVAL { configure -selectedNodeIDs $currentIdxs }
      ::Document::disableRecording
    }

    private method on_opennode {node} {
      if {![info exists itk_component(table)] || ![winfo exists $itk_component(table)]} {
        return
      }
      TRY_EVAL {
        set current $node 
        if { $node == ""} {
          set current [$itk_component(table) index current]
        }
        set tree [$itk_component(table) cget -tree]
        if {[info commands $tree] == ""} {
          return
        }
        
#        if {[$tree children $current] != {} || \
#                [$itk_component(table) entry cget $current -button] == "auto"} {
#          return
#        }

        if {[$itk_component(table) entry cget $current -button] == "auto"} {
          return
        }
   
        $document run_command OpenNodeCommand NodeArgument $current
      }
    }

    private method on_closenode {node} {
      if {![info exists itk_component(table)] || ![winfo exists $itk_component(table)]} {
        return
      }
      TRY_EVAL {
        set current $node 
        if { $node == ""} {
          set current [$itk_component(table) index current]
        }
        set tree [$itk_component(table) cget -tree]
        if {[info commands $tree] == ""} {
          return
        }
        $document run_command CloseNodeCommand NodeArgument $current
      }
    }

    protected method create_popup_menu {} {}
    
    protected method create_tooltip {} {
      itk_component add tooltip {
        toplevel $itk_interior.tooltip -bd 1 -bg black
      }
      wm overrideredirect $itk_component(tooltip) 1
      pack [label $itk_component(tooltip).label -bg lightyellow -fg black -justify left]
      
      wm withdraw $itk_interior.tooltip

      $itk_component(table) bind Entry <Enter> "+[code $this request_show_tooltip %x %y %X %Y]"
      $itk_component(table) bind Entry <Leave> "+[code $this hide_tooltip]"
      bind $itk_component(table) <FocusOut> "+[code $this hide_tooltip]"
    }

    protected method on_double_click {} {
      TRY_EVAL {
        set current [$itk_component(table) index current]
        
        if {[$itk_component(table) entry cget $current -button] == 1 && \
                [$itk_component(table) entry isopen $current] == 0} {
          $itk_component(table) open $current
        }
      }
      TRY_EVAL {
        $document run_command OpenSelectionCommand Args [list ChooseMoreApropriate]
      }
    }
    
    public method on_RMB {} {
      set currentIdxs [$itk_component(table) curselection]
      set resetSelection 1

      if {[llength $currentIdxs] >1} {
        set current_index [$itk_component(table) index current]

        if {[lsearch $currentIdxs $current_index] != -1 } {
          set resetSelection 0
        }
      } 

      if { $resetSelection} {
        $itk_component(table) selection clearall
        $itk_component(table) selection set current
        #update is must here;otherwise popup menu is called for wrong kind
        update
      }
      
      if {[$itk_component(table) curselection] > 0 \
              && [info exists itk_component(popup_menu)]} {
        $itk_component(popup_menu) update_menu 
        $itk_component(popup_menu) raise [winfo pointerx .] [winfo pointery .]
      }
    }
    
    # virtual method - redefine in derived class if needed 
    protected method set_binding {} {
      
      $itk_component(table) bind Entry <Enter> +[code $this update_statusbar %x %y]
      $itk_component(table) bind Entry <Motion> [code $this update_statusbar %x %y]
      $itk_component(table) bind Entry <Leave> +[code $this update_statusbar %x %y]
           
      $itk_component(table) bind Entry <Double-1> [code $this on_double_click]
      $itk_component(table) bind Entry <B1-Motion> [code $this update_statusbar %x %y]
      
      #this is in order to prevent Autoscroll !!!
      $itk_component(table) bind  Entry <B1-Leave> "break;"
      #bind   $itk_component(table) <B1-Leave> "break;"
      
      $itk_component(table) bind Entry <3> "[code $this on_RMB]"
      
      bind $itk_component(table) <Leave> [code $this update_statusbar %x %y]
      bind $itk_interior <Leave> [code $this update_statusbar %x %y]

      ::Widgets::disable_hiertable_autoscroll
      ::Widgets::fix_hiertable_keybindings
      ::Widgets::fix_hiertable_binding_bug $itk_component(table)

      bind $itk_interior <FocusIn> [code $this focus_in $itk_component(table)]
    }
    
    protected method key_is_exist {key index} {
      if {$key == "" || $index == ""} {
        return 0
      }
      
      set tree [$itk_component(table) cget -tree]
      if {[$tree index $index] == -1} {
        return 0
      }
     
      foreach {key_source value} [$tree get $index] {
        if {$key_source == $key} {
          return 1
        }
      }
      return 0
    }

    protected method find_tag {index tag varname {find_in_parent 1}} {
      if {$index != -1} {
        set tree [$itk_component(table) cget -tree]
        if {$tree != ""} {
          if {[key_is_exist $tag $index]} {
            set [$document get_variable_name $varname] [$tree get $index $tag]
          } elseif {$find_in_parent} {
            set parent_index [$tree parent $index]
            find_tag $parent_index $tag $varname $find_in_parent
          }
        }
      }
    }

    protected method set_variable_by_tabletag {tabletag varname} {
      TRY_EVAL {
        set cur_sel [$document get_variable_value CurrentSelection]
        if {$tabletag == "Line"} {
          set [$document get_variable_name $varname] 0
        } else {
          set [$document get_variable_name $varname] ""
        }
        
        if {$cur_sel == "" || ([llength $cur_sel] != 1 && $tabletag != "Kind")} { 
          return
        }
        
        set nodeID [lindex $cur_sel 0]
        set index [$itk_component(table) index $nodeID]
        if {$index == ""} {
          return
        }
        set find_in_parent 1
        if {$tabletag  == "Kind"} {
          set find_in_parent 0
        }
        find_tag $index $tabletag $varname $find_in_parent
      }
    }
    
    protected method set_boolean_variable_by_tabletag {tabletag varname} {
      set cur_sel [$document get_variable_value CurrentSelection]
      if {$cur_sel == "" || [llength $cur_sel] != 1} { 
        set [$document get_variable_name $varname] 0
        return
      }

      set [$document get_variable_name $varname] 0
      set tree [$itk_component(table) cget -tree]
      set index [$tree find 0 -exact [lindex $cur_sel 0] -path]
      find_tag $index $tabletag $varname
    }
    
    private method update_statusbar {x y} {
      catch {
        set main_frame [winfo toplevel $itk_interior]
        if { $main_frame == ""} {
          return
        }
        
        if {[lsearch [$main_frame component] statusBar] == -1} {
          return
        }
        
        set statusbar [$main_frame component statusBar]
        if {$statusbar == "" || ![winfo exists $statusbar]} {
          return
        }
        
        set status_label [$statusbar component status_label]
        if {$status_label == "" || ![winfo exists $status_label]} {
          return
        }

        $status_label configure -text [get_show_data $x $y]
      }
    }
    
    protected method get_show_data {pos_x pos_y} {

      if {![string is digit -strict $pos_x] || \
              ![string is digit -strict $pos_y]} {
        return ""
      }
        
      scan [split [winfo geometry $itk_component(table)] "x+"] "%d %d %d %d" \
          table_width table_height table_x table_y

      set max_x [expr $table_x + $table_width - [$itk_component(table) cget -bd]]
      set max_y [expr $table_y + $table_height - [$itk_component(table) cget -bd]]
      if {($pos_x > $max_x) || ($pos_y > $max_y)} {
        return ""
      }
        
      set index [$itk_component(table) nearest $pos_x $pos_y]
      if {$index == "" || $index < 1} {
        return ""
      }
      
      # text
      set text [$itk_component(table) entry cget $index -label]
      if {$text == ""} {
        set text [$itk_component(table) get $index]
        if {$text == ""} {
          return ""
        }
      }
      return [regsub -all {[\r]} [regsub -all {[\n]} [join $text] {\n}] {\r}]
    }
    
    private variable show_tooltip_request ""
    private method request_show_tooltip {entryX entryY positionX positionY} {
      catch {after cancel $show_tooltip_request}
      set show_tooltip_request [after 1000 [code $this show_tooltip $entryX $entryY $positionX $positionY]]
    }

    private method show_tooltip {entryX entryY positionX positionY}
    private method hide_tooltip {} {
      catch {after cancel $show_tooltip_request}
      if {[winfo viewable $itk_interior.tooltip] == 0} {
        return
      }
      wm withdraw $itk_interior.tooltip
    }
  }
}

body ::UI::TreeTableBase::show_tooltip {entryX entryY positionX positionY} {
  catch {
    set entry [$itk_component(table) nearest $entryX $entryY]
    if {[key_is_exist Tooltip $entry] == 0} {
      return
    }
    $itk_component(tooltip).label configure -text [[$itk_component(table) cget -tree] get $entry Tooltip]
    
    set width [winfo reqwidth $itk_component(tooltip).label]
    set height [winfo reqheight $itk_component(tooltip).label]
    
    wm geometry $itk_component(tooltip) \
        [format "%sx%s+%s+%s" $width $height [expr $positionX + 5] [expr $positionY + 5]]
    
    wm deiconify $itk_component(tooltip)
    raise $itk_component(tooltip)
  }
}


configbody ::UI::TreeTableBase::treebackground {
  if {[info exists itk_component(table)]} {
    $itk_component(table) column configure treeView \
        -background $itk_option(-treebackground)
  }
}

body ::UI::TreeTableBase::check_new_value/selectedNodeIDs { nodeIDs} {
  if {$nodeIDs != {}} {
    foreach nodeID $nodeIDs {
      set index [$itk_component(table) index $nodeID]
      if {$index == ""} {
        error "There is no node with ID=$nodeID"
      }
    }
  }
}

body ::UI::TreeTableBase::update_gui/selectedNodeIDs {} {
  set old_cur_indexs [$itk_component(table) curselection]
  
  if {$selectedNodeIDs == {} } {
    if {$old_cur_indexs != {}} {
      $itk_component(table) selection clearall
    }
    return
  }
  
  set tree [$itk_component(table) cget -tree]
  
  foreach nodeID $selectedNodeIDs {
    set index [$itk_component(table) index $nodeID]
    if {$index == ""} {
      continue
    }
    set found_idx [lsearch $old_cur_indexs $index]
    if {$found_idx == -1} {
      $itk_component(table) selection set $index
      $itk_component(table) see $index
    } else {
      set old_cur_indexs [lreplace $old_cur_indexs $found_idx $found_idx]
    }
  }
  
  foreach old_cur_idx $old_cur_indexs {
    $itk_component(table) selection clear $old_cur_idx
  }
  if {[llength $selectedNodeIDs] == 1} {
    $itk_component(table) focus $selectedNodeIDs
  }
}

namespace eval ::UI {
  ::itcl::class UI/TreeTableBase/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document SelectedNodeIDs} {
      $widget configure \
          -selectedNodeIDsvariable [$document get_variable_name $SelectedNodeIDs]
    }
  }

  UI/TreeTableBase/DocumentLinker UI/TreeTableBase/DocumentLinkerObject
}
