namespace eval ::Net::Rpc {

  class Tool {

    private variable connection
    private variable toolName
    private variable majorConnectionName

    constructor {_toolName} {
      set connection ""
      set toolName $_toolName
      set majorConnectionName [::Utilities::MajorName::getMajorName $_toolName]
    }
    
    public method getConnection {} {
      return $connection
    }

    public method getName {} {
      return $toolName
    }

    public method makeValid {} {
      if {$connection != "" && [::Utilities::objectExists $connection]} {
        if {[$connection isValid]} {
          return ;# ok
        } else {
          if {[$connection isBusy]} {
            error "Invalid connection $majorConnectionName. Unable to create another one at this time."
          }
        }
      }
      ::Net::Ipc::connectionManager deleteConnection $connection
      set connection ""
      set connectionList [::Net::Ipc::connectionManager getConnectionGroup $majorConnectionName 1]
      set usedConnections [::Net::Rpc::toolManager getUsedConnections $majorConnectionName]
      set freeConnections [lindex [intersect3 $connectionList $usedConnections] 0]
      set connection ""
      foreach freeConnection $freeConnections {
        if {[$freeConnection isValid]} {
          set connection $freeConnection
          return
        }
      }
      set connection [::Net::Ipc::connectionManager createNewConnection $majorConnectionName]
      if {$connection == "" || ![$connection isValid]} {
        error "Unable to build tool $majorConnectionName"
      }
    }

    public method isValid {} {
      return [expr {[::Utilities::objectExists $connection] && [$connection isValid]}]
    }

    public method callAsIs {expression} {
      makeValid
      return [$connection call $expression]
    }

    public method call {expression} {
      callAsIs $expression
    }

  }

}
