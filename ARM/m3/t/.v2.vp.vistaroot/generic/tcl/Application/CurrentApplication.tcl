namespace eval ::Application {
  set app ""
  proc getCurrentApplicationName {} {
    return [[::Application::getCurrentApplication] getName]
  }
  proc getCurrentApplicationProcess {} {
    return [[::Application::getCurrentApplication] getProcess]
  }
  proc getCurrentApplicationRegistryDirectory {} {
    return [[::Application::getCurrentApplication] getRegistryDirectory]
  }
  proc getCurrentApplication {} {
    return $::Application::app
  }
  proc initCurrentApplication {name {pwd ""} args} {
    if {$pwd == ""} {
      set pwd [pwd]
    }
    set ::Application::app [eval [list ::Application::appFactory buildCurrentApplication $name $pwd] $args]
  }
}
