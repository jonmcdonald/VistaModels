namespace eval ::Net::Ipc {
  
  class ConnectionServer {
    # called from derived class. 
    # This function should be called from derived class, 
    # when connection request is received.
    # This function does nothing with 'connectionArguments', passing them
    # to the virtual funnctions, called from this method
    protected method connectionRequestArived {host connectionArguments} {
      set message [readEstablishmentPackage $connectionArguments]
      set status ""
      if {[catch {
        ::Net::Ipc::parseEstablishmentPackage $message connectionName pid
        ipcDebug "$connectionName connected pid=$pid"
        handleConnection $connectionName $host $pid $connectionArguments
      } msg]} {
        ipcDebug "error ON_Connect: $msg $::errorInfo"
        set status [::Net::Ipc::makeEstablishmentStatus 0 $msg]
        catch {sendEstablishmentStatus $connectionArguments $status}
        catch {lowLevelCleanup $connectionArguments}
      }
    }

    # Virtual. Derived  classes should read an establishment package
    protected method readEstablishmentPackage {connectionArguments}

    # Virtual. Derived  classes should send an establishment status
    protected method sendEstablishmentStatus {connectionArguments status}

    # Virtual. Derived  classes should cleanup low level channel
    # after the connection request was not serviced correctly
    protected method lowLevelCleanup {connectionArguments} 


    private method handleConnection { connectionName host pid connectionArguments } {
      set appName [::Utilities::MajorName::getMajorName $connectionName]
      set application ""
      catch {set application [::Application::appFactory load $appName $host $pid]}
      ::Net::Ipc::connectionManager handleFromRemoteRequest $connectionName $application $connectionArguments
    }

  }

}
