option add *StackView.nofocusselectbackground yellow widgetDefault

namespace eval ::v2::ui::processes {
  class StackView {
    inherit ::UI::SWidget
    
    itk_option define -nofocusselectbackground nofocusselectbackground Background white
    
    ::UI::ADD_VARIABLE stackLevel StackLevel -1

    private variable currentStackLevelBackground white
    private variable currentStackLevelForeground black
    
    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      
      construct_variable stackLevel
      
      eval itk_initialize $args

      set currentStackLevelBackground [cget -nofocusselectbackground]

      create_body
      set_binding
    }
    
    destructor {
      catch { destruct_variable stackLevel }
    }

    public method focus_in {component} {
      focus $itk_component(stack)
    }
    
    private method create_body {} {
      itk_component add stack {
        listbox $itk_interior.stack -bg white \
            -selectbackground white -selectforeground black \
            -xscrollcommand "$itk_interior.hs set" \
            -yscrollcommand "$itk_interior.vs set" \
            -listvariable [$document get_variable_name CurrentStackForView]
      } {
        rename -font -sourcefont sourcefont Font
        rename -background -sourcebackground sourcebackground Sourcebackground
        keep -foreground -selectbackground -selectforeground
      }

      ### scrollbars
      scrollbar $itk_interior.hs -orient horizontal -highlightthickness 0 \
          -command "$itk_interior.stack xview" 
      scrollbar $itk_interior.vs -orient vertical -highlightthickness 0 \
          -command "$itk_interior.stack yview" 
      
      blt::table $itk_interior \
          $itk_component(stack) 0,0 -fill both \
          $itk_interior.vs 0,1 -fill y \
          $itk_interior.hs 1,0 -fill x
      blt::table configure $itk_interior r1 c1 -resize none 
    }
    
    protected method set_binding {} {
      chain

      ::Widgets::set_focus_by_mouse_press $itk_component(stack)
      bind $itk_component(stack) <Double-Button-1> [code $this update_stack_level]
      bind $itk_component(stack) <Key-Return> [code $this update_stack_level]
      bind $itk_component(stack) <FocusIn> "+[code $this change_focus in]"
      bind $itk_component(stack) <FocusOut> "+[code $this change_focus out]"
    }

    private method change_focus {focus_state} {
      catch {$document set_variable_value CurrentTreeTable ""} 
      if {$focus_state == "in"} {
        set currentStackLevelBackground [cget -selectbackground]
        set currentStackLevelForeground white
      } else {
        set currentStackLevelBackground [cget -nofocusselectbackground]
        set currentStackLevelForeground black
      }
      mark_stackLevel $stackLevel
    } 
    
    private method update_stack_level {} {
      set curselection [$itk_component(stack) curselection]
      configure -stackLevel $curselection
    }
    
    private method unmark_stackLevel {index} {
      if {[$itk_component(stack) get $index] != {}} {
        $itk_component(stack) itemconfigure $index \
            -background [cget -sourcebackground] -foreground black \
            -selectbackground [cget -sourcebackground] -selectforeground black
      }
    }

    private method mark_stackLevel {index} {
      if {[$itk_component(stack) get $index] != {}} {
        $itk_component(stack) itemconfigure $index \
            -background $currentStackLevelBackground -foreground $currentStackLevelForeground \
            -selectbackground $currentStackLevelBackground -selectforeground $currentStackLevelForeground
        
        return 1
      }
      return 0
    }
  }
}

body ::v2::ui::processes::StackView::update_gui/stackLevel {} {
  unmark_stackLevel $stackLevelOld
  if { [mark_stackLevel $stackLevel] == 1 } {
    $itk_component(stack) see $stackLevel
  }
}

namespace eval ::UI {
  class v2/ui/processes/StackView/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document StackLevel} {


      $widget configure \
          -stackLevelvariable [$document get_variable_name $StackLevel]
    }
  }

  v2/ui/processes/StackView/DocumentLinker v2/ui/processes/StackView/DocumentLinkerObject
}
