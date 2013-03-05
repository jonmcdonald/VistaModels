namespace eval ::Document {

  class Document {
    common currentDocument ""
    private variable document
    constructor {docID} {
      set document $docID
      ::Document::lockDocument $document
    }
    public method clone {} {
      return [objectNew ::Document::Document $document]
    }
    destructor {
      ::Document::unlockDocument $document
    }
    public method get_ID {} {
      return $document
    }

    public method get_sub_document_ID {tag} {
      return [::Document::getSubdocument $document $tag]
    }

    public method create_tcl_sub_document {tag} {
      return [::Utilities::objectNew ::Document::Document [get_sub_document_ID $tag]]
    }
    
    public method get_type {} {
      return [::Document::getDocumentType $document]
    }

    ;# returns a path to the namespace where the document data is stored
    public method get_workspace {} {
      return [::Document::getDocumentWorkspace $document]
    }
    ;# returns full variable name according to the document and tag
    public method get_variable_name {tag} {
      return [::Document::getModelVariableName $document $tag]
    }
    ;# returns variable value according to the document and tag
    public method get_variable_value {tag} {
      return [set [get_variable_name $tag]]
    }
    public method get_array_size {tag} {
      return [array size [get_variable_name $tag]]
    }
    
    ;# sets variable value according to the document and tag
    public method set_variable_value {tag value} {
      set [get_variable_name $tag] $value
    }
    ;# returns a name of the variable, which used to enabling/disabling the command
    public method get_enable_variable_name {tag} {
      return [::Document::getEnableVariableName $document $tag]
    }
    ;# returns a name of the variable, which used to store the reason why the command is disabled
    public method get_disable_reason_variable_name {tag} {
      return [::Document::getDisableReasonVariableName $document $tag]
    }
    public method get_free_variable_name {} {
      set space [get_workspace]
      while {[info exists [set var_name [set space]::tmp[createUniqueIdentifier]]]} {}
      return $var_name
    }
    public method isEnabled {tag} {
      set enable_var_name [get_enable_variable_name $tag]
      return [expr {![info exists $enable_var_name] || [set $enable_var_name] != "0"}]
    }
    public method run_command_with_result {tag args} {
      set_variable_value LastCommandResult {}
      eval [list $this run_command $tag] $args
      return [$this get_variable_value LastCommandResult]
    }
    public method run_command_with_result_ex {tag args} {
      set_variable_value LastCommandResult {}
      eval [list $this run_command_ex $tag] $args
      return [$this get_variable_value LastCommandResult]
    }
    ;# evaluates a command on the document
    public method run_command {tag args} {
      set result ""
      if {[catch {
        set result [eval [list run_command_ex $tag] $args]
      } msg]} {
        puts "Command `$tag' finished with error:\n$msg"
      }
      return $result
    }
    ;# evaluates a command on the document. may throw exception
    public method run_command_ex {tag args} {
      if {![isEnabled $tag]} {
        error "Command $tag is disabled"
      }
      ::Utilities::FINAL_ACTION [list set currentDocument $currentDocument]
      set currentDocument $this
      eval [list ::Document::runCommand $document $tag] $args
    }
    ;# internal function: called as a trace callback when the variable is changed
    private method document_execute_command {commandName arglist var_name sub_name op} {
      eval [list run_command $document $commandName] $arglist
    }
    ;# adds a command, to be evaluated, when the variable is changed
    public method add_variable_command {tag commandName args} {
      set variableName [get_variable_name $tag]
      trace variable $variableName w [itcl::code $this document_execute_command $commandName $args]
    }
    public method get_sub_enable_variable_name {tag value} {
      return [::Document::getSubEnableVariableName $document $tag $value]
      #return "[get_enable_variable_name $tag]/$value"
    }
    public method is_value_valid {tag value} {
      return [::Document::isValueValid $document $tag $value]
    }
    
    public method is_command_name {tag} {
      return [::Document::isCommandName $document $tag]
    }

    public method is_model_name {tag} {
      return [::Document::isModelName $document $tag]
    }

    public method is_own_command_name {tag} {
      return [::Document::isOwnCommandName $document $tag]
    }

    public method is_own_model_name {tag} {
      return [::Document::isOwnModelName $document $tag]
    }

    public method is_inherited_command_name {tag} {
      return [::Document::isInheritedCommandName $document $tag]
    }

    public method is_inherited_model_name {tag} {
      return [::Document::isInheritedModelName $document $tag]
    }

    public method get_interface_names {} {
      return [::Document::getInterfaceNames $document]
    }

    public method get_inherited_document_ids {} {
      return [::Document::getInheritedDocumentsIDs $document]
    }

## Temporary
    public method getCovFilesList {} {
      return ""
    }
    public method getDgnFilesList {} {
      return ""
    }
    public method getFSMFilesList {} {
      return ""
    }

    public method getToggleMasterFile {} {
      return ""
    }
    public method getCovFile {} {
      return ""
    }

    public method getDesignFile {} {
      return ""
    }

    public method getFSMFile {} {
      return ""
    }
    
## end Temporary


  }

  proc get_document_ids {} {
    return [::Document::getDocumentIDs]
  }



  ;# Utility, which returns correct value of the eneble variable.
  ;# If the one does not exist, 1 is returned
  proc get_enable_value {enable_var_name} {
    if {[info exists $enable_var_name]} {
      return [set $enable_var_name]
    } else {
      return 1
    }
  }

  proc splitVariableName {variableName} {
    if {![regexp {^::document::Document(.+)::((Enable_)|(Model_))(.+)$} $variableName all docId type a1 a2 varName]} {
      error "$variableName has an invalid format"
    }
    return [list $docId $type $type$varName $varName]
  }


  proc getChild {parentID childType} {
    variable childrenMap
    set key "$parentID,$childType"
    if {![info exists childrenMap($key)]} {
      return ""
    }
    return $childrenMap($key);
  }
  
  proc getParent {childID parentType} {
    variable parentsMap
    set key "$childID,$parentType"
    if {![info exists parentsMap($key)]} {
      return ""
    }
    return $parentsMap($key);
  }

  proc _setChild {parentID childType childID} {
    variable childrenMap
    set key "$parentID,$childType"
    set childrenMap($key) $childID
  }

  proc _setParent {childID parentType parentID} {
    variable parentsMap
    set key "$childID,$parentType"
    set parentsMap($key) $parentID
  }

  set deleteRelationsBeforeSet 0

  proc setRelations {parentID parentType childID childType} {
    variable deleteRelationsBeforeSet
    if {$deleteRelationsBeforeSet} {
      _deleteRelations
    }
    _setChild $parentID $childType $childID
    _setParent $childID $parentType $parentID
  }

  proc _deleteRelations {} {
    variable parentsMap
    variable childrenMap
    if {[info exists parentsMap]} {
      unset parentsMap
    }
    if {[info exists childrenMap]} {
      unset childrenMap
    }
  }
  
  proc isChild {childID parentID} {
    variable childrenMap
    foreach key [array names childrenMap "$parentID,*"] {
      if {$childrenMap($key) == $childID} {
        return 1
      }
    }
    return 0
  }
}
