namespace eval ::Net::Ipc {

  proc areHostsEqual {host1 host2} {
    # yet
    return [expr {[string compare $host1 $host2] == 0}]
  }
  
  ;# yet works only for current hosts
  proc isProcessExist {host uniqProcessId} {
    return [::Utilities::isUniqueProcessExist $uniqProcessId]
  }

  proc getAppConnectionGroup {application name} {
    set registeredConnections [::Net::Ipc::connectionRegistry getConnectionNameList $application]
    return [::Utilities::MajorName::getNamesInGroup $registeredConnections $name]
  }

  proc isConnectionValid {connection} {
    return [expr {$connection != "" && [::Utilities::objectExists $connection] && [$connection isValid]}]
  }
  
  proc getConnectionProcessId {connection} {
    if {![isConnectionValid $connection]} {
      return -1;
    }
    set application [$connection getApplication]
    if {$application == ""} {
      return -1;
    }
    set process [$application getProcess]
    if {$process == ""} {
      return -1
    }
    set pid [$process getSystemPid]
    if {![string is digit $pid]} {
      return -1
    }
    return $pid
  }

  proc checkForNewConnection {savedConnectionList connectionName} {
    set connectionList [::Net::Ipc::connectionManager getConnections]
    set newConnections [lindex [intersect3 $savedConnectionList $connectionList] 2]
    foreach connection $newConnections {
      if {![string compare [$connection getMajorName] $connectionName]} {
        return $connection
      }
    }
    return ""
  }

  proc printConnections {} {
    foreach c [::Net::Ipc::connectionManager getConnections] {
      if {[catch {puts "$c: [$c getName] socket=[$c getSocket] port=[$c getPort] host=[$c getHost]"} msg]} {
        puts "$c : error:$msg"
      }
    }
  }
  proc ::get_connection {name} {
    return [::Net::Ipc::connectionManager peekConnectionFromGroup $name 1]
  }

}
