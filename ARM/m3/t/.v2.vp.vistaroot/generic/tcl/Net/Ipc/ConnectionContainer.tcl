namespace eval ::Net::Ipc {

  class ConnectionContainer {
    private variable connections

    public method getConnectionNameList {} {
      return [array names connections]
    }

    public method getConnections {} {
      set resLst {}
      foreach name [array names connections] {
        lappend resLst $connections($name)
      }
      return $resLst
    }

    public method isExists {connection} {
      return [info exists connections([$connection getName])]
    }

    public method peekConnection {connectionName} {
      if {[info exists connections($connectionName)]} {
        return $connections($connectionName)
      }
      return ""
    }

    public method peekConnectionFromGroup {connectionName mustBeValid} {
      return [getConnectionFromGroupInternal $connectionName $mustBeValid 0]
    }

    public method popConnection {connectionName} {
      if {[info exists connections($connectionName)]} {
        set connection $connections($connectionName)
        unset connections($connectionName)
        return $connection
      }
      return ""
    }

    public method popConnectionFromGroup {connectionName mustBeValid} {
      return [getConnectionFromGroupInternal $connectionName $mustBeValid 1]
    }


    public method addConnection {connection} {
      set connectionName [$connection getName]
      if {[info exists connections($connectionName)]} {
        error "Internal error: connection $connectionName is already exist in $this"
      }
      set connections($connectionName) $connection
      return ""
    }

    public method removeConnection {connection} {
      set connectionName [$connection getName]
      if {![info exists connections($connectionName)]} {
        error "Internal error: connection $connectionName does not exist in $this"
      }
      unset connections($connectionName)
    }

    public method removeByName {connectionName} {
      unset connections($connectionName)
    }

    public method getConnectionGroup {connectionName mustBeValid} {
      set group [::Utilities::MajorName::getObjectGroup connections $connectionName]
      if {$mustBeValid} {
        set resLst {}
        foreach connection $group {
          if {[::Utilities::objectExists $connection] && [$connection isValid]} {
            lappend resLst $connection
          }
        }
        return $resLst
      } else {
        return $group
      }
    }
    
    private method getNamesInGroup {connectionName} {
      return [::Utilities::MajorName::getNamesInGroup [array names connections] $connectionName]
    }

    private method getConnectionFromGroupInternal {connectionName mustBeValid remove} {
      if {[info exists connections($connectionName)]} {
        set connection $connections($connectionName)
        if {$mustBeValid} {
          if {[::Utilities::objectExists $connection] && [$connection isValid]} {
            if {$remove} {
              unset connections($connectionName)
            }
            return $connection
          }
        }
      }

      set group [::Utilities::MajorName::getObjectGroup connections $connectionName]
      if {[llength $group]} {
        set found 0
        if {$mustBeValid} {
          foreach connection $group {
            if {[::Utilities::objectExists $connection] && [$connection isValid]} {
              set connection $connection
              set found 1
              break
            }
          }
        } else {
          set connection [lindex $group 0]
          set found 1
        }
        if {$found} {
          if {$remove} {
            unset connections([$connection getName])
          }
          return $connection
        }
      }
      return ""
    }

  }
}
