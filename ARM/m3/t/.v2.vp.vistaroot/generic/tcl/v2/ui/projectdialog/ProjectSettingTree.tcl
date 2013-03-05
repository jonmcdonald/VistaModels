namespace eval ::v2::ui::projectdialog {
  class ProjectSettingTree {
    inherit ::UI::TreeTable
 
    constructor {_document args} {
      ::UI::TreeTable::constructor $_document
    } {
      eval itk_initialize $args

      $itk_component(table) configure -tree [$document get_variable_name Tree] 
      $itk_component(table) configure -highlightthickness 1
      set [$document get_variable_name Tree] $itk_component(table)

      attach $itk_interior ProjectSettingSelection 
      
      $document run_command OpenNodeCommand NodeArgument 0
    }
    protected method update_gui/selectedNodeIDs {}
  }
}

body ::v2::ui::projectdialog::ProjectSettingTree::update_gui/selectedNodeIDs {} {
  chain
  set_variable_by_tabletag "Kind" CurrentKind
}
namespace eval ::UI {
  ::itcl::class v2/ui/projectdialog/ProjectSettingTree/DocumentLinker {
    inherit UI/TreeTable/DocumentLinker
  }
  v2/ui/projectdialog/ProjectSettingTree/DocumentLinker v2/ui/projectdialog/ProjectSettingTree/DocumentLinkerObject
}
