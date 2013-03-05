namespace eval ::Images {
}
namespace eval ::UI {
  variable myimagedirs {}

  proc addbitmapdir {dir} {
    variable myimagedirs
    if {[lsearch -exact $myimagedirs $dir] == -1} {
      lappend myimagedirs $dir
    }
  }

  proc getimage {name {withError 1} {image_name ""} } {
    variable myimagedirs
    set index [lsearch -exact [image names] ::Images::$name]
    if {$index > -1} {
      return [lindex [image names] $index]
    }
    if {$myimagedirs == ""} {
      if {$withError == 1} {
        error "There is no image directory"
      } else {
        return ""
      }
    }
    if {$image_name==""} {
      set image_name ::Images::$name
    }
    foreach dir $myimagedirs {
      
      if {[::Utilities::isUnix]} {
        set fileName [file join $dir $name.xpm]
      } else {
        set fileName [file join $dir $name.bmp]
      }
      
      if {[file exists $fileName]} {
        if {[::Utilities::isUnix]} {
          return [image create pixmap $image_name -file $fileName]
        } else {
          return [image create photo $image_name -file $fileName]
        }
      }
      
      set fileName [file join $dir $name.gif]
      
      if {[file exists $fileName]} {
        return [image create photo $image_name -file $fileName]
      }
      
      
    }
    if {$withError == 1} {
      error "Image $name not found"
    } else {
      return ""
    }
  }

  proc isImageExist {name} {
    return [expr [llength [info command ::Images::$name]] != 0]
  }


  # same as getimage but works only with gif images (for use in getcombinedimage).
  proc getgifimage {name {withError 1} {image_name ""} } {

    variable myimagedirs
  
    if {[isImageExist $name] && [image type ::Images::$name] == "photo"} {
      return ::Images::$name
    }

    if {$myimagedirs == ""} {
      if {$withError == 1} {
        error "There is no image directory"
      } else {
        return ""
      }
    }
    if {$image_name==""} {
      set image_name ::Images::$name
    }
    set empty_file_name {}
    foreach dir $myimagedirs {
      set fileName [file join $dir $name.gif]
      if {[file exists $fileName]} {
        return [image create photo $image_name -file $fileName]
      }
      if {[string match "*__*" $name]} { ;# symbol__color
        set first__ [string first __ $name]
        set symbol [string range $name 0 $first__ ]
        set color [string range $name [expr $first__ + 2] end]
        set fileName [file join $dir $symbol.gif]
        if {[file exists $fileName]} {
          set symbol_color_image [image create photo $image_name -file $fileName]
          replace_image_color $symbol_color_image $color
          return $symbol_color_image
        }
      }
      set fileName [file join $dir empty.gif]
      if {($empty_file_name == "") && ([file exists $fileName])} {
        set empty_file_name $fileName
      }
    }
    if {$empty_file_name != ""} {
      return [image create photo $image_name -file $empty_file_name]
    }

    if {$withError == 1} {
      error "Image $name not found"
    } else {
      return ""
    }  
  }
  
  #returns width in pixels
  proc getimagewidth {image} {
    if {[image type $image] != "photo"} {
      return 0
    }
    return [image width $image]
  }

  #returns height in pixels
  proc getimageheight {image} {
    if {[image type $image] != "photo"} {
      return 0
    }
    return [image height $image]
  }

  #namelist list of images to combine
  #for vertical image orientation its name should start with "vertical_"
  proc getcombinedimage {namelist {withError 1} {image_name ""} } {
    variable myimagedirs
    
    if {[isImageExist $namelist]} { ;#search as is
      return ::Images::$namelist
    }

    set sorted_list [lrmdups $namelist] ;#remove duplicates & sort

    if {[isImageExist $sorted_list]} { ;#search sorted
      return ::Images::$sorted_list
    }

    if {$myimagedirs == ""} {
      if {$withError == 1} {
        error "There is no image directory"
      } else {
        return ""
      }
    }
    if {$image_name==""} {
      set image_name ::Images::$sorted_list
    }

    set count [llength $sorted_list] ;#number of image items

    set item_name [lindex $sorted_list 0]
    #create base image
    if {$count < 2} {
      set image0 [getgifimage $item_name 0 $image_name]
    } else {
      set image0 [image create photo $image_name]
      $image0 copy [getgifimage $item_name 0]
    }

    set last_image_width [getimagewidth $image0]
    #add rest items to base image
    loop i 1 $count {
      set pixels [getimagewidth $image0]
      set item_name [lindex $sorted_list $i]
      if {[string first "vertical_" $item_name] == 0} {
        #8 is the lenght of "vertical_"
        set item_name [string range $item_name 9 end]
        set ypixels [getimageheight $image0]
        set x1 [expr $pixels - $last_image_width]
        $image0 copy [getgifimage $item_name 0] -to $x1 $ypixels
      } else {
        $image0 copy [getgifimage $item_name 0] -to $pixels 0
      }
      set last_image_width [expr [getimagewidth $image0] - $pixels]
    }
    if {[string compare $namelist $sorted_list] == 0} {
      return $image0
    } else { ;#create same image with other name
      set image_name ::Images::$namelist
        set image1 [image create photo $image_name]
      $image1 copy $image0
      return $image1
    }
    if {$withError == 1} {
      error "Image $name not found"
    } else {
      return ""
    }
  }

  # replace all pixels with basic color #ff0000 to new color
  proc replace_image_color {image new_color} {
    set image_data [$image data]
    set basic_color #ff0000
    set new_data [regsub -all $basic_color $image_data $new_color]
    set transparent_x_y_list {} ;# collect transparent pixels
    set len_y [llength $image_data]
    for {set y 0} {$y < $len_y} {incr y} {
      set x_record [lindex $image_data $y]
      set len_x [llength $x_record]
      for {set x 0} {$x < $len_x} {incr x} {
        if {[$image transparency get $x $y] == 1} {
          lappend transparent_x_y_list [list $x $y]
        }
      }
    }
    $image put $new_data
    foreach coord $transparent_x_y_list {
      set x [lindex $coord 0]
      set y [lindex $coord 1]
      $image transparency set $x $y 1
    }
  }

}
