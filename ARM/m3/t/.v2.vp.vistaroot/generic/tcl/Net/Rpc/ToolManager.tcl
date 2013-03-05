namespace eval ::Net::Rpc {

  class ToolManager {

    private variable tools
    private variable counter 0

    public method getToolNameList {} {
      return [array names tools]
    }

    public method getTools {} {
      set retList {}
      foreach toolName [array names tools] {
        lappend retList $tools($toolName)
      }
      return $retList
    }

    # returns list of used connections
    public method getUsedConnections {majorConnectionName} {
      set group [::Utilities::MajorName::getNamesInGroup [array names tools] $majorConnectionName] 
      set resLst {}
      foreach name $group {
        set tool $tools($name)
        if {$tool != "" && [::Utilities::objectExists $tool]} {
          set connection [$tool getConnection]
          if {$connection != "" && [::Utilities::objectExists $connection]} {
            lappend resLst $connection
          }
        }
      }
      return $resLst
    }

    public method getTool {toolName} {
      set tool [getCached $toolName]
      if {$tool != "" && [::Utilities::objectExists $tool]} {
        return $tool
      }
      return [createTool $toolName]
    }
    
    public method newTool {toolName} {
      return [createTool $toolName]
    }
    
    public method getToolGroup {toolName} {
      return [::Utilities::MajorName::getObjectGroup tools $toolName]
    }
    
    private method getNamesInGroup {toolName} {
      return [::Utilities::MajorName::getNamesInGroup [array names tools] $toolName]
    }

    private method getFreeName {toolName} {
      if {![info exists tools($toolName)]} {
        return $toolName
      } else {
        set majorName [::Utilities::MajorName::getMajorName $toolName]
        incr counter
        return [::Utilities::MajorName::makeFullName $majorName $counter]
      }
    }

    private method createTool {toolName} {
      set freeName [getFreeName $toolName]
      set tool [ objectNew ::Net::Rpc::Tool $freeName]
      set catchStatus [ catch {$tool makeValid} msg ]
      if {$catchStatus} {
        set errorInfo $::errorInfo
        set errorCode $::errorCode
        catch {delete object $tool}
        error $msg $errorInfo $errorCode
      }
      cache $tool
      return $tool
    }
    
    public method isToolExist {toolName} {
      set tool [getCached $toolName]
      return [expr {$tool != "" && [::Utilities::objectExists $tool]}]
    }

    ;# private methods

    private method getCached {toolName} {
      if {[info exists tools($toolName)]} {
        return $tools($toolName)
      } else {
        return ""
      }
    }
    
    private method cache {tool} {
      set tools([$tool getName]) $tool
    }
    
    private method uncache {toolName} {
      if {[info exists tools($toolName)]} {
        unset tools($toolName)
      }
    }
    
  }

  ToolManager toolManager

}

