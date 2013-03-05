
namespace eval ::v2::ui::tlmwindow::filter {
  class FilterDialog {
    inherit ::UI::BaseDialog
    private variable frame
    private variable text

    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set top $itk_interior
      itk_component add menu {
        [namespace parent]::ViewMenu $itk_interior.menu $document 
      }
      itk_component add toolbar {
        [namespace parent]::Toolbar $itk_interior.toolbar $document 
      }
      $itk_component(menu) show
      pack $itk_component(menu) -side top -fill x -anchor nw 
      $itk_component(toolbar) show
      pack $itk_component(toolbar) -side top -fill x -anchor nw 


      set frame [frame $top.frame]
      pack $frame -fill both -expand y
      set text [set frame].text
      text $text -relief sunken -bd 2 -yscrollcommand "$frame.scroll set" \
       -height 20 -autosep 1 -background white
      
      bindtags $text [::List::removeElement [bindtags $text] [winfo toplevel $text]]
      $text configure -undo 1

      bind $text <<Modified>> [code $this on_modified]
      bind $text <Control-Key-c> [list tk_textCopy $text]
      bind $text <Control-Key-C> [list tk_textCopy $text]
      bind $text <Control-Key-x> [list tk_textCut $text]
      bind $text <Control-Key-X> [list tk_textCut $text]
      bind $text <Control-Key-v> [list tk_textPaste $text]
      bind $text <Control-Key-V> [list tk_textPaste $text]


      $document set_variable_value TextWidgetName $text

      scrollbar $frame.scroll -command "$text yview"
      pack $frame.scroll -side right -fill y
      pack $text -expand yes -fill both

      attach $text FilterBody
      add_ok_button
      add_button ApplyCommand -text "Apply" -width 5 -underline 0 
      add_cancel_button
      add_help_button

      eval itk_initialize $args
      
      wm minsize $itk_interior 300 0
      wm resizable $itk_interior 1 1

      draw
      $text edit modified 0
      $text edit reset
      set prependBody [$document get_variable_value PrependBody]
      if {[string length $prependBody] > 0} {
        $text mark set start_of_previous_body 0.0
        $text insert 0.0 "$prependBody\n"
        $text tag add prepend_body 0.0 start_of_previous_body
        $text tag con prepend_body -foreground red
      }
      on_modified
    }
    
    private method on_modified {args} {
      $document set_variable_value TextModified [$text edit modified]
    }

  }
}
