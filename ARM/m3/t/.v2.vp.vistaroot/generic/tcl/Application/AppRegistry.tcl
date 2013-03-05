namespace eval Application {
  
  class AppRegistry {
    # returns HomeDirectory
    # Unix - $HOME, PC - HKEY_CURRENT_USER
    private method getRoot {} {
      return [::FileRegUtil::getHomeDirectory]/.summit
    }

    # returns $HOME/.summit/appName
    private method getApplicationRoot {appName} {
      return [getRoot]/$appName
    }

    # returns $HOME/.summit/appName/hostName
    # temporrary public
    public method getHostRoot {appName hostName} {
      return [getApplicationRoot $appName]/$hostName
    }

    private method getProcessRoot {appName hostName uniqProcessId} {
      return [getHostRoot $appName $hostName]/$uniqProcessId
    }
    

    # public part

    # returns list of registered applications (names)
    public method getAppNameList {} {
      return [::FileRegUtil::getSubdirectories [getRoot]]
    }

    # returns list of hosts for application
    public method getHostNameList {appName} {
      return [::FileRegUtil::getSubdirectories [getApplicationRoot $appName]]
    }
    
    # returns list of registered processes
    public method getProcessList {appName hostName} {
      set hostRoot [getHostRoot $appName $hostName]
      return [::FileRegUtil::getSubdirectories $hostRoot]
    }

    # creates new RegistryDirectory object
    public method getAppDirectory {appName host pid} {
      return [objectNew ::Utilities::RegistryDirectory [getProcessRoot $appName $host $pid]]
    }

    # checks, whether a registry information for the specified parameters exists
    public method isAppDirectoryExist {appName host pid} {
      return [::FileRegUtil::isDirectoryExists [getProcessRoot $appName $host $pid]]
    }

  }
  
  AppRegistry appRegistry
  
}
