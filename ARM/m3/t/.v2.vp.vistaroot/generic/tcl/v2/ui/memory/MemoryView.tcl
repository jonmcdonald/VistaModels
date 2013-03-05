namespace eval ::v2::ui::memory {
  class MemoryView {
    inherit ::UI::SWidget
    
    constructor {_document args} {
      ::UI::SWidget::constructor $_document
    } {
      eval itk_initialize $args

      create_toolbar
      create_textual_widget

      show
    }
    
    protected method create_popup_menu {} {
    }
    
    private method create_toolbar {} {
      itk_component add toolbar {
        frame $itk_interior.toolbar -bd 1 -relief raised -pady 1 -padx 1
      } {
        keep -background
      }

      ### Address
      label $itk_component(toolbar).address_label -text "Start Address:" 
      itk_component add address {
        ::UI::SEntry $itk_component(toolbar).address \
            -helptext "Enter number or expression" -width 12 -background white \
            -disabledforeground black
      } {
        keep -font
      }
      attach $itk_component(address) Address
      pack $itk_component(toolbar).address_label -side left -anchor w
      pack $itk_component(address) -side left -padx 5 -anchor nw
      
      ### Repeat Count
      label $itk_component(toolbar).count_label -text "Count:"
      itk_component add count {
        ::UI::SEntry $itk_component(toolbar).count -type digit \
            -helptext "Enter number between 1 and 1024" -width 10 -background white \
            -disabledforeground black
      } {
        keep -font
      }
      attach $itk_component(count) RepeatCount
      pack $itk_component(toolbar).count_label -side left -anchor w
      pack $itk_component(count) -side left -padx 5 -anchor nw
      ::UI::auto_trace variable [$document get_variable_name RepeatCount] \
          w $itk_interior [code $this check_repeatcount_value]

      
      ### Format Letters
      label $itk_component(toolbar).format_label -text "Format:"
      itk_component add format {
        ::UI::BwidgetCombobox $itk_component(toolbar).format -editable 0 \
            -helptext "Choose display format" -width 14
      } {
        keep -font
      }
      attach $itk_component(format) CurrentFormat FormatList
      pack $itk_component(toolbar).format_label -side left -anchor w
      pack $itk_component(format) -side left -padx 5 -anchor nw

      ### Size Letters
      label $itk_component(toolbar).size_label -text "Size:"
      itk_component add size {
        ::UI::BwidgetCombobox $itk_component(toolbar).size -editable 0 \
            -helptext "Choose size of each entry" -width 6
      } {
        keep -font
      }
      attach $itk_component(size) CurrentSize SizeList 
      pack $itk_component(toolbar).size_label -side left -anchor w
      pack $itk_component(size) -side left -padx 5 -anchor nw

 #      ### Buttons
#       itk_component add show {
#         Button $itk_component(toolbar).show_current -helptext "Show" -text "Show" -relief link \
#             -padx 0 -pady 0 -highlightthickness 0 -width 0 -height 0 -padx 1 -pady 1
#       } {
#         keep -background -foreground -font -takefocus 
#         rename -activebackground -background background Background
#         rename -height -buttonheight buttonHeight ButtonHeight
#       }
#       #attach $itk_component(show) ShowMemoryCommand
#       pack $itk_component(toolbar).show_current -side left -anchor nw

      itk_component add next {
        Button $itk_component(toolbar).next -helptext "Next" -text "Next" -relief link \
            -padx 0 -pady 0 -highlightthickness 0 -width 0 -height 0 -padx 1 -pady 1
      } {
        keep -background -foreground -font -takefocus 
        rename -activebackground -background background Background
        rename -height -buttonheight buttonHeight ButtonHeight
      }
      attach $itk_component(next) NextMemoryCommand
      pack $itk_component(toolbar).next -side left -anchor nw
    }

    private method create_textual_widget {} {
      itk_component add text {
        ::UI::STextViewer $itk_interior.text $document \
            -font "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
      } {
        keep -font
#        rename -font -sourcefont sourceFont SourceFont
      }
      attach $itk_component(text) MemoryState
    }

    public method show {} {
      pack $itk_component(toolbar) -side top -anchor nw -fill x -expand 1
      pack $itk_component(text) -fill both -expand 1
    }
    
    private method check_repeatcount_value {args} {
      set repeatCount [$document get_variable_value RepeatCount]
      if {$repeatCount < 1 || $repeatCount > 1024} {
        $itk_component(count) configure -background red
        ::UI::Message::errorMessage "Enter number between 1 and 1024"
      } else {
        $itk_component(count) configure -background white
      }
    }
  }
}

namespace eval ::UI {
  ::itcl::class v2/ui/memory/MemoryView/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/memory/MemoryView/DocumentLinker v2/ui/memory/MemoryView/DocumentLinkerObject
}
