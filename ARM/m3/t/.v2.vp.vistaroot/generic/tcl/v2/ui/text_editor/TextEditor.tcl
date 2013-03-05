namespace eval ::v2::ui::text_editor {
  class TextEditor {
    private variable frame
    private variable text

    inherit itk::Widget ::UI::DocumentUIBuilder

    constructor {_document  args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      set top $itk_interior
      itk_component add menu {
        [namespace parent]::ViewMenu $top.menu $document 
      }
      itk_component add toolbar {
        [namespace parent]::Toolbar $top.toolbar $document 
      }
      $itk_component(menu) show
      pack $itk_component(menu) -side top -fill x -anchor nw 
      $itk_component(toolbar) show
      pack $itk_component(toolbar) -side top -fill x -anchor nw 

      set text_height [$document get_variable_value TextWidgetHeight]

      set frame [frame $top.frame]
      pack $frame -fill both -expand y
      set text [set frame].text
      text $text -relief sunken -bd 2 -yscrollcommand "$frame.scroll set" \
       -height $text_height -width 60 -autosep 1 -background white

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

      attach $text TextBody

      eval itk_initialize $args
      

      $text edit modified 0
      $text edit reset
      set prependBody [$document get_variable_value PrependBody]
      if {[string length $prependBody] > 0} {
        $text mark set start_of_previous_body 0.0
        $text insert 0.0 "$prependBody\n"
        $text tag add prepend_body 0.0 start_of_previous_body
        $text tag con prepend_body -foreground red
      }
      set file [$document get_variable_value OpenedFileName]
      if {[file readable $file]} {
        ::UI::set_data_to_text_widget $text [read_file [$document get_variable_value OpenedFileName]]
        $text edit modified 0
      }
      on_modified
    }

    private method on_modified {args} {
      set is_modified [$text edit modified]
      $document set_variable_value TextModified $is_modified
    }
    
  }
}
