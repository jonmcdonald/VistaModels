namespace eval ::Net::TcpIp {
  class ConnectionWithRpc {
    inherit ::Net::Rpc::Rpc ::Net::TcpIp::Connection
    constructor {name application} {
      chain $name $application
    } {
    }
    destructor {
    }
  }
}
