namespace eval UI {
  namespace eval console {

  ::itcl::class Console {

  #really public
  public variable ExpandCustomnameProc {} 

  private variable consolePath 
  private variable consoleinterp 

  private variable blinkTime   500 
  private variable blinkRange  1   
  private variable magicKeys   1   
  private variable maxLines    600 
  private variable showMatches 1   

  private variable inPlugin [info exists embed_args]

  private variable defaultPrompt  
  
  private method EvalAttached {args} {
    catch {
      error $args
    }
    eval "$consoleinterp eval $args"
  }


  constructor {path _consoleinterp} {} {
    set consoleinterp $_consoleinterp
    if {$inPlugin} {
      set defaultPrompt {subst {[history nextid] % }}
    } else {
      set defaultPrompt {subst {([file tail [pwd]]) [history nextid] % }}
    }
    set ::DDD $defaultPrompt
    global tcl_platform

    if {[string equal $tcl_platform(platform) "macintosh"]
        || [string equal [tk windowingsystem] "aqua"]} {
      set mod "Cmd"
    } else {
      set mod "Ctrl"
    }

    set font 6x13
    switch -exact $tcl_platform(platform) {
      "windows" {
        set font systemfixed
      }
    }
    
    set con [text $path.console  -yscrollcommand [list $path.sb set]  -bg white -font $font]
    
    set consolePath $con
    scrollbar $path.sb -command [list $con yview]
    pack $path.sb -side right -fill both
    pack $con -side left -fill both -expand 1
    $con configure -highlightthickness 0 -relief flat -selectbackground #b7cfeb

    ConsoleBind $con
    
    $con tag configure esc_col_0 -foreground black
    $con tag configure esc_col_1 -foreground red
    $con tag configure esc_col_2 -foreground green
    $con tag configure esc_col_3 -foreground yellow
    $con tag configure esc_col_4 -foreground blue
    $con tag configure esc_col_5 -foreground magenta
    $con tag configure esc_col_6 -foreground cyan
    $con tag configure esc_col_7 -foreground white

    $con tag configure stderr	-foreground \#c00202
    $con tag configure stderr	-foreground \#c00202
    $con tag configure stdin	-foreground blue
    $con tag configure prompt	-foreground \#8F4433
    $con tag configure proc	-foreground \#008800
    $con tag configure var	-background \#FFC0D0
    $con tag raise sel
    $con tag configure blink	-background \#FFFF00
    $con tag configure find	-background \#FFFF00
    
    focus $con

    $con mark set output [$con index "end - 1 char"]
    ::tk::TextSetCursor $con end
    $con mark set promptEnd insert
    $con mark gravity promptEnd left
    
    # A variant of ConsolePrompt to avoid a 'puts' call
    set w $con
    set temp [$w index "end - 1 char"]
    $w mark set output end

    if {![$consoleinterp eval "info exists tcl_prompt1"]} {
      set string [EvalAttached $defaultPrompt]
    } else {
      set string [$consoleinterp eval "eval \[set tcl_prompt1\]"]
    }
    $w insert output $string stdout

    $w mark set output $temp
    ::tk::TextSetCursor $w end
    $w mark set promptEnd insert
    $w mark gravity promptEnd left
    
    if {$tcl_platform(platform) eq "windows"} {
      after idle [list $con delete 1.0 output]
    }
  }
  
  public method getInterpreterProc {} {
    return $consoleinterp
  }

  public method setInterpreterProc {interp_proc} {
    set consoleinterp $interp_proc
  }

  private method ConsoleSource {} {
    set filename [tk_getOpenFile -defaultextension .tcl -parent . \
                      -title [mc "Select a file to source"] \
                      -filetypes [list \
                                      [list [mc "Tcl Scripts"] .tcl] \
                                      [list [mc "All Files"] *]]]
    if {[string compare $filename ""]} {
      set cmd [list source $filename]
      if {[catch {$consoleinterp eval $cmd} result]} {
        ConsoleOutput stderr "$result\n"
      }
    }
  }

  public method ConsoleInvoke {args} {

    set ranges [$consolePath tag ranges input]
    set cmd ""
    if {[llength $ranges]} {
      set pos 0
      while {[string compare [lindex $ranges $pos] ""]} {
        set start [lindex $ranges $pos]
        set end [lindex $ranges [incr pos]]
        append cmd [$consolePath get $start $end]
        incr pos
      }
    }
    if {[string equal $cmd ""]} {
      ConsolePrompt
    } elseif {[info complete $cmd]} {
      $consolePath mark set output end
      $consolePath tag delete input
      set result [$consoleinterp record $cmd]
      if {[string compare $result ""]} {
        ConsoleOutput stderr "$result\n"
      }
      ConsoleHistory reset
      ConsolePrompt
    } else {
      ConsolePrompt partial
    }
    $consolePath yview -pickplace insert
  }

  private variable HistNum 1

  public method ConsoleHistory {cmd} {
    variable HistNum
    if {[$consolePath compare {insert linestart} == {end-1c linestart}] == 0} {
      set cur_pos [$consolePath index insert]
      set cur_pos_list [split $cur_pos .]
      set row_pos [lindex $cur_pos_list 1]
      set cur_line_number [lindex $cur_pos_list 0]
      switch $cmd {
        "prev" {
          set line_number [expr $cur_line_number -1]
          if {$line_number > 0} {
            ::tk::TextSetCursor $consolePath "$line_number.$row_pos"
          }
        }
        "next" {
          set line_number [expr $cur_line_number +1]
          ::tk::TextSetCursor $consolePath "$line_number.$row_pos"
        }
        default {}
      }
      return
    }
    switch $cmd {
      prev {
        incr HistNum -1
        if {$HistNum == 0} {
          set cmd {history event [expr {[history nextid] -1}]}
        } else {
          set cmd "history event $HistNum"
        }
        if {[catch {$consoleinterp eval $cmd} cmd]} {
          incr HistNum
          return
        }
        $consolePath delete promptEnd end
        $consolePath insert promptEnd $cmd {input stdin}
      }
      next {
        incr HistNum
        if {$HistNum == 0} {
          set cmd {history event [expr {[history nextid] -1}]}
        } elseif {$HistNum > 0} {
          set cmd ""
          set HistNum 1
        } else {
          set cmd "history event $HistNum"
        }
        if {[string compare $cmd ""]} {
          catch {$consoleinterp eval $cmd} cmd
        }
        $consolePath delete promptEnd end
        $consolePath insert promptEnd $cmd {input stdin}
      }
      reset {
        set HistNum 1
      }
    }
  }

  public method ConsolePrompt {{partial normal}} {
    set w $consolePath
    
    if {[string equal $partial "normal"]} {
      set temp [$w index "end - 1 char"]
      $w mark set output end
      if {[$consoleinterp eval "info exists tcl_prompt1"]} {
        $consoleinterp eval "eval \[set tcl_prompt1\]"
      } else {
        ConsoleOutput stdout [EvalAttached $defaultPrompt] 
      }
    } else {
      set temp [$w index output]
      $w mark set output end
      if {[$consoleinterp eval "info exists tcl_prompt2"]} {
        $consoleinterp eval "eval \[set tcl_prompt2\]"
      } else {
        ConsoleOutput stdout "> "
      }
    }
    flush stdout
    $w mark set output $temp
    ::tk::TextSetCursor $w end
    $w mark set promptEnd insert
    $w mark gravity promptEnd left
    ConstrainBuffer $w $maxLines
    $w see end
  }

  private method ConsoleBind {w} {
    bindtags $w [list $w Post[set w]]

    ## Get all Text bindings into Console
    foreach ev [bind Text] { bind $w $ev [bind Text $ev] }	
    ## We really didn't want the newline insertion...
    bind $w <Control-Key-o> {}
    ## ...or any Control-v binding (would block <<Paste>>)
    bind $w <Control-Key-v> {}

    # For the moment, transpose isn't enabled until the console
    # gets and overhaul of how it handles input -- hobbs
    bind $w <Control-Key-t> {}

    # Ignore all Alt, Meta, and Control keypresses unless explicitly bound.
    # Otherwise, if a widget binding for one of these is defined, the

    bind $w <Alt-KeyPress> {
      # nothing 
    }
    bind $w <Meta-KeyPress> {# nothing
    }
    bind $w <Control-KeyPress> {# nothing
    }
    
    foreach {ev key} {
      <<Console_Prev>>		<Key-Up>
      <<Console_Next>>		<Key-Down>
      <<Console_NextImmediate>>	<Control-Key-n>
      <<Console_PrevImmediate>>	<Control-Key-p>
      <<Console_PrevSearch>>		<Control-Key-r>
      <<Console_NextSearch>>		<Control-Key-s>
      
      <<Console_Expand>>		<Key-Tab>
      <<Console_Expand>>		<Key-Escape>
      <<Console_ExpandFile>>		<Control-Shift-Key-F>
      <<Console_ExpandProc>>		<Control-Shift-Key-P>
      <<Console_ExpandVar>>		<Control-Shift-Key-V>
      <<Console_Tab>>			<Control-Key-i>
      <<Console_Tab>>			<Meta-Key-i>
      <<Console_Eval>>		<Key-Return>
      <<Console_Eval>>		<Key-KP_Enter>
      
      <<Console_Clear>>		<Control-Key-l>
      <<Console_KillLine>>		<Control-Key-k>
      <<Console_Transpose>>		<Control-Key-t>
      <<Console_ClearLine>>		<Control-Key-u>
      <<Console_SaveCommand>>		<Control-Key-z>
    } {
      event add $ev $key
      bind $w  $key {}
    }
    

    bind $w <<Console_ExpandProc>> "if \{ \[%W compare insert > promptEnd\]\} \{ $this Expand %W proc \}"

    bind $w <<Console_ExpandFile>> "if \{ \[%W compare insert > promptEnd\]\} \{ $this Expand %W path \}"
    
    bind $w <<Console_ExpandVar>> "if \{ \[%W compare insert > promptEnd\]\} \{ $this Expand %W var\}"

    bind $w <<Console_Eval>> "%W mark set insert end-1c \; $this ConsoleInsert %W \"\n\" \; $this ConsoleInvoke \; break"

    bind $w <Delete> {
      if {[string compare {} [%W tag nextrange sel 1.0 end]] \
              && [%W compare sel.first >= promptEnd]} {
        %W delete sel.first sel.last
      } elseif {[%W compare insert >= promptEnd]} {
        %W delete insert
        %W see insert
      }
    }

    bind $w <<Console_Expand>> [list if {[%W compare insert > promptEnd]} [list $this Expand %W] ]

    bind $w <BackSpace> {
      if {[string compare {} [%W tag nextrange sel 1.0 end]] \
              && [%W compare sel.first >= promptEnd]} {
        %W delete sel.first sel.last
      } elseif {[%W compare insert != 1.0] && \
                    [%W compare insert > promptEnd]} {
        %W delete insert-1c
        %W see insert
      }
    }
    bind $w <Control-h> [bind Console <BackSpace>]
    
    bind $w <Home> {
      if {[%W compare insert < promptEnd]} {
        ::tk::TextSetCursor %W {insert linestart}
      } else {
        ::tk::TextSetCursor %W promptEnd
      }
    }
    bind $w <Control-a> [bind $w <Home>]
    bind $w <End> {
      ::tk::TextSetCursor %W {insert lineend}
    }
    bind $w <Control-e> [bind $w <End>]
    bind $w <Control-d> {
      if {[%W compare insert < promptEnd]} break
      %W delete insert
    }
    bind $w <<Console_KillLine>> {
      if {[%W compare insert < promptEnd]} break
      if {[%W compare insert == {insert lineend}]} {
        %W delete insert
      } else {
        %W delete insert {insert lineend}
      }
    }
    bind $w <<Console_Clear>> {
      ## Clear console display
      %W delete 1.0 "promptEnd linestart"
    }
    bind $w <<Console_ClearLine>> {
      ## Clear command line (Unix shell staple)
      %W delete promptEnd end
    }
    bind $w <Meta-d> {
      if {[%W compare insert >= promptEnd]} {
        %W delete insert {insert wordend}
      }
    }
    bind $w <Meta-BackSpace> {
      if {[%W compare {insert -1c wordstart} >= promptEnd]} {
        %W delete {insert -1c wordstart} insert
      }
    }
    bind $w <Meta-d> {
      if {[%W compare insert >= promptEnd]} {
        %W delete insert {insert wordend}
      }
    }
    bind $w <Meta-BackSpace> {
      if {[%W compare {insert -1c wordstart} >= promptEnd]} {
        %W delete {insert -1c wordstart} insert
      }
    }
    bind $w <Meta-Delete> {
      if {[%W compare insert >= promptEnd]} {
        %W delete insert {insert wordend}
      }
    }
    bind $w <<Console_Prev>> "$this ConsoleHistory prev"

    bind $w <<Console_Next>> "$this ConsoleHistory next"

    bind $w <Insert> "[list catch "$this ConsoleInsert %W \[::tk::GetSelection %W PRIMARY\]" ]"

    bind $w <KeyPress> "[list $this ConsoleInsert %W %A]"


    bind $w <Button-2> "[list catch "$this ConsoleInsert %W \[::tk::GetSelection %W PRIMARY\]" ]"

    bind $w <ButtonRelease-2> "::tk::TextSetCursor %W {insert lineend}"


    bind $w <ButtonRelease-1> {
      if {![catch {set data [%W get sel.first sel.last]}]} {
        clipboard clear -displayof %W
        clipboard append -displayof %W $data
      }
    }


    bind $w <F9> {
      eval destroy [winfo child .]
      if {[string equal $tcl_platform(platform) "macintosh"]} {
        if {[catch {source [file join $tk_library console.tcl]}]} {source -rsrc console}
      } else {
        source [file join $tk_library console.tcl]
      }
    }
    if {[string equal $::tcl_platform(platform) "macintosh"]
        || [string equal [tk windowingsystem] "aqua"]} {
      bind $w <Command-q> {
        exit
      }
    }
    bind $w <<Cut>> {
      # Same as the copy event
      if {![catch {set data [%W get sel.first sel.last]}]} {
        clipboard clear -displayof %W
        clipboard append -displayof %W $data
      }
    }
    bind $w <<Copy>> {
      if {![catch {set data [%W get sel.first sel.last]}]} {
        clipboard clear -displayof %W
        clipboard append -displayof %W $data
      }
    }

    bind $w <<Paste>> "\
      catch \{ \ 
      set clip \[::tk::GetSelection %W CLIPBOARD\] \; \
      set list \[split \$clip \"\\n\\r\" \] \;\
      $this ConsoleInsert %W \[lindex \$list 0\] \; \
      foreach x \[lrange \$list 1 end\] \; \{\
        %W mark set insert \{end - 1c\} \;\
        $this ConsoleInsert %W \"\n\" \; \ 
        $this ConsoleInvoke \; \
        $this ConsoleInsert %W \$x \; \
    \}\
\}"
    

    bind Post[set w] <Key-parenright> "if \{\[ string compare \\\\ \[%W get insert-2c\]\]\} \{\
        $this MatchPair %W \( \) promptEnd
      \}"
    

    bind Post[set w] <Key-bracketright> "\
      if \{\[string compare \\\\ \[%W get insert-2c\]\]\} \{\
        $this MatchPair %W \[ \] promptEnd\
      \}"
    
    bind Post[set w] <Key-braceright> "\
      if \{\[string compare \\\\ \[%W get insert-2c\]\]\} \{\
        $this MatchPair %W \{ \} promptEnd
      \}"
    
    bind Post[set w] <Key-quotedbl> "if \{\[string compare \\\\ \[%W get insert-2c\]\]\} \{\
     $this MatchQuote %W promptEnd\
    \} \
 \}"

    bind Post[set w] <KeyPress> "if \{ {%A} != \"\"\} \{ $this TagProc %W \} break"
  }

  #really public
  public method ConsoleInsert {w s} {
    if {[string equal $s ""]} {
      return
    }
    catch {
      if {[$w compare sel.first <= insert]
          && [$w compare sel.last >= insert]} {
        $w tag remove sel sel.first promptEnd
        $w delete sel.first sel.last
      }
    }
    if {[$w compare insert < promptEnd]} {
      $w mark set insert end
    }
    $w insert insert $s {input stdin}
    $w see insert
  }

  #really public
  public method ConsoleOutput {dest string} {
    
    set w $consolePath
    $w insert output $string $dest
    $this ConstrainBuffer $w $this
    $w see end
  }

  public method ConsoleAbout {} {
    tk_messageBox -type ok -message "[mc {Tcl for Windows}]

Tcl $::tcl_patchLevel
Tk $::tk_patchLevel"
  }

  public method TagProc w {
    if {!$magicKeys} { return }
    set exp "\[^\\\\\]\[\[ \t\n\r\;{}\"\$\]"
    set i [$w search -backwards -regexp $exp insert-1c promptEnd-1c]
    if {$i == ""} {set i promptEnd} else {append i +2c}
    regsub -all "\[\[\\\\\\?\\*\]" [$w get $i "insert-1c wordend"] {\\\0} c
    if {[llength [EvalAttached [list info commands $c]]]} {
      $w tag add proc $i "insert-1c wordend"
    } else {
      $w tag remove proc $i "insert-1c wordend"
    }
    if {[llength [EvalAttached [list info vars $c]]]} {
      $w tag add var $i "insert-1c wordend"
    } else {
      $w tag remove var $i "insert-1c wordend"
    }
  }

  public method MatchPair {w c1 c2 {lim 1.0}} {
    if {!$magicKeys} { return }
    if {[string compare {} [set ix [$w search -back $c1 insert $lim]]]} {
      while {
             [string match {\\} [$w get $ix-1c]] &&
             [string compare {} [set ix [$w search -back $c1 $ix-1c $lim]]]
           } {}
      set i1 insert-1c
      while {[string compare {} $ix]} {
        set i0 $ix
        set j 0
        while {[string compare {} [set i0 [$w search $c2 $i0 $i1]]]} {
          append i0 +1c
          if {[string match {\\} [$w get $i0-2c]]} continue
          incr j
        }
        if {!$j} break
        set i1 $ix
        while {$j && [string compare {} \
                          [set ix [$w search -back $c1 $ix $lim]]]} {
          if {[string match {\\} [$w get $ix-1c]]} continue
          incr j -1
        }
      }
      if {[string match {} $ix]} { set ix [$w index $lim] }
    } else { set ix [$w index $lim] }
    if {$blinkRange} {
      Blink $w $ix [$w index insert]
    } else {
      Blink $w $ix $ix+1c [$w index insert-1c] [$w index insert]
    }
  }

  public method MatchQuote {w {lim 1.0}} {
    if {!$magicKeys} { return }
    set i insert-1c
    set j 0
    while {[string compare [set i [$w search -back \" $i $lim]] {}]} {
      if {[string match {\\} [$w get $i-1c]]} continue
      if {!$j} {set i0 $i}
      incr j
    }
    if {$j&1} {
      if {$blinkRange} {
        Blink $w $i0 [$w index insert]
      } else {
        Blink $w $i0 $i0+1c [$w index insert-1c] [$w index insert]
      }
    } else {
      Blink $w [$w index insert-1c] [$w index insert]
    }
  }

  public method Blink {w args} {
    eval [list $w tag add blink] $args
    after $blinkTime [list $w] tag remove blink $args
  }

  public method ConstrainBuffer {w size} {
    if {[$w index end] > $size} {
      $w delete 1.0 [expr {int([$w index end])-$size}].0
    }
  }

  public method Expand {w {type ""}} {
    set exp "\[^\\\\\]\[\[ \t\n\r\\\{\"\\\\\$\]"
    set tmp [$w search -backwards -regexp $exp insert-1c promptEnd-1c]
    if {$tmp == ""} {set tmp promptEnd} else {append tmp +2c}
    if {[$w compare $tmp >= insert]} { return }
    set str [$w get $tmp insert]
    switch -glob $type {
      path* { set res [ExpandPathname $str] }
      proc* { set res [ExpandProcname $str] }
      var*  { set res [ExpandVariable $str] }
      custom* { set res [ExpandCustomname $str] }
      default {
        set res {}
        foreach t {Pathname Procname Variable Customname} {
          if {![catch {Expand$t $str} res] && ($res != "")} { break }
        }
      }
    }
    set len [llength $res]
    if {$len} {
      set repl [lindex $res 0]
      $w delete $tmp insert
      $w insert $tmp $repl {input stdin}
      if {($len > 1) && $showMatches \
              && [string equal $repl $str]} {
        ConsoleOutput stdout "[lsort [lreplace $res 0 0]]\n"
        #        puts stdout [lsort [lreplace $res 0 0]]
      }
    } else { bell }
    return [incr len -1]
  }

  public method ExpandCustomname str {
    if { $ExpandCustomnameProc != {} } {
      set match [eval $ExpandCustomnameProc $str]
      if {[llength $match] > 1} {
        regsub -all { } [ExpandBestMatch $match $str] {\\ } str
        set match [linsert $match 0 $str]
      } else {
        regsub -all { } $match {\\ } match
      }
      return $match
    }
    return {}
  }

  public method ExpandPathname str {
    set pwd [EvalAttached pwd]
    if {[catch {EvalAttached [list cd [file dirname $str]]} err]} {
      return -code error $err
    }
    set dir [file tail $str]

    if {[string match */ $str]} { append dir / }
    if {[catch {lsort [EvalAttached [list glob $dir*]]} m]} {
      set match {}
    } else {
      if {[llength $m] > 1} {
        global tcl_platform
        if {[string match windows $tcl_platform(platform)]} {

          set tmp [ExpandBestMatch [string tolower $m] \
                       [string tolower $dir]]

          if {[string length $dir]==[string length $tmp]} {
            set tmp $dir
          }
        } else {
          set tmp [ExpandBestMatch $m $dir]
        }
        if {[string match ?*/* $str]} {
          set tmp [file dirname $str]/$tmp
        } elseif {[string match /* $str]} {
          set tmp /$tmp
        }
        regsub -all { } $tmp {\\ } tmp
        set match [linsert $m 0 $tmp]
      } else {

        eval append match $m
        if {[file isdir $match]} {append match /}
        if {[string match ?*/* $str]} {
          set match [file dirname $str]/$match
        } elseif {[string match /* $str]} {
          set match /$match
        }
        regsub -all { } $match {\\ } match

        set match [list $match]
      }
    }
    EvalAttached [list cd $pwd]
    return $match
  }

  public method ExpandProcname str {
    set match [EvalAttached [list info commands $str*]]
    if {[llength $match] == 0} {
      set ns [EvalAttached \
                  "namespace children \[namespace current\] [list $str*]"]
      if {[llength $ns]==1} {
        set match [EvalAttached [list info commands ${ns}::*]]
      } else {
        set match $ns
      }
    }
    if {[llength $match] > 1} {
      regsub -all { } [ExpandBestMatch $match $str] {\\ } str
      set match [linsert $match 0 $str]
    } else {
      regsub -all { } $match {\\ } match
    }
    return $match
  }

  public method ExpandVariable str {
    if {[regexp {([^\(]*)\((.*)} $str junk ary str]} {
      ## Looks like they're trying to expand an array.
      set match [EvalAttached [list array names $ary $str*]]
      if {[llength $match] > 1} {
        set vars $ary\([ExpandBestMatch $match $str]
        foreach var $match {lappend vars $ary\($var\)}
        return $vars
      } elseif {[llength $match] == 1} {
        set match $ary\($match\)
      }
      ## Space transformation avoided for array names.
    } else {
      set match [EvalAttached [list info vars $str*]]
      if {[llength $match] > 1} {
        regsub -all { } [ExpandBestMatch $match $str] {\\ } str
        set match [linsert $match 0 $str]
      } else {
        regsub -all { } $match {\\ } match
      }
    }
    return $match
  }

  public method ExpandBestMatch {l {e {}}} {
    set ec [lindex $l 0]
    if {[llength $l]>1} {
      set e  [string length $e]; incr e -1
      set ei [string length $ec]; incr ei -1
      foreach l $l {
        while {$ei>=$e && [string first $ec $l]} {
          set ec [string range $ec 0 [incr ei -1]]
        }
      }
    }
    return $ec
  }
  
}



}
}

