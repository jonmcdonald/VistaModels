namespace eval ::Net::Ipc {

  class BaseConnection {

    inherit ::Utilities::Model

    protected variable pRegistryDirectory
    private variable application
    private variable name ""
    private variable externalName
    private variable invalidReason ""
    private variable status

    private variable stream ""
    private variable streamMutex ""
    private variable streamMutexListener ""
    private variable isAborted 0
    private variable waitInterval 1000
    private variable insideReceive 0

    constructor {_name _application} {
      set application $_application
      if {[::Net::Ipc::connectionManager peekConnection $_name] != ""} {
        set name [::Net::Ipc::connectionManager getFreeConnectionName $_name]
      } else {
        set name $_name
      }
      set pRegistryDirectory [::Net::Ipc::connectionRegistry getConnectionDirectory [::Application::getCurrentApplication] $name]
      set externalName [::Application::getCurrentApplicationName]
      set status "no_connected"
      storeInRegistry
      set streamMutex [::Mutex::createMutex]
      set streamMutexListener [::Mutex::addMutexListener $streamMutex [list [namespace current]::on_streamMutex $this]]
      ::Net::Ipc::connectionManager connectionCreated $this
    }
    
    destructor {
      catch {::Mutex::deleteMutex $streamMutex}
#      catch {setStatus broken}
      if {$application != ""} {
        removeApplivation
      }
      catch {delete object $pRegistryDirectory}
      ::Net::Ipc::connectionManager connectionRemoved $this
    }

    proc on_streamMutex {connection} {
      after 1 [list [namespace current]::notifyConnectionIfExist $connection]
    }

    proc notifyConnectionIfExist {connection} {
      if {[::Utilities::objectExists $connection]} {
        if {[catch {
          namespace inscope [namespace current] [list $connection checkMessage]
        } msg]} {
          catch {$connection logError $msg}
        }
      }
    }

    ;# ---- Public methods ---------
    

    ;# Returns the connection name. By this name the connection can be getted by ConnectionCacher
    public method getName {} {
      return $name
    }

    public method getMajorName {} {
      return [::Utilities::MajorName::getMajorName [getName]]
    }

    private method removeApplivation {} {
      catch {delete object $application}
    }

    ;# returns 1, if the connection may be swapped with another one
    public method isBusy {} {
      return 0
    }

    public method getStatus {} {
      return $status
    }

    public method isValid {} {
      return [expr {"$status" == "ok"}]
    }

    protected method checkValid {} {
      if {![$this isValid]} {
        throwError "Invalid connection"
      }
    }

    protected method throwError {{default ""}} {
      if {$invalidReason != ""} {
        error $invalidReason
      } else {
        error $default
      }
    }


    protected method invalidate {{_invalidReason ""}} {
      setStatus "broken"
      if {$_invalidReason != ""} {
        set invalidReason $_invalidReason
      }
    }

    public method getInvalidReason {} {
      return $invalidReason
    }

    public method close {{isNormal 1}} {
      catch {::Utilities::forgetDeadChildren}
      closeConnection
      if {$isNormal} {
        catch {$pRegistryDirectory deleteDirectoryFromRegistry}
      }
    }

    public method open {} {
      openConnection
      set catchStatus [ catch {
        set package [::Net::Ipc::makeEstablishmentPackage $externalName [::Utilities::getUniqueProcessId]]
        sendEstablishmentPackage $package
        set result [receiveEstablishmentStatus]
        ::Net::Ipc::parseEstablishmentStatus $result status errorMessageOrPid
        if {!$status} {
          set errorMessage "Error during opening connection ($name): $errorMessageOrPid"
          error $errorMessage
        }
      } msg ]
      if {$catchStatus} {
        set errorInfo $::errorInfo
        set errorCode $::errorInfo
        catch {closeConnection}
        error $msg $errorInfo $errorCode
      }
      connectionOpened "directly"
    }

    protected method makeIpcPackage {message} {
      return $message
    }
    
    protected method parseIpcPackage {package pMessage pNextIndex} {
      upvar $pMessage message
      upvar $pNextIndex nextIndex
      set nextIndex [string length $package]
      if {$nextIndex > 0} {
        set pMessage $package
        return 1
      }
      return 0
    }

    ;# sends the message to the remote side
    public method sendMessage {message} {
      ipcDebug "[getName] [info level 0]"
      if {$insideReceive} {
#        error "Can't send message at this time"
      }
      checkValid
      set package [makeIpcPackage $message]
      
      ;# Call the message callback if exists
      if { [info commands ::Net::Ipc::SendMessageCallback] != "" } {
        ::Net::Ipc::SendMessageCallback
      }
      
      sendPackage $package
    }

    ;# receives a message from the remote side and returns it

    public method receiveMessage {} {
      ipcDebug "[getName] [info level 0]"
      set ok "ERROR"
      incr insideReceive
      TRY_EVAL {
        checkValid
        if {![streamPopMessage message]} {
          streamWaitForData 1
          while {![streamPopMessage message]} {
            if {![streamWaitForData $waitInterval]} {
              if {$isAborted} {
                catch {closeConnection}
                invalidate "Aborted"
                throwError
              }
            }
            checkValid
          }
        }
        set ok "OK"
      } {
        incr insideReceive -1
        ipcDebug "[getName] return from [info level 0] (isOk=$ok)"
      }
      return $message
    }

    public method isInsideReceive {} {
      return $insideReceive
    }

    public method deleteMessage {} {
      streamPopMessage message
    }

    public method abort {} {
      set isAborted 1
      ;# check here if receiveCounter > 0
      ::Mutex::notifyMutexTimeOut $streamMutex
    }



    public method peekMessage {pMessage} {
      checkValid
      upvar $pMessage message
      return [expr {[streamPeekMessage message] || ([streamWaitForData 0] && [streamPeekMessage message])}]
    }
     
    ;# ---- Virtual methods -----

    ;# Should be implemented by child send data to the remote site
    protected method sendPackage {package}
    

    protected method dataArived {data} {
      streamAppend $data
    }

    
    ;# ---- Private methods -----

    ;# waits until the new data is appended into the stream
    private method streamWaitForData {{timeOut 0x7fffffff}} {
      set ret [::Mutex::waitOnMutex $streamMutex $timeOut]
      return $ret

    }

    private method streamAppend {data} {
      ipcDebug "[getName] [info level 0]"
      append stream $data
      ipcDebug "[getName] now stream=<$stream>"
      if {[catch {
        ::Mutex::notifyMutex $streamMutex 1
      } msg]} {
        catch {closeConnection}
        invalidate $msg
        throwError
      }
    }

    private method streamSet {data} {
      set stream $data
    }

    ;# gets the stream data
    private method streamGet {} {
      return $stream
    }

    ;# cuts the stream. Makes the startIndex be first index of the new stream data
    private method streamCut {startIndex} {
      ipcDebug "[getName] [info level 0]"
      streamSet [string range [streamGet] $startIndex end]
      ipcDebug "[getName] now stream=<[streamGet]>"
    }

    ;# extracts (and removes) the new valid message from the stream and saves in pMessage argument.
    ;# Returns 1, if success.
    private method streamPopMessage {pMessage} {
      upvar $pMessage message
      set result [streamPopMessageCallback message]
      if {!$result} {
        if {[parseIpcPackage [streamGet] message nextIndex]} {
          streamCut $nextIndex
          set result 1
        }
      }
      
      if {$result && [isValid]} {
        after 1 [list [namespace current]::notifyConnectionIfExist $this]
      }
      return $result
    }
    

    ;# The purpose of this method is to let chance to derived classes
    ;# to change behaviour of streamPopMessage.
    ;# For example, Rpc class overrides 
    ;# decides to change an order of the messages according to current_call_id.
    ;# By default this method is empty
    protected method streamPopMessageCallback {pMessage} {
      return 0
    }


    ;# checks, whether the stream contains a valid message. If so saves it in pMessage argument.
    ;# Returns 1, if the message is exist, and 0 if there is no valid message
    private method streamPeekMessage {pMessage} {
      upvar $pMessage message
      return [parseIpcPackage [streamGet] message nextIndex]
    }

    private method checkMessage {} {
      if {[isValid] && [streamPeekMessage message]} {
        $this messageReceived $message
      }
    }

    public method messageReceived {message} {
      notifyListeners "MESSAGE_RECEIVED" $message
    }

    public method getApplication {} {
      return $application
    }

    public method setExternalName {_externalName} {
      set externalName $_externalName
    }

    public method getExternalName {} {
      return $externalName
    }

    protected method sendEstablishmentPackage {package}

    protected method receiveEstablishmentStatus {} {
    }
    
    private method sendEstablishmentStatus {establishmentStatus} {
      sendEstablishmentPackage $establishmentStatus
    }

    protected method openConnection {} {
    }

    protected method connectionOpened {by_remote_request} {
      setStatus "ok"
      if {$by_remote_request == "by_remote_request"} {
        catch {sendEstablishmentStatus [::Net::Ipc::makeEstablishmentStatus 1 [::Utilities::getUniqueProcessId]]}
      }
      notifyListeners "CONNECTION_OPENED"
    }

    protected method closeConnection {} {
    }

    protected method connectionClosed {} {
      ipcDebug "[getName] [info level 0]"
      catch {::Utilities::forgetDeadChildren}
      after 500 [list catch [list ::Utilities::forgetDeadChildren]]
      ::Mutex::notifyMutexError $streamMutex "Connection closed"
      setStatus "broken"
      notifyListeners "CONNECTION_CLOSED" [list $this]
      after idle [list catch [list delete object $this]]
    }

    public method logError {msg} {
      ipcDebug "[getName] $msg"
    }


    protected method setStatus {_status} {
      ipcDebug "[getName] [info level 0]"
      if {"$_status" != "$status"} {
        set status $_status
        storeInRegistry
      }
    }

    protected method storeInRegistry {{_registryDirectory ""}} {
      if {$_registryDirectory == ""} {
        set _registryDirectory $pRegistryDirectory
      }
      set process [::Application::getCurrentApplicationProcess]
      $_registryDirectory writeSection "host" [$process getHost]
      $_registryDirectory writeSection "pid"  [$process getPid]
      $_registryDirectory writeSection "status" $status
    }
    
  }

}
