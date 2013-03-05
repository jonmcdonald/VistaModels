usual TreeTableWithRoot {}

namespace eval ::UI {

  class TreeTableWithRoot {
    inherit ::UI::TreeTable
    
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args
      
      $itk_component(table) configure -hideroot 0
    }

    protected method set_root_name { name } {
      $itk_component(table) entry configure root -label $name
    }
  }
}

namespace eval ::UI {
  ::itcl::class UI/TreeTableWithRoot/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }

  UI/TreeTableWithRoot/DocumentLinker UI/TreeTableWithRoot/DocumentLinkerObject
}
