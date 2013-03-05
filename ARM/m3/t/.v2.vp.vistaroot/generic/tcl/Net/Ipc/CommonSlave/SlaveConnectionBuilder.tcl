namespace eval ::Net::Ipc::CommonSlave {

  class SlaveConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder
    
    public method build {} {
      set connection [ objectNew ::Net::TcpIp::ConnectionWithRpc "Slave" ""]
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
    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      error "$connectionName can not be built by remote request"
    }
  }

  SlaveConnectionBuilder slaveConnectionBuilder

  class ConnectionListener {
    inherit ::Utilities::NativeListener
    public method ON_CONNECTION_CLOSED {model data} {
      exit
    }
  }
  
  
  ConnectionListener slaveConnectionListener
  
}
