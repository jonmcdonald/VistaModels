namespace eval ::Utilities {

  proc splitExecutablePath {exePath retDirname retTail retExeName retSuffix} {
    upvar $retDirname dirname
    upvar $retTail tail
    upvar $retExeName exeName
    upvar $retSuffix suffix
    set dirname [file dirname $exePath]
    set tail [file tail $exePath]

    set suffix ""
    if {[regsub {(\.exe$)} $tail "" exeName]} {
      set suffix ".exe[set suffix]"
    }

    if {[regsub {(\.dyn$)} $exeName "" exeName]} {
      set suffix ".dyn[set suffix]"
    }
    if {[regsub {(\.purify$)} $exeName "" exeName]} {
      set suffix ".purify[set suffix]"
    }
    return ""
  }

  proc getExeName {exePath} {
    splitExecutablePath $exePath dirName tail exeName suffix
    return $exeName
  }


  proc constructExecutableName {exeName suffix} {
    return "[set exeName][set suffix]"
  }

  proc constructExecutablePath {dirName exeName suffix} {
    return "[set dirName]/[constructExecutableName $exeName $suffix]"
  }

  proc resolveExecutablePath {exeName} {
    set thisExePath [info nameofexecutable]
    splitExecutablePath $thisExePath dirName tail thisExeName suffix
    return [constructExecutablePath $dirName $exeName $suffix]
  }

  proc setDefaultAppEnvVariable {executable var_name value {override 1}} {
    if {$override} {
      set ::env(SUMMIT_[set var_name]) $value
    } else {
      ::Utilities::doNotOverride ::env(SUMMIT_[set var_name]) $value
    }
  }

  proc setAppEnvVariable {executable var_name value {override 1}} {
    regsub -all {\.} [getExeName $executable] "_" keyPrefix
    if {$override} {
      set ::env([set keyPrefix]_[set var_name]) $value
    } else {
      ::Utilities::doNotOverride ::env([set keyPrefix]_[set var_name]) $value
    }
  }

  proc resolveAppEnvVariable {executable var_name} {
    regsub -all {\.} [getExeName $executable] "_" exeName
    foreach keyPrefix [list $exeName SUMMIT] {
      if {[info exist ::env([set keyPrefix]_[set var_name])]} {
        return [set ::env([set keyPrefix]_[set var_name])]
      }
    }
    return ""
  }

  proc getExecutableDebugger {executable} {
    return [resolveAppEnvVariable $executable DEB]
  }
  
  proc debuggerRequired {executable} {
    return [ expr {[getExecutableDebugger $executable] != ""} ]
  }

  proc resolveExecTimeout {executable defaultTimeout} {
    if {[debuggerRequired $executable]} {
      return 0x7fffffff
    }
    return $defaultTimeout
  }

}
