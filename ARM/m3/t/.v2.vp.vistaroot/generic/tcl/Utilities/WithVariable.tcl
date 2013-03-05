NOT_SUPPORTED_ON_PURE_TCL
namespace eval ::Utilities {

  ;# Very usefull function.
  ;# Assignes `newValue' to `varName' and evaluates `script'
  ;# After the `script' is finished an old value of `varName'
  ;# will be reverted.
  ;# In case, when the variable had not been set before calling this function
  ;# the one will be `unset'
  ;# Example:
  ;# proc test {} {
  ;#   withVariable ::env(PATH) /usr/bin {
  ;#     withVariablea ::env(TMP_PATH) $::env(PATH) {
  ;#       exec xterm
  ;#     }
  ;#   }
  ;#}
  ;# As a result in the opened xterm $PATH amd $TMP_PATH will be /usr/bin
  ;# After `test' procedure finishes, env(PATH) will be reverted, and TMP_PATH will be unset

  proc withVariable {varName newValue script} {
    set oldExists [uplevel info exists $varName]
    if {$oldExists} {
      set oldValue [uplevel set $varName]
      set revertAction [list set $varName $oldValue] 
    } else {
      set revertAction [list ::Utilities::safeUnset $varName]
    }
#    LOCAL_ACTION [list uplevel $revertAction]
    TRY_EVAL {
         uplevel [list set $varName $newValue]
         uplevel $script
    } $revertAction
  }
  namespace export withVariable

  proc withoutVariable {varName script} {
    set oldExists [uplevel info exists $varName]
    if {$oldExists} {
      set oldValue [uplevel set $varName]
      set revertAction [list set $varName $oldValue] 
    } else {
      set revertAction [list ::Utilities::safeUnset $varName]
    }
    TRY_EVAL {
#    LOCAL_ACTION [list uplevel $revertAction]
	if {$oldExists} {
	    uplevel [list unset $varName]
	}
	uplevel $script
    } $revertAction
  }
  namespace export withoutVariable
}

