namespace eval ::Net::Ipc {

  class MessageConnection {

    inherit ::Net::Ipc::BaseConnection

    constructor {name application} {
      chain $name $application
    } {
    }
    # protocol
    
    protected method makeIpcPackage {message} {
      return "[string length $message]\n$message"
    }
    
    protected method parseIpcPackage {package pMessage pNextIndex} {
      upvar $pMessage message
      upvar $pNextIndex nextIndex
      if {[regexp {^([0-9]+)\n(.*)$} $package all len rest] && [string length $rest] >= $len} {
        set message [string range $rest 0 [expr {$len - 1}]]
        set nextIndex [expr {[string length $len] + 1 + $len}]
        return 1
      }
      return 0
    }

  }

}
