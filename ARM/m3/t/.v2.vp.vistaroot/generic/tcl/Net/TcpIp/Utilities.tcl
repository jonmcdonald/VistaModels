namespace eval ::Net::TcpIp {

  proc findAliveServerPortList {serverName} {
    set dir [::Application::appRegistry getHostRoot $serverName [::Utilities::getCurrentHostAddr]]
    set pids [::FileRegUtil::getSubdirectories $dir]
    set resList {}
    foreach pid $pids {
      if {[::Utilities::isUniqueProcessExist $pid]} {
        if {[::FileRegUtil::isFileExists $dir/$pid port]} {
          catch {lappend resList [::FileRegUtil::readFile $dir/$pid port]}
        }
      } else {
        catch {::FileRegUtil::deleteDirectory $dir/$pid }
      }
    }
    return $resList
  }

  proc findAliveServerPort {serverName} {
    return [lindex [findAliveServerPortList $serverName] 0]
  }

}
