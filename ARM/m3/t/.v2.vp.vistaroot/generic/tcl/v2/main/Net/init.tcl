summit_begin_package v2:main:Net

summit_package_require Net:Ipc
summit_package_require Net:Rpc
summit_package_require Net:TcpIp
summit_package_require Net:Util
summit_package_require Net:Ipc:CommonSlave
summit_package_require v2:xemacs

summit_source V2GdbConnectionBuilder.tcl
summit_source V2SystemCConnectionBuilder.tcl
summit_source V2SimvisionConnectionBuilder.tcl
summit_source VistaClientConnectionBuilder.tcl
summit_source RemoteSimulationListener.tcl

::Net::Ipc::connectionFactory registerBuilder "Gdb" ::v2::main::Net::v2GdbConnectionBuilder
::Net::Ipc::connectionFactory registerBuilder "SystemC" ::v2::main::Net::v2SystemCConnectionBuilder
::Net::Ipc::connectionFactory registerBuilder "Simvision" ::v2::main::Net::v2SimvisionConnectionBuilder
::Net::Ipc::connectionFactory registerBuilder "VistaClient" ::v2::main::Net::vistaClientConnectionBuilder

set ::env(VISTA_SERVER_HOST) [::Net::TcpIp::server getServerHost]
set ::env(VISTA_SERVER_PORT) [::Net::TcpIp::server getServerPort]

summit_end_package
