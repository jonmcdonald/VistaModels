namespace eval ::Net::Ipc::CommonSlave {

  proc create_slave_ipc {{masterName ""}} {
    if {$masterName == ""} {
      set masterName $::env(MASTER_APP_NAME)
    }
    uplevel \#0 {
      summit_package_require Net:Ipc
      summit_package_require Net:Rpc
      summit_package_require Net:TcpIp
      summit_package_require Net:Util
    }
    ::Net::Ipc::connectionFactory registerBuilder $masterName ::Net::Ipc::CommonSlave::slaveConnectionBuilder

    set connection [::Net::Ipc::connectionManager createNewConnection $masterName]
    $connection addListener ::Net::Ipc::CommonSlave::slaveConnectionListener
  }
 
}
