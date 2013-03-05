# builds connection to Gdb

namespace eval ::v2::main::Net {

  class V2GdbConnectionBuilder {
    inherit ::Net::TcpIp::ConnectionBuilder

    proc getActualGdbExe {} {
      if {[info exists ::env(V2_GDB_EXE)]} {
        return $::env(V2_GDB_EXE)
      }
      return "gdb"
    }

    proc getGdbExe {} {
      return [getActualGdbExe]
    }

    proc getGdbArgs {} {
      return [list -quiet -interp=opengdb -runtcl=\"[::Utilities::escapeSpaces "$::env(V2_HOME)/tcl/v2/gdb/gdb.tcl"]\" --nx]
    }

    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      set connection [::Net::TcpIp::ConnectionBuilder::buildByRemoteRequest $connectionName $application $arguments ]
      $connection addListener  ::v2::main::Net::v2GdbConnectionListener
      return $connection
    }
  } 

  V2GdbConnectionBuilder v2GdbConnectionBuilder

  class V2GdbConnectionListener {
    inherit ::Utilities::NativeListener
    public method ON_DESTROY {model data} {
      if {[info exists ::env(V2_BATCH_MODE)] && $::env(V2_BATCH_MODE) == "1"} {
        #trigger vwait
        catch {
          set gdbShellConnection [::Net::Ipc::connectionManager peekConnectionFromGroup GdbShell 1]
          if {$gdbShellConnection != ""} {
            $gdbShellConnection close
          }
          ::Mutex::suspend 1000
        }
        set ::v2_batch_simulation_running 0
      }
    }
  }
  V2GdbConnectionListener v2GdbConnectionListener
  
  set external_resimulating_mutex [::Mutex::createMutex]
  proc start_external_resimulating {gdb_connection} {
    $gdb_connection acall ::v2::gdb::start_external_resimulating
    ::Mutex::waitOnMutex $::v2::main::Net::external_resimulating_mutex
  }
  proc start_external_quiting {gdb_connection} {
    $gdb_connection acall ::v2::gdb::start_external_quiting
    ::Mutex::waitOnMutex $::v2::main::Net::external_resimulating_mutex
  }
  proc external_resimulating_handled {} {
    ::Mutex::notifyMutex $::v2::main::Net::external_resimulating_mutex
  }
  proc break_external_resimulating {gdb_connection} {
    ::Mutex::notifyMutexTimeOut $::v2::main::Net::external_resimulating_mutex
  }
}


#::Net::Ipc::connectionManager getCreateConnection Gdb
