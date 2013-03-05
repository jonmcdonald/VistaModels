Namespace eval ::Utilities {
  
  Class Model {
    
    protected variable listenerList {}
    private variable disableCounter 0

    destructor {
      notifyListeners DESTROY
    }
    
    Public method addListener {listener} {
      if {[lsearch -exact $listenerList $listener] == -1} {
        lappend listenerList $listener
      }
    }
    
    Public method removeListener {listener} {
      ::List::removeItem listenerList $listener
    }
    
    Public method notifyListeners {event {eventData ""}} {
      if {[isModelEnabled]} {
        foreach listener $listenerList {
          if {[info commands $listener] != ""} {
            if {[catch {
              $listener execute $this $event $eventData
            } msg]} { 
              ;# do not worry about ::PM the following line should be deleted
              ::Message::addMessage dbg "error while notifying ($listener execute $this $event $eventData) :$msg $::errorInfo"
            }
          } else {
            removeListener $listener
          }
        }
      }
    }
    
    public method notifyListenersOrDie {event {eventData ""}} {
      set isError 0
      if {[isModelEnabled]} {
        foreach listener $listenerList {
          if {[info commands $listener] != ""} {
            if {[catch {
              $listener execute $this $event $eventData
            } msg]} { 
              set isError 1
            }
          } else {
            removeListener $listener
          }
        }
      }
      if { $isError } {
        error "Error during notifyListenersOrDie"
      }
    }
    
    Public method removeAll {} {
      unset listenerList
    }
    
    public method getListenerList {} {
      return $listenerList
    }
    
    private method getListenerIndex {listener} {
      return [lsearch -exact $listenerList $listener]
    }

    Public method isModelEnabled {} {
      return [expr $disableCounter == 0]
    }
    
    Public method enableModel {} {
      if {$disableCounter > 0} {
        incr disableCounter -1
      }
    }

    Public method disableModel {} {
      incr disableCounter
    }

    public method callFunction {function args}
    
  }
  
  Class OrderedModel {
    Inherit Model
    
    protected method sort {} { ;# should be implemented
    }
    
    public proc compareListeners {listener1 listener2 args} {
      set priority1 [$listener1 getPriority]
      set priority2 [$listener2 getPriority]
      if {$priority1 < $priority2} {
        return -1
      } elseif {$priority1 > $priority2} {
        return 1
      } else {
        return 0
      }
    }
    
    protected method findIndexToInsert {listener} {
      return [::List::bsearchInsert $listenerList $listener ::Utilities::OrderedModel::compareListeners]
    }
    
    Public method addListener {listener} {
      set index [findIndexToInsert $listener]
      if {![info exists listenerList]} {
        set listenerList {}
      }
      set listenerList [linsert $listenerList $index $listener]
    }
    
    public method getListenersByPriority {priority} {
      set resultList {}
      foreach listener $listenerList {
        if {[$listener getPriority] == $priority} {
          lappend resultList $listener
        }
      }
      return $resultList
    }
    
    public method getIndicesByPriority {priority} {
      set resultList {}
      set index 0
      foreach listener $listenerList {
        if {[$listener getPriority] == $priority} {
          resultList $index
        }
        incr index
      }
      return $resultList
    }
    
  }
  
  
  Class Listener {
    
    private variable isListenerEnabled 1
    private variable priority 0x7fffffff
    
    public method getPriority {} {
      return $priority
    }
    
    public method setPriority {_priority} {
      set priority $_priority
    }
    
    Protected method fire {model event eventData} { 
    }

    Public method execute {model event eventData} {
      if {$isListenerEnabled} {
        fire $model $event $eventData
      }
    }
    
    Public method disableListener {} {
      set isListenerEnabled 0
    }
    
    Public method enableListener {} {
      set isListenerEnabled 1
    }
    
    Public method isListenerEnabled {} {
      return $isListenerEnabled
    }

    Public method ON_DESTROY { model eventData} {
      delete object $this
   }
  

  }
  
  Class CallMethodListener {
    Inherit Listener
    private variable targetObject ""
    private variable methodName ""
    private variable callArguments ""
    Constructor {_targetObject _methodName args} {
      set targetObject $_targetObject
      set methodName $_methodName
      set callArguments $args
    }
    Protected method fire {model event eventData} {
      uplevel \#0 [list $targetObject $methodName $model $event $eventData] $callArguments
    }
  }
  
  Class CallbackListener {
    Inherit Listener
    private variable callback
    private variable callArguments ""
    Constructor {_callback args} {
      set callback $_callback
      set callArguments $args
    }
    Protected method fire {model event eventData} {
      uplevel \#0 [list $callback $model $event $eventData] $callArguments
    }

    proc addNewListener {model _callback args} {
      set listener [uplevel \#0 [list objectNew [namespace current] $_callback] $args]
      $model addListener $listener
      return $listener
    }
  }
  

  
  Class NativeListener {
    Inherit Listener
    
    Protected method fire { model event eventData } {
      if {[lsearch [$this info function] *::ON_$event] != -1} {
        $this ON_$event $model $eventData
      }
    }
  }

  class MutexModel {
    inherit ::Utilities::Model ::Mutex::MutexHolder
    variable listenerIds

    proc ON_Notify {model listener} {
      if {[catch {$listener execute $model ON_MUTEX [set [$model getMutex] ]}]} {
        $model removeListener $listener
      }
    }
    public method addListener {listener} {
      set listenerIds($listener) [::Mutex::addMutexListener $mutex [list ::Utilities::MutexModel::ON_Notify $this $listener]]
    }

    public method removeListener {listener} {
      if {[info exists listenerIds($listener)]} {
        set listenerId $listenerIds($listener)
        ::Mutex::removeMutexListener $mutex $listenerId
        unset listenerIds($listener)
      }
    }
    
    ;# there is a bug here: the time out should be decreased during while. 
    public method waitForEvent {eventPattern {timeOut 0x7fffffff""}} {
      while 1 {
        if {![::Mutex::waitOnMutex $mutex $timeOut]} {
          return 0
        }
        if {[string match [set $mutex] $eventPattern]} {
          return 1
        }
      }
    }

  }

}

