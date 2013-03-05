namespace eval ::Utilities {


  proc isUnix {} { 1 }
  proc getEnvSeparator {} {}
  proc getPlatformName {} {}

  if {$::tcl_platform(platform) == "windows"} {
    proc isUnix {} {return 0}
    proc getEnvSeparator {} {return "\;"}
    proc getPlatformName {} {return "win32"}
    
    proc platform_strcmp {s1 s2} {
      return [stricmp $s1 $s2]
    }
  } else {
    proc isUnix {} {return 1}
    proc getEnvSeparator {} {return ":"}
    switch -exact -- $::tcl_platform(os) {
      HP-UX {
        proc getPlatformName {} {return "HP-UX11"}
      }
      SunOS {
        proc getPlatformName {} {return "SunOS5"}
      }
      AIX {
        proc getPlatformName {} {return "AIX4"}
      }
      Linux {
        proc getPlatformName {} {return "Linux"}
      }
      default {
        proc getPlatformName {} {return $::tcl_platform(os)}
      }
    }

    proc platform_strcmp {s1 s2} {
      return [string compare $s1 $s2]
    }
  }

}

proc platform_strcmp {s1 s2} {
  return [::Utilities::platform_strcmp $s1 $s2]
}

