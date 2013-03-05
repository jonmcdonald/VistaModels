#tcl-mode
option add *BaseSourceView.font "-adobe-helvetica-medium-r-normal--12-*-*-*-*-*-*-*" widgetDefault
option add *BaseSourceView.background  \#dfdfdf widgetDefault 
option add *BaseSourceView.foreground black widgetDefault

option add *BaseSourceView.headerfont "-adobe-helvetica-bold-i-normal-*-12-*-*-*-*-*-*-*" widgetDefault
option add *BaseSourceView.headerforeground black widgetDefault
option add *BaseSourceView.headerbackground gray widgetDefault

option add *BaseSourceView.sourcefont "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*" widgetDefault

option add *BaseSourceView.sourcecovinfobg \#969696  widgetDefault
option add *BaseSourceView.sourcelinebg \#dfdfdf widgetDefault
option add *BaseSourceView.sourcebackground white widgetDefault

option add *BaseSourceView.accentfont "-adobe-courier-bold-r-normal--12-*-*-*-*-*-*-*" widgetDefault
option add *BaseSourceView.accentforeground blue widgetDefault
namespace eval ::UI {
  class BaseSourceView {
    inherit itk::Widget ::UI::DocumentUIBuilder
    common qa_cache qa_cache

    protected variable text_widget_list {}
    protected variable additional_text_widget_list {}
    protected variable last_text_line 0

    itk_option define -accentforeground accentforeground Accentforeground blue {
      if {[winfo exists $itk_component(source)]} {
        set list_tags [$itk_component(source) tag names]
        if { [lsearch -exact $list_tags viewRegion] != -1} {
          $itk_component(source) tag configure viewRegion \
              -foreground $itk_option(-accentforeground)
        }
      }
    }

    itk_option define -accentfont accentfont Accentfont "*-fixed-bold-r-normal-*-14-120-*" {
      if {[winfo exists $itk_component(source)]} {
        set list_tags [$itk_component(source) tag names]
        if { [lsearch -exact $list_tags viewRegion] != -1} {
          $itk_component(source) tag configure viewRegion \
              -font $itk_option(-accentfont)
        }
      }
    }
    ::UI::ADD_VARIABLE filedata FileData {}
    ::UI::ADD_VARIABLE currentSourceElementData CurrentSourceElementData {}
    ::UI::ADD_VARIABLE currentline CurrentLine {}
    ::UI::ADD_VARIABLE coveragedata CoverageData {}
    
    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    } {
      construct_variable filedata
      construct_variable currentSourceElementData
      construct_variable currentline
      construct_variable coveragedata
      CreateTable

      eval itk_initialize $args
    } ;# constructor

    destructor {
      destruct_variable filedata
      destruct_variable currentSourceElementData
      destruct_variable currentline
      destruct_variable coveragedata
    } ; # destructor

    public method getFileName  {} { return [lindex $filedata 0] }
    public method getStartLine {} { return [lindex $filedata 1] }
    public method getEndLine   {} { return [lindex $filedata 2] }

    public method getCurrentElementIndex {} { return [lindex $currentSourceElementData 0] }
    public method getViewRegionList {} { return [lindex $currentSourceElementData 1] }

    public method getCoveredFileName {}     { return [lindex $coveragedata 0] }
    public method getCoveredType {}     { return [lindex $coveragedata 1] }
    public method getReportType {}     { return [lindex $coveragedata 2] }
    public method getCoveredDataList {} { return [lindex $coveragedata 3] }

    public method getCoveredDataByIndex {index} { ; # only for seeRegions and clearViewRegions !!!!!!
      foreach coveredDataLine [getCoveredDataList] {
        if {[getElementIndex $coveredDataLine] == $index} {
          return $coveredDataLine
        }
      }
      return ""
    } ; # getCoveredDataByIndex

    public method getElementIndex {coveredDataLine} { return [lindex $coveredDataLine 0] }
    public method getLineNumber   {coveredDataLine} { return [lindex $coveredDataLine 1] }
    public method getHit          {coveredDataLine} { return [lindex $coveredDataLine 2] }
    public method getTotal        {coveredDataLine} { return [lindex $coveredDataLine 3] }
    public method getComment      {coveredDataLine} { return [lindex $coveredDataLine 4] }
    public method getState        {coveredDataLine} { return [lindex $coveredDataLine 5] }
    public method isMultiLine     {coveredDataLine} { return [lindex $coveredDataLine 6] }
    public method isTopLine       {coveredDataLine} { return [lindex $coveredDataLine 7] }
        
    public method gotoLine {line} {
      set text $itk_component(source)
      $text see $line.0
      $text tag delete currentLine
      $text tag add currentLine $line.0 $line.end
      $text tag configure currentLine -foreground red
    } ; #gotoLine
    
    protected method createHeaders {} {
      itk_component add coverage_label {
        label $itk_interior.coverage_label -relief raised -width 8 -bd 1 -highlightthickness 0
      } {
        rename -font -headerfont headerfont Headerfont
        rename -background -headerbackground headerbackground Headerbackground
        rename -foreground -headerforeground headerforeground Headerforeground
      }
      itk_component add line_label {
        label $itk_interior.line_label -relief raised -width 5  -bd 1 -highlightthickness 0 \
          -text "Line"
      } {
        rename -font -headerfont headerfont Headerfont
        rename -background -headerbackground headerbackground Headerbackground
        rename -foreground -headerforeground headerforeground Headerforeground
      }
      itk_component add frame_filename {
        frame $itk_interior.filename -relief raised -bd 1 -highlightthickness 0 
      } {
        rename -background -headerbackground headerbackground Headerbackground
      }
      
      itk_component add frame_filename_in {
        frame $itk_interior.filename.in -bd 0 -highlightthickness 0  
      } {
        rename -background -headerbackground headerbackground Headerbackground
      }
      
      ### file name
      itk_component add filename {
        label $itk_interior.filename.in.source_label -highlightthickness 0 \
            -text "File: " -pady 0 -bd 1
      } {
        rename -font -headerfont headerfont Headerfont
        rename -background -headerbackground headerbackground Headerbackground
        rename -foreground -headerforeground headerforeground Headerforeground
      }
      ### button
      itk_component add filename_button {
        cwidgets::Compoundbutton $itk_interior.filename.in.button -image [::UI::getimage down_sm] \
            -compound smartimage -relief flat -overrelief raised \
            -command [code $this ChangeFile] -padx 3 -pady 3 -highlightthickness 0 
            
      } {
        rename -font -headerfont headerfont Headerfont
        rename -background -headerbackground headerbackground Headerbackground
        rename -foreground -headerforeground headerforeground Headerforeground
        rename -activebackground -headerbackground headerbackground Headerbackground
      }
      pack $itk_interior.filename.in.source_label $itk_interior.filename.in.button \
           -side left -padx 4 -pady 0 
      pack $itk_interior.filename.in

    } ;# createHeaders
    
    protected method createSeparators {} {
      frame $itk_interior.sep_after_coverage -width 1 -background black
      frame $itk_interior.sep_after_line -width 1 -background black
    } ; #createSeparators
    
    protected method createTextWidgets {} {
      ### coverage
      itk_component add coverage {
        text $itk_interior.coverage -width 8
      }  {
        rename -font -sourcefont sourcefont Font
        rename -background -sourcecovinfobg sourcecovinfobg Sourcecovinfobg
      }
      $itk_component(coverage) tag configure right -justify right
      lappend text_widget_list $itk_component(coverage)
      lappend additional_text_widget_list $itk_component(coverage)

      ### line 
      itk_component add line {
        text $itk_interior.line -width 5
      }  {
        rename -font -sourcefont sourcefont Font
        rename -background -sourcelinebg sourcelinebg Sourcelinebg
      }
      lappend text_widget_list $itk_component(line)
      
      ### source
      itk_component add source {
        text $itk_interior.source -bg white \
            -xscrollcommand "$itk_interior.hs set" 
      } {
        rename -font -sourcefont sourcefont Font
        rename -background -sourcebackground sourcebackground Sourcebackground
      }
      lappend text_widget_list $itk_component(source)
    } ; # createTextWidgets

    protected method packComponents {} {
      blt::table $itk_interior \
          $itk_interior.coverage_label 0,2  -fill y\
          $itk_interior.line_label 0,4  -fill y\
          $itk_interior.filename 0,6 -fill x \
          $itk_interior.sep_after_coverage 0,3 -rowspan 2 -fill y \
          $itk_interior.sep_after_line 0,5 -rowspan 2 -fill y \
          $itk_interior.coverage 1,2 -fill y \
          $itk_interior.line 1,4 -fill y \
          $itk_interior.source 1,6 -fill both\
          $itk_interior.bottom_left_filler 2,0 -columnspan 6 -fill both -pady {0 4}\
          $itk_interior.bottom_right_filler 2,7 -fill both -pady {0 4}\
          $itk_interior.hs 2,6 -fill x -pady {0 4}\
          $itk_interior.top_right_filler 0,7 -fill both \
          $itk_interior.vs 1,7 -fill y
      
      blt::table configure $itk_interior r0 r2 c0 c1 c2 c3 c4 c5 c7 -resize none 
    } ; # packComponents
        
    protected method enableTextWidgets {} {
      foreach elem $text_widget_list {
        ::UI::common_set_state_using_option $elem 1
      }
    } ; # enableTextWidgets
    
    protected method disableTextWidgets {} {
      foreach elem $text_widget_list {
        ::UI::common_set_state_using_option $elem 0
      }
    } ; # disableTextWidgets
    
    protected method applyAdditionalData {} {}
    
    protected method seeRegions {}  {
      set viewRegion [getViewRegionList]
      set length [llength $viewRegion]
      if {$length == 0} {
        $itk_component(source) see 0.0
        return
      }
      set firstStartRealLine 0
      set endRealLine 0
      foreach {startLine endLine} $viewRegion {
        if {$startLine == ""} {
          set startLine 0
        }
        if {$endLine == ""} {
          set endLine $startLine
        }
        set startRealLine [getRealNumberLine $startLine]
        set endRealLine [getRealNumberLine $endLine]
        if {[isValidLine $startRealLine] && [isValidLine $endRealLine]} {
          if {$firstStartRealLine == 0 } {
            set firstStartRealLine $startRealLine
          }
          $itk_component(source) tag add viewRegion $startRealLine.0 $endRealLine.end
          $itk_component(source) tag configure viewRegion \
              -foreground $itk_option(-accentforeground) -font $itk_option(-accentfont)
        }
      }
      update idletasks
      $itk_component(source) see $endRealLine.end
      $itk_component(source) see $firstStartRealLine.0
    } ; # seeRegions
    
    protected method clearViewRegions {} {
      $itk_component(source) tag delete viewRegion
    } ; # clearViewRegions

    protected method isValidLine {line} {
      if {$line != "" && [string is digit $line] && $line > 0} {
        return 1
      }
      return 0
    }

    protected method getRealNumberLine {line} {
      set realStartNumberLine [getStartLine]
      if {![isValidLine $line] || ![isValidLine $realStartNumberLine]} {
        return 0
      }
      
      set realline [expr {$line - $realStartNumberLine + 1}]
      if {![isValidLine $realline]} {
        return 0
      }
      
      scan [$itk_component(source) index end] "%d" number_lines
      if {$realline < $number_lines } {
        return $realline
      } 
      return 0
    } ;#getRealNumberLine
    
    protected method clearOthers {} {}

    private method CreateTable {} {
      createHeaders
      createSeparators
      createTextWidgets
      
      foreach text_widget $text_widget_list {
        $text_widget configure -relief flat -bd 0 -highlightthickness 0 \
            -wrap none -state disabled -yscrollcommand [code $this Yscroll] 
      }
      
      ### scrollbars
      scrollbar $itk_interior.hs -orient horizontal -highlightthickness 0 \
          -command "$itk_interior.source xview" 
      scrollbar $itk_interior.vs -orient vertical -highlightthickness 0 \
          -command [::itcl::code $this ScrollTextWidgetsVertically] 
      
      #fillers
      frame $itk_interior.bottom_left_filler -relief raised -bd 1
      frame $itk_interior.bottom_right_filler -relief flat -bd 1 
      frame $itk_interior.top_right_filler -relief flat -bd 1 
      
      packComponents
    } ; #CreateTable 
    
    private method compare_numbers {num1 num2} {
      return [expr {($num1 + 0.0) == ($num2 + 0.0)}]
    }

    private method compare_coords {fract1 fract2 vs_coords} {
      return [expr {[compare_numbers $fract1 [lindex $vs_coords 0]] && \
                        [compare_numbers $fract2 [lindex $vs_coords 1]]}]
    }

    private method ScrollTextWidgetsVertically {args} {
      foreach text_widget $text_widget_list {
        eval [list $text_widget yview] $args
      }
    } ; #  ScrollTextWidgetsVertically
 
    private method Yscroll {from to} {
      $itk_interior.vs set $from $to
      foreach text_widget $text_widget_list {
        if {![compare_coords $from $to [$text_widget yview]]} {
          $text_widget yview moveto $from
        }
      }
    } ; # Yscroll
     
    private method ClearData {} {
      clearViewRegions
      enableTextWidgets
      $itk_component(filename) configure -text "File: "
      foreach elem [concat $text_widget_list $additional_text_widget_list] {
        $elem delete 1.0 end
      }
      disableTextWidgets
      set last_text_line 0
    } ; # ClearData

    private method SetSourceText {filename {startline 1} {endline "end"}} {
      if {$filename == ""} {
        return
      }
      set last_text_line 0
      set counter $startline
      if {$endline == "end"} {
        set endline 10000000
      }
      if {![isValidLine $startline] || ![isValidLine $endline] || $startline > $endline} {
        return
      }
      
      if {![catch { open $filename r } channel]} {
        set catchStatus [ catch {
          $itk_component(filename) configure -text "File: $filename"
          
          enableTextWidgets
          incr startline -1
          incr endline
          while {![eof $channel]} { 
            set str [gets $channel]
            if {$counter > $startline &&  $counter < $endline} {
              $itk_component(source) insert end $str\n
              $itk_component(line) insert end $counter\n "tag_regular"
              foreach additional_text_widget $additional_text_widget_list {
                $additional_text_widget insert end \n
              }
            }
            incr counter
          }
        } msg]
        set errorInfo $::errorInfo; set errorCode $::errorCode
        catch {close $channel}
        catch {disableTextWidgets}
        if {$catchStatus} {
          error $msg $errorInfo $errorCode
        }
      }
      set last_text_line [expr $counter - 1]
    } ; # SetSourceText
     
    private method UpdateSourceText {full_path} {
      ClearData
      SetSourceText $full_path [getStartLine] [getEndLine]
    }
 
    private method ClearAdditionalData {} {
      enableTextWidgets
      #clear data
      set lineNumber [$itk_component(source) index end]
      foreach additional_text_widget $additional_text_widget_list {
        $additional_text_widget delete 1.0 end
      }
      #insert empty lines
      set number_lines 0
      scan [$itk_component(source) index end] "%d" number_lines
      
      incr number_lines -1
      for {set i 1} {$i < $number_lines} { incr i} {
        foreach additional_text_widget $additional_text_widget_list {
          $additional_text_widget insert end "\n"
        }
      }
      clearOthers
      
      disableTextWidgets
    } ; # ClearAdditionalData
    
    private method ChangeFile {} {
      set filename [::UI::open_source_command]

      if {$filename != ""} {
        UpdateRequestFullPathFileName [getCoveredFileName] $filename
        configure -filedata [list $filename 1 "end"]

        update idle
        applyAdditionalData
        seeRegions
      }
    }

    private method SearchFullPathFileName {filename} {
      if {$filename == ""} {
        return $filename
      }
      set request_filename [GetRequestFullPathFileName $filename]
      if {$request_filename != ""} {
        return $request_filename
      }
      
      set searchDirList [$document get_variable_value SearchDirList]

      if {[::Document::isReplayMode]} {
        lappend searchDirList $qa_cache
      }

      if {$searchDirList != ""} {
        set namelist [file split $filename]
        while {[llength $namelist]} {
          foreach dir $searchDirList {
            set name [file join $dir [ eval file join $namelist]]
            if {[file exists $name]} {
              return [GetRequestFullPathFileName $name]
            }
            set name [file join [ file dirname $dir] [ eval file join $namelist]]
            if {[file exists $name]} {
              return [GetRequestFullPathFileName $name]
            }
          }
          set namelist [lreplace $namelist 0 0]
        }
      }
     
      return ""
    }

    private method GetRequestFullPathFileName {filename} {
      if {$filename != ""} {
        set file_array_name [$document get_variable_name RequestSourceFilePairArray]
        if { [info exists [set file_array_name]($filename)] } {
          return $[set file_array_name]($filename)
        }

        if {[file exist $filename]} {
          set [set file_array_name]($filename) $filename
          return $filename
        }
      }
      return ""
    }
    
    private method UpdateRequestFullPathFileName {filename request_filename} {
      if {$request_filename != "" && [file exists $request_filename]} {
        set file_array_name [$document get_variable_name RequestSourceFilePairArray]
        set [set file_array_name]($filename) $request_filename
        return $filename
      }
      return ""
    }

    private method update_source_interactive {filename}
    private method update_source_interactive_real {filename}
    private method update_source {}
    proc update_source_command {object} {
      catch { $object update_source}
    }
  } ;# BaseSourceView
  
  ::itcl::class UI/BaseSourceView/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document tagFileData tagCoverageData \
                                         tagCurrentSourceElementData args} {
      $widget configure -filedatavariable [$document get_variable_name $tagFileData]
      $widget configure -coveragedatavariable [$document get_variable_name $tagCoverageData]
      $widget configure -currentSourceElementDatavariable \
          [$document get_variable_name $tagCurrentSourceElementData]
    }
  }
  UI/BaseSourceView/DocumentLinker UI/BaseSourceView/DocumentLinkerObject
} ;# namespace



### filedata
body ::UI::BaseSourceView::clean_gui/filedata {} {
  ClearData
}

body ::UI::BaseSourceView::check_new_value/filedata {newValue} {
  set filename [lindex $newValue 0]
  set beginIndex [lindex $newValue 1]
  set endIndex [lindex $newValue 2]
  if {$filename == ""} {
    return; #error "File name should be given"
  } elseif {$beginIndex != "" && $beginIndex < 1} {
    error "\"From\" index  should be > 0"
  } elseif {$endIndex != "" && $endIndex != "end" && $endIndex < 1} {
    error "\"End\" index  should be > 0"
  } elseif {$beginIndex != "" && $endIndex != "" && $endIndex != "end" && $beginIndex > $endIndex} {
    error "\"From\" index should be < \"End\" index"
  }
}

body ::UI::BaseSourceView::update_gui/filedata {} {
  $document run_command UpdateSourceFileCommand SourceViewWidget $itk_interior
}

body ::UI::BaseSourceView::update_source_interactive {filename} {
  ::UI::eval_when_flipflop_free [code [list catch [list $this update_source_interactive_real $filename]]]
}

body ::UI::BaseSourceView::update_source_interactive_real {filename} {
  set full_path [::UI::open_source_command $filename]
  if {$full_path != ""} {
    if {[::Document::isRecordMode]} {
      catch {
        file mkdir $qa_cache
        file copy $full_path $qa_cache
      }
    }
  }
  UpdateSourceText $full_path
}

body ::UI::BaseSourceView::update_source {} {
  set file_array_name [$document get_variable_name RequestSourceFilePairArray]
  if { [array size [set file_array_name]] != 0} {
    set filename [getCoveredFileName]
  } else {
    set filename [getFileName]
  }
  
  if {$filename == ""} {
    return ""
  }
  set full_path [SearchFullPathFileName $filename]
  if { $full_path != "" } {
    UpdateSourceText $full_path
  } else {
    ::UI::eval_when_viewable $itk_interior [code [list catch [list $this update_source_interactive $filename]]]
  }
}

### currentSourceElementData
body ::UI::BaseSourceView::clean_gui/currentSourceElementData {} {
  clearViewRegions
}

body ::UI::BaseSourceView::update_gui/currentSourceElementData {} {
  seeRegions
}

### currentline
body ::UI::BaseSourceView::update_gui/currentline {} {
  gotoLine $currentline
}

### coveragedata
body ::UI::BaseSourceView::clean_gui/coveragedata {} {
  ClearAdditionalData
}

body ::UI::BaseSourceView::update_gui/coveragedata {} {
  applyAdditionalData
  seeRegions
}
