namespace eval ::Net::TcpIp {
  class NullConnection {
    inherit ::Net::TcpIp::ConnectionWithRpc
    constructor {name application} {
	    chain $name $application
    } {
	    setStatus "ok"
    }
    destructor {
    }
    public method call {message} {
	    return ""
    }
    public method acall {message} {
	    return ""
    }
  }
}
