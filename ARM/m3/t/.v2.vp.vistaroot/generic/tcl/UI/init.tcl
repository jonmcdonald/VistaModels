summit_begin_package UI

summit_package_require Utilities
summit_package_require Document
summit_package_require Widgets
summit_package_require UI:message
package require Itk
package require BLT
package require BWidget
package require Iwidgets
package require Tktable
package require Tix
if {[::Utilities::isUnix]} {
  catch {package require Tkx}
}
update

namespace eval :: {
  namespace import -force itk::* iwidgets::*
  set ::errorInfo ""
}

summit_source Tricky.tcl
summit_source CreateView.tcl
summit_source DocumentLinker.tcl
summit_source StandardLinkers.tcl
#summit_source CWidgetsLinkers.tcl
summit_source BWidgetsLinkers.tcl
summit_source OtherLinkers.tcl
#summit_source CheckMenu.tcl
summit_source FlushEntry.tcl
summit_source Checkbuttonbox.tcl
summit_source Labelbox.tcl
summit_source Selectmenu.tcl
summit_source PercentBar.tcl
summit_source BaseSourceView.tcl
summit_source Checkbutton.tcl
#sourcing tkTable patches file
summit_source tkTable.tcl
summit_source tixTable.tcl
summit_source TixTableLinker.tcl
summit_source TableMenu.tcl 
summit_source CommandLineDialog.tcl
summit_source RandomColor.tcl

#xpm should appear before gif

::UI::addbitmapdir [set ::Basics::INSTALLATION_ROOT]/xpm
::UI::addbitmapdir [set ::Basics::INSTALLATION_ROOT]/gif
if {[info exists ::env(MODEL_BUILDER_HOME)]} {
  ::UI::addbitmapdir [set ::env(MODEL_BUILDER_HOME)]/include/ui/img
}

summit_end_package
