namespace eval ::v2::project {
  proc find_packages {}  {
    set files {}
    if {![info exists ::env(PERL5LIB)]} {
      return {}
    }
    set directories [split $::env(PERL5LIB) ":"]
    foreach dir $directories {
      if {$::tcl_platform(platform) == "windows"} {
        set dir [regsub {^/(.)/} "$dir/vista_packages" {\1:/}]
      } else {
        set dir "$dir/vista_packages"
      }
      if {![file isdirectory "$dir"]} {
        continue
      }
      set files [concat $files [glob -nocomplain -directory $dir -tails "*.pm"]]
    }
    set files [lsort  -dictionary -unique $files]
    set result {}
    foreach file $files {
      lappend result [file rootname $file]
    }
    return $result
  }

  proc get_project_document_id_by_name {projectName} {
    foreach d [::Document::get_document_ids] {
      if {[::Document::getDocumentType $d] != "DocumentTypeProject"} {
        continue
      }
      set theProjectName [::Utilities::safeGet [::Document::getModelVariableName $d ProjectName]]
      if {![string equal $theProjectName $projectName]} {
        continue
      }
      return $d
    }
    error "Project $projectName is not found"
  }

  proc run_command_on_project {projectName args} {
    set project_document_id [get_project_document_id_by_name $projectName]
    eval [list ::Document::runCommand $project_document_id] $args
  }

  proc recognize_schematics_h_file {file} {
    if {![file readable $file]} {
      return 0
    }
    set result 0
    catch {
      set filebody [read_file $file]
      set result [expr {[regexp {[ \t]*\$includes_begin} $filebody] || \
                            [regexp {[ \t]*\$module_begin[ \t]*\([ \t]*} $filebody] \
                          }]
      
      
    }
    return $result
  }

}

