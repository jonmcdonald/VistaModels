namespace eval ::Utilities {
  proc escapeForMake {str} {
#    regsub -all -expanded "=" $str "\\=" str
    regsub -all -expanded "\[\n\r\]" $str " " str
    regsub -all -expanded "\(\\\$\)\(\[a-zA-Z0-9_\]+\)" $str "\\1(\\2)" str
    regsub -all -expanded "\(\['\"\]\)" $str "\\\\\\1" str
    return $str
  }
  proc extendedEscapeForMake {str} {
    regsub -all -expanded "\[\n\r\]" $str " " str

    #The result of this level of escaping will be inserted directly to .cmd file
    #Example:
    #COMPANY="Summit Design" will result to:
    #COMPANY='"'Summit' 'DESIGN'"'

    regsub -all -expanded "\\\\" $str "\\\\\\\\" str
    regsub -all -expanded "@" $str "A@" str
    regsub -all -expanded "'" $str "B@" str
    regsub -all -expanded {([)(>< \"])} $str "'\\1'" str
    regsub -all -expanded "B@" $str "\"'\"" str
    regsub -all -expanded "A@" $str "@" str

    #This level of escaping is needed for 'echo'
    #See src/make/preMakefile $(v2_echo) '$(v2_gcc_compiler) -c $(v2_cpp_options) $(1) $< -o $@'
    regsub -all -expanded "\\\\" $str "\\\\\\\\" str
    regsub -all -expanded "@" $str "A@" str
    regsub -all -expanded "'" $str "B@" str
    regsub -all -expanded {([)(><\"])} $str "'\\1'" str
    regsub -all -expanded "B@" $str "\"'\"" str
    regsub -all -expanded "A@" $str "@" str

    regsub -all -expanded "\(\\\$\)\(\[a-zA-Z0-9_\]+\)" $str "\\1(\\2)" str
    
    #The result must be enclosed into "'" symbol.
    #This is needed to exclude our string from quotes used by $(v2_echo) command line:
    #$(v2_echo) 'start'str'end'
    return '$str'
  }

  proc flattenFilename {str} {
    set str [::Utilities::escapeForMake $str]
    regsub -all -expanded ":" $str "" str
    regsub -all -expanded "\\$" $str "D" str
    regsub -all -expanded "\\(" $str "_" str
    regsub -all -expanded "\\)" $str "_" str
    regsub -all -expanded "\/\/*" $str "\/" str
    regsub -all -expanded "^\/" $str "" str
    return $str
  }
  proc doubleDollarsEscapeForMake {str} {
    set str [::Utilities::escapeForMake $str]
    regsub -all -expanded "\\$" $str {$$} str
    return $str
  }
  proc objectFileFromCFile {str} {
    set str [::Utilities::flattenFilename $str]
    regsub -all -expanded -nocase "\.c\(xx\|pp|c\)?$" $str ".o" str
    return $str
  }
  proc vpObjectFileFromCFile {str} {
    set str [::Utilities::flattenFilename $str]
    regsub -all -expanded -nocase "\.c\(xx\|pp|c\)?$" $str ".vp.o" str
    return $str
  }
  proc wpObjectFileFromCFile {str} {
    set str [::Utilities::flattenFilename $str]
    regsub -all -expanded -nocase "\.c\(xx\|pp|c\)?$" $str ".wp.obj" str
    return $str
  }
  proc exeFileFromCFile {str} {
    set str [::Utilities::objectFileFromCFile $str]
    regsub -all -expanded -nocase "\.o$" $str ".exe" str
    return $str
  }
  proc vpExeFileFromCFile {str} {
    set str [::Utilities::vpObjectFileFromCFile $str]
    regsub -all -expanded -nocase "\.o$" $str ".exe" str
    return $str
  }
  proc wpExeFileFromCFile {str} {
    set str [::Utilities::wpObjectFileFromCFile $str]
    regsub -all -expanded -nocase "\.obj$" $str ".exe" str
    return $str
  }
  proc dgnFileFromCFile {str} {
    set str [::Utilities::objectFileFromCFile $str]
    regsub -all -expanded -nocase "\.o$" $str ".dgn" str
    return $str
  }
  proc dbFileFromCFile {str} {
    set str [::Utilities::objectFileFromCFile $str]
    regsub -all -expanded -nocase "\.o$" $str ".db" str
    return $str
  }
  proc depFileFromCFile {str} {
    set str [::Utilities::objectFileFromCFile $str]
    regsub -all -expanded -nocase "\.o$" $str ".dep" str
    return $str
  }
  proc convertToUnix {str} {
    if {[is_cygwin] || [is_mingw]} {
      regsub -all -expanded "\(\[a-zA-Z\]+\)\:\(/.*\)" $str "/\\1\\2" str
#      regsub -all " " $str "\\\\ " str
    }
    return $str
  }
  proc convertToPC {str} {
    if {[is_cygwin] || [is_mingw]} {
      regsub -all -expanded "^/\(\[a-zA-Z\]\)\(/.*\)" $str "\\1\:\\2" str
      regsub -all {\\ } $str { } str
    }
    return $str
  }
  proc escapeSpaces {str} {
    if {[is_cygwin] || [is_mingw]} {
      regsub -all " " $str "\\\\ " str
    }
    return $str
  }
}
