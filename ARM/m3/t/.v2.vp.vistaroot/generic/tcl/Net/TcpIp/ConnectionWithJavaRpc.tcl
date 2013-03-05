namespace eval ::Net::TcpIp {
  class ConnectionWithJavaRpc {
    inherit ::Net::TcpIp::ConnectionWithRpc

    constructor {name application} {
      chain $name $application
    } {
    }
    destructor {
    }
    public method messageReceived {message} {
#      ipcDebug "[getName] (ConnectionWithJavaRpc) $message"

      #chain $message
      $this deleteMessage
#      ipcDebug "[getName] (ConnectionWithJavaRpc (after delete message)"
      NotifyJavaMessageReceived $this $message
#      ipcDebug "[getName] (ConnectionWithJavaRpc (after NotifyJavaMessageReceived)"
    }

    protected method connectionClosed {} {
      chain
      NotifyJavaConnectionClosed $this
    }

  }
}
