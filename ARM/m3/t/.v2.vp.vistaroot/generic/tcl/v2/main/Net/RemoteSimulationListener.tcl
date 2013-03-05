namespace eval ::v2::main::Net {

  proc transfere_simulation_callbacks {connection listener arguments args} {
    if {![::Net::Ipc::isConnectionValid $connection]} {
      _unregister_remote_listener $connection $listener $arguments
      return
    }
    catch {
      eval [list $connection execute $listener] $arguments $args
    }
    return ""
  }


  proc add_simulation_remote_listener {listener arguments} {
    set connection [::Net::Rpc::Rpc::getLastConnectionWhichReceivedClientCall]
    if {$connection == ""} {
      return ""
    }
    _register_remote_listener $connection $listener $arguments
    return ""
  }

  proc remove_simulation_remote_listener {listener arguments} {
    set connection [::Net::Rpc::Rpc::getLastConnectionWhichReceivedClientCall]
    if {$connection == ""} {
      return ""
    }
    mgc_vista_remove_simulation_listener $connection $listener $arguments
  }

  proc _register_remote_listener {connection listener arguments} {
    mgc_vista_add_simulation_listener ::v2::main::Net::transfere_simulation_callbacks $connection $listener $arguments
  }

  proc _unregister_remote_listener {connection listener arguments} {
    mgc_vista_remove_simulation_listener ::v2::main::Net::transfere_simulation_callbacks $connection $listener $arguments
  }

}
