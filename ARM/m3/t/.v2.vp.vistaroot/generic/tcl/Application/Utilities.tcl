namespace eval ::Application {

  proc loadAliveApplications {appName host} {
    set appList {}
    foreach pid [::Application::appRegistry getProcessList $appName $host] {
      if {[::Utilities::isUniqueProcessExist $pid]} {
        catch {lappend appList [::Application::appFactory load $appName $host $pid]}
      }
    }
    return $appList
  }

  proc loadApplications {appName host} {
    set appList {}
    foreach pid [::Application::appRegistry getProcessList $appName $host] {
      catch {lappend appList [::Application::appFactory load $appName $host $pid]}
    }
    return $appList
  }

  proc cleanAppRegistry {appName host} {
    foreach pid [::Application::appRegistry getProcessList $appName $host] {
      if {![::Utilities::isUniqueProcessExist $pid]} {
        set pRegistryDirectory [::Application::appRegistry getAppDirectory $appName $host $pid]
        catch {$pRegistryDirectory deleteDirectoryFromRegistry}
        catch {delete object $pRegistryDirectory}
      }
    }
  }


  
}
