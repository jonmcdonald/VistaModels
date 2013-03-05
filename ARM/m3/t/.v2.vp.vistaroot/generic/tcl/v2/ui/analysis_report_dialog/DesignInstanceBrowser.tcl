namespace import -force ::itcl::*

namespace eval ::v2::ui::analysis_report_dialog {
  
  class DesignInstanceBrowser {

    inherit ::UI::BaseDialog

    constructor {_document args} {
      ::UI::BaseDialog::constructor [$_document create_tcl_sub_document DocumentTypeInstanceTreeView]
    } {
      create_body
      create_buttons
      eval itk_initialize $args
      wm minsize   $itk_interior 280 380
      draw
    }

    protected method create_body {} {
      set top [get_body_frame]

      itk_component add tree_view {
        ::v2::ui::analysis_report_dialog::DesignTree $top.tree_view \
            [$document create_tcl_sub_document DocumentTypeInstanceTreeView]
      } {}

      pack $itk_component(tree_view) -side left -anchor nw -fill both -expand 1
    }

    protected method create_buttons {} {
      add_button "" -text "OK" -width 5 -underline 0 -command [code $this InstanceBrowserOKCommand]
      add_button DestroyCommand -text "Close"
    }

    private method InstanceBrowserOKCommand {} {
      $document run_command SetInstanceCommand
      $document run_command DestroyCommand
    }


  } ;# class


} ;# namespace
