#tcl-mode

option add *TreeTableBalloon.font "*-arial-medium-r-normal-*-12-120-*" widgetDefault
option add *TreeTableBalloon.background \#ffffe7 widgetDefault
option add *TreeTableBalloon.balloonborderwidth 1 widgetDefault
option add *TreeTableBalloon.relief solid widgetDefault

namespace eval ::UI {
  class TreeTableBalloon {
    inherit ::UI::TkBalloon 

    constructor {args} {
      eval itk_initialize $args
    }
    destructor {}

    public method update_balloon {treetable pos_x pos_y} {
      set data_show [get_show_data $treetable $pos_x $pos_y]
      set is_viewable [winfo viewable $itk_interior]
      
      if {$data_show != "" && $is_viewable == 0} {
        eval show $treetable $data_show
      } elseif {$data_show == "" && $is_viewable == 1} {
        hide
      }
    }

    private method get_show_data {treetable pos_x pos_y} {
      set return_value ""
      catch {
        if {$treetable == "" || ![string is digit -strict $pos_x] || \
                ![string is digit -strict $pos_y]} {
          return ""
        }
        
        scan [split [winfo geometry $treetable] "x+"] "%d %d %d %d" \
            table_width table_height table_x table_y

        set max_x [expr $table_x + $table_width - [$treetable cget -bd]]
        set max_y [expr $table_y + $table_height - [$treetable cget -bd]]
        if {($pos_x > $max_x) || ($pos_y > $max_y)} {
          return ""
        }
        
        set index [$treetable nearest $pos_x $pos_y]
        if {$index == "" || $index < 1} {
          return ""
        }
        
        # entry data
        scan [$treetable bbox -screen $index] "%*d %d" entry_y
        scan [$treetable bbox $index] "%d %*d %d" entry_x width_entry
        # text size
        set fontName [$treetable cget -font]
        set text [$treetable entry cget $index -label]
        set isLabel 1
        if {$text == ""} {
          set text [$treetable get $index]
          set isLabel 0
          if {$text == ""} {
            return ""
          }
        }
        set text [join $text]
        
        if {$text != [$itk_component(message) cget -text] && [winfo viewable $itk_interior]} {
          hide
        }

        set text_width [font measure $fontName -displayof $treetable $text]
        
        #image size
        set image_width 0
        set imageName [lindex [$treetable cget -icons] 0]
        if {$imageName != ""} {
          set image_width [image width $imageName]
        }
        
        # connection line size
        set line_width [$treetable cget -selectborderwidth]
        
        #ballon border 
        set ballon_border [cget -balloonborderwidth] 
        
        # table coords
        set rootx [winfo  rootx $treetable]
        set rooty [winfo  rooty $treetable]
        
        set full_width_of_entry [expr $entry_x + $width_entry + $image_width + $line_width]
        if {$pos_x < [expr $full_width_of_entry - $text_width] ||
            $max_x > $full_width_of_entry} {
          return ""
        }
        
        set x_ballon [expr $rootx + $full_width_of_entry - $text_width - $ballon_border]
        set y_ballon [expr $rooty + $entry_y + $line_width]

        #return [list $x_ballon $y_ballon $text]
        set return_value [list $x_ballon $y_ballon $text]
      }
      return $return_value
    }
  }
}
