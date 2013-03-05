option add *TreeView.Column.titleFont { Helvetica 12 bold }


usual ProfilingStatisticsTable {}
namespace eval ::v2::ui::profilingwindow {
  class ProfilingStatisticsTable {
    inherit ::UI::TreeTable

    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args
      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      #$itk_component(table) configure -linewidth 0; #check with dynamic processes!
      set [$document get_variable_name Tree] $itk_component(table)
      set names [$itk_component(table) column names]

      $itk_component(table) column insert end chunk_allocation chunk_number max_allocation 
      $itk_component(table) column configure [lindex $names 0] -title "Process" -command [code $this sort_by_field process_name]
      $itk_component(table) column configure chunk_allocation -title "Total potential memory leak" -command [code $this sort_by_field chunk_allocation]
      $itk_component(table) column configure chunk_number -title "Number of potential memory leaks" -command [code $this sort_by_field chunk_number]
      $itk_component(table) column configure max_allocation -title "Max memory allocation"  -command [code $this sort_by_field max_allocation]
    
      attach $itk_interior CurrentSelection 
    }
    protected method create_popup_menu {} {
      itk_component add popup_menu {
        ::v2::ui::profilingwindow::PopupMenu $itk_interior.popup_menu $document
      }
    }
    public method sort_by_field {field} {
      switch $field {
        "process_name" {
          $document run_command SortByProcessNameCommand
          $document set_variable_value IsSortedByName 1
        }
        "chunk_allocation" {
          $document set_variable_value ProfilingView "Total potential memory leak"
          $document set_variable_value IsSortedByName 0
        }
        "chunk_number" {
          $document set_variable_value ProfilingView "Number of potential memory leaks"
          $document set_variable_value IsSortedByName 0
        }
        "max_allocation" {
          $document set_variable_value ProfilingView "Max memory allocation"
          $document set_variable_value IsSortedByName 0
        }
      }
    }
  }
}

namespace eval ::UI {
  ::itcl::class v2/ui/profilingwindow/ProfilingStatisticsTable/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/profilingwindow/ProfilingStatisticsTable/DocumentLinker v2/ui/profilingwindow/ProfilingStatisticsTable/DocumentLinkerObject
}
