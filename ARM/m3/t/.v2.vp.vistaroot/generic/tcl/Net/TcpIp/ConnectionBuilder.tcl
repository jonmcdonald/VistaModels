namespace eval ::Net::TcpIp {

  class ConnectionBuilder {
    inherit ::Net::Ipc::ConnectionBuilder

    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      set connection [ objectNew ::Net::TcpIp::ConnectionWithRpc $connectionName $application]
      set socket [lindex $arguments 0]
      set host [lindex $arguments 1]
      set port [lindex $arguments 2]
      $connection initByRemoteRequest $socket $host $port
      return $connection
    }
  }

  ConnectionBuilder passiveConnectionBuilder

}
