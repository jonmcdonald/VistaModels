itk::usual SText {
  -cursor
}
namespace eval ::UI {
  class SText {
    inherit itk::Widget ::UI::DocumentUIBuilder

    ::UI::ADD_VARIABLE content Content ""

    public variable traceOn 1

    itk_option define -height height Height 100 {
      $itk_component(text) config -height $itk_option(-height)
    }
    itk_option define -state state State disabled {
      $itk_component(text) config -state $itk_option(-state)
    }

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    }  {
      itk_component add sw {
        ScrolledWindow $itk_interior.sw
      } {}
      
      itk_component add text {
        text [$itk_component(sw) getframe].text -bg white  -wrap word
      } {
        keep -font 
      }
      #puts "text=$itk_component(text)"
      #puts "widget=$this"
      set_bindings

      $itk_component(sw) setwidget $itk_component(text)

      eval itk_initialize $args
      set traceOn 1
      show
    }
    
    destructor {
      destruct_variable content
    }
    private method get_text {} {
      set text [regsub "\n\$" [$itk_component(text) get 0.0 end] ""]
      return $text
    }
    private method show {} {
      pack $itk_component(sw) -fill both -expand 1
    }
    private method set_bindings {} {
      bindtags $itk_component(text) [::List::removeElement [bindtags $itk_component(text)] [winfo toplevel $itk_component(text)]]

      bind $itk_component(text) <Control-Key-c> [list tk_textCopy $itk_component(text)]
      bind $itk_component(text) <Control-Key-C> [list tk_textCopy $itk_component(text)]
      bind $itk_component(text) <Control-Key-x> [list tk_textCut $itk_component(text)]
      bind $itk_component(text) <Control-Key-X> [list tk_textCut $itk_component(text)]
      bind $itk_component(text) <Control-Key-v> [list tk_textPaste $itk_component(text)]
      bind $itk_component(text) <Control-Key-V> [list tk_textPaste $itk_component(text)]

      foreach event { <KeyPress> <ButtonRelease-2> <Control-Key-v> <Control-Key-V> } key {%K x x x} {
        bind STextActive_$itk_component(text) $event "[code $this update_variable $key]"
      }
      bindtags $itk_component(text) "[bindtags $itk_component(text)] STextActive_$itk_component(text)"
    }

    private method update_variable {key} {
      if {[lsearch {Right Left Home End} $key] != "-1"} {
        return 
      }
       if {$itk_option(-contentvariable) != ""} {
        set newText [get_text]

        set oldText [set $itk_option(-contentvariable)]

        if { [string compare $oldText $newText] } {
#          puts "update_variable: newText=$newText oldText=$oldText"
          set traceOn 0
#          puts "update_variable: set $itk_option(-contentvariable) $newText"
          set $itk_option(-contentvariable) $newText
        }
      }
    }
#     #update text  
    public method update_text {} { 
      if { $traceOn } {
        update_gui/content
      } else {
#        puts "update_text : set traceOn 1!!!"
        set traceOn 1
      }
   }
  }
}
body ::UI::SText::update_gui/content {} { 
  if { $traceOn } {
    set oldText [get_text]
    if { [string compare $oldText $content] } {
      #puts "update_gui/content!!!!"
      set old_state $itk_option(-state)
      $itk_component(text) configure -state normal
      $itk_component(text) delete 1.0 end
      $itk_component(text) insert 1.0 $content
      $itk_component(text) configure -state $old_state
    }
  }
}
 body ::UI::SText::check_new_value/content {value} {
 }

 namespace eval ::UI {
   ::itcl::class UI/SText/DocumentLinker {
     inherit DataDocumentLinker
    protected method attach_to_data {widget document Content} {
      #puts "attach_to_data $widget $document $Content"
      set content_variable_name [$document get_variable_name $Content]
      $widget configure \
          -contentvariable $content_variable_name
      ::UI::auto_trace variable $content_variable_name w $widget [::itcl::code $this _data_changed $document $Content]
    }
    private method _data_changed {document tag widget variable_name args} {
#      puts "_data_changed $document $tag $widget $variable_name"
      $widget update_text
    }
  }
  
  UI/SText/DocumentLinker UI/SText/DocumentLinkerObject
}
  
