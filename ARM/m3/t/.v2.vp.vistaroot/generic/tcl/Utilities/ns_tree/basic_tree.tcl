proc debug_tree {str} {
#  puts "debug_tree:$str"
}
namespace eval ::Utilities::ns_tree {

  proc construct_basic_tree {ns} {
    namespace eval $ns {
      namespace eval path {
        proc root {} {
          return .
        }
        proc add_root {path} {
          if {[lindex $path 0] == "."} {
            return $path
          }
          return [concat [list .] $path]
        }
        proc get_parent {path} {
          return [lrange $path 0 end-1]
        }
        proc join_element {path tail_element} {
          return [lappend path $tail_element]
        }
        proc join_paths {path1 path2} {
          return [concat $path1 $path2]
        }
        proc sub_path {path from to} {
          return [lrange $path $from $to]
        }
        proc length {path} {
          return [llength $path]
        }
        proc escape {path} {
          return [regsub -all -- "::" $path "DVADVOETO4IJA"]
        }
        proc normalize {path} {
          return [regsub -all -- "DVADVOETO4IJA" $path "::"]
        }
      }

      namespace eval node {
        
        proc construct {user_data has_children} {
          return [list $user_data $has_children]
        }

        proc get_has_children_flag {node_data} {
          return [lindex $node_data 0]
        }
        
        proc get_user_data {node_data} {
          return [lindex $node_data 1]
        }
      }

      proc _does_node_exist {path} {
        return [info exist [namespace current]::[set path]]
      }

      proc _get_node_data {path} {
        if {![_does_node_exist $path]} {
          return {}
        }
        return [set [namespace current]::[set path]]
      }

      proc _set_node_data {path data} {
        set [namespace current]::[set path] $data
        virtual_on_node_changed [path::normalize $path]
      }

      proc _get_children_names {path} {
        debug_tree [info level 0]
        if {![_does_node_exist $path]} {
          return {}
        }
        set var_list [info vars [namespace current]::[concat . * ]]
        set result {}
        set lengthMinus1 [expr [llength $path] - 1]
        set lengthPlus1 [expr $lengthMinus1 + 2]
        foreach var $var_list {
          set v [namespace tail $var]
          if {[llength $v] != $lengthPlus1} {
            continue
          }
          if {![string equal [lrange $v 0 $lengthMinus1] $path]} {
            continue
          }
          lappend result [lindex $v end]
        }
        return $result
      }

      proc _get_has_children_flag {path} {
        debug_tree [info level 0]
        set node_data [_get_node_data $path]
        if {$node_data == ""} {
          return 0
        }
        return [expr [node::get_has_children_flag $node_data] != 0]
      }

      # removes node with path=`path` together with it's the subtree from the tree
      proc _remove_tree {path} {
        debug_tree [info level 0]
        if {![_does_node_exist $path]} {
          return
        }
        _remove_children $path
        unset [namespace current]::$path
        virtual_on_tree_removed [path::normalize $path]
      }

      # removes children of the node with path=`path`
      proc _remove_children {path} {
        debug_tree [info level 0]
        set var_list [info vars [namespace current]::[concat . * ]]

        set lengthMinus1 [expr [llength $path] - 1]
        set lengthPlus1 [expr $lengthMinus1 + 2]

        foreach var $var_list {
          set v [namespace tail $var]
          if {[llength $v] != $lengthPlus1} {
            continue
          }
          if {![string equal [lrange $v 0 $lengthMinus1] $path]} {
            continue
          }
          unset $var
        }
      }

      proc get_tree_data {} {
        debug_tree [info level 0]
        return [::Utilities::copy_namespace_variables_to_script [namespace current]]
      }

      proc _traverse_tree {path function Args} {
        debug_tree [info level 0]
        set result1 [eval [list $function pre_visit [path::normalize $path]] $Args]
        if {$result1 == ".stop"} {
          return ".stop"
        }
        if {$result1 != ".dont_go_deeper"} {
          foreach child [_get_children_names $path] {
            set result2 [_traverse_tree [path::join_element $path $child] $function $Args]
            if {$result2 == ".stop"} {
              return ".stop"
            }
            if {$result2 == ".dont_traverse_siblings"} {
              break
            }
          }
        }
        set result3 [eval [list $function post_visit [path::normalize $path]] $Args]
        if {$result3 == ".stop"} {
          return ".stop"
        }
        if {$result1 == ".dont_traverse_siblings" || $result3 == ".dont_traverse_siblings"} {
          return ".dont_traverse_siblings"
        }
        return ""
      }


      proc traverse_tree {path function args} {
        debug_tree [info level 0]
        set path [path::add_root [path::escape $path]]
        if {![_does_node_exist $path]} {
          return
        }
        _traverse_tree $path $function $args
      }

      proc print_tree {{root ""} } {
        variable tab
        set tab 0
        proc printer {command path args} {
          variable tab
          if {$command == "pre_visit"} {
            set spaces [string repeat " " $tab]
            puts "$spaces$path"
            incr tab 2
          } else {
            incr tab -2
          }
        }
        
        traverse_tree $root [namespace current]::printer
      }


      #virtual functions

      proc virtual_on_node_changed {path} {
      }

      proc virtual_on_tree_removed {path} {
      }


      proc does_node_exist {path} {
        debug_tree [info level 0]
        return [_does_node_exist [path::add_root [path::escape $path]]]
      }

      proc has_children {path} {
        debug_tree [info level 0]
        return [_get_has_children_flag [path::add_root [path::escape $path]]]
      }

      proc get_children_names {path} {
        debug_tree [info level 0]
        set normalized_names {}
        foreach child_name [_get_children_names [path::add_root [path::escape $path]]] {
          lappend normalized_names [path::normalize $child_name]
        }
        return $normalized_names
      }

      proc get_children {path} {
        set path [path::add_root [path::escape $path]]
        debug_tree [info level 0]
        set result {}
        foreach child_name [_get_children_names $path] {
          lappend result [list [path::normalize $child_name] [_get_node_data [path::join_element $path $child_name]]]
        }
        return $result
      }

      proc get_node_data {path} {
        debug_tree [info level 0]
        return [_get_node_data [path::add_root [path::escape $path]]]
      }

      proc set_node_data {path data} {
        debug_tree [info level 0]
        set path [path::add_root [path::escape $path]]
        _set_node_data $path $data
        return ""
      }

      proc remove_tree {path} {
        debug_tree [info level 0]
        _remove_tree [path::add_root [path::escape $path]]
        return ""
      }
    }
  }

}

