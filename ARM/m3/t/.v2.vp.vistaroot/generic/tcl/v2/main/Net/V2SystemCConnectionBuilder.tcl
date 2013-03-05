# builds connection to SystemC

namespace eval ::v2::main::Net {

  class V2SystemCConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder
  }
  
  V2SystemCConnectionBuilder v2SystemCConnectionBuilder
  
}



