namespace eval ::Net::Ipc {

  class ConnectionRegistry {
    
    public method getConnectionNameList {application} {
      set appRegistryPath [[$application getRegistryDirectory] getRegistryPath]
      return [::FileRegUtil::getSubdirectories $appRegistryPath/Connections]
    }

    public method getConnectionDirectory {application connectionName} {
      set appRegistryPath [[$application getRegistryDirectory] getRegistryPath]
      return [objectNew ::Utilities::RegistryDirectory $appRegistryPath/Connections/$connectionName]
    }

    public method isConnectionDirectoryExist {application connectionName} {
      set appRegistryPath [[$application getRegistryDirectory] getRegistryPath]
      return [::FileRegUtil::isDirectoryExists $appRegistryPath/Connections/$connectionName]
    }
    
  }
  
  ConnectionRegistry connectionRegistry

}

