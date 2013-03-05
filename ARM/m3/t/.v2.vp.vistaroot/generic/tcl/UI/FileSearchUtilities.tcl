
namespace eval ::UI {
  set qa_cache ""
    
  proc get_realfullpathname {docID environment filename} {
    #puts "get_realfullpathname filename = $filename"
    if {$filename == "" || [file exists $filename]} {
      #puts "get_realfullpathname exists RETURN  $filename"
      return $filename
    }
    
    upvar $environment my_env
    if {[array names my_env] == {}} {
      upvar ::env my_env
    }
 
    set real_filename [calculate_pathname my_env $filename]
    if {[file exists $real_filename]} {
      return $real_filename
    }
    
    if {$docID == ""} {
      if {$::Document::Document::currentDocument == ""} {
        return ""
      }
      set docID [$::Document::Document::currentDocument get_ID]
    }
    
    set request_filename [get_request_fullpathname $docID $real_filename]
    if {$request_filename != ""} {
      return $request_filename
    }
    return ""
  }
  
  proc search_realfullpathname {docID filename} {
    #puts "search_realfullpathname: filename = $filename"
    if {$filename == ""} {
      return ""
    }

    if {[file exists $filename]} {
      return $filename
    }

    if {$docID == ""} {
      if {$::Document::Document::currentDocument == ""} {
        return ""
      }
      set docID [$::Document::Document::currentDocument get_ID]
    }
    
    set searchDirList [set [::Document::getModelVariableName $docID SearchDirList]]
    
    if {[::Document::isReplayMode]} {
      lappend searchDirList $qa_cache
    }
    
    if {$searchDirList != ""} {
      set namelist [file split $filename]
      while {[llength $namelist]} {
        foreach dir $searchDirList {
          set name [file join $dir [ eval file join $namelist]]
          if {[file exists $name]} {
            return [update_request_fullpathname $docID $filename $name]
          }
          set name [file join [ file dirname $dir] [ eval file join $namelist]]
          if {[file exists $name]} {
            return [update_request_fullpathname $docID $filename  $name]
          }
        }
        set namelist [lreplace $namelist 0 0]
      }
    }
    
    return ""
  }
  
  proc get_request_fullpathname {docID filename} {
    #puts "get_request_fullpathname filename= $filename"
    if {$filename != ""} {
      if {$docID == ""} {
        if {$::Document::Document::currentDocument == ""} {
          return ""
        }
        set docID [$::Document::Document::currentDocument get_ID]
      }
      set file_array_name [::Document::getModelVariableName $docID RequestSourceFilePairArray]
      if { [info exists [set file_array_name]($filename)] } {
        return $[set file_array_name]($filename)
      }
    }
    return ""
  }
  
  proc update_request_fullpathname {docID filename request_filename} {
    #puts "update_request_fullpathname: filename= $filename request_filename= $request_filename"
    if {$request_filename != "" && [file exists $request_filename]} {
      if {$docID == ""} {
        if {$::Document::Document::currentDocument == ""} {
          return ""
        }
        set docID [$::Document::Document::currentDocument get_ID]
      }         
      set file_array_name [::Document::getModelVariableName $docID RequestSourceFilePairArray]

      
      set [set file_array_name]($filename) $request_filename

      #puts "new array: \n [parray [set file_array_name]]\n"
      return $request_filename
    }
    return ""
  }

  proc calculate_pathname {environment filename} {
    #puts "calculate_pathname filename = $filename"
    if {$filename == ""} {
      return $filename
    }
    
    upvar $environment my_env
    if {[array names my_env] == ""} {
      upvar ::env my_env
    }
    
    set counter 0
    set namelist [file split $filename]
    foreach name $namelist {
      if {[string first "\$" $name] == 0} {
        set name_env [string range $name 1 end]
        if {[info exists my_env($name_env)]} {
          set namelist \
              [lreplace $namelist $counter $counter $my_env($name_env)]
        }
      }
      incr counter
    }
    #puts "calculate_pathname return  [eval file join $namelist]"
    return [eval file join $namelist]
  }

}
