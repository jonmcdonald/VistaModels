NOT_SUPPORTED_ON_PURE_TCL
namespace eval ::Utilities {
  class LocalAction {
    private variable theFinalScript
    constructor {finalScript} {
      set theFinalScript $finalScript 
    }
    destructor {
      catch { uplevel $theFinalScript }
    }
  }
  proc LOCAL_ACTION {finalScript} {
    uplevel [list ::Utilities::newLocal ::Utilities::LocalAction $finalScript]
  }
  namespace export LOCAL_ACTION

  proc FINAL_ACTION {finalScript} {
    uplevel [list ::Utilities::newLocal ::Utilities::LocalAction $finalScript]
  }
  namespace export FINAL_ACTION
}

