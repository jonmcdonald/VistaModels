namespace eval ::Net::Ipc {

  class ConnectionManager {

    inherit ::Utilities::Model

    private variable connections
    private variable waitingHash

    constructor {} {
      set connections [ objectNew ::Net::Ipc::ConnectionContainer ]
    }

    private method serviceRequest {connectionName application connectionArguments} {
      set connection ""
      set catchStatus [ catch {
        set connection [::Net::Ipc::connectionFactory buildByRemoteRequest $connectionName $application $connectionArguments]
      } msg ]
      set errorInfo $::errorInfo
      set errorCode $::errorCode
      
      if {[info exists waitingHash($connectionName)]} {
        set mutex [lindex $waitingHash($connectionName) end]
        if {$catchStatus} {
          ::Mutex::notifyMutexError $mutex $msg $errorInfo $errorCode
        } else {
          ::Mutex::notifyMutex $mutex $connection
        }
      } else {
        if {$catchStatus} {
          error $msg $errorInfo $errorCode
        }
      }
      return ""
    }

    public method handleFromRemoteRequest {connectionName application connectionArguments} {
      serviceRequest $connectionName $application $connectionArguments
    }

    public method getConnections {} {
      return [$connections getConnections]
    }
    
    public method peekConnection {connectionName} {
      return [$connections peekConnection $connectionName]
    }

    public method peekConnectionFromGroup {connectionName mustBeValid} {
      return [$connections peekConnectionFromGroup $connectionName $mustBeValid]
    }

    public method getConnectionGroup {connectionName mustBeValid} {
      return [$connections getConnectionGroup $connectionName $mustBeValid]
    }

    public method isExists {connection} {
      return [$connections isExists $connection]
    }

    public method getCreateConnection {connectionName} {
      set connection [$connections peekConnectionFromGroup $connectionName 1]
      if {$connection == ""} {
        set connection [createNewConnectionInternal $connectionName]
        if {$connection == ""} {
          error "unable to get connection $connectionName."
        }
      }
      return $connection
    }

    public method createNewConnection {connectionName} {
      return [createNewConnectionInternal $connectionName]
    }

    public method deleteConnection {connection} {
      catch { delete object $connection }
    }

    public method isWaitingForConnection {connectionName} {
      return [info exists waitingHash($connectionName)]
    }

    public method getWaitingList {} {
      return [array names waitingHash]
    }

    private method waitForConnectionInternal {connectionName mutex timeOut timeOutScript} {
      while 1 {
        set result [::Mutex::waitOnMutex $mutex $timeOut]
        set connection [set $mutex]
        if {"$result" != "0"} {
          return $connection
        }
        if {$timeOutScript == ""} {
          break
        }
        set answer [uplevel \#0 $timeOutScript $connectionName $mutex]

        ;# Connection could be established during 
        ;# evaluation of timeout script
        set newConnection [set $mutex]
        if {$newConnection != $connection} { 
          ;# A new connection is created
          if {$answer == "cancel"} {
            ;# this situation was not handled by timeOutScript. 
            ;# so we must to close a connection, to avoid "zombies" connection
            catch {$newConnection close}
            break
          }
          return $newConnection
        }
        ;# there no new connection was established during timeOutScript: stop waiting
        if {$answer == "cancel"} {
          break
        }
        ;# nothing happened, continue waiting
      }
      error "while waiting for $connectionName: timeout expired" "" TimeOut
    }

    public method waitForConnection {connectionName {timeOut 0x7fffffff} {timeOutScript ""} {waitPrehook ""} {waitPostHook ""}} {
      set mutex [registerWaiting $connectionName]
      set connection ""
      if {$waitPrehook != ""} {
        set connectionList [getConnections]
        catch {uplevel \#0 $waitPrehook [list $connectionName] [list $mutex]}
        set connection [::Net::Ipc::checkForNewConnection $connectionList $connectionName]
      }
      set catchStatus [ catch {
        if {$connection == ""} {
          set connection [waitForConnectionInternal $connectionName $mutex $timeOut $timeOutScript]
        } else {
          ::Mutex::notifyMutex $mutex $connection
        }
      } msg ]
      set errorInfo $::errorInfo
      set errorCode $::errorCode
      if {$waitPostHook != ""} {
        catch {uplevel \#0 $waitPostHook [list $connectionName] [list $mutex]}
      }
      catch {unRegisterWaiting $connectionName}
      if {$catchStatus} {
        error $msg $errorInfo $errorCode
      }
      return $connection
    }

    public method addConnectionServer {server} {
      $server addListener $this
    }

    public method getFreeConnectionName {connectionName} {
      set connection [$connections peekConnection $connectionName]
      if {$connection == ""} {
        return $connectionName
      }
      set majorName [::Utilities::MajorName::getMajorName $connectionName]

      return [::Utilities::MajorName::makeFullName $majorName [::Utilities::createUniqueIdentifier]]
    }

    private method registerWaiting {connectionName} {
      set mutex [::Mutex::createMutex]
      lappend waitingHash($connectionName) $mutex
      return $mutex
    }
    
    private method unRegisterWaiting {connectionName} {
      if {![info exists waitingHash($connectionName)]} {
        return
      }
      set new_mutex_list [lrange $waitingHash($connectionName) 0 end-1]
      if {[llength $new_mutex_list] == 0} {
        unset waitingHash($connectionName)
      } else {
        set waitingHash($connectionName) $new_mutex_list
      }
    }

    private method createNewConnectionInternal {connectionName} {
      set connection [::Net::Ipc::connectionFactory build $connectionName]
      if {$connection == ""} {
        error "unable to build connection $connectionName"
      }
      if {![::Utilities::objectExists $connection] || ![$connection isValid]} {
        catch { delete object $connection }
        error "invalid connection $connectionName"
      }
      return $connection
    }

    public method connectionCreated {connection} {
      $connections addConnection $connection
      if {[info command "_tcl_net_ConnectionManager_CONNECTION_CREATED"] != ""} {
        catch {_tcl_net_ConnectionManager_CONNECTION_CREATED $connection}
      }
      notifyListeners CONNECTION_CREATED [list $connection]
    }

    public method connectionRemoved {connection} {
      if {[isExists $connection]} {
        $connections removeConnection $connection
        if {[info command "_tcl_net_ConnectionManager_CONNECTION_REMOVED $connection "] != ""} {
          catch {_tcl_net_ConnectionManager_CONNECTION_REMOVED $connection}
        }
        notifyListeners "CONNECTION_REMOVED"
      }
      return ""
    }

  }

  ConnectionManager connectionManager

}

proc .getConnection {connectionName} {
  return [::Net::Ipc::connectionManager peekConnectionFromGroup $connectionName 1]
}
