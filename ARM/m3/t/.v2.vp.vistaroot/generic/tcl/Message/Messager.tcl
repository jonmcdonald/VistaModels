Namespace eval ::Message {
  Namespace eval Codes {
    # variable message should be defined
  }
  
  Proc isMessageDefined {stdErrCode} {
    variable message
    return [info exist ::Message::Codes::message($stdErrCode)]
  }
  
  Proc getMessage {stdErrCode args} {
    variable message
    if {[info exist ::Message::Codes::message($stdErrCode)]} {
      return [ eval {format [set ::Message::Codes::message($stdErrCode)]} $args ]
    } else {
      return "$stdErrCode $args"
    }
  }
  
  
  set messageManager ""
  
  Proc getMessageManager {} {
    variable messageManager
    if {$messageManager == ""} {
      set messageManager [objectNew ::Message::MessageManager]
    }
    return $messageManager
  }
  
  Proc addMessage {severity message {info ""} {code ""}} {
    [getMessageManager] addMessage [list -severity $severity -message $message -code $code -info $info]
  }
  
  Proc addStdMessage {severity code args} {
    set message [ eval {getMessage $code } $args ]
    addMessage $severity $message "" $code
  }
  
  Class MessageManager {
    private variable messageReceiverList {}
    
    Public method addMessageReceiver {pMessageReceiver} {
      lappend messageReceiverList $pMessageReceiver
    }
    
    Public method removeMessageReceiver {pMessageReceiver {isDestruct 1}} {
      ::List::removeItem messageReceiverList $pMessageReceiver
      if {$isDestruct} {
        delete object $pMessageReceiver
      }
    }
    
    Public method getMessageReceiverList {} {
      return $messageReceiverList
    }
    
    public method addMessageToMessageReceiver {messageReceiver messageContent} {
      if {[info command $messageReceiver] != ""} {
        $messageReceiver addMessage $messageContent
      } else {
        removeMessageReceiver $messageReceiver 0
      }
    }
    
    Public method addMessage {messageContent} {
      foreach messageReceiver [getMessageReceiverList] {
        addMessageToMessageReceiver $messageReceiver $messageContent
      }
    }
    
  }
  
  
  Class MessageReceiver {
    
    protected variable severityList ""
    
    Public method getSeverityList {} {
      return $severityList
    }
    
    Public method setSeverityList {_severityList} {
      set severityList $_severityList
    }
    
    Public method addSeverity {severity} {
      lappend severityList $severity
    }
    
    Public method removeSeverity {severity} {
      set severityList [::List::ldeleteList $severityList [list $severity]]
    }
    
    protected method filterMessage {messageContent} {
      set severity [getOption $messageContent -severity]
      if {[lsearch -exact $severityList $severity] != -1 || [lsearch -exact $severityList "all"] != -1} {
        return 1
      } else {
        return 0
      }
    }
    
    protected method getHeader {messageContent} {
      set tag [getOption $messageContent -tag]
      set severity [getOption $messageContent -severity]
      return "<<<$tag $severity>>>"
    }
    protected method getContent {messageContent} {
      return [getOption $messageContent -message]
    }
    protected method getTail {messageContent} {
      return ""
    }
    protected method buildRecord {messageContent} {
      set header [getHeader $messageContent]
      set content [getContent $messageContent]
      set tail [getTail $messageContent]
      return "$header$content$tail"
    }
    protected method saveMessage {messageContent} {
      set record [buildRecord $messageContent]
      saveRecord $record
    }
    
    protected method saveRecord {record}
    
    protected method loadRecord {}
    
    
    Public method addMessage {messageContent} {
      if {[filterMessage $messageContent]} {
        saveMessage $messageContent
      }
    }
    
    public method queryMessageContentList {args}
  }
  
  Class StderrMessageReceiver {
    Inherit ::Message::MessageReceiver
    
    constructor {} {
      set severityList {bug fatal error}
    }
    
    #     protected method filterMessage {messageContent} {
    #       set severity [getOption $messageContent -severity]
    #       if {$severity == "bug" || $severity == "fatal" || $severity == "error"} {
    #         return 1
    #       }
    #       return 0
    #     }
    protected method saveRecord {record} {
      puts stderr $record
    }
  }
  
  Class StdoutMessageReceiver {
    Inherit ::Message::MessageReceiver
    
    constructor {} {
      set severityList {note warning}
    }
    
    #     protected method filterMessage {messageContent} {
    #       set severity [getOption $messageContent -severity]
    #       if {$severity == "note" || $severity == "warning"} {
    #         return 1
    #       }
    #       return 0
    #     }
    protected method saveRecord {record} {
      puts stdout $record
    }
  }
  
  Class LogFileReceiver {
    Inherit ::Message::MessageReceiver
    
    private variable logFileName
    private variable fileHandle
    
    constructor {} {
      set severityList {all}
    }
    
    destructor {
      catchNotify {closeFile}
    }
    Public method setLogFile {_logFileName} {
      catchNotify {closeFile}
      set logFileName $_logFileName
    }
    Public method getLogFile {} {
      return $logFileName
    }
    protected method getHeader {messageContent} {
      set tag [getOption $messageContent -tag]
      set severity [getOption $messageContent -severity]
      return "<<<$tag $severity ([clock format [clock seconds]])>>>"
    }
    protected method getContent {messageContent} {
      set severity [getOption $messageContent -severity]
      if {$severity == "bug" || $severity == "fatal" || $severity == "error"} {
        return [join $messageContent]
      }
      return [getOption $messageContent -message]
    }
    protected method saveRecord {record} {
      if {![isFileOpen]} {
        if [catch {
          openFile
        } msg] {
          puts stderr "Can not open the logFile: $msg."
          return ""
        }
        set openedHere 1
      } else {
        set openedHere 0
      }
      if [catch {
        puts $fileHandle $record
      } msg] {
        puts stderr "Can not write into the logFile: $msg."
      }
      if {$openedHere} {
        closeFile 
      }
    }
    public method openFile {{mode a}} {
      if {![isFileOpen]} {
        set fileHandle [open $logFileName $mode]
      }
      return $fileHandle
    }
    public method closeFile {} {
      if {[isFileOpen]} {
        close $fileHandle
        unset fileHandle
        return 0
      }
      return -1
    }
    public method getFileHandle {} {
      if {[isFileOpen]} {
        return $fileHandle
      }
      return ""
    }
    public method isFileOpen {} {
      return [info exist fileHandle]
    }
    public method flush {} {
      if {[isFileOpen]} {
        ::flush $fileHandle
      }
    }
  }
  
  
  # documentation 


  doc isMessageDefined {
    {Description "Checks whether the standard message is defined for code."}
    {Arguments {
      {stdErrCode "The message code"}
    }}
    {Results "(1|0)"}
    
    {Example {}}
  }
  doc getMessage {
    {Description "Returns the standard message for code."}
    {Arguments {
      {stdErrCode "The message code"}
      {args "The arguments required by the message."}
    }}
    {Results "Message string"}
    
    {Example {}}
  }
  
  doc addStdMessage {
    {Description "Generates a standard message."}
    {Arguments {
      {severity "One of the following: fatal, error, warning, note."}
      
      {code "The message code."}
      {args "The arguments required by the message."}
    }}
    {Results "none"}
    
    {Example {}}
  }
  
  doc addMessage {
    {Description "Generates a message."}
    {Arguments {
      {severity "One of the following: fatal, error, warning, note."}
      
      {message "The message string."}
      {code "The message code."}
      {info "Additional information about a message. Defaults to \"\"."}
      {code "Additional code. Defaults to \"\"."}
    }}
    {Results "none"}
    
    {Example {}}
  }
  
  
}

