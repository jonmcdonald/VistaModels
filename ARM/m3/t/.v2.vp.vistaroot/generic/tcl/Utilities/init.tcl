summit_begin_package Utilities

summit_package_require List
summit_package_require Message
namespace eval :: {
  summit_source Pwd.tcl
  summit_source Tcl.tcl
  if {![basics_is_pure_tcl]} {
    summit_source LocalAction.tcl
    summit_source WithVariable.tcl
    summit_source WithProcedure.tcl
    summit_source arguments.tcl
  }
  summit_source SummitExec.tcl
  summit_source TclTypes.tcl
  if {![basics_is_pure_tcl]} {
    summit_source FlipFlop.tcl
  }
  summit_source AddSuite.tcl
  summit_source String.tcl
  if {![basics_is_pure_tcl]} {
    foreach i {
      ::Utilities::LOCAL_ACTION
      ::Utilities::FINAL_ACTION
      ::Utilities::DISABLE_TCL_FLIP_FLOP
      ::Utilities::DISABLE_C++_FLIP_FLOP
      ::Utilities::DISABLE_FLIP_FLOPS
      ::Utilities::TRY_EVAL
      ::Utilities::withVariable
      ::Utilities::withoutVariable
    } {
      namespace import -force $i
    }
  }
  foreach i {
    ::Utilities::objectNew 
    ::Utilities::newLocal 
    ::Utilities::switchToLocal 
    ::Utilities::objectNewInit 
    ::Utilities::objectDelete 
    ::Utilities::objectExists 
    ::Utilities::catchNotify 
    ::Utilities::createUniqueIdentifier 
    ::Utilities::foreach_pair 
  } {
    namespace import -force $i
  }
}

summit_end_package
