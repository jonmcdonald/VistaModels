
namespace eval ::UI {

  usual TableMenu {}

  class TableMenu {
    inherit  ::UI::PopupMenu

    public variable table_widget "" 
    public variable addShowRowsCommand 0
    private variable moreRows 1

    constructor {_document args} {
      chain $_document
    } {
      eval itk_initialize $args
    }

    destructor {}

    public method get_table {} {
      return $table_widget
    }
    public method update_menu {} {
      $itk_component(menu) delete 0 end
      $itk_component(menu) add command -label "Cut"  -underline 2 -accelerator "Ctrl+X" -command  "tixTable:cutSelected $table_widget"
      $itk_component(menu) add command -label "Copy"  -underline 0 -accelerator "Ctrl+C" -command "tixTable:copySelected $table_widget"
      $itk_component(menu) add command -label "Paste"  -underline 0 -accelerator "Ctrl+V" -command "tixTable:pasteSelected $table_widget"
      
      $itk_component(menu) add separator
      $itk_component(menu) add command -label "Move Row Up"  -underline 10 -command  "tixTable:moveRow $table_widget up"
      $itk_component(menu) add command -label "Move Row Down"  -underline 10 -command "tixTable:moveRow $table_widget down"
      if {$addShowRowsCommand} {
        $itk_component(menu) add separator
        if {$moreRows} { 
          $itk_component(menu) add command -label "Show More Rows"  -underline 10 -command "$this showMoreRows"
        } else {
          $itk_component(menu) add command -label "Show Less Rows"  -underline 10 -command "$this showLessRows"
        }
      }
      
    }
    public method showMoreRows {} {
      #more
      set moreRows 0
      $table_widget.table config -height 10
    }
    public method showLessRows {} {
      #less
      set moreRows 1
      $table_widget.table config -height 4
    }
    

    public method fill_menu {} {
    }
    public method moveRowUp {} {
      $table_widget moveRow up
    }
  }
}
