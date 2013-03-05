option add *TreeView.Column.titleFont { Helvetica 9 }

namespace eval ::v2::ui::analysis::window {

  # base class for XXXSummaryTable
  class SummaryTableBase {
    inherit ::UI::TreeTable
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args

      configure_table
      create_tooltip

      attach $itk_interior CurrentSelection
      bind $itk_component(table) <Delete> "[itcl::code $this remove_objects]"
      bind $itk_component(table) <ButtonPress-1> "+[itcl::code $this on_b1_click]"
      
      $itk_component(table) column bind all <Enter> "+[itcl::code $this on_mouse_enter %X %Y %x %y]"
      $itk_component(table) column bind all <Leave> "+[itcl::code $this on_mouse_leave]"
    }

    destructor {
      catch { destroy $itk_component(tooltip) }
    }

    protected method configure_table {} {} ;# pure virtual

    public method remove_objects {} {
      $document run_command RemoveSelectedObjectsCommand
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
    
    protected method on_double_click {} {
      catch {
        set current [$itk_component(table) index current]
        
        if {[$itk_component(table) entry cget $current -button] == 1 && \
                [$itk_component(table) entry isopen $current] == 0} {
          $itk_component(table) open $current
        }
      } 
      $document run_command AddObjectsCommand
    }

    protected method on_b1_click {} {
      set current_index [$itk_component(table) index current]
      #puts "current_index=$current_index"
      if {$current_index != ""} {
        $document run_command ShowSelectedLinesCommand
      } 
    }

    protected method sort_by_column {column_name} {
      $document set_variable_value ColumnNameForSort $column_name
    }

    protected method create_tooltip {} {
      itk_component add tooltip {
        toplevel $itk_interior.tooltip -bd 1 -bg black
      } {}
      wm overrideredirect $itk_component(tooltip) 1
      pack [label $itk_component(tooltip).label -bg lightyellow -fg black -justify left]
      wm withdraw $itk_component(tooltip)
      
    }

    protected method on_mouse_enter {positionX positionY x y} {
      set column_name [$itk_component(table) column nearest $x $y]
      set column_title [$itk_component(table) column cget $column_name -text]
      
      if {$column_title == ""} {
        set column_title "name"
      }
      $itk_component(tooltip).label configure -text "Sort by $column_title"
      set width [winfo reqwidth $itk_component(tooltip).label]
      set height [winfo reqheight $itk_component(tooltip).label]
      wm geometry $itk_component(tooltip) \
        [format "%sx%s+%s+%s" $width $height [expr $positionX + 5] [expr $positionY - 10]]
      
      wm deiconify $itk_component(tooltip)
      raise $itk_component(tooltip)
    }
    protected method on_mouse_leave {args} {
      
      if {[winfo viewable $itk_component(tooltip)] == 0} {
        return
      }
      wm withdraw $itk_component(tooltip)
    }


  } ;# class
} ;# namespace
