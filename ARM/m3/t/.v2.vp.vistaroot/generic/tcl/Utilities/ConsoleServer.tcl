namespace eval ::Utilities {
  class ConsoleServer {
    
    private variable clients
    private variable serverSocket
    private variable serverPort
    private variable interpPath
    private variable isInsideEval
    private variable mainLoopCallback
    private variable callbackFeature
    
    constructor {{_interpPath ""}} {
      set interpPath $_interpPath
      createServerSocket
      set isInsideEval 0
      set mainLoopCallback 0
      set callbackFeature [expr {[info commands ::enableMainLoopCallback] != "" && \
                                     [info commands ::disableMainLoopCallback] != ""}]
    }
    
    destructor {
      if {$serverSocket != ""} {
        catch {ipcDebug "close $serverSocket"}
        catch {close $serverSocket}
      }
    }
    
    public method print {} {
      foreach sock [array names clients] {
        puts "<<<$sock $clients($sock)>>>\n"
      }
    }
    
    public method getServerPort {} {
      return $serverPort
    }
    
    public method sendToClients {string} {
      foreach client [array names clients] {
        catch {sendString $client $string}
      }
    }
    
    private method createServerSocket {} {
      for {set serverPort 10000} {$serverPort < 20000} {incr serverPort} {
        if {![catch {set serverSocket [socket -server [namespace code [list $this onConnect]] $serverPort ]} msg]} {
          return
        }
      }
      error $msg
    }
    
    private method closeConnection {sock} {
      catch {ipcDebug "close $sock"}
      catch {close $sock}
      catch {unset clients($sock)}
    }
    
    private method sendString {sock string} {
      if {[catch {
        puts -nonewline $sock $string
        flush $sock
      } result]} {
        closeConnection $sock
      }
      return ""
    }
    
    private method sendPrompt {sock} {
      sendString $sock "% "
    }
    
    private method isResetSignature {str} {
      return [expr {"$str" == "@@@CLEAR_DATA@@@"}]
    }
    
    private method readExpression {sock pExpression} {
      set ret "closed"
      catch {
        if {![eof $sock] && [gets $sock line] != -1} {
          if {[isResetSignature $line]} {
            set ret "reset"
          } else {
            upvar $pExpression expression
            set expression $line
            set ret "ok"
          }
        }
      }
      return $ret
    }
    
    private method onConnect {sock addr port} {
      ipcDebug "Accept $sock from $addr port $port"
      set clients($sock) ""
      fconfigure $sock -buffering line -translation {binary binary}
      fileevent $sock readable [list $this onClientCall $sock]
      sendPrompt $sock
    }
    
    
    public method onClientCall {sock} {
      set ret [readExpression $sock line]
      switch -exact -- $ret {
        "closed" {
          deleteDelayCalls $sock
          closeConnection $sock
        }
        "reset" {
          sendString $sock "\n"
          sendPrompt $sock
          deleteDelayCalls $sock
        }
        "ok" {
          append clients($sock) "$line\n"
          serviceCall $sock
        }
      }
    }
    
    private method delayCall {sock} {
      addMainLoopCallback
    }
    
    private method deleteDelayCalls {sock} {
      set clients($sock) ""
      foreach sock [array names clients] {
        if {$clients($sock) != ""} {
          return
        }
      }
      removeMainLoopCallback
    }
    
    private method addMainLoopCallback {} {
      if {$callbackFeature} {
        if {$mainLoopCallback == 0} {
          set mainLoopCallback 1
          ::enableMainLoopCallback
          trace variable ::mainLoopMutex w [list $this checkDelay]
        }
      }
    }
    
    private method removeMainLoopCallback {} {
      if {$callbackFeature} {
        if {$mainLoopCallback != 0} {
          set mainLoopCallback 0
          ::disableMainLoopCallback
          trace vdelete ::mainLoopMutex w [list $this checkDelay]
        }
      }
    }
    
    public method checkDelay {args} {
      foreach sock [array names clients] {
        set expression $clients($sock)
        if {$expression != ""} {
          serviceCall $sock
        }
      }
    }
    
    private method serviceCall {sock} {
      set expression $clients($sock)
      if {[info complete $expression]} {
        if {$isInsideEval} {
          delayCall $sock
        } else {
          set isInsideEval 1
          set clients($sock) ""
          deleteDelayCalls $sock
          catch {
            interp eval $interpPath [list uplevel \#0 $expression]
          } result
          sendString $sock "$result\n"
          sendPrompt $sock
          set isInsideEval 0
          $this checkDelay
        }
      }
    }
    
  }
}
