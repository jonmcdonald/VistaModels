namespace eval ::UI {
  class RandomColor {
    common initial_colors {red green blue} ;# "\#fdfd81" "\#66e054" "\#a9fefe" "\#ffaff9" 
    private variable count 0
    public method reset {} {
      set count 0
    }
    public method get_color {} {
      if {$count < [llength $initial_colors]} {
        set result [lindex $initial_colors $count]
        incr count
        return $result
      }
      
      set r [format %.2x [expr int(floor(rand() * 128 - $count + 0.5))]]
      set g [format %.2x [expr int(floor(rand() * 128 + $count + 0.5))]]
      set b [format %.2x [expr int(floor(rand() * 128 - $count + 0.5))]]


      set color "\#$r$g$b"
      lappend initial_colors $color
      if {$count == 20} {
        set count 0
      }
      incr count
      return $color
    }
  }
}
