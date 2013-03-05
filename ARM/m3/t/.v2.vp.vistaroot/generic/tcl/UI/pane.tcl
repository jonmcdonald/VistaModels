#
# Paned
# ----------------------------------------------------------------------
# Implements a pane for a paned window widget.  The pane is itself a 
# frame with a child site for other widgets.  The pane class performs
# basic option management.
#
# ======================================================================

#
# Usual options.
#
itk::usual Pane {
  keep -background -cursor
}

# ------------------------------------------------------------------
#                               PANE
# ------------------------------------------------------------------
namespace eval ::UI {
  class Pane {
    inherit itk::Widget ::UI::DocumentUIBuilder
    
    public variable isselected 0
    private variable button_close ""
    public method get_button_close {} { return $button_close}

    constructor {_document args} {
      ::UI::DocumentUIBuilder::constructor $_document
    }  {

      # Create the pane childsite label.
      itk_component add paneltitle {
        label $itk_interior.paneltitle -anchor w -relief raised -bd 1 -justify left -padx 15
      } {
        keep -image -font -bitmap -underline -background -foreground
      }
      
      # Create the pane childsite.
      itk_component add childsite {
        frame $itk_interior.childsite 
      } {
        keep -background -cursor -width -height
      }
      pack $itk_component(childsite) -anchor nw -fill both -expand 1
      
      eval itk_initialize $args

      # Create the pane childsite toolbar.
      if {$itk_option(-withtoolbar) == 1} { 

        itk_component add toolbar {
          ::UI::Toolbar $itk_interior.toolbar $document -buttonheight 10
        } {
          keep -background -foreground -font
        }
        $itk_component(toolbar) show

        set button_close [$itk_component(toolbar) addVariableButton [$itk_component(toolbar) get_frame] \
                              close close "Close"]

        $itk_component(toolbar) configure -buttonheight $itk_option(-toolbarheight)
        $itk_component(toolbar) pack_right [$itk_component(toolbar) get_frame] close
        pack $itk_component(toolbar) -before $itk_component(childsite) -fill x -anchor nw
      } else {
        if {$itk_option(-withtoolbar) != 0} {
          error "-withtoolbar must be 0 or 1"
        }
      }

      set_binding
    }

    private method set_binding {} {
    }

    destructor {}

    itk_option define -minimum minimum Minimum 10
    itk_option define -marginx marginx Marginx 0
    itk_option define -marginy marginy Marginy 0
    itk_option define -thickness thickness Thickness 0
    itk_option define -orientpane orientpane OrientPane horizontal
    
    itk_option define -titlevariable titleVariable TitleVariable "" 
    itk_option define -withtitle withTitle WithTitle 0
    itk_option define -withtoolbar withToolbar WithToolbar 0 ;# read only
    itk_option define -toolbarheight toolbarHeight ToolbarHeight 10; # read only

    itk_option define -selectedlabelbg selectedlabelbg SelectedLabelBG blue
    itk_option define -selectedlabelfg selectedlabelfg SelectedLabelFG white
    itk_option define -labelbg labelbg LabelBG blue
    itk_option define -labelfg labelfg LabelFG white   

    itk_option define -showInCreate showincreate ShowInCreate 1
    itk_option define -state state State "normal"
    
    public method childsite {}
    public method paneltitle {}    
    public method toolbar {}
    
    public method set_selected {is_selected} 
    public method is_inherited_from_pane {} { return 1}
    public method update_title {title} {
      $itk_component(paneltitle) configure -text $title
    }
  }
}

#
# Provide a lowercased access method for the Pane class.
# 
proc ::UI::pane {pathName args} {
  uplevel ::UI::Pane $pathName $args
}

# ------------------------------------------------------------------
#                        CONSTRUCTOR
# ------------------------------------------------------------------

# ------------------------------------------------------------------
#                             OPTIONS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# OPTION: -minimum
#
# Specifies the minimum size that the pane may reach.
# ------------------------------------------------------------------
configbody ::UI::Pane::minimum {
  set pixels \
	    [winfo pixels $itk_component(hull) $itk_option(-minimum)]
  
  set itk_option(-minimum) $pixels
}

# ------------------------------------------------------------------
# OPTION: -marginx
#
# Specifies the border distance between the pane and pane contents by x axis.
# ------------------------------------------------------------------
configbody ::UI::Pane::marginx {
  set pixels [winfo pixels $itk_component(hull) $itk_option(-marginx)]
  set itk_option(-marginx) $pixels
  
  pack configure $itk_component(childsite) -padx $itk_option(-marginx)
}

# ------------------------------------------------------------------
# OPTION: -marginy
#
# Specifies the border distance between the pane and pane contents by y axis.
# ------------------------------------------------------------------
configbody ::UI::Pane::marginy {
  set pixels [winfo pixels $itk_component(hull) $itk_option(-marginy)]
  set itk_option(-marginy) $pixels
  
  pack configure $itk_component(childsite) -pady $itk_option(-marginy)
}

configbody ::UI::Pane::titlevariable {
  if {$itk_option(-withtitle) == 1} {
    if {$itk_option(-titlevariable) != ""} {
      $itk_component(paneltitle) configure -textvariable $itk_option(-titlevariable)
    } else {
      $itk_component(paneltitle) configure -textvariable ""
    }
    
  }
}

configbody ::UI::Pane::withtitle {
  switch $itk_option(-withtitle) {
    0 {
      if {[winfo manager $itk_component(paneltitle)] != ""} {
        pack forget $itk_component(paneltitle)
      }
    }
    1 {
      if {[winfo manager $itk_component(paneltitle)] == ""} {
        if {$itk_option(-withtoolbar) && [winfo manager $itk_component(toolbar)] != ""} {
          pack $itk_component(paneltitle) -before $itk_component(toolbar) -fill x -anchor nw -side top
        } else {
          pack $itk_component(paneltitle) -before $itk_component(childsite) -fill x -anchor nw -side top
        }
      }
    }
    default {
      error "-withtitle must be 0 or 1"
    }
  }
}

# ------------------------------------------------------------------
# OPTION: -orientpane
#
#  Specifies the orientation of the pane.
# ------------------------------------------------------------------
configbody ::UI::Pane::orientpane {
  configure -thickness $itk_option(-thickness)
}

# ------------------------------------------------------------------
# OPTION: -thickness
#
#  Specifies the thickness of the pane.
# ------------------------------------------------------------------
configbody ::UI::Pane::thickness {
  if {$itk_option(-orientpane) == "horizontal"} {
    configure -height $itk_option(-thickness) -width 0
  } else {
    configure -width $itk_option(-thickness) -height 0
  }
}


# ------------------------------------------------------------------
#                            METHODS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# METHOD: childsite
#
# Return the pane child site path name.
# ------------------------------------------------------------------
body ::UI::Pane::childsite {} {
  return $itk_component(childsite)
}

# ------------------------------------------------------------------
# METHOD: paneltitle
#
# Return the pane label path name.
# ------------------------------------------------------------------
body ::UI::Pane::paneltitle {} {
  return $itk_component(paneltitle)
}

# ------------------------------------------------------------------
# METHOD: toolbar
#
# Return the pane toolbar path name.
# ------------------------------------------------------------------
body ::UI::Pane::toolbar {} {
  if {!$itk_option(-withtoolbar)} {
    return ""
  }
  return $itk_component(toolbar)
}

configbody ::UI::Pane::isselected {
  if {$isselected == 1} {
    $itk_component(paneltitle) configure -background $itk_option(-selectedlabelbg)
    $itk_component(paneltitle) configure -foreground $itk_option(-selectedlabelfg)
    if {$itk_option(-withtoolbar) && [info exists itk_component(toolbar)]} {
      $itk_component(toolbar) configure -framebackground $itk_option(-selectedlabelbg)
    }
  } else {
    $itk_component(paneltitle) configure -background [cget -labelbg]
    $itk_component(paneltitle) configure -foreground [cget -labelfg] 
    if {$itk_option(-withtoolbar) && [info exists itk_component(toolbar)]} {
      $itk_component(toolbar) configure -framebackground [cget -labelbg]
    }
  }
}
 
namespace eval ::UI {
  ::itcl::class UI/Pane/DocumentLinker {
    inherit DataDocumentLinker
    protected method attach_to_data {widget document {ShowVariable ""}} {
      if {$ShowVariable != ""} {
        $widget attach [$widget get_button_close] $ShowVariable
      }
    }
  }

  UI/Pane/DocumentLinker UI/Pane/DocumentLinkerObject
}
