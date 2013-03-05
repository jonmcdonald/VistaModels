namespace eval ::Utilities {
  
  class RegistryDirectory {

    private variable path

    constructor {_path} {
      set path $_path
    }

    public method getRegistryPath {} {
      return $path
    }

    public method setRegistryPath {_path} {
      set path $_path
    }

    public method writeSection {section data} {
      ::FileRegUtil::writeFile $path $section $data
    }

    public method readSection {section {must 0}} {
      set catchStatus [ catch {
        ::FileRegUtil::readFile $path $section
      } result ]
      if {$catchStatus} {
        if {$must} {
          error $result $::errorInfo $::errorCode
        }
        return ""
      }
      return $result
    }
    
    public method isSectionExist {section} {
      ::FileRegUtil::isFileExists $path $section
    }

    public method deleteSection {section} {
      ::FileRegUtil::deleteFile $path $section
    }

    public method makeDirectoryInRegisty {} {
      set section "dummy_section_[::Utilities::createUniqueIdentifier]"
      ::FileRegUtil::writeFile $path $section ""
      ::FileRegUtil::deleteFile $path $section
    }

    public method deleteDirectoryFromRegistry {} {
      ::FileRegUtil::deleteDirectory $path
    }

    public method isDirectoryExistInRegistry {} {
      ::FileRegUtil::isDirectoryExists $path
    }

    public method clone {} {
      return [ objectNew [info class] $path]
    }

  }

}
