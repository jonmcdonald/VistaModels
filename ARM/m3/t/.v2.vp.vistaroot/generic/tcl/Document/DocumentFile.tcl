package require Tclx
namespace eval ::Document {
  proc markDocumentAsLoading {docID} {
    set isLoadingVarName ""
    catch {
      set isLoadingVarName  [::Document::getModelVariableName $docID "IsLoading"]
    }
    if {$isLoadingVarName != "" } {
      set $isLoadingVarName 1
    }
  }

#tagName is a name of first variable saved in docID1
  proc readDocumentFile {file docID0 {docID1 ""} {tagName ""} {onlySecond 0}} {
    set docID $docID0
    markDocumentAsLoading $docID
    
    if {![file exists $file]} {
      return 0
    }
    if { [catch {set f [open $file]}] } {
      if {[info exists ::errorInfo]} {
        set ::errorInfo ""
      }
      return 0;
    }

    catch {
      set data {}
      set tmp {}
      while {[lgets $f tmp] > 0} {
        catch {
          set tag [lindex $tmp 0]

          if {$tagName!="" && [string equal $tag $tagName]} {
            set docID $docID1
            markDocumentAsLoading $docID
            set tagName ""
            set onlySecond 0
          }
          
          if {!$onlySecond} {
            set [::Document::getModelVariableName $docID $tag] [lindex $tmp 1]
          }
        }
      }
    }

    close $f
    return 1;
  }

  proc writeDocumentFile {file docID0 varlist0 {docID1 ""} {varlist1 ""}} {
    if { [catch {set f [open $file "w"]} ] } {
      return 0;
    }
    set valList [list $docID0 $varlist0 $docID1 $varlist1]
    foreach {docID varlist} $valList {
      foreach tagpair $varlist {
        catch {
          set tag [lindex $tagpair 0]
          if {[llength $tagpair] > 1} {
            set type [lindex $tagpair 1]
          } else {
            set type "string"
          }
          set value [set [::Document::getModelVariableName $docID $tag]]
          if {$value != ""} {
            if {$type == "list"} {
              puts $f [list $tag $value]
            } elseif {$type == "pairlist"} {
              set pairsStr ""
              foreach {key val} $value {
                if {[llength $key] > 1} {
                  set key [list $key]
                }
                if {[llength $key] == 0} {
                  set key [list ""]
                }
#                if {[llength $val] > 1} {
#                  set val [list $val]
#                }
#                if {[llength $val] == 0} {
#                  set val [list ""]
#                }
                #always - in order to preserve special characters - ",\ 
                set val [list $val]
                catch {
                  #formatting for readability
                  set val [regsub -all "\} \{" $val "\}\n\t\t\{"]
                  set val [regsub -all "\{\{" $val "\{\n\t\t\{"]
                  set val [regsub -all "\}\}" $val "\}\n\t \}"]
                }
                append pairsStr "\n\t $key $val "
              }
              append pairsStr "\n"
              puts $f [list $tag $pairsStr]
            } else { ;# string
              puts $f [list $tag $value]
            }
          }
        }
      }
      
    }
    close $f
    return 1
  }
  
  
}
