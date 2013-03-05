summit_begin_package Net:TcpIp

summit_package_require Net:Ipc
summit_package_require Net:Rpc
summit_package_require Utilities

summit_source Connection.tcl
summit_source ConnectionWithRpc.tcl
summit_source NullConnection.tcl
summit_source ConnectionBuilder.tcl
summit_source Server.tcl
summit_source Utilities.tcl
summit_source ClientConnectionBuilder.tcl

::Net::TcpIp::Server::create
::Net::TcpIp::server register

::Net::Ipc::connectionFactory registerBuilder "ExternalClient" [::Utilities::objectNew ::Net::TcpIp::ConnectionBuilder]
::Net::Ipc::connectionFactory registerBuilder "SimpleClient" [::Utilities::objectNew ::Net::TcpIp::ConnectionBuilder]

summit_end_package
