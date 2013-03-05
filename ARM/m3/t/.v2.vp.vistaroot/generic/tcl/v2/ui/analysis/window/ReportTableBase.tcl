
option add *TreeView.Column.titleFont { Helvetica 9 }

namespace eval ::v2::ui::analysis::window {

  # base class for XXXReportTable
  class ReportTableBase {
    inherit ::UI::TreeTable
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args

      configure_table

      attach $itk_interior CurrentSelection
      bind $itk_component(table) <Delete> "[itcl::code $this remove_objects]"
      bind $itk_component(table) <ButtonPress-1> "+[itcl::code $this on_b1_click]"

    }

    protected method configure_table {} {} ;# pure virtual

    public method remove_objects {} {
      $document run_command RemoveSelectedObjectsCommand
    }

    public method clear_selection {} {
      $document set_variable_value CurrentSelection {}
    }

    protected method on_selection {} {
      catch {
        UI::TreeTableBase::on_selection
      } 
      $document run_command ShowSelectedLinesCommand
    }

    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::analysis::window::PopupMenu $itk_interior.popup_menu $document
      }
    }

    protected method on_b1_click {} {
      set current_index [$itk_component(table) index current]
      #puts "current_index=$current_index"
      if {$current_index == ""} {
        clear_selection
      } else {
        on_selection
      }
    }

    protected method on_double_click {} { }

  } ;# class

} ;# namespace
