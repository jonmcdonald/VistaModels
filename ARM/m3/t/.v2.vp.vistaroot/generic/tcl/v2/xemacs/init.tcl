summit_begin_package v2:xemacs

summit_package_require Net:Ipc
summit_package_require Net:Rpc
summit_package_require Net:TcpIp
summit_package_require Net:Util

summit_source V2XEmacsConnectionBuilder.tcl
::Net::Ipc::connectionFactory registerBuilder "XEmacs" ::v2::xemacs::v2XEmacsConnectionBuilder

summit_end_package
