source [file dirname [info script]]/basic_tree.tcl
namespace eval ::Utilities::ns_tree {

  proc construct_tree {ns} {
    construct_basic_tree $ns
    namespace eval $ns {

      proc virtual_get_node_data {path} {
        return {}
      }
      proc virtual_get_children_names {path} {
        return {}
      }

      proc _open_node {path} {
        debug_tree [info level 0]
        if {![_insure_path $path]} {
          return
        }
        if {![_get_has_children_flag $path]} {
          return
        }
        if {[llength [_get_children_names $path]]} {
          return
        }
        _update_children $path
      }

      proc _insure_path {path} {
        debug_tree [info level 0]
        if {[_does_node_exist $path]} {
          return 1
        }
        _update_tree_1 [path::root]
        if {![_does_node_exist [path::root]]} {
          return 0
        }
        if {[_does_node_exist $path]} {
          return 1
        }

        set length [path::length $path]
        set child [path::root]
        for {set i 1} {$i < $length} {incr i} {
          set parent $child
          set child [path::sub_path $path 0 $i]
          if {[_does_node_exist $child]} {
            continue
          }
          # child does not exist
          # if we already have children it means that the child does not exist at all
          if {[llength [_get_children_names $parent]] != 0} {
            return 0
          }
          ;# add subtree
          while {1} {
            _update_children $parent
            if {![_does_node_exist $child]} {
              return 0
            }
            incr i
            if {$i == $length} {
              break
            }
            set parent $child
            set child [path::sub_path $path 0 $i]
          }
          return 1
        }
        return 0
      }

      proc _update_children {path} {
        debug_tree [info level 0]

        set old_children_names [_get_children_names $path]
        set new_children_names {}
        foreach child_name [virtual_get_children_names [path::normalize $path]] {
          lappend new_children_names [path::escape $child_name]
        }
        foreach child_name [union $old_children_names $new_children_names] {
          _update_tree_1 [path::join_element $path $child_name]
        }
      }

      proc _update_tree_1 {path} {
        debug_tree [info level 0]
        set new_node_data [virtual_get_node_data [path::normalize $path]]
        if {$new_node_data == ""} {
          if {[_does_node_exist $path]} {
            _remove_tree $path
          }
          return
        }
        if {![string equal [_get_node_data $path] $new_node_data]} {
          _set_node_data $path $new_node_data
        }
        if {[llength [_get_children_names $path]] == 0} {
          return
        }
        _update_children $path
      }


      #------------ API ---------
      proc open_node {path} {
        debug_tree [info level 0]
        _open_node [path::add_root [path::escape $path]]
        return ""
      }

      proc update_tree {{path ""}} {
        debug_tree [info level 0]
        _update_tree_1 [path::add_root [path::escape $path]]
        return ""
      }

    }
  }
}
