namespace eval ::UI {
  class HelpAbout {
    inherit itk::Toplevel
    private variable cancel_variable_name {}
    private variable _withCloseButton
    public method get_cancel_variable_name {} {
      return $cancel_variable_name
    }
    constructor {{withCloseButton 1}} {
      set cancel_variable_name ::v2::ui::cancel[::Utilities::createUniqueIdentifier]
      set _withCloseButton $withCloseButton
      wm withdraw $itk_interior
      createView
    }

    destructor {
      set $cancel_variable_name 1
      after 1 [list unset $cancel_variable_name]
    }

    public method getTop {} {
      return $itk_interior
    }
    private method createView {} {
      if {[info exists ::env(THIS_PRODUCT_LOGO)]} {
        set top $itk_interior
        
        if {[info exists ::env(THIS_PRODUCT_NAME_AND_VERSION)]} {
          set label_text $::env(THIS_PRODUCT_NAME_AND_VERSION)
        } else {
          set label_text " "
        }

        if {[info exists ::env(THIS_PRODUCT_NAME_AND_VERSION_AUX)]} {
          set label_text_aux $::env(THIS_PRODUCT_NAME_AND_VERSION_AUX)
        } else {
          set label_text_aux " "
        }

        if {[info exists ::env(THIS_PRODUCT_BUILD_INFO)]} {
          set label_text_build_info $::env(THIS_PRODUCT_BUILD_INFO)
        } else {
          set label_text_build_info " "
        }

        if {[info exists ::env(THIS_PRODUCT_COPYRIGHT)]} {
          set copyright_text $::env(THIS_PRODUCT_COPYRIGHT)
        } else {
          set copyright_text " "
        }
        
        set logo_bitmap ::THIS_PRODUCT_LOGO
        if {[lsearch [image names] ::THIS_PRODUCT_LOGO] == -1} {
          if {[::Utilities::isUnix]} {
            image create pixmap $logo_bitmap -file $::env(THIS_PRODUCT_LOGO)
          } else {
            image create photo $logo_bitmap -file $::env(THIS_PRODUCT_LOGO)
          }
        }
        set logo_canvas $top.canvas
        canvas $logo_canvas -bd 0 -cursor {}
        set logo_bbox [$logo_canvas bbox [$logo_canvas create image 0 0 -image $logo_bitmap -anchor nw]]
        eval [list $logo_canvas create text] \
            $::env(THIS_PRODUCT_NAME_LOCATION_ON_LOGO) \
            [list -text $label_text -anchor nw -fill white -font {Helvetica 16}]

        eval [list $logo_canvas create text] \
            $::env(THIS_PRODUCT_BUILD_INFO_LOCATION_ON_LOGO) \
            [list -text $label_text_build_info -anchor nw -fill white -font {Helvetica 12}]

        eval [list $logo_canvas create text] \
            $::env(THIS_PRODUCT_NAME_LOCATION_ON_LOGO_AUX) \
            [list -text $label_text_aux -anchor nw -fill white -font {Helvetica 14}]


        set x_copyright_text [lindex $::env(THIS_PRODUCT_COPYRIGHT_LOCATION_ON_LOGO) 0]
        set y_copyright_text [lindex $::env(THIS_PRODUCT_COPYRIGHT_LOCATION_ON_LOGO) 1]
        if {[info exists copyright_text]} {
          eval [list $logo_canvas create text] \
              $x_copyright_text $y_copyright_text \
              [list -text $copyright_text -anchor nw -fill red -font {Helvetica 8}]
        }
        $logo_canvas conf -width [lindex $logo_bbox 2]
        $logo_canvas conf -height [lindex $logo_bbox 3]
        pack $logo_canvas
        
        if {$_withCloseButton} {
          button $logo_canvas.but -text OK -command [code delete obj $this ] -font {Helvetica 10 bold}
          
          set x [expr [lindex $logo_bbox 0] + [lindex $logo_bbox 2] - 40]
          set y [expr [lindex $logo_bbox 1] + 30]
          $logo_canvas create window $x $y -window $logo_canvas.but 
        }
        
        wm title $top "About $::env(THIS_PRODUCT_NAME_AND_VERSION)"
        #wm geometry $top +100+100
        set req_width [$logo_canvas cget -width]
        set req_height [$logo_canvas cget -height]
       
        set max_width [winfo vrootwidth $itk_interior]
        set max_height [winfo vrootheight $itk_interior]
        set geometry [format "+%s+%s" \
                          [expr round(($max_width - $req_width) / 2)] \
                          [expr round(($max_height - $req_height) / 2)]]
        wm geometry $top $geometry
         
        wm deiconify $top
        wm resizable $top 0 0

      }
    }
  }
}
