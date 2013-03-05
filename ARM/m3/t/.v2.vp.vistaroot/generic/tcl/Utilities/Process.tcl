namespace eval ::Utilities {
  
  class Process {
    private variable host
    private variable pid
    
    constructor {_host _pid} {
      set host $_host
      set pid $_pid
    }

    public method getPid {} {
      return $pid
    }

    public method getHost {} {
      return $host
    }

    public method kill {} {
    }

    public method isExists {} {
      return [::Utilities::isUniqueProcessExist $pid]
    }
    
    public method getSystemPid {} {
      if {[regexp {^([0-9]+)} $pid all result]} {
        return $result
      }
      return -1
    }

  }

}
