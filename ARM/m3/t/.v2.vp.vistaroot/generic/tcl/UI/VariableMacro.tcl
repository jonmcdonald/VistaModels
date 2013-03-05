namespace eval ::UI {
  ##
  # Tcl Macro: ADD_VARIABLE_BASIC
  #
  # Is used by the Tcl Macro ADD_VARIABLE below to create (once per class)
  # the common methods and variables.
  #
  # See the description of Tcl Macro ADD_VARIABLE for more information.
  ##
  proc ADD_VARIABLE_BASIC {} {
    uplevel {
      if {![info exists ADD_VARIABLE_BASIC_called]} {
        common ADD_VARIABLE_BASIC_called 1

        protected method set_new_value_with_callbacks {valueVarname new_value} {
          set oldValueVarname [set valueVarname]Old
          set $oldValueVarname [set $valueVarname]

          set variableIsHandledVarname [set valueVarname]IsHandled
          set oldIsHandledFlag [set $variableIsHandledVarname]
          set $variableIsHandledVarname 1
          catch {clean_data/$valueVarname}
          catch {clean_gui/$valueVarname}
          if {[ catch {check_new_value/$valueVarname $new_value} ]} {
            set $variableIsHandledVarname $oldIsHandledFlag
            if {![set $variableIsHandledVarname]} {
              if {[info exist $oldValueVarname]} {
                unset $oldValueVarname
              }
            }
            return ;# error during check
          }
          if {[ catch {set $valueVarname $new_value} ]} {
            set $variableIsHandledVarname $oldIsHandledFlag
            if {![set $variableIsHandledVarname]} {
              if {[info exist $oldValueVarname]} {
                unset $oldValueVarname
              }
            }
            return ;# error during set
          }
          if {[ catch { ;# try to set value
            setup_data/$valueVarname
            update_gui/$valueVarname
          } msg]} { ;# error
            catch {handle_error/$valueVarname $msg $::errorInfo $::errorCode}
          }
          set $variableIsHandledVarname $oldIsHandledFlag
          if {![set $variableIsHandledVarname]} {
            unset $oldValueVarname
          }
        }

        protected method is_variable_handled {valueVarname} {
          set variableIsHandledVarname [set valueVarname]IsHandled
          return [set $variableIsHandledVarname]
        }

        protected method on_data_changed {valueVarname widget var_name sub op} {
          set optionVarname [set valueVarname]Variable

          if {[info exists [set $optionVarname]]} {
            set new_value [set [set $optionVarname]]
            set_new_value_with_callbacks $valueVarname $new_value
          }
        }
        
        protected method on_data_unset {valueVarname widget var_name sub op} {
          set_data_callback $valueVarname
          set_data_unset_callback $valueVarname
        }
        
        protected method set_data_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable

          ::UI::auto_trace variable [set $optionVarname] w $itk_interior [itcl::code $this on_data_changed $valueVarname]
        }
        
        protected method remove_data_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable

          ::UI::auto_trace vdelete [set $optionVarname] w $itk_interior [itcl::code $this on_data_changed $valueVarname]
        }
        
        protected method set_data_unset_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable

          ::UI::auto_trace variable [set $optionVarname] u $itk_interior [itcl::code $this on_data_unset $valueVarname]
        }
        
        protected method remove_data_unset_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable

          ::UI::auto_trace vdelete [set $optionVarname] u $itk_interior [itcl::code $this on_data_unset $valueVarname]
        }
        
        protected method clean_gui {} {}
        
        protected method update_gui {} {}

        protected method destruct_variable {valueVarname} {
          set optionVarname [set valueVarname]Variable
          set defaultOptionVarname [set optionVarname]Default

          catch {remove_data_callback $valueVarname}
          catch {remove_data_unset_callback $valueVarname}
          catch {clean_data/$valueVarname}
          catch {if {[info exists [set $defaultOptionVarname]]} {unset [set $defaultOptionVarname]}}
        }
        
        protected method construct_variable {valueVarname} {
          set optionVarname [set valueVarname]Variable
          set defaultOptionVarname [set optionVarname]Default
          set defaultValueVarname [set valueVarname]Default

          set $optionVarname [::Utilities::createUniqueIdentifier ::VariableMacro]
          set $defaultOptionVarname [set $optionVarname]
          set [set $optionVarname] [set $defaultValueVarname]
          set $valueVarname [set $defaultValueVarname]
        }
        
        protected method variable_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable
          set defaultOptionVarname [set optionVarname]Default
          set optionName "-[set valueVarname]"
          set variableOptionName [set optionName]variable

          set current_var_name [full_variable_path $itk_option($variableOptionName)]
          if {$current_var_name == ""} {
            set current_var_name [set $defaultOptionVarname]
            set current_var_name [full_variable_path $current_var_name]
            set itk_option($variableOptionName) $current_var_name
          }
          if {$current_var_name != [set $optionVarname]} {
            remove_data_callback $valueVarname
            remove_data_unset_callback $valueVarname
            
            set $optionVarname $current_var_name
            
            if {[info exists $current_var_name]} {
              set new_value [set $current_var_name]
              if {$new_value != [set $valueVarname]} {
                set_new_value_with_callbacks $valueVarname $new_value
              }
            } else {
              set $current_var_name [set $valueVarname]
            }
          
            set_data_callback $valueVarname
            set_data_unset_callback $valueVarname
          }
        }
    
        protected method value_callback {valueVarname} {
          set optionVarname [set valueVarname]Variable
          set optionName "-[set valueVarname]"
          set variableOptionName [set optionName]variable

          set new_value $itk_option($optionName)

          if {$new_value != [set $valueVarname]} {
            set current_var_name [full_variable_path $itk_option($variableOptionName)]
            set $current_var_name $itk_option($optionName)

            set_new_value_with_callbacks $valueVarname $new_value
          }
        }
        
        protected method full_variable_path {var} {
          if {$var == ""} {
            return ""
          }
          if {[string equal [string range $var 0 1] "::"]} {
            return $var
          }
          return ::$var
        }

      }
    }
  }

  ##
  # Tcl Macro: ADD_VARIABLE valueVarname  resourceClass (optional) init). 
  #
  # Usage:
  #
  # *   In Itk class scope:
  #       ADD_VARIABLE $valueVarname $resourceClass (optional) $init
  #           where $resourceClass should be the same as $valueVarname, except
  #           it has to start with a Capital Letter.
  #     
  # *   In the Itk class constructor:
  #       construct_variable $valueVarname
  #
  # *   In the Itk class constructor:
  #       destruct_variable $valueVarname
  #
  #
  # This macro should be included in an Itk class to create the following:
  #
  # *  An itk_option named $valueVarname. It will be initialized to the value of $init.
  #
  # *  An itk_option named [set valueVarname]variable.
  #
  # *  A protected variable named $valueVarname and
  #    equal to the value of $itk_option($valueVarname).
  #
  # *  A protected variable named [set valueVarname]Old and
  #    equal to the value of $itk_option($valueVarname)
  #    before the last change.
  #
  # *  A protected method named setup_data/$valueVarname
  #    and called when the value of $itk_option($valueVarname) is changed.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method does nothing.
  #
  # *  A protected method named update_gui/$valueVarname
  #    and called right after the call to setup_data/$valueVarname.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method calls the method update_gui.
  #
  # *  A protected method named update_gui.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method does nothing.
  #
  # *  A protected method named clean_data/$valueVarname
  #    and called when the value of $itk_option($valueVarname)
  #    is about to be changed or when the object is being destroyed.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method does nothing.
  #
  # *  A protected method named clean_gui/$valueVarname
  #    and called right after the call to clean_data/$valueVarname,
  #    except when the object is being destroyed.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method calls the method clean_gui.
  #
  # *  A protected method named clean_gui.
  #    This method does not have arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method does nothing.
  #
  # *  A protected method named check_new_value/$valueVarname
  #    and called right after the call to clean_gui/$valueVarname.
  #    This method receives the new value of $itk_option($valueVarname)
  #    as its argument.
  #    If this method throws error,
  #    the old value of $itk_option($valueVarname) is restored.
  #    Client code may redefine the body of this method.
  #    By default, this method does nothing.
  #
  # *  A protected method named handle_error/$valueVarname
  #    and called if setup_data/$valueVarname or update_gui/$valueVarname
  #    threw an error.
  #    This method receives readable message, ::errorInfo and ::errorCode
  #    as its arguments.
  #    Client code may redefine the body of this method.
  #    By default, this method calls clean_gui/$valueVarname.
  #
  # *  A protected method named is_variable_handled
  #    which should be called to figure out whether one of the callbacks
  #    is in stack.
  #    This method receives $valueVarname as its argument.
  ##
  proc ADD_VARIABLE {valueVarname resourceClass {init ""}} {
    set optionVarname [set valueVarname]Variable

    set oldValueVarname [set valueVarname]Old

    set optionName "-[set valueVarname]"
    set resourceName $valueVarname

    set variableOptionName [set optionName]variable
    set variableResourceName [set resourceName]Variable
    set variableResourceClass [set resourceClass]Variable
    
    set defaultOptionVarname [set optionVarname]Default
    set defaultValueVarname [set valueVarname]Default

    set variableIsHandledVarname [set valueVarname]IsHandled

    uplevel ::UI::ADD_VARIABLE_BASIC

    uplevel [list protected variable $valueVarname ""]
    uplevel [list protected variable $oldValueVarname ""]
    uplevel [list protected variable $optionVarname ""]
    uplevel [list protected variable $defaultOptionVarname ""]
    uplevel [list protected variable $defaultValueVarname $init]
    uplevel [list protected variable $variableIsHandledVarname 0]
    uplevel [list \
                 itk_option define \
                 $variableOptionName $variableResourceName $variableResourceClass "" \
                 [list \
                      variable_callback $valueVarname ]]

    uplevel [list \
                 itk_option define $optionName $resourceName $resourceClass $init \
                 [list \
                      value_callback $valueVarname ]]

    uplevel [list protected method setup_data/$valueVarname [list] [list]]
    uplevel [list protected method clean_data/$valueVarname [list] [list]]
    uplevel [list protected method check_new_value/$valueVarname [list value] [list]]
    uplevel [list protected method update_gui/$valueVarname [list] [list update_gui]]
    uplevel [list protected method clean_gui/$valueVarname [list] [list clean_gui]]
    uplevel [list protected method handle_error/$valueVarname [list message info code] [list clean_gui/$valueVarname]]
  }
}
