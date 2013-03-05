namespace eval ::Net::Ipc {

  class ConnectionFactory {
 
    private variable builders
    
    public method registerBuilder {connectionName builder} {
      set majorConnectionName [::Utilities::MajorName::getMajorName $connectionName]
      set builders($majorConnectionName) $builder
    }
    
    protected method getBuilder {connectionName} {
      set majorConnectionName [::Utilities::MajorName::getMajorName $connectionName]
      if {[info exists builders($majorConnectionName)]} {
        return $builders($majorConnectionName)
      }
      error "There is no registered builder for $connectionName"
    }
    
    public method build {connectionName} {
      return [[getBuilder $connectionName] build]
    }
    
    public method buildByRemoteRequest {connectionName application {arguments {}}} {
      return [[getBuilder $connectionName] buildByRemoteRequest $connectionName $application $arguments]
    }

  }

  ConnectionFactory connectionFactory
  
}
