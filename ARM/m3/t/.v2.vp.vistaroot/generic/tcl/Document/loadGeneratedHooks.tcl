namespace eval ::Document {
  proc loadGeneratedHooks {hooksDirectory} {
    set load_hooks_only 1
    catch {
      namespace eval tmp_space {
        proc hook {name arguments body} {
          ::Document::addHookToCollection $name $arguments [split $body \n]
#          puts "$name {$arguments} {$body}"
          #          puts [lindex [info level 0] 2]
          
        }
        set load_hooks_only 1
      }
      foreach file [glob -nocomplain $hooksDirectory/*.tcl] {
        if {[string compare [file tail $file] "Loader.tcl"]} {
          namespace eval tmp_space [list source $file]
        }
      }
    }
    catch { 
      if {[namespace exists $tmp_space]} {
        namespace delete $tmp_space 
      }
    }
  }
}
