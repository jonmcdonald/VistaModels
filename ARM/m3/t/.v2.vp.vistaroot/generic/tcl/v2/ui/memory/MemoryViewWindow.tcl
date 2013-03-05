
namespace eval ::v2::ui::memory {

  class MemoryViewWindow {
    inherit ::UI::TopView

    constructor {_document args} {
      ::UI::TopView::constructor $_document [namespace parent]
    } {
      wm protocol $itk_interior WM_DELETE_WINDOW [itcl::code $this onDelete]
      eval itk_initialize $args
      #add_notebook
      create_standart_component $document

      itk_component add memory_view {
        ::v2::ui::memory::MemoryView $itk_interior.memory_view [$document create_tcl_sub_document DocumentTypeMemoryViewWindow]
      } {}
    }

    public method show {} {
      show_standart_component
      pack $itk_component(memory_view) -side top -fill both -expand 1
      chain
      pack forget $itk_component(toolbar)
    }

    private method set_geometry {} {
      wm minsize $itk_interior 300 200
      set width  [expr round([winfo screenwidth $itk_interior]*0.4)]
      set height [expr round([winfo screenheight $itk_interior]*0.4)]
      wm geometry $itk_interior \
          [format "%sx%s" $width $height]
    }

    #was protected
    public method onDelete {args} {
      $document run_command DestroyCommand
    }

  } ;# class MemoryViewWindow

} ;# namespace
