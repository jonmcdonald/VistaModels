namespace eval ::Utilities {
  
  proc canWriteToFile {fileName} {
    return [expr {$fileName != "" && (([file writable $fileName] && ![file isdirectory $fileName] ) || (![file exist $fileName] && [file writable [file dirname $fileName]]))}]
  }
  #returns 1 if file exists and is readable or if file does not exist and it's directory is readable
  proc canBeReadable {fileName} {
    set errorString ""
    if { [catch { file attributes $fileName } ] } {
      set errorString $::errorInfo   
    } 
    set index [string first ":" $errorString]
    if {$index != "-1"} {
      if {[string  first " permission denied" $errorString $index] != -1} {
        return 0;
      } else {
        return 1;
      }
    }
    return [file readable $fileName]
  }
  ;# yet, compare as string. Should understand a relative pathes
  proc comparePathes {path1 path2} {
    return [string compare $path1 $path2]
  }
  
  proc safeDeleteFile {fileName} {
    if [file exist $fileName] {
      file delete -force $fileName
    }
  }
  
  proc pathUnix2Win {path} {
    regsub -all / $path {\\} path
    return $path
  }
  
  proc pathWin2Unix {path} {
    regsub -all {\\} $path / path
    return $path
  }

  proc pathMakeNative {path} {
    if {[isUnix]} {
      return [pathWin2Unix $path]
    } else {
      return [pathUnix2Win $path]
    }
  }
  
  proc setPermission {fileName octPermission} {
    if {[isUnix]} {
      file attributes $fileName -permissions $octPermission
    } else {
      file attributes $fileName -readonly [expr [::Utilities::isUserWritable $octPermission] == 0]
    }
  }
  
  proc getPermission {fileName} {
    if {[isUnix]} {
      return [file attributes $fileName -permissions]
    } else {
      set perm 0
      if {[file readable $fileName]} {
        set perm 0444 
      }
      if {[file writable $fileName]} {
        set perm [expr $perm | 0222]
      }
      if {[file executable $fileName]} {
        set perm [expr $perm | 0111]
      }
      return $perm
    }
  }

}

