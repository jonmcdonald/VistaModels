NOT_SUPPORTED_ON_PURE_TCL
namespace eval ::Utilities {
  # procName should be specified with full path
  proc withProcedure {procName procArgs procBody script} {
    set oldExists [expr {[llength [info commands $procName]] == 1}]
    if {$oldExists} {
      set tmpName ::[createUniqueIdentifier]
      rename $procName $tmpName

      set revertAction "[list rename $procName {}];[list rename $tmpName $procName]"
    } else {
      set tmpName ""
      set revertAction "[list rename $procName {}]"
    }
    TRY_EVAL {
      proc $procName $procArgs "set orig_proc [list $tmpName];$procBody"
      uplevel $script
    } $revertAction
  }

  namespace export withProcedure
  proc withProcedureBody {procName procBody script} {
    uplevel [list ::Utilities::withProcedure $procName [::FunctionDoc::getFullInfoArgs $procName] $procBody $script]
  }
  namespace export withProcedureBody
}
