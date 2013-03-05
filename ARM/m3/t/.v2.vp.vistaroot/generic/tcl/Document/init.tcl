summit_begin_package Document

summit_package_require Utilities
summit_source Document.tcl
summit_source Replay.tcl
summit_source ReplayLog.tcl
#summit_source VariableChangeHooks.tcl
#summit_source NewDocHooks.tcl
summit_source loadGeneratedHooks.tcl

set ::main_doc [objectNew Document::Document [::Document::getMainDocument]]

summit_end_package
