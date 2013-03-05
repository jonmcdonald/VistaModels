#tcl-mode
option add *SToplevel.helpbackground yellow widgetDefault
option add *SToplevel.helpforeground black widgetDefault
option add *SToplevel.helpFont "*-arial-medium-r-normal-*-12-120-*" widgetDefault

namespace eval ::UI {
  class SToplevel {
    inherit itk::Toplevel ::UI::DocumentOwner
    
    itk_option define -helpfont helpfont Font "*-arial-medium-r-normal-*-12-120-*" {
      DynamicHelp::configure -font $itk_option(-helpfont)
    }
    
    itk_option define -helpforeground helpforeground Helpforeground blue {
      DynamicHelp::configure -foreground $itk_option(-helpforeground)
    }

    itk_option define -helpbackground helpbackground Helpbackground white {
      DynamicHelp::configure -background $itk_option(-helpbackground)
    }
    
    ::UI::ADD_VARIABLE title Title ""
    
    constructor {_document args} {
      ::UI::DocumentOwner::constructor $_document
    } {
      construct_variable title
      
      wm withdraw $itk_interior
      eval itk_initialize $args
      set [$document get_variable_name WidgetName] $itk_interior
      setCurrentTopWindowWidgetName

      set_binding
    }

    destructor {
      destruct_variable title
    }

    protected method set_binding {} {
      bind $itk_interior <Control-slash><d><e><b><m><a><i><n> \
          [code ::UI::run_document_debugger 0]
      bind $itk_interior <Control-slash><d><e><b><u><g> \
          [code $document run_command DebugCommand]
      bind $itk_interior <Control-slash><c><o><n><s><o><l><e> \
          [code $document run_command ConsoleCommand]
      bind $itk_interior <FocusIn> \
          [code $this setCurrentTopWindowWidgetName]
      
    }

    public method postInit {_document args} {
      catch {configure -titlevariable [$_document get_variable_name Title]}
    }
    
    public method show {} {
      wm deiconify $itk_interior
      raise $itk_interior
      ::Utilities::withVariable ::Utilities::dontDisplayErrors 1 {
        if {[catch {wm iconphoto $itk_interior [::UI::getgifimage top]}]} {
          if {[info exists ::errorInfo]} {
            set ::errorInfo ""
          }
        }
      }
    }

    public method hide {} {
      wm withdraw $itk_interior
    } 

    public method on_visible {} {}
    public method update_title {} {}
    public method saveGeometry {} {}
    public method run_component_command {component command args} {
      set index [lsearch [$itk_interior component] $component]
      if {$index != -1} {
        eval [list $itk_component($component) $command] $args
      }
    }
    
    protected method setCurrentTopWindowWidgetName {} {
      if {[$document get_variable_value CurrentTopWindowWidgetName] != $itk_interior} {
        $document set_variable_value CurrentTopWindowWidgetName $itk_interior
      }
    }
  }
}

itcl::body ::UI::SToplevel::update_gui/title {} {
  wm title $itk_interior "$::env(THIS_PRODUCT_NAME) - $title"
}
