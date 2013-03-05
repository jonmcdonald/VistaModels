# tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault

namespace eval ::UI {

  usual Toolbar {}
  class Toolbar {
    inherit itk::Widget ::UI::DocumentUIBuilder
    
    itk_option define -font font Font ""
    itk_option define -foreground foreground Foreground black
    itk_option define -buttonheight buttonHeight ButtonHeight 18
    
    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      itk_component add frame {
        frame $itk_interior.f -relief raised -borderwidth 1 -padx 1
      } {
        keep -height -takefocus
        rename -background -framebackground frameBackground FrameBackground
      }
      configure -framebackground [cget -background]
      eval itk_initialize $args
    }
    
    public method fillToolbar {} {} ;# virtual method
    
    public method show {} {
      pack $itk_component(frame) -fill x -expand 1 -anchor nw
    }
    
    public method pack_left {parent args} {
      foreach name $args {
        pack $parent.$name -side left -anchor w
      }
    }

    public method pack_right {parent args} {
      foreach name $args {
        pack $parent.$name -side right -anchor e
      }
    }
    
    public method addButton {parent name {imgnameOrTag ""} {commandTag ""} {helpText ""} {args ""} } {
      set widget $parent.$name
      itk_component add button_$name {
        Button  $widget\
            -relief link -helptext $helpText \
            -padx 0 -pady 0 -highlightthickness 0 -width [cget -buttonheight]
      } {
        keep -background -foreground -font -takefocus 
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }
      if {[string first ":tag:" $imgnameOrTag] != -1} {
        ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag
      } else {
        set image [::UI::getimage $imgnameOrTag 0]
        if {$image != ""} {
          $widget configure -image $image
        } else {
          $widget configure -text $imgnameOrTag -width 0 -height 0 -padx 1 -pady 1
        }
      }
      if {$commandTag != ""} {
          eval [list attach $widget $commandTag] $args
      }
      return $widget
    }

    public method addArrowWithMenuToButton {parent name buttonMenuClass helpText {arrowCommandTag ""} args} {
      
      set widget $parent.$name
      set button $parent.$name.$name


      itk_component add menu_button_$name {
        Button $widget.menu_button -image [::UI::getimage arrow]\
            -relief link -helptext $helpText \
            -padx 0 -pady 0 -highlightthickness 0 -width 0
      } {
        keep -background -foreground -font -takefocus 
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }

      set menu_button $widget.menu_button
      
      set menu_document $document
      if {$arrowCommandTag != ""} {
        eval [list attach $menu_button $arrowCommandTag] $args
        if {[llength $arrowCommandTag] > 1} {
          set menu_document [$document create_tcl_sub_document [lindex $arrowCommandTag 0]]
          if {$menu_document == {}} {
            set menu_document $document
          }
        }
      }
      
      itk_component add popup_menu_$name {
        $buttonMenuClass $widget.popup_menu $menu_document
      }
      $menu_button configure \
          -command [code $this raise_menu $itk_component(popup_menu_$name) \
                        $itk_component(menu_button_$name)] 

      #binding
      bind $menu_button <Enter> +[ code $this set_relief $button  raised]
      bind $menu_button <Leave> +[ code $this set_relief $button  link]

      bind $button <Enter>  +[ code $this set_relief $menu_button raised]
      bind $button <Leave>  +[ code $this set_relief $menu_button link]

      pack $menu_button -side left -fill y

    }


    public method addButtonWithMenuButton {parent name {imgnameOrTag ""} {commandTag ""} {helpText ""} \
                                               {buttonMenuClass ""} {arrowCommandTag ""} {args}} {
      set widget $parent.$name

      frame $widget -highlightthickness 0 -bd 0 -takefocus 0
      #button
      set button [ eval [list addButton $widget $name $imgnameOrTag $commandTag $helpText] $args]

      # menu button
      pack $button -side left
      
      if {$buttonMenuClass != ""} {
        eval [list addArrowWithMenuToButton $parent $name $buttonMenuClass $helpText $arrowCommandTag] $args
      }
      return $button
    }

    public method addCheckButton {parent name {imgnameOrTag ""} {valuedata 1} {variableTag ""} {helpTextOn ""} {helpTextOff ""}} {
      set widget $parent.$name
      itk_component add checkbutton_$name {
        ::UI::BwidgetCheckButton $widget \
            -relief link -helptextOn $helpTextOn -helptextOff $helpTextOff \
            -padx 1 -pady 1 -highlightthickness 0 -width [cget -buttonheight] -valuedata $valuedata
      } {
        keep -background -foreground -font -takefocus
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }
      if {$variableTag != ""} {
        attach $widget $variableTag
      }
      ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag

      return $widget
    }

    public method addBwidgetRadioButton {parent name {imgnameOrTag ""} {value ""} {variableTag ""} \
                                      {commandTag ""} {helpText ""}} {
      set widget $parent.$name
      itk_component add radiobutton_$name {
        ::UI::BwidgetRadioButton $widget \
            -relief link -helptext $helpText \
            -padx 1 -pady 1 -highlightthickness 0 -width [cget -buttonheight] -value $value
      } {
        keep -background -foreground -font -takefocus
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight     
      }
      attach $widget $variableTag $commandTag
      ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag
      return $widget
    }

    public method addRadioButton {parent name {imgnameOrTag ""} {value ""} {variableTag ""} \
                                      {helpText ""}} {
      set widget $parent.$name
      itk_component add radiobutton_$name {
        radiobutton $widget -image [::UI::getimage $imgnameOrTag] \
            -padx 1 -pady 1 -highlightthickness 0 -width [cget -buttonheight] -value $value
      } {
        keep -background -foreground -font -takefocus
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight     
      }
      attach $widget $variableTag
      ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag
      return $widget
    }

    public method addToggleRadioButton {parent name {imgnameOrTag ""} {value ""} {variableTag ""} \
                                      {commandTag ""} {helpText ""}} {
      set widget $parent.$name
      itk_component add radiobutton_$name {
        ::UI::BwidgetToggleRadioButton $widget \
            -relief link -helptext $helpText \
            -padx 1 -pady 1 -highlightthickness 0 -width [cget -buttonheight] -value $value
      } {
        keep -background -foreground -font -takefocus
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }
      attach $widget $variableTag $commandTag
      ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag
      
      return $widget
    }
    
    public method addVariableButton {parent name {imgnameOrTag ""} {helpText ""} {variableTag ""} } {
      set widget $parent.$name
      itk_component add variablebutton_$name {
        ::UI::BwidgetVariableButton $widget \
            -relief link -helptext $helpText \
            -padx 1 -pady 1 -highlightthickness 0 -width [cget -buttonheight]
      } {
        keep -background -foreground -font -takefocus
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }
      if {$variableTag != ""} {
        attach $widget $variableTag
      }
       ::UI::Button/DocumentLinkerObject attach_button_image_to_data $widget $document $imgnameOrTag
     
      return $widget 
    }

    public method addCommandMenuButton {parent name {imgnameOrTag ""} {commandTag ""} \
                                            {helpText ""} {commandList ""} {args ""}} {
      
      set widget $parent.$name
      frame $widget -highlightthickness 0 -bd 0 -takefocus 0

      set button [ eval [list addButton $widget $name $imgnameOrTag $commandTag $helpText] $args]
      itk_component add popup_command_menu_$name {
        ::UI::CommandMenuButton $widget.$name.popup_command_menu $document
      }
      if {$commandList != ""} {
        attach [$itk_component(popup_command_menu_$name) component menu] $commandList
      }
      pack $button -side left
    }

    public method addSeparator {parent name } {
      set widget $parent.$name
      itk_component add separator_$name {
        frame $widget -bd 1 -width 2  -relief sunken -height [expr $itk_option(-buttonheight) + 4] \
            -takefocus 0
      }
      return $widget
    }

    public method addHorizontalSeparator {parent name} {
      set widget $parent.$name
      itk_component add hor_separator_$name {
        frame $widget -bd 1 -width 30 -relief sunken -height 2 -takefocus 0
      }
    }
    
    public method revertVariableValue {varName} {
      upvar $varName variableName
      set $varName [expr ! $variableName]
    }
    
    public method get_frame {} {
      return $itk_component(frame)
    }  

    protected method GetFont {} { return $itk_option(-font) }
    
    private method set_relief { widget relief} {
      catch {
        if {[$widget cget -state] == "normal"} {
          $widget configure -relief $relief
        } else {
          $widget configure -relief link
        }
        
      }
    }

    protected method raise_menu {popup_menu_widget menu_button} {
      scan [split [winfo geometry $menu_button] "x+"] "%*d %d" height
      set menu_x [winfo rootx $menu_button]
      set menu_y [expr [winfo rooty $menu_button] + $height]
      $popup_menu_widget update_menu
      $popup_menu_widget raise $menu_x $menu_y
    }

    public method raise_command_list {button_name} {
      raise_menu $itk_component(popup_command_menu_$button_name) $itk_component(button_$button_name)
    }
  }
  
  usual CommandMenuButton {}


  class CommandMenuButton {
    inherit  ::UI::PopupMenu

    public variable commandtag ""
    public variable argumentname ""
    public variable datalist {}
    
    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    public method update_menu {} {
      if {$commandtag != "" && $argumentname != ""} {
        $itk_component(menu) delete 0 end
        foreach data $datalist {
          foreach {dataObj dataName} $data {
            $itk_component(menu) insert end command -label $dataName
            attach_menu_item  $itk_component(menu) end $commandtag $argumentname $dataObj
          }
        }
      }
    }
  }
}
