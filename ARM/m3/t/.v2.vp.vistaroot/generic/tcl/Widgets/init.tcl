summit_begin_package Widgets
package require BWidget

summit_source combobox.tcl
summit_source hiertable.tcl
summit_source Dialog.tcl
summit_source tk_messageBox.tcl
summit_source panedwindow.tcl
summit_source tabset.tcl

::fix_tk_messageBox
::Widgets::fixBwidget_ComboBox_mapliste
::Widgets::fix_tk_panedwindow
::Widgets::fix_tabset

summit_end_package
