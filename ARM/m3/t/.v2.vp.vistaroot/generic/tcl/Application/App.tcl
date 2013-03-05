namespace eval ::Application {

  class App {

    protected variable pRegistryDirectory
    private variable deleteFromRegistryOnDestruct
    private variable name
    private variable process
    private variable exe
    private variable argv
    private variable pwd
    private variable envData
    private variable envReg
    private variable display

    constructor {_name _process _pRegistryDirectory} {
      set name $_name
      set process $_process
      set pRegistryDirectory $_pRegistryDirectory
      set deleteFromRegistryOnDestruct 0
    }

    destructor {
      if {$deleteFromRegistryOnDestruct} {
        catch {$pRegistryDirectory deleteDirectoryFromRegistry}
      }
      catch {delete object $pRegistryDirectory}
      catch {delete object $process}
    }

    public method init {_exe _argv _pwd _envData} {
      set exe $_exe
      set argv $_argv
      set envData $_envData
      set pwd $_pwd
      set display [resolveDisplay]
    }

    public method getRegistryDirectory {} {
      return $pRegistryDirectory
    }

    public method setRegistryDirectory {_pRegistryDirectory} {
      if {"$pRegistryDirectory" != "$_pRegistryDirectory"} {
        delete object $pRegistryDirectory
        set pRegistryDirectory $_pRegistryDirectory
      }
    }

    public method getDeleteFromRegistryOnDestruct {} {
      return $deleteFromRegistryOnDestruct
    }

    public method setDeleteFromRegistryOnDestruct {value} {
      set deleteFromRegistryOnDestruct $value
    }


    public method getProcess {} {
      return $process
    }
    
    public method setProcess {_process} {
      set process $_process
    }

    public method isValid {} {
      return [expr {"$process" == "" || ([::Utilities::objectExists $process] && [$process isExists])}]
    }

    public method getName {} {
      return $name
    }
    
    public method run {} {
      ::Utilities::runProcess [getExecutableForRun] [getArgumentsForRun] [getEnvData] [getPwd] &
    }

    protected method getArgumentsForRun {} {
      return $argv
    }
    
    public method getExecutableForRun {} {
      return $exe
    }

    
    public method getExe {} {
      return $exe
    }

    public method setExe {_exe} {
      set exec $_exe
    }

    public method getArgv {} {
      return $argv
    }

    public method setArgv {_argv} {
      set argv $_argv
    }

    public method getPwd {} {
      return $pwd
    }

    public method setPwd {_pwd} {
      set pwd $_pwd
    }

    public method getEnv {} {
      return [getEnvData]
    }

    public method setEnv {_envData} {
      set envData $_envData
      if {[info exists envReg]} {
        unset envReg
      }
    }

    public method getDisplay {} {
      return $display
    }

    public method setDisplay {_display} {
      set display $_display
    }


    # return 1, if the this application is compatible with a given application
    public method compatibleWith {application {considerName 1}} {
      return [compatibleWithImpl $application $considerName]
    }

    public method storeInRegistry {{_registryDirectory ""}} {
      if {$_registryDirectory == ""} {
        set _registryDirectory $pRegistryDirectory
      }
      storeInRegistryImpl $_registryDirectory
    }

    public method loadFromRegistry {{must 0} {_registryDirectory ""}} {
      if {$_registryDirectory == ""} {
        set _registryDirectory $pRegistryDirectory
      }
      loadFromRegistryImpl $must $_registryDirectory
    }

    protected method storeInRegistryImpl {_registryDirectory} {
      $_registryDirectory writeSection "executable" $exe
      $_registryDirectory writeSection "argv"       [argv2reg $argv]
      $_registryDirectory writeSection "pwd" $pwd
      $_registryDirectory writeSection "env" [getEnvReg]
    }

    private method resolveDisplay {} {
      set ind [lsearch -exact $argv "-display"]
      if {$ind != -1} {
        set _display [lindex $argv [expr {$ind + 1}]]
        if {$_display != ""} {
          return $_display
        }
      }
      array set localEnv [getEnvData]
      if {[info exists localEnv(DISPLAY)]} {
        return $localEnv(DISPLAY)
      }
      return ":0.0"
    }

    protected method loadFromRegistryImpl {must _registryDirectory} {
      set exe            [$_registryDirectory readSection "executable" $must]
      set argv [reg2argv [$_registryDirectory readSection "argv" $must]]
      set pwd            [$_registryDirectory readSection "pwd" $must]
      set envReg         [$_registryDirectory readSection "env" $must]
      if {[info exists envData]} {unset envData}
      set display [resolveDisplay]
    }
    
    protected method compatibleWithImpl {application considerName} {
      return [expr {
                    ($considerName == 0 || ![platform_strcmp "$name" "[$application getName]"]) &&
                    ![platform_strcmp "$exe" "[$application getExe]"] &&
                    ![platform_strcmp "$display" "[$application getDisplay]"] &&
                    ![platform_strcmp "$pwd" "[$application getPwd]"]
                  }]
    }

    private method argv2reg {_argv} {
      return [join $_argv \n]
    }

    private method reg2argv {_regArgv} {
      return [split $_regArgv \n]
    }

    private method env2reg {_envData} {
      array set localEnv $_envData
      set resString ""
      foreach envName [array names localEnv] {
        append resString "\n$envName=$localEnv($envName)"
      }
      return [string range $resString 1 end]
    }

    private method reg2env {_regEnv} {
      set lst [split $_regEnv \n]
      set localEnv {}
      foreach item $lst {
        if {[regexp {^(.+)=(.*)$} $item all key value]} {
          lappend localEnv $key $value
        }
      }
      return $localEnv
    }

    protected method getEnvData {} {
      if {![info exists envData]} {
        if {[info exists envReg]} {
          set envData [reg2env $envReg]
        } else {
          set envData {}
        }
      }
      return $envData
    }
    
    protected method getEnvReg {} {
      if {![info exists envReg]} {
        if {[info exists envData]} {
          set envReg [env2reg $envData]
        } else {
          set envReg {}
        }
      }
      return $envReg
    }
    
  }
  
}

