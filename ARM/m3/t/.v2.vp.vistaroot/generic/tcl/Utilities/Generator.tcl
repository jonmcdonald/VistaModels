namespace eval ::Utilities {
  proc generator_getIncludeFileName {str} {
    set res ""
    regexp "#include *\"(.*)\"" $str temp res
    return $res
  }

  proc generator_getSignalName {str} {
    set str [string trim $str "\n\t "]
    regexp "//v2: channel (.*)" $str temp res
    return $res
  }

  proc generator_getClockName {str} {
    set str [string trim $str "\n\t "]
    regexp "//v2: clock (.*)" $str temp res
    return $res
  }

  proc generator_getInstanceName {str} {
    set str [string trim $str "\n\t "]
    regexp "//v2: instance (.*) - instance number .* of module .*" $str temp res
    return $res
  }

  proc generator_getInstanceIndex {str} {
    set str [string trim $str "\n\t "]
    regexp "//v2: instance .* - instance number (.*) of module .*" $str temp res
    return $res
  }

  proc generator_getInstanceModule {str} {
    set str [string trim $str "\n\t "]
    regexp "//v2: instance .* - instance number .* of module (.*)" $str temp res
    return $res
  }

  proc generator_replacePaths {pathsList newDir} {
    set res ""
    foreach path $pathsList {
      if { [string match "-l*" $path] } {
        set res "$res $path"
      } else {
        set splittedPath [split $path "/"]
        set res "$res [set newDir]/[lindex $splittedPath end]"
      }
    }
    return $res
  }
}
