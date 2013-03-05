# builds connection to VistaClient

namespace eval ::v2::main::Net {

  class VistaClientConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder

    # invoked at the start time
    public method build {} {
      set connection [ objectNew ::Net::TcpIp::ConnectionWithRpc "VistaClient" ""]
      $connection setExternalName "Vista"
      set catchStatus [catch {
        if {[info exists ::env(VISTA_ENABLE_INTERHOST_COMMUNICATION)] && $::env(VISTA_ENABLE_INTERHOST_COMMUNICATION) == "1"} {
          set remoteHost $::env(MASTER_SERVER_HOST)
        } else {
          set remoteHost [::Utilities::getCurrentHostAddr]
        }
        set remotePort $::env(MASTER_SERVER_PORT)
        $connection init $remoteHost $remotePort
        $connection open
      } msg]
      
      if {$catchStatus} {
        delete object $connection
        #error $msg $::errorInfo $::errorCode
        puts $msg
        catch {after 3000}
        exit
      }
      return $connection
      
    }
  }
  
  VistaClientConnectionBuilder vistaClientConnectionBuilder
  
}



