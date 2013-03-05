
namespace eval ::v2::ui::inspectdialog {
  class InspectTree {
    inherit ::UI::TreeTable
 
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args

      $itk_component(table) configure -tree [$document get_variable_name Tree]

      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior InspectTreeSelection 
      
      $document run_command OpenNodeCommand NodeArgument 0
    }
  }
  class InspectDialog {
    inherit ::UI::BaseDialog
    
    constructor {_document args} {
      ::UI::BaseDialog::constructor $_document
    } {
      set top $itk_interior

      labelframe $top.expr_frame -text "Expression:"
      pack $top.expr_frame -side top -fill x -padx 5 -pady 2

      entry $top.expr_frame.inspect_entry
      attach $top.expr_frame.inspect_entry InspectExpression
      pack $top.expr_frame.inspect_entry -fill x -side top

      set function_frame [labelframe $top.function_frame -text "Current Function"]
      ::UI::Checkbutton $top.function_frame.check -text "Only in:"
      attach $top.function_frame.check OnlyInFunction
      pack $top.function_frame.check -side left 

      pack $function_frame -fill x -side top  -padx 5 -pady 2

      label $top.function_frame.current_function
      attach $top.function_frame.current_function CurrentFunction
      pack $top.function_frame.current_function -fill x -side left

      ::UI::auto_trace variable [$top.function_frame.check cget -variable] w \
          $top.function_frame.check [::itcl::code $this _on_check $top.function_frame.current_function]

      labelframe $top.result_frame -text "Result:"
      pack $top.result_frame -side top -fill both -expand y  -padx 5 -pady 2
      
      set inspectTree $top.result_frame.inspectTree

      itk_component add inspect_tree {
        ::v2::ui::inspectdialog::InspectTree $inspectTree $document
      } {}

      pack $itk_component(inspect_tree) -fill both -side top -expand 1 -pady 3 

      pack [set buttons [frame $top.mybuttons_frame]] -side top -pady 5 -padx 5 -fill x
      attach [button $buttons.evaluate -text "Evaluate"] EvaluateCommand
      pack $buttons.evaluate -side left -fill x  -expand 1
      attach [button $buttons.addToWatch -text "AddToWatch"] AddToWatchCommand
      pack $buttons.addToWatch -side left -fill x  -expand 1
      attach [button $buttons.close -text "Close"] DestroyCommand
      pack $buttons.close -side left -fill x -expand 1
      attach [button $buttons.help -text "Help"] HelpCommand
      pack $buttons.help -side left -fill x -expand 1

      eval itk_initialize $args
      
      wm geometry $itk_interior 300x300
      wm resizable $itk_interior 1 1
    }

    private method _on_check {function_widget widget variable_name args} {
      if {[string equal [::Utilities::safeGet $variable_name] "1"]} {
        $function_widget configure -foreground red
      } else {
        $function_widget configure -foreground black
      }
    }

  }


}
namespace eval ::UI {
  ::itcl::class v2/ui/inspectdialog/InspectTree/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/inspectdialog/InspectTree/DocumentLinker v2/ui/inspectdialog/InspectTree/DocumentLinkerObject
}
