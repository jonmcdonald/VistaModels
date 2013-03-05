namespace eval ::Utilities {
  
  set myPids {}
  
  proc forgetDeadChildren {} {
    if {([llength [info commands ::infox]] == 0) || ![infox have_waitpid]} {
      proc forgetDeadChildren {} {}
    }
    set newList {}

    foreach pid $::Utilities::myPids {
      catch {
        catch {
          ::wait -nohang $pid
        }
        if {[::Utilities::isProcessExist $pid]} {
          lappend newList $pid
        }
      }
    }
    set ::Utilities::myPids $newList
  }

  proc registerPids {pids} {
    if {([llength [info commands ::infox]] == 0) || ![infox have_waitpid]} {
      proc registerPids {pids} {}
    }
    set ::Utilities::myPids [concat $::Utilities::myPids $pids]
  }

  proc getNullDevice {} {
    if {[::Utilities::isUnix]} {
      return /dev/null
    }
    return nul
  }
  
  proc getRedirections {executable} {
    set stdin [resolveAppEnvVariable $executable STDIN]
    set stdout [resolveAppEnvVariable $executable STDOUT]
    set stderr [resolveAppEnvVariable $executable STDERR]
    set redirections ""
    if {$stdin != ""} {
      append redirections "< $stdin"
    }
    if {$stdout != ""} {
      append redirections " >> $stdout"
    }
    if {$stderr != ""} {
      append redirections " 2>> $stderr"
    }
    return $redirections
  }
  
  proc getExecCommand {executable arguments} {
    set command [concat [list $executable] $arguments]
    set deb [getExecutableDebugger $executable]
    if {$deb != ""} {
      set command [concat [list $deb] $command]
    }
    return $command
  }


  proc execInternal {executable arguments ampersand} {
    catch {::Utilities::forgetDeadChildren}
    return [eval exec [getExecCommand $executable $arguments] [getRedirections $executable] $ampersand]
  }

  proc runProcess {executable arguments environment pwd {ampersand ""}} {
    runProcessInternal $executable $arguments $environment $pwd $ampersand
  }

  proc runProcessInternal {executable arguments environment pwd ampersand} {
    set ::errorInfo ""
    array set oldEnv [array get ::env]
    set oldPwd [pwd]
    set catchStatus [ catch {
      array set ::env $environment
      catch { cd $pwd }
      ::Utilities::withVariable ::env(PWD) $pwd {
        set result [execInternal $executable $arguments $ampersand]
      }
    } msg ]
    set errorInfo $::errorInfo
    set errorCode $::errorCode
    catch {array set ::env [array get oldEnv]}
    catch {cd $oldPwd}
    if {$catchStatus} {
      error $msg $errorInfo $errorCode
    }
    return $result
  }
}

rename exec ::Utilities::exec_orig
proc exec {args} {
  set result [eval ::Utilities::exec_orig $args]
  if {[string range $args end end] == "&"} {
    ::Utilities::registerPids $result
  }
  return $result
}
