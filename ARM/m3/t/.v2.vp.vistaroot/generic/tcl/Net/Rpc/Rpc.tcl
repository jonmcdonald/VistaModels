namespace eval ::Net::Rpc {

  class Rpc {
    common lastConnectionWhichReceivedClientCall ""
    private variable callCounter 0
    private variable handleClientCallCounter 0
    private variable resultMap
    private variable current_call_id ""

    private variable cachedOutStrings
    private variable cachedOutStringsCounter 0
    private variable outStringsToReport {}
    
    private variable cachedInStrings

    ;# protocol
    private method makeRpcPackage {type call_id message} {
      return "$type $call_id $message" 
    }
    
    private method parseRpcPackage {package pType pCallId pMessage} {
      upvar $pType type
      upvar $pCallId call_id
      upvar $pMessage message
      return [regexp {^([^ ]+) ([^ ]+) (.*)$} $package all type call_id message]
    }

    private method startCall {} {
      incr callCounter
    }

    private method endCall {} {
      incr callCounter -1
    }

    public method isBusy {} {
      return [expr {$callCounter > 0 || [$this isInsideReceive] || [chain]}]
    }

    public method messageReceived {message} {
      ipcDebug "[$this getName] [info level 0] (when callCounter=$callCounter)"
      catch {chain $message}
      
      if {$callCounter == 0} {
        $this deleteMessage

        if {![parseRpcPackage $message type call_id value]} {
          $this logError "Rpc: Invalid message format: $message"
          return
        }

        switch -exact -- $type {
          "call" {
            catch {
              handleClientCall $call_id $value
            }
          }
          "acall" {
            catch {
              handleAsynchronousClientCall $value
            }
          }
          default {
            $this logError "Rpc: Invalid protocol: call or acall expected ($message)"
            return
          }
        }
      } else {
        if {![parseRpcPackage $message type call_id value]} {
          $this logError "Rpc: Invalid message format: $message"
          return
        }
        if {$call_id == $current_call_id || [info exists resultMap($current_call_id)]} {
          $this notifyListeners "ANSWER_READY" $current_call_id
        }
      }
    }

    proc getLastConnectionWhichReceivedClientCall {} {
      return $lastConnectionWhichReceivedClientCall
    }

    public method isHandlingClientCall {} {
      return [expr {$handleClientCallCounter > 0}]
    }

    private method handleClientCall {call_id message} {
      ipcDebug "[$this getName] [info level 0]"
      set prevConnectionWhichReceivedClientCall $lastConnectionWhichReceivedClientCall
      incr handleClientCallCounter
      if {[catch {
        set lastConnectionWhichReceivedClientCall $this
        serviceClientCall $message
      } result]} {
        set package [makeRpcPackage error $call_id $result]
      } else {
        set package [makeRpcPackage ret $call_id $result]
      }
      incr handleClientCallCounter -1
      set lastConnectionWhichReceivedClientCall $prevConnectionWhichReceivedClientCall
      ipcDebug "[$this getName] sending result of $message (the result is <$package>)"
      if {[catch {
        $this sendMessage $package
        ipcDebug "SENT:$package"
      } msg ]} {
        ipcDebug "ERROR $msg"
      }
    }

    private method handleAsynchronousClientCall {message} {
      set prevConnectionWhichReceivedClientCall $lastConnectionWhichReceivedClientCall
      set lastConnectionWhichReceivedClientCall $this
      if {[catch { serviceAsynchronousClientCall $message } result]} {
        catch {$this logError "Rpc: An error occurred during asynchronous call $message: $result"}
      }
      set lastConnectionWhichReceivedClientCall $prevConnectionWhichReceivedClientCall
    }

    private method isReadyForCall {} {
      if {$callCounter != 0} {
        return 1
      }
      if {[info commands ::isSomethingModal] != "" && [::isSomethingModal]} {
        return 0
      }
      
      if {[info commands ::isInsideMotifWait] != "" && [::isInsideMotifWait]} {
        return 0
      }
      return 1
    }
    
    private method checkIfReadyForCall {} {
      if {![isReadyForCall]} {
        error "application busy"
      }
    }
    
    
    protected method serviceClientCall {message} {
      checkIfReadyForCall
      uplevel \#0 $message
    }
    
    protected method serviceAsynchronousClientCall {message} {
      uplevel \#0 $message
    }


    public method execute {args} {
      return [call $args]
    }

    protected method streamPopMessageCallback {pMessage} {
#      puts "in streamPopMessageCallback when current_call_id=$current_call_id"
      if {[info exists resultMap($current_call_id)]} {
#        puts "resultMap($current_call_id) exists and equalt to $resultMap($current_call_id)"
        upvar $pMessage message
        set message $resultMap($current_call_id)
        unset resultMap($current_call_id)
        return 1
      }
      return 0
    }

    proc generate_call_id {} {
      set id [::Utilities::createUniqueIdentifier]
      regsub -all " " $id "." id
      return "tcl_[pid].$id"
    }

    public method call {message} {
      ipcDebug "[$this getName] [info level 0] callCounter(after incr)=[expr $callCounter + 1]"
      reportOutStrings
      startCall
      set prev_call_id $current_call_id
      set current_call_id [generate_call_id]
      set catchStatus [ catch {
        set package [makeRpcPackage call $current_call_id $message]
        $this sendMessage $package
        while 1 {
          set result [$this receiveMessage]
          ipcDebug "[$this getName] result of $message is <$result>"
          if {![parseRpcPackage $result type call_id value]} {
            error "Rpc: Invalid message format: $result"
          }
          switch -exact -- $type {
            "call" {
              handleClientCall $call_id $value
            }
            "acall" {
              handleAsynchronousClientCall $value
            }
            "ret" {
              ;# normal case, when we got OUR answer
              if {![string compare $current_call_id $call_id]} {
                break
              }
              ;# save an answer in private cache
              set resultMap($call_id) $result
            }
            "error" {
              ;# normal case, when we got OUR answer
              if {![string compare $current_call_id $call_id]} {
                error $value
              }
              ;# save an answer in private cache
              set resultMap($call_id) $result
            }
            default {
              $this logError "Rpc: Invalid message type $type: $message"
            }
          }
        }
      } msg ]

      if {$catchStatus } {
        ipcDebug "[$this getName] ERROR: ($msg, $::errorInfo) message was: $message"
      }

      set errorInfo $::errorInfo
      set errorCode $::errorCode
      set current_call_id $prev_call_id
      catch {endCall}

      if {$catchStatus} {
        error $msg $errorInfo $errorCode
      }
      return $value
    }

    private method acall_internal {message} {
      set package [makeRpcPackage acall "1" $message]
      $this sendMessage $package
    }

    public method acall {message} {
      reportOutStrings
      acall_internal $message
    }

    proc break_condition_for_call_when_possible {connection} {
      if {![::Utilities::objectExists $connection]} {
        return 1
      }
      if {![$connection isValid]} {
        return 1
      }
      return 0;
    }

    proc break_condition_for_call_when_possible_and_condition {connection break_condition} {
      if {![break_condition_for_call_when_possible $connection]} {
        return 0
      }
      return [uplevel \#0 $break_condition]
    }

    proc condition_for_call_when_possible {connection} {
      return [expr {![$connection isBusy]}]
    }

    proc condition_for_call_when_possible_and_condition {connection condition} {
      if {![condition_for_call_when_possible $connection]} {
        return 0
      }
      return [uplevel \#0 $condition]
    }
    
    public method do_when_not_busy {script {force_background 0}} {
      if {$force_background} {
        set script [list $this do_when_not_busy $script 0]
        after idle [list catch $script]
        return
      }
      ::Utilities::eval_when \
          [list ::Net::Rpc::Rpc::condition_for_call_when_possible $this] \
          $script \
          [list ::Net::Rpc::Rpc::break_condition_for_call_when_possible $this]
    }

    public method do_when_not_busy_and_condition {script condition break_condition force_background} {
      if {$force_background} {
        set script [list $this do_when_not_busy_and_condition $script $condition $break_condition 0]
        after idle [list catch $script]
        return
      }
      ::Utilities::eval_when \
          [list ::Net::Rpc::Rpc::condition_for_call_when_possible_and_condition $this $condition] \
          $script \
          [list ::Net::Rpc::Rpc::break_condition_for_call_when_possible_and_condition $this $break_condition]
    }

    public method callWhenPossible {message  } {
      do_when_not_busy [list $this call $message] 
    }

    public method cacheOutString {string} {
      if {[info exists cachedOutStrings($string)]} {
        return $cachedOutStrings($string)
      }
      incr cachedOutStringsCounter
      set cachedOutStrings($string) $cachedOutStringsCounter
      lappend outStringsToReport [list $cachedOutStringsCounter $string]
      return $cachedOutStringsCounter
    }

    public method getInString {index} {
      if {[info exists cachedInStrings($index)]} {
        return $cachedInStrings($index)
      }
      return ""
    }

    public method cacheInString {index string} {
      set cachedInStrings($index) $string
    }

    public method cacheReportedInStrings {reportedInStrings} {
      foreach pair $reportedInStrings {
        cacheInString [lindex $pair 0] [lindex $pair 1]
      }
    }

    public method reportOutStrings {} {
      if {[llength $outStringsToReport] == 0} {
        return
      }
      set toReport $outStringsToReport
      set outStringsToReport {}
      acall_internal [list ::Net::Rpc::Rpc::handle_reported_in_strings $toReport]
    }

    proc handle_reported_in_strings {toReport} {
      $lastConnectionWhichReceivedClientCall cacheReportedInStrings $toReport
    }
  }
}
