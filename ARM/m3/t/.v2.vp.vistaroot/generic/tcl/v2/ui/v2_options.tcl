#tcl-mode
proc v2_option_add {key value} {
#  if {[::Utilities::isUnix]} {
#    option add $key $value interactive
#  } else {
    option add $key $value interactive
#  }

# widgetDefault
# interactive
}
if {[::Utilities::isUnix]} {
  set defaultBackground \#bfbfbf
  set accentBackground \#ffffbb
  set defaultSelectionBackground \#637fbb ;# \#4464ac; #royalblue #blue
  set defaultForeground black
  set defaultSelectionForeground white
  set defaultFont "-adobe-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*"
  set defaultBoldFont "-adobe-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*"
  set defaultFixedFont "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
  set defaultBoldFixedFont "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
  set tooltipBackground \#ffffbb
  set nofocusselectbackground #bfefff
} else {

  label .tEmPlAbEl
  set labelBackground [option get .tEmPlAbEl background Background]
  if {$labelBackground == {}} {
    set labelBackground [.tEmPlAbEl cget -background]
  }
  set labelForeground [option get .tEmPlAbEl foreground Foreground]
  if {$labelForeground == {}} {
    set labelForeground [.tEmPlAbEl cget -foreground]
  }
  destroy .tEmPlAbEl
  
  entry .tempEnTrY
  set entryBackground [option get .tempEnTrY selectBackground Foreground]
  if {$entryBackground == {}} {
    set entryBackground [.tempEnTrY cget -selectbackground]
  }
  set entryForeground [option get .tempEnTrY selectForeground Background]
  if {$entryForeground == {}} {
    set entryForeground [.tempEnTrY cget -selectforeground]
  }
  destroy .tempEnTrY

  set defaultBackground SystemButtonFace
  set accentBackground \#ffffbb
  set defaultSelectionBackground $entryBackground
# SystemHighlight
  set defaultForeground SystemWindowText
  set defaultSelectionForeground SystemHighlightText
  set defaultFont "-adobe-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*"
  set defaultBoldFont "-adobe-helvetica-medium-r-normal-*-12-*-*-*-*-*-*-*"
  set defaultFixedFont "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
  set defaultBoldFixedFont "-adobe-courier-medium-r-normal--12-*-*-*-*-*-*-*"
  set tooltipBackground \#ffffbb
  set nofocusselectbackground #bfefff
#SystemActiveBorder
#SystemActiveCaption
#SystemAppWorkspace
#SystemBackground
#SystemButtonFace
#SystemButtonHighlight
#SystemButtonShadow
#SystemButtonText
#SystemCaptionText
#SystemDisabledText
#SystemHighlight
#SystemHighlightText
#SystemInactiveBorder
#SystemInactiveCaption
#SystemInactiveCaptionText
#SystemMenu
#SystemMenuText
#SystemScrollbar
#SystemWindow
#SystemWindowFrame
#SystemWindowText
}

v2_option_add *font $defaultFont
v2_option_add *labelFont $defaultFont

v2_option_add *background $defaultBackground
v2_option_add *foreground $defaultForeground

v2_option_add *titlebackground $defaultBackground

v2_option_add *highlightbackground $defaultBackground
v2_option_add *highlightBackground $defaultBackground

v2_option_add *helpbackground $tooltipBackground
v2_option_add *helpforeground $defaultForeground
v2_option_add *helpfont $defaultFont

v2_option_add *lightbackground white

v2_option_add *headerfont $defaultBoldFont
v2_option_add *headerforeground $defaultForeground
v2_option_add *headerbackground gray

v2_option_add *selectbackground $defaultSelectionBackground
v2_option_add *selectBackground $defaultSelectionBackground
v2_option_add *selectelementbackground cyan
v2_option_add *selectforeground $defaultSelectionForeground
v2_option_add *selectForeground $defaultSelectionForeground
v2_option_add *activebackground yellow

v2_option_add *selectedlabelbg $defaultSelectionBackground
v2_option_add *selectedlabelfg $defaultSelectionForeground
v2_option_add *labelbg $defaultBackground
v2_option_add *labelfg $defaultForeground

v2_option_add *textbackground white
v2_option_add *textBackground white
v2_option_add *disabledbackground white
v2_option_add *disabledBackground white
v2_option_add *disabledforeground gray50
v2_option_add *disabledForeground gray50
v2_option_add *nofocusselectbackground $nofocusselectbackground

v2_option_add *ComboBox.readonlybackground $defaultBackground
v2_option_add *ComboBox.readonlyBackground $defaultBackground

### Main Frame
v2_option_add *MainFrame.winwidth 768 
v2_option_add *MainFrame.winheight 640
v2_option_add *MainFrame.minsize {725 480}

### notebook option
v2_option_add *Notebook.background $defaultBackground
v2_option_add *Notebook.foreground $defaultForeground
v2_option_add *Notebook.font $defaultFont

### PercentBar
v2_option_add *PercentBar.bordercolor \#d9d9d9
v2_option_add *PercentBar.thresholdcolor black
v2_option_add *PercentBar.validpercentcolor green
v2_option_add *PercentBar.invalidpercentcolor red

### Tree Tables
v2_option_add *treebackground white

#TreeTable Balloon
v2_option_add *TreeTableBalloon.background $defaultBackground
v2_option_add *TreeTableBalloon.balloonborderwidth 1
v2_option_add *TreeTableBalloon.relief solid

#radiobutton
v2_option_add *Radiobutton.selectColor white
v2_option_add *Radiobutton.activeBackground $defaultBackground

#entry
v2_option_add *Entry.background white

#checkbutton
v2_option_add *Checkbutton.selectColor white
v2_option_add *Checkbutton.activeBackground white

### Dialogs
# font for explanation
v2_option_add *commentfont "*-arial-medium-r-normal-*-12-120-*"

### Source Views
v2_option_add *accentfont $defaultBoldFixedFont
v2_option_add *accentforeground blue
v2_option_add *accentbackground $accentBackground

v2_option_add *sourcefont $defaultFixedFont
v2_option_add *sourcecovinfobg \#969696 
v2_option_add *sourcelinebg $defaultBackground
v2_option_add *sourcebackground white
v2_option_add *sourceblockinfobg $defaultBackground

# report component view
v2_option_add *reportbackground $defaultBackground
v2_option_add *reportforeground $defaultForeground

#TreeView

v2_option_add *TreeView*background white
v2_option_add *HierTable*background white

#FileMultipleSelectionBox
v2_option_add *FileMultipleSelectionBox.selectbackground $defaultSelectionBackground
v2_option_add *FileMultipleSelectionBox.selectforeground $defaultSelectionForeground

#tixTable
v2_option_add *cellSelectBackground $defaultSelectionBackground

if {![::Utilities::isUnix]} {
  v2_option_add *Treetable*background $labelBackground
  v2_option_add *tablebackground $labelBackground
  v2_option_add *treebackground white
  v2_option_add *Treetable*foreground $labelForeground  
  v2_option_add *Text.selectBackground $entryBackground
  v2_option_add *selectBackground $entryBackground
  v2_option_add *selectelementbackground cyan
  v2_option_add *Text.selectForeground $entryForeground
  v2_option_add *selectForeground $entryForeground
  v2_option_add *Treetable*selectBackground $entryBackground
  v2_option_add *Treetable*selectForeground $entryForeground
#startupFile

  v2_option_add *Notebook.tabbackground $labelBackground
  v2_option_add *Notebook.selectbackground $entryBackground

  v2_option_add *headerforeground $labelForeground
  v2_option_add *headerbackground $labelBackground  

#Menus
  v2_option_add *BaseMenu*activeBackground $defaultSelectionBackground
  v2_option_add *FrameMenu*activeBackground $defaultSelectionBackground
  v2_option_add *ViewMenu*activeBackground $defaultSelectionBackground
  v2_option_add *BaseMenu*activeForeground $defaultSelectionForeground
  v2_option_add *FrameMenu*activeForeground $defaultSelectionForeground
  v2_option_add *ViewMenu*activeForeground $defaultSelectionForeground 
}

# tabset
v2_option_add *Tabset.selectForeground blue
