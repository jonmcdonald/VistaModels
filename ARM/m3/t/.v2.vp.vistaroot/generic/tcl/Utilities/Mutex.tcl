namespace eval ::Mutex {

  variable listenerScripts
  array set listenerScripts ""

  proc callWrapper { delegate args } {
    eval $delegate 
  }

  proc createMutex { } {
    set mutexId ::Mutex::[createUniqueIdentifier "m"]
	if { [info exists $mutexId] } {
	  error "Error during mutex creation $mutexId"
	}
    variable $mutexId 
    set $mutexId ""
    return $mutexId
  }
  
  proc deleteMutex { mutexId } {
    variable $mutexId
    unset $mutexId
  }

  proc notifyMutex { mutexId { newMutexValue "" } } {
    variable $mutexId
    if { $newMutexValue != "" } {
      if { $mutexId != $newMutexValue } {
        set $mutexId $newMutexValue
      }
    } else {
      if { [set $mutexId] == "1" } {
        set $mutexId "0"
      } else {
        set $mutexId "1"
      }
    }
  }

  proc notifyMutexError {mutexId errorMessage {errorInfo ""} {errorCode ""}} {
    notifyMutex $mutexId "..error.. [list $errorMessage $errorInfo $errorCode]"
  }
  
  proc notifyMutexTimeOut {mutexId} {
    notifyMutex $mutexId ".timeout."
  }

  proc getMutexValue {mutexId} {
    return [set $mutexId]
  }

  #returns 0 if a timeout is expired
  #        2 if the mutex has been notified with error message: pErrorRecord=[list errorMessage errorInfo errorCode]
  #        1 in regular case. 
  proc parseMutexValue {mutexId {pErrorRecord ""}} {
    set value  [set $mutexId]
    set key [string range $value 0 8]
    if {"$key" == "..error.."} {
      if {$pErrorRecord != ""} {
        upvar $pErrorRecord errorRecord
        set errorRecord [string range $value 10 end]
      }
      return 2
    }
    if {"$key" == ".timeout."} {
      return 0
    }
    return 1
  }


  
  proc addMutexListener { mutexId listenerScript } {
    variable listenerScripts
    set listenerScript "::Mutex::callWrapper [list $listenerScript]"
	set traceInfo [trace vinfo $mutexId]
	foreach traceItem $traceInfo {
	  eval {trace vdelete $mutexId} $traceItem
	}

    trace variable $mutexId w $listenerScript
	for {set ind [expr [llength $traceInfo] -1]} {$ind >=0} {incr ind -1} {
	  eval {trace variable $mutexId} [lindex $traceInfo $ind]
	}

    set listenerId [createUniqueIdentifier "l"]
    set listenerScripts($listenerId) $listenerScript
    return $listenerId
  }
  
  proc removeMutexListener { mutexId listenerId } {
    variable listenerScripts
    set listenerScript $listenerScripts($listenerId)
    trace vdelete $mutexId w $listenerScript
    unset listenerScripts($listenerId)
  }
  
  proc addUnsetMutexListener { mutexId listenerScript } {
    variable listenerScripts
    set listenerScript "::Mutex::callWrapper [list $listenerScript]"
    trace variable $mutexId u $listenerScript
    set listenerId [createUniqueIdentifier "l"]
    set listenerScripts($listenerId) $listenerScript
    return $listenerId
  }

  proc removeUnsetMutexListener { mutexId listenerId } {
    variable listenerScripts
    set listenerScript $listenerScripts($listenerId)
    trace vdelete $mutexId u $listenerScript
    unset listenerScripts($listenerId)
  }

  proc waitOnMutex { mutexId {timeOut 0x7fffffff}} {
    if {$timeOut != 0x7fffffff} {
      set timerId [after $timeOut [list ::Mutex::notifyMutexTimeOut $mutexId]]
    }
    set catchStatus [catch {vwait $mutexId} result]
    if {$timeOut != 0x7fffffff} {
      after cancel $timerId
    }

    set result [parseMutexValue $mutexId errorRecord]
    if {$result == 2} {
      error [lindex $errorRecord 0] [lindex $errorRecord 1] [lindex $errorRecord 2]
    }
    return $result
  }

  proc suspend {timeOut} {
    set m [createMutex]
    catch {waitOnMutex $m $timeOut}
    return ""
  }


  class MutexHolder {
    protected variable mutex ""

    constructor {} {
      set mutex [::Mutex::createMutex]
    }

    destructor {
      ::Mutex::deleteMutex $mutex
    }

    public method getMutex {} {
      return $mutex
    }
    
  }


  proc test { } {
    set mutex [createMutex]
    set l1 [addMutexListener $mutex { puts "Action performed from 1" }]
    set l2 [addMutexListener $mutex { puts "Action performed from 2" }]
    notifyMutex $mutex
    removeMutexListener $mutex $l1
    notifyMutex $mutex
    removeMutexListener $mutex $l2
    notifyMutex $mutex
    deleteMutex $mutex
  }
}
