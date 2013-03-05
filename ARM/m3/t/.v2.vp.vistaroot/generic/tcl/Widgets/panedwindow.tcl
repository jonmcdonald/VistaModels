namespace eval ::Widgets {
#adding catch to original procedures in order to fix Tcl error in "identify"
  proc fix_tk_panedwindow {} {
    namespace eval ::tk::panedwindow {
      if {[info proc Motion_orig ] == ""} {
        auto_load Motion
        rename Motion Motion_orig
      }
      
      if {[info proc MarkSash_orig ] == ""} {
        auto_load MarkSash
        rename MarkSash MarkSash_orig
      }
      

      proc Motion {w x y} {
        catch {
          Motion_orig $w $x $y
        }
      }
      
      proc MarkSash {w x y proxy} {
        catch {
          MarkSash_orig $w $x $y $proxy
        }
      }

    }
    
  }
}
