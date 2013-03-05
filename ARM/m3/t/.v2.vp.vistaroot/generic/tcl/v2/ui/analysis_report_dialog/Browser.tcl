
namespace import -force ::itcl::*

namespace eval ::v2::ui::analysis_report_dialog {
  
  
  ::itcl::class DesignTree {
    inherit ::UI::TreeTable
    
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args
      puts "document=$document"
      puts "tree=[$document get_variable_name Tree]"
      puts "variable_name Tree = [$document get_variable_name Tree]"
      puts "table=$itk_component(table)"
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior CurrentSelection 

      $document run_command OpenNodeCommand NodeArgument 0
    }
    
    protected method create_popup_menu {} {
      
    }

  }
}    
#   ::itcl::class Browser {

#     inherit ::UI::BaseDialog
#     private variable analysis_dlg

#     constructor {_document args} {
#       ::UI::BaseDialog::constructor [$_document create_tcl_sub_document DocumentTypeAnalysisTreeView]
#     } {
#       puts "Browser: constructor"
#       #set analysis_dlg $_analysis_dlg

#       create_body

#       global lightBg
#       global headerFg
#       global borderColor
      
#       #create_buttons
#       add_button AddCommand -text "Add" -width 5 -underline 0 -borderwidth 1 -relief flat \
#           -background $lightBg -foreground $headerFg -activebackground $lightBg -activeforeground $headerFg \
#           -highlightthickness 1 -highlightbackground $borderColor
#       add_button CloseCommand -text "Close" -width 5 -underline 0 -borderwidth 1 -relief flat \
#           -background $lightBg -foreground $headerFg -activebackground $lightBg -activeforeground $headerFg \
#           -highlightthickness 1 -highlightbackground $borderColor

#       eval itk_initialize $args
      
#       wm minsize   $itk_interior 280 380

#       draw
#     }
    
#     protected method create_body {} {
#       set top [get_body_frame]

#       # change to white background
#       set body_top [winfo parent $top]
#       $body_top configure -background white
#       set top_children [winfo children $body_top]
      
#       foreach child $top_children {
#         $child configure -background white
#       }
      
#       itk_component add table_view {
        
#         ::v2::ui::analysis_report_dialog::DesignTree $top.table_view \
#             [$document create_tcl_sub_document DocumentTypeAnalysisTreeView]
#       } {}
      
#       pack $top.table_view \
#           -fill both -anchor nw -side left -expand 1 

#       global mediumBg
#       global borderColor
#       [$itk_component(table_view) component hscroll] configure -background $mediumBg -activebackground $mediumBg \
#           -troughcolor $borderColor -borderwidth 1 -elementborderwidth 1 -width 10
#       [$itk_component(table_view) component vscroll] configure -background $mediumBg -activebackground $mediumBg \
#           -troughcolor $borderColor -borderwidth 1 -elementborderwidth 1 -width 10
#     }
#   }
# }


namespace eval ::UI {
  ::itcl::class v2/ui/analysis_report_dialog/DesignTree/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/analysis_report_dialog/DesignTree/DocumentLinker v2/ui/analysis_report_dialog/DesignTree/DocumentLinkerObject
}


