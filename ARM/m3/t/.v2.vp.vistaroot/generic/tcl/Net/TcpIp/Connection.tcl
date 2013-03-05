namespace eval ::Net::TcpIp {


  class Connection {
    inherit ::Net::Ipc::MessageConnection

    variable socket ""
    variable host ""
    variable port ""

    constructor {name application} {
      chain $name $application
    } {}

    destructor {
      catch {closeSocket}
    }

    public method initByRemoteRequest {_socket _host _port} {
      set socket $_socket
      set host   $_host
      set port   $_port
      configureSocket
      connectionOpened "by_remote_request"
    }

    protected method sendEstablishmentPackage {package} {
      ipcDebug "[$this getName] [info level 0]"
      set oldBlock [fconfigure $socket -blocking]
      fconfigure $socket -blocking 1
      set catchStatus [catch {
        puts $socket "$package"
        flush $socket
      } msg]
      set errorInfo $::errorInfo
      set errorCode $::errorCode
      fconfigure $socket -blocking $oldBlock 
      if {$catchStatus} {
        ipcDebug "[$this getName] [info level 0]: error: $msg"
        error $msg $errorInfo $errorCode
      }
      ipcDebug "[$this getName] [info level 0]: sent"
      return ""
    }

    protected method receiveEstablishmentStatus {} {
      ipcDebug "[$this getName] [info level 0]"
      set oldBlock [fconfigure $socket -blocking]
      fconfigure $socket -blocking 1
      set catchStatus [catch {
        set status [gets $socket]
      } msg]
      set errorInfo $::errorInfo
      set errorCode $::errorCode
      fconfigure $socket -blocking $oldBlock 
      if {$catchStatus} {
        error $msg $errorInfo $errorCode
      }
      return $status
    }


    protected method openConnection {} {
      set socket [::socket $host $port]
      configureSocket
    }
 
    public method init {_host _port} {
      set port $_port
      set host $_host
    }

    private method configureSocket {} {
      fileevent $socket readable [list $this ON_dataReady]
      fconfigure $socket -blocking 0 -tran {binary binary}
    }

    public method ON_dataReady {} {
      if {$socket == ""} {
        ipcDebug "[$this getName] [info level 0]: invalid socket handle"
        return
      }
      set is_eof 1
      if {[catch {
        set is_eof [eof $socket]
      } msg]} {
        ipcDebug "[$this getName] [info level 0]: error during eof call"
        catch {closeSocket}
        return
      }
      if {$is_eof} {
        ipcDebug "[$this getName] [info level 0]: eof"
        catch {closeSocket}
        return
      }
      ipcDebug "[$this getName] [info level 0]: Reading data..."
      set data ""
      if {[catch {
        set data [read $socket]
      } msg]} {
        ipcDebug "[$this getName] [info level 0]: error while reading data: $msg"
        catch {closeSocket}
        return
      }
      ipcDebug "[$this getName] data=<$data>"
      catch {dataArived $data}
    }

    public method getSocket {} {
      return $socket
    }

    public method getHost {} {
      return $host
    }

    public method getPort {} {
      return $port
    }

#     this function is final in ::Net::Ipc::Connection
#     public method isValid {} {
#       return [expr {$socket != "" && [chain] && ![catch {eof $socket} result] && !$result}]
#     }

    protected method closeConnection {} {
      closeSocket
    }
    
    protected method closeSocket {} {
      if {$socket != ""} {
        set s $socket
        set socket ""
        ::Utilities::eval_when "expr {!\[::Utilities::isProcessExist [::Net::Ipc::getConnectionProcessId $this]\]}" {} {} 1000
        after 500 [list catch [list ::Utilities::forgetDeadChildren]]
        catch {::close $s}
        connectionClosed
      }
    }

    set ::v2_blocking_send 0
    if {[info exists ::env(V2_BLOCKING_SEND)] && $::env(V2_BLOCKING_SEND) == "1"} {
      set ::v2_blocking_send 1
    }
    
    
    protected method sendPackage {package} {
      ipcDebug "[$this getName] [info level 0]"
      if {$::v2_blocking_send} {
        set oldBlock [fconfigure $socket -blocking]
        fconfigure $socket -blocking 1
      }
      set catchStatus [catch {
        puts -nonewline $socket $package
        flush $socket
      } msg ]
      set errorInfo $::errorInfo
      set errorCode $::errorCode
      if {$::v2_blocking_send} {
        fconfigure $socket -blocking $oldBlock
      }
      if {$catchStatus} {
        error $msg $errorInfo $errorCode
      }
    }
  }

}
