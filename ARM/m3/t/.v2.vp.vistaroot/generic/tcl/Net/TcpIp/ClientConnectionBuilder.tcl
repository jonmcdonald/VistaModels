namespace eval ::Net::TcpIp {

  class ClientConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder
    # the following common variables should be set before building
    # for example using withVariable procedure

    common server_host ""
    common server_port ""
    common external_name ""

    private variable local_name

    constructor {_local_name} {
      set local_name $_local_name
    }

    public method build {} {
      if {$::Net::TcpIp::ClientConnectionBuilder::server_port == ""} {
        error "server_port must be specified"
      }
      if {$::Net::TcpIp::ClientConnectionBuilder::server_host == ""} {
        set ::Net::TcpIp::ClientConnectionBuilder::server_host [::Net::TcpIp::server getServerHost]
      }
      set connection [ objectNew ::Net::TcpIp::ConnectionWithRpc $local_name ""]
      set catchStatus [catch {
        if {$::Net::TcpIp::ClientConnectionBuilder::external_name != ""} {
          $connection setExternalName $external_name
        }
        $connection init $server_host $server_port
        $connection open
      } msg]
      
      if {$catchStatus} {
        set savedErrorInfo $::errorInfo
        set savedErrorCode $::errorCode
        catch {delete object $connection}
        error $msg $savedErrorInfo $savedErrorCode
      }
      return $connection
    }

    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      error "connection $connectionName can not be build by remote request"
    }

    proc createConnection {_server_port {_external_name "ExternalClient"} {_local_name "Client"} {_server_host ""}} {
      set builder ""
      catch {
        set builder [::Net::Ipc::connectionFactory getBuilder $_local_name]
      }
      if {$builder == ""} {
        set builder [objectNew ::Net::TcpIp::ClientConnectionBuilder $_local_name]
        puts "registering builder for $_local_name"
        ::Net::Ipc::connectionFactory registerBuilder $_local_name $builder
      }
      ::Utilities::withVariable ::Net::TcpIp::ClientConnectionBuilder::external_name $_external_name {
        ::Utilities::withVariable ::Net::TcpIp::ClientConnectionBuilder::local_name $_local_name {
          ::Utilities::withVariable ::Net::TcpIp::ClientConnectionBuilder::server_port $_server_port {
            ::Utilities::withVariable ::Net::TcpIp::ClientConnectionBuilder::server_host $_server_host {
              set connection [::Net::Ipc::connectionManager createNewConnection $_local_name]
            }
          }
        }
      }
      return $connection
    }
  }
}

