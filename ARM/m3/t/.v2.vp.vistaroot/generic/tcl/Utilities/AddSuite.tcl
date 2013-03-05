namespace eval ::Utilities {
#see description of usage in src/doc/HowToAddTestcasesAutomatically.doc

#usage : for regression suites call : createProject $dir $sourcePath "systemc" "Regtests"
#where $sourcePath is something like "./testcases/systemC-regtests-2.0.1/tests/systemc/datatypes/int/arith/arith01"
  proc createProject {directoryName sourcePath {nameStartToken ""} {prefix ""}} {
    set projectName $sourcePath

    set index [string first $nameStartToken $sourcePath]
    if {$index !=-1} {
      set projectName [string range $projectName [expr $index + [string length $nameStartToken]] end]
    } 
    set separator [file separator $sourcePath]
    set projectName $prefix[string map "$separator _" $projectName]
    puts "call create_project_cmd $projectName $directoryName"
    return [::v2::tcl_interface::create_project_cmd $projectName $directoryName]
  }
  

  proc addFilesToProject {sourcePath projectPath} {
    set filesList [getFilesList $sourcePath]
    puts "addFilesToProject : projectPath=$projectPath sourcePath=$sourcePath \nFiles=$filesList"
    return [::v2::tcl_interface::add_files_to_project_cmd $projectPath $filesList]
  }
#recursive 
  proc getFilesList {directoryName} {
    puts "getFilesList $directoryName"
    set res ""
    set filesList [glob -nocomplain -directory $directoryName *]
    foreach file $filesList {
      puts "---file=$file---"
      if {[string compare $file [file join $directoryName "CVS"]]} {
        if { [file isdirectory $file]} {
          set list [getFilesList $file ]
          if {$list != ""} {
            append res " $list"
          }
        } else {
          append res " $file"
        }
             
      }
    } 
    return $res;
  }

  proc createRegSuitesProject { directoryName sourcePath {nameStartToken "systemc" } {prefix "Regtests"} } {
    set status 0
    set projectPath [createProject $directoryName $sourcePath $nameStartToken $prefix ]
    if {$projectPath != ""} {
      if {[addFilesToProject $sourcePath $projectPath]} {
#call to guess_design_for_project_cmd should be removed after sc_main will be distinguished automatically during the compilation
        set designName [::v2::tcl_interface::guess_design_for_project_cmd $projectPath]
        puts "found design: $designName"
        set status 1
      }
    }

    if {$status} {

      puts "========Project $projectPath was created successfully.========"
      set projectName [::v2::tcl_interface::get_project_name_by_path_cmd $projectPath]
      puts "projectName=$projectName"

      puts "To build project invoke : vista_build_project  $projectName "
      puts "To simulate project invoke: ::Utilities::simulateRegSuitesProject $projectName  $sourcePath [file tail [glob -nocomplain $sourcePath/golden/*.log]]\n\n"
      return $projectPath
    } else {
      puts "Failed to create project $projectPath."
      return ""
    }
  }
  proc simulateRegSuitesProject {projectName sourcePath logfile}  {
      puts "========Simulating project========="
      puts "command : eval exec vista_simulate $projectName > $logfile"
      
      eval exec vista_simulate $projectName > $logfile
      puts "========Comparing simulation resullts========="
      puts "command :   {  exec diff $logfile $sourcePath/golden/$logfile}"
      eval  exec diff $logfile $sourcePath/golden/$logfile
  }
#   proc createGroupOfRegSuitesProjects {directory count {tag "test"}} {
#     set projectPath ""
#     set tag_suffix ""
#     for { set i 1} {$i <=$count} {incr i} {
#       set tag_label $tag$i
#       set tag_suffix $i
#       if {$i<10} {
#         set tag_suffix "0$i"
#         set tag_label $tag$tag_suffix
#       }
#       set projectPath [::Utilities::createRegSuitesProject [pwd] $directory/$tag_label]
#     }
#     if {$projectPath!=""} {
#       puts "last project path=$projectPath"
#       set projectName [::v2::tcl_interface::get_project_name_by_path_cmd $projectPath]
#       puts "last projectName=$projectName tag_suffix=$tag_suffix"
#       set index [string last $tag_suffix $projectName]
#       if {$index !=-1} {
#         set projectName [string range $projectName 0 [expr $index -1]]
#       }
#       puts "***********************\nTo build group of projects invoke: ./regtests_compile.sh $projectName $count\n*******************" 
#     }
#   } 
  proc createGroupOfRegSuitesProjectsFromRoot {root} {
    return [createGroupOfProjectsFromRoot $root "systemc" "Regtests"]
  }
  proc createGroupOfProjectsFromRoot {root {nameStartToken "" } {prefix ""}} {
    set nameslist  [_createGroupOfProjectsFromRootImpl $root $nameStartToken $prefix]
    if {$nameslist!= ""} {
      puts "***********************\nTo build group of projects invoke: $::env(V2_HOME)/testcases/compile_projects.sh $nameslist\n*******************" 
    }
   return $nameslist
}

#recursive
  proc _createGroupOfProjectsFromRootImpl {root nameStartToken prefix} {
    set nameslist ""
    set filelist [glob -nocomplain -directory $root -type f *.\[ch\]*]
    if {$filelist !=""} {
      set projectPath ""
      set projectPath [::Utilities::createRegSuitesProject [pwd] $root $nameStartToken $prefix]
      if {$projectPath!=""} {
        set projectName  " [::v2::tcl_interface::get_project_name_by_path_cmd $projectPath]"
        if {$projectName!=""} {
          append nameslist " $projectName"
        }
      }
    } else {
      set dirlist [glob -nocomplain -directory $root -type d *]
      puts "dirlist=$dirlist"

      foreach dir $dirlist {
        if {[file tail $dir] != "CVS"} {
          set list [_createGroupOfProjectsFromRootImpl $dir $nameStartToken $prefix]
          if {$list!=""} {
            append nameslist " $list"
          }
        }
        
      }
    } 
#    puts "nameslist=$nameslist"
    return $nameslist;

  }
}
