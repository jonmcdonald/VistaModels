namespace eval ::Net::TcpIp {

  class Server {
    
    proc create {} {
      ::Net::TcpIp::Server ::Net::TcpIp::server
      ::Net::TcpIp::server createServerSocket
    }

    inherit ::Net::Ipc::ConnectionServer
    
    private variable acceptSocket ""
    private variable serverPort

    public method createServerSocket {} {
      for {set serverPort 10000} {$serverPort < 20000} {incr serverPort} {
        if {![catch {set ::acceptSocket [socket -server [namespace code [list $this ON_Connect]] $serverPort ]} msg]} {
          catch {fcntl $::acceptSocket CLOEXEC 1}
          return
        }
      }
      error $msg
    }
  
    public method getServerPort {} {
      return $serverPort
    }

    public method getServerHost {} {
      return [::Utilities::getCurrentHostAddr]
    }
    
    public method register {} {
      catch {
        set currentApplicationDirectory [::Application::getCurrentApplicationRegistryDirectory]
        if {$currentApplicationDirectory != ""} {
          $currentApplicationDirectory writeSection "port" $serverPort
        }
      }
      catch {
        foreach env_var [array names ::env SERVER_REGISTER_FILE_FOR_*] {
          if {[regexp {SERVER_REGISTER_FILE_FOR_(.*)} $env_var all requested_app_name]} {
            if {[string equal [::Application::getCurrentApplicationName] $requested_app_name]} {
              set f [::open [set ::env($env_var)] "w"]
              catch {puts $f "[getServerPort] [getServerHost]"}
              close $f
            }
          }
        }
      }
    }

    public method unregister {} {
      [::Application::getCurrentApplicationRegistryDirectory] deleteSection "port"
    }

    protected method sendEstablishmentStatus {connectionArguments status} {
      ipcDebug "[info level 0]"
      set sock [lindex $connectionArguments 0]
      puts $sock $status
      flush $sock
      ipcDebug "[info level 0] Done"
    }
    
    protected method readEstablishmentPackage {connectionArguments} {
      ipcDebug "[info level 0]. Reading..."
      set sock [lindex $connectionArguments 0]
      set result [gets $sock]
      ipcDebug "[info level 0]. Done: result=$result"
      return $result
    }

    protected method lowLevelCleanup {connectionArguments} {
      set sock [lindex $connectionArguments 0]
      close $sock
    }

    private method ON_Connect {sock a p} {
      connectionRequestArived $a [list $sock $a $p]
    }
    
  }

}

