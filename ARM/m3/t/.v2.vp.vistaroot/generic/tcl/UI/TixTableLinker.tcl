#Linker for tixTable widget

namespace eval ::UI {
  ::itcl::class TixTable/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tag args} {

      set variableName [$document get_variable_name $tag]
      set tableDefaultRowsNum 38
      set size [$document get_array_size $tag]
      set cols [$widget cget -cols]
      set rows [expr $size/($cols -1) + 1]
      set height 30
      if {$tag == "LinkObjectsTable"} {
        set height 20
        if {$rows <30} {
          set rows 30
        }
      } elseif {$rows < $tableDefaultRowsNum} {
        set rows $tableDefaultRowsNum
      }
      $widget.table configure -height $height
      $widget configure -rows $rows -variable $variableName 

      set [set variableName](_widget_) $widget
    }
    
  }
  TixTable/DocumentLinker TixTable/DocumentLinkerObject
}
