# builds connection to SystemC

namespace eval ::v2::main::Net {

  class V2SimvisionConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder
  }
  
  V2SimvisionConnectionBuilder v2SimvisionConnectionBuilder
  
}



