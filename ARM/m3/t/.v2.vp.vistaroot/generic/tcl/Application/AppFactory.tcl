namespace eval ::Application {

  class AppFactory {

    private variable appClasses

    public method registerAppClass {appName appClass} {
      set appClasses($appName) $appClass
    }

    protected method getAppClass {appName} {
      if {[info exists appClasses($appName)]} {
        return $appClasses($appName)
      }
      return ::Application::App
    }
    
    private method buildInternal {appName process pRegistryDirectory} {
      return [objectNew [getAppClass $appName] $appName $process $pRegistryDirectory]
    }
    
    public method build {appName host pid args} {
      set process [objectNew ::Utilities::Process $host $pid]
      set pRegistryDirectory [::Application::appRegistry getAppDirectory $appName $host $pid]
      set application [buildInternal $appName $process $pRegistryDirectory]
      eval {$application init} $args
      return $application
    }

    public method buildCurrentApplication {appName pwd args} {
      set host [::Utilities::getCurrentHostAddr]
      set pid [::Utilities::getUniqueProcessId]
      set exe [info nameofexecutable]
      set process [objectNew ::Utilities::Process $host $pid]
      set pRegistryDirectory [::Application::appRegistry getAppDirectory $appName $host $pid]
      set application [buildInternal $appName $process $pRegistryDirectory]
      withVariable ::argv [::Utilities::safeGet ::argv] {
        eval {$application init $exe $::argv $pwd [array get ::env]} $args 
      }
      $application storeInRegistry
      $application setDeleteFromRegistryOnDestruct 1
      return $application
    }

    private method loadFromDirectoryInternal {appName host pid pRegistryDirectory} {
      set process [objectNew ::Utilities::Process $host $pid]
      set application [buildInternal $appName $process $pRegistryDirectory]
      set catchStatus [ catch {$application loadFromRegistry} msg ]
      if {$catchStatus} {
        set errorInfo $::errorInfo
        set errorCode $::errorCode
        catch {delete object $application}
        error $msg $errorInfo $errorCode
      }
      return $application
    }

    public method load {appName host pid} {
      set pRegistryDirectory [::Application::appRegistry getAppDirectory $appName $host $pid]
      return [loadFromDirectoryInternal $appName $host $pid $pRegistryDirectory]
    }

    public method loadFromDirectory {appName host pid pRegistryDirectory} {
      return [loadFromDirectoryInternal $appName $host $pid [$pRegistryDirectory clone]]
    }

  }

  AppFactory appFactory

}
