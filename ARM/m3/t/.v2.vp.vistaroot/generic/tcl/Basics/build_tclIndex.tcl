package require Itcl
namespace eval :: {
  namespace import -force itcl::*
}
namespace eval ::Basics {

  proc build_tclIndex {path convertScript perl args} {
    set tmpDir _TCLINDEX_
    set fileList [glob -nocomplain $path/*.tcl]
    if {[llength $fileList]} {
      if {[file exist $path/$tmpDir]} {
        file delete -force $path/$tmpDir
      }
      file mkdir $path/$tmpDir
      set pwd [pwd]
      set catchStatus [catch {
        foreach file $fileList {
          eval exec $perl $args {$convertScript $file > $path/$tmpDir/[file tail $file]}
        }
        cd $path/$tmpDir
        auto_mkindex . *.tcl

        set F [open tclIndex r]
        set OUT [open ../tclIndex w]
        set content [read $F]
        regsub -all -line -- "^ *\#.*" $content "" content
        regsub -all -line -- {\[list source \[file join \$dir (.*)\]\]} $content "\[list summit_add_tclindex $path/\\1\]" content
        regsub -all -- "\n\n*" $content "\n" content
        regsub -all -- "^\n*" $content "" content
        puts -nonewline $OUT $content
        close $OUT
        close $F
      } msg]
      set savedErrorInfo $::errorInfo
      set savedErrorCode $::errorCode
      cd $pwd
      file delete -force $path/$tmpDir
      if {$catchStatus} {
        error $msg $savedErrorInfo $savedErrorCode
      }
    } else {
      file delete -force $path/tclIndex
    }
  }
}
