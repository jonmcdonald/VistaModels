namespace eval ::FileRegUtil {

  proc fileRegUtil {} {}
  proc getHomeDirectory {} {return /}
  proc writeFile {directory file data} {}
  proc readFile {directory file} {}
  proc deleteDirectory {directory} {}
  proc deleteFile {directory file} {}
  proc delete {path} {}
  proc getSubdirectories {directory {subDirPattern *}} {}
  proc getFiles {directory {filePattern *}} {}
  proc isFileExists {directory file} {return 0}
  proc isDirectoryExists {directory} {return 0}
  proc deletePath {path} {}



#   proc resolveRegistryStyle {} {
#     if {$::tcl_platform(platform) == "windows"} { ;# Windows
#       if {[info exists ::force_use_windows_registry] && $force_use_windows_registry} {
#         return "pc"
#       } else {
#         return "pc_with_home_drive"
#       }
#     } else {
#       return "unix"
#     }
#   }


#   proc deletePath {path} {
#     if {[isDirectoryExists $path]} {
#       deleteDirectory $path
#     } else {
#       set directory [file dirname $path]
#       set file [file tail $path]
#       if {[isFileExists $path]} {
#         deleteDirectory $path
#       }
#     }
#   }
  
#   set registry_style [resolveRegistryStyle]

#   if {$registry_style == "pc"} {
    
#     package require registry
    
#     proc getHomeDirectory {} {
#       return HKEY_CURRENT_USER
#     }
    
#     proc writeFile {directory file data} {
#       registry set [file nativename $directory] $file $data
#     } 
    
#     proc readFile {directory file} {
#       return [registry get [file nativename $directory] $file]
#     }
    
#     proc deleteDirectory {directory} {
#       catch {
#         registry delete [file nativename $directory]
#       }
#     }
    
#     proc deleteFile {directory file} {
#       catch {
#         registry delete [file nativename $directory] $file
#       }
#     }
    
#     proc getSubdirectories {directory {subDirPattern *}} {
#       if {[catch {
#         set resList [registry keys [file nativename $directory] $subDirPattern]
#       }]} {
#         return {}
#       }
#       return $resList
#     }
    
#     proc getFiles {directory {filePattern *}} {
#       if {[catch {
#         set resList [registry values [file nativename $directory] $filePattern]
#       }]} {
#         return {}
#       }
#       return $resList
#     }
    
#     proc isFileExists {directory file} {
#       if {[catch {
#         set resList [registry values [file nativename $directory] $file]
#       }]} {
#         return 0
#       }
#       return [llength $resList]
#     }
    
#     proc isDirectoryExists {directory} {
#       return [expr {! [catch {registry keys [file nativename $directory] *}]}]
#     }
    
#   } else {
#     if {$registry_style == "pc_with_home_drive"} {
#       proc getHomeDirectory {} {
#         variable homeDirectory
#         if {![info exists homeDirectory]} {
#           if {[info exists ::env(HOMEDRIVE)] && [info exists ::env(HOMEPATH)]} {
#             set homedrive $::env(HOMEDRIVE)
#             regsub -all {\\} $::env(HOMEPATH) / homepath
#             set homeDirectory "$homedrive$homepath/Local Settings/Application Data"
#           } else {
#             set homeDirectory "c:/.summit"
#           }
#         }
#         return $homeDirectory
#       }
#     } else {
#       proc getHomeDirectory {} {
#         return $::env(HOME)
#       }
#     }
    
#     proc writeFile {directory file data} {
#       file mkdir $directory
#       write_file $directory/$file $data
#     }
    
#     proc readFile {directory file} {
#       return [read_file -nonewline $directory/$file]
#     }
    
#     proc deleteDirectory {directory} {
#       file delete -force $directory
#     }
    
#     proc deleteFile {directory file} {
#       file delete -force $directory/$file
#     }
    
#     proc getSubdirectories {directory {subDirPattern *}} {
#       set resList {}
#       foreach dir [glob -nocomplain $directory/$subDirPattern] {
#         if {[file isdirectory $dir]} {
#           lappend resList [file tail $dir]
#         }
#       }
#       return $resList
#     }
    
#     proc getFiles {directory {filePattern *}} {
#       set resList {}
#       foreach dir [glob -nocomplain $directory/$filePattern] {
#         if {[file isfile $dir]} {
#           lappend resList [file tail $dir]
#         }
#       }
#       return $resList
#     }
    
#     proc isFileExists {directory file} {
#       return [file exists $directory/$file]
#     }
    
#     proc isDirectoryExists {directory} {
#       return [file isdirectory $directory]
#     }
    
#   } ;# Unix
  
  namespace export *
  
}
