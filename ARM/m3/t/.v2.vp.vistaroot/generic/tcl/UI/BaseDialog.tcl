namespace eval ::UI {
  proc BaseDialogButton1Action {w} {
    catch {wm deiconify $w}
    catch {raise $w}
    
    set old_transient ""
    catch {set old_transient [wm transient $w]}
    set parentWindow ""
    catch {set parentWindow  [$w getParentWindow]}
    if {$parentWindow != ""} {
      catch {wm transient $w $parentWindow}
      after 100 [list catch [list wm transient $w $old_transient]]
    }
  }
}

bind BaseDialogBind <Button-1> {::UI::BaseDialogButton1Action %W}

option add *commentfont "*-arial-bold-r-normal-*-12-120-*" widgetDefault

namespace eval ::UI {
  class BaseDialog {
    inherit ::UI::SToplevel

    private variable cancel_variable_name {}
    private variable buttons_counter 0
    
    private variable parentWindow ""

    public method getParentWindow {} {
      return $parentWindow
    }

    public method get_cancel_variable_name {} {
      return $cancel_variable_name
    }
    constructor {_document args} {
      ::UI::SToplevel::constructor $_document
    } {
      set cancel_variable_name  ::v2::ui::cancel[::Utilities::createUniqueIdentifier]

      wm withdraw $itk_interior


      ### Body
      itk_component add body {
        frame $itk_interior.body
      } {}
      ### Button Box
      itk_component add buttons {
        frame $itk_interior.buttons 
      } {}

      eval itk_initialize $args

      bind $itk_interior <Return> [code $document run_command OKCommand]
      bind $itk_interior <Escape> [code $document run_command DestroyCommand]

      set parentWindow ""
      catch {set parentWindow [$document get_variable_value ParentWidgetName]}
      if {$parentWindow==""} {
        catch {set parentWindow [$document get_variable_value CurrentTopWindowWidgetName]}
      }

      ::bindtags $itk_interior [concat [list BaseDialogBind] [bindtags $itk_interior]]

    }

    destructor {
      set $cancel_variable_name 1
      after 1 [list unset $cancel_variable_name]
    }
 
#####################################################################
    protected method create_body {} {
      puts "pure virtual"
    }
    
    protected method set_geometry {} {
      if {$parentWindow == "" || [winfo exist $parentWindow] == 0} {
        return
      }

      scan [winfo geometry $parentWindow] "%*dx%*d+%d+%d" parentX parentY 
      wm geometry $itk_interior +[expr $parentX + 30]+[expr $parentY + 30]
    }

    protected method draw {} {
      set_geometry
      update idle
      
      #change packing order to prevent disappearing of buttons box
      pack $itk_component(buttons) -side bottom -anchor center -padx 5 -pady 5 
      pack $itk_component(body) -padx 5 -pady 5 -side top -anchor nw -fill both -expand 1
      catch {focus $itk_component(buttons).b0}
    }
    
    protected method create_explanation {text {iconName ""}} {
      ### text
      if {$text != "" || $iconName != ""} {
        set top [frame $itk_interior.comment] 
        pack $itk_interior.comment -fill x -anchor nw -padx 10
        
        if {$iconName != ""} {
          label $top.icon -image [::UI::getimage $iconName]
          pack $top.icon -pady 10 -side left -anchor w
        }
        if {$text != ""} {
          itk_component add comment {
            label $top.lb -text $text
          } {
            rename -font -commentfont commentfont Commentfont
          }
          pack $top.lb -pady 10 -side left -anchor w
        }
       
        ### separator
        frame $itk_interior.sep -height 2 -relief sunken -bd 1
        pack $itk_interior.sep -anchor w -fill x -padx 10
      }
    }
    

    protected method get_body_frame {} { return $itk_component(body) }

    ## list - list of label and variable value pairs: example -  "Code Coverage" code
    protected method create_choices {list choiceVariableTag {label ""} side} {
      if {$list != {} } {
        itk_component add choices {
          frame $itk_component(body).choices
        }
        if {$label != ""} {
          itk_component add label_choices {
            label $itk_component(choices).lb -text $label
          } {
            rename -font -headerfont headerfont Headerfont
          }
          pack $itk_component(choices).lb -side left -padx 5
        }
        foreach {label value} $list {
          set name [string tolower $label]
          radiobutton $itk_component(choices).$name -text $label -value $value \
              -highlightthickness 0
          attach $itk_component(choices).$name $choiceVariableTag
          set pad padx
          if {$side == "top"} {
            set pad pady
          }
          pack $itk_component(choices).$name -side $side -$pad 5
        }
      } 
      pack $itk_component(choices) -anchor c -pady 10 
    }

    protected method create_buttons {} {
      add_ok_button
      add_common_buttons
    }
    
    protected method add_ok_button { {text "OK"} } { 
      add_button OKCommand -text $text -width 5 -underline 0 
    }    
    
    protected method add_cancel_button {} { 
      add_button DestroyCommand -text "Cancel" -width 5 -underline 0 
    }    
    
    protected method add_help_button {} { 
      add_button HelpCommand -text "Help" -width 5 -underline 0
      bind $itk_interior <F1> [code $document run_command HelpCommand]
    }
    
    protected method add_common_buttons {} {
      add_cancel_button
      add_help_button
    }
    ## add button to ButtonBox
    protected method add_button {commandTag args} {
      set command_index [lsearch -exact $args "-command"]
      if {$commandTag == "" && $command_index == -1} {
        error "Either commandTag or -command option must be defined" 
      }
      if {$commandTag != "" && $command_index > -1 } {
        error "CommandTag and -command option  cannot be used together"
      }
      
      set button [eval button $itk_component(buttons).b$buttons_counter \
                      -highlightbackground [$itk_component(buttons) cget -background] $args]
      incr buttons_counter
      pack $button -padx 5 -side left

      if {$commandTag != ""} {
        attach $button $commandTag
      }

      set underline_index [lsearch -exact $args "-underline"]
      set text_index [lsearch -exact $args "-text"]
      if {$underline_index > -1 && $text_index > -1} {
        incr underline_index
        incr text_index
        set bind_letter [lindex $args $underline_index]
        set text [lindex $args $text_index]
        set letter [string index $text $bind_letter]
        if {$letter != ""} {
          set letterUp [string toupper $letter]
          set letterDw [string tolower $letter]

          bind $itk_interior <Alt-$letterUp> [code $button invoke]
          bind $itk_interior <Alt-$letterDw> [code $button invoke]
        }
      }
      return $button
    }

    
    protected method add_state_trace {choiceVariableTag} {
      ::UI::auto_trace_with_init variable [$document get_variable_name $choiceVariableTag] \
          w $itk_interior [::itcl::code $this change_state_value $choiceVariableTag ]
    }

    private method change_state_value {args} {
      eval change_state $args
    }
    protected method change_state {args} ;# pure virtual

    protected method set_title {text} {
      configure -title $text
    }
    
##########################
### methods for listbox
##########################
    protected method create_listbox {topWidget componentName {listVariable ""} \
                                         {selectListVariable ""}} {
      itk_component add $componentName {
        UI::BwidgetListbox $topWidget.$componentName 
      } {
        keep -background
      }

      if {$listVariable != "" && $selectListVariable != ""} {
        attach $itk_component($componentName) $listVariable $selectListVariable
      }
    
      $itk_component($componentName) configure -height 4 -highlightthickness 0 \
          -deltay 20 -borderwidth 0 -relief flat
    }
    ### end of methods for listbox   
  } ;# BaseDialog

  proc get_dialog {classname parentDocID} {
    set document [objectNew Document::Document [build[set classname]Document $parentDocID]]
    [[namespace current]::$classname .\#auto $document] show
  }
}
