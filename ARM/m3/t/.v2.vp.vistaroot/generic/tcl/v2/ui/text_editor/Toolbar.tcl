#tcl-mode
option add *Toolbar.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *Toolbar.background \#e0e0e0 widgetDefault
option add *Toolbar.foreground black widgetDefault
option add *Toolbar.headerfont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::v2::ui::text_editor {
  
  class Toolbar {
    inherit ::UI::Toolbar
    
    constructor {_document args} {
      ::UI::Toolbar::constructor $_document
    } {
      configure -height 30
    
      ### Buttons
      
      fill_toolbar
      eval itk_initialize $args

    }
    private method fill_toolbar {} {
      create_left
    }
    private method create_left {} {
      set buttons [frame [get_frame].buts -bg $itk_option(-background)]
      set sepCounter 1
      if { [$document get_variable_value HasSaveCommand]} {
        addButton $buttons saveas   "saveu"   SaveCommand  "Save..."
      } else {
        addButton $buttons saveas   "saveu"   SaveAsCommand  "Save As..."
      }
      set hasOpen 0
      set hasInsert 0
      if { [$document get_variable_value HasOpenCloseCommand]} {
        set hasOpen 1
        addButton $buttons openFile "open" OpenCommand "Open..."
      }
      if { [$document get_variable_value HasInsertFromFileCommand]} {
        set hasInsert 1
        addButton $buttons insertFromFile  "tsv_insert_on_top"  InsertFromFileCommand  "Insert on Top..."
      }
      addSeparator $buttons sep[incr sepCounter]
      if {$hasInsert && $hasOpen} {
        pack_left $buttons saveas openFile insertFromFile sep[set sepCounter]
      } elseif {$hasOpen} {
        pack_left $buttons saveas openFile sep[set sepCounter]
      } elseif {$hasInsert} {
        pack_left $buttons saveas insertFromFile sep[set sepCounter]
      } 

      addButton $buttons cut   "cut"   CutCommand  "Cut"
      addButton $buttons copy  "copy"  CopyCommand  "Copy"
      addButton $buttons paste "paste" PasteCommand  "Paste"
      addSeparator $buttons sep[incr sepCounter]
      pack_left $buttons cut copy paste sep[set sepCounter]
      
      addButton $buttons undo "undo" UndoCommand "Undo" ;
      addButton $buttons redo "redo" RedoCommand "Redo";
      addSeparator $buttons sep[incr sepCounter]
      pack_left $buttons undo redo sep[set sepCounter]
      
      #Small help should be changed according to the current layout to the opposit layout name
      
      # searching
#      addButton $buttons find "find" FindCommand "Find"
      #addButton $buttons find_in_tree "find_in_tree" ""  "Find In Tree";#FindInTreeCommand
      
#      addButton $buttons findnext "find_next"  FindNextCommand "Find Next"
      #      addButton $buttons replace "find_replace"  OpenReplaceDialog "Replace";
#      addButton $buttons replace "find_replace"  FindAndReplace "Replace"
#      addSeparator $buttons sep[incr sepCounter]
#      pack_left $buttons find findnext replace sep[set sepCounter]


      pack $buttons -side top -anchor w

    }


  }
}
