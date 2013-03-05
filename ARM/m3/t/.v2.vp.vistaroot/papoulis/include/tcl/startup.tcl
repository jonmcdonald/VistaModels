
;#************************************************************
;#                                                            
;#      Copyright Mentor Graphics Corporation 2006 - 2012     
;#                  All Rights Reserved                       
;#                                                            
;#       THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY      
;#         INFORMATION WHICH IS THE PROPERTY OF MENTOR        
;#         GRAPHICS CORPORATION OR ITS LICENSORS AND IS       
;#                 SUBJECT TO LICENSE TERMS.                  
;#                                                            
;#************************************************************


;# TCL startup script.
;# This file is sourced very early (from init.cpp of this package);
;# please do not add *any* application code here.

proc load_tcl_index { package_name } {
  global auto_index 
  set dir [file join $::papoulis_include_dir $package_name]
  set tcl_index_file [file join $dir tclIndex]
  if { [file isfile $tcl_index_file] && [file readable $tcl_index_file] } {
    source $tcl_index_file
  }
}

proc source_tcl_init { file_path } {
  uplevel [list source $file_path]
}

;# package hook mechanism
rename package package_orig_mgc_10012008
proc package { args } {
  set retv [eval package_orig_mgc_10012008 $args]
  set command [lindex $args 0]
  if { $command == "require" } {
    set package_name [lindex $args 1]
    set posthook "::tcl::on_package_${package_name}_loaded"
    if { [info commands $posthook] != {} } {
      catch {
        $posthook
      }
    }
  }
  return $retv
}
