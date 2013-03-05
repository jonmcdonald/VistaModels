
# ========================EXAMPLE=======================================
package require Tclx
package require BLT


source tree.tcl
namespace eval ::Utilities::ns_tree::test {
namespace import -force ::blt::*
namespace import -force ::blt::tile::*  
  proc createGUI {} {
    variable top
    variable tree
    variable treeview
    set top .top
    toplevel $top
    pack [frame [set topframe $top.frame]] -fill both -expand y
    set treeview $topframe.tree
    
    set tree [tree create]
    $tree delete 0
    treeview $treeview \
        -width 0 \
        -yscrollcommand [list $topframe.vs set ] \
        -xscrollcommand [list $topframe.hs set ] \
        -selectmode single \
        -tree $tree
    $treeview column configure treeView -text "" 
    focus $treeview
    
    scrollbar $topframe.vs -orient vertical -command [list $treeview yview ]
    scrollbar $topframe.hs -orient horizontal -command [list $treeview xview ]
    

    table $topframe \
        0,0 $treeview  -fill both \
        0,1 $topframe.vs -fill y \
        1,0 $topframe.hs -fill x
    table configure $topframe c1 r1 -resize none
    $treeview column insert end path type
    $treeview configure -selectforeground black
    $treeview sort auto 1
    $treeview sort configure -command [namespace current]::sort_nodes


    
  }
  proc sort_nodes {args} {
    puts [info level 0]
#    return [string compare $a $b]
  }

  proc is_opened {path} {
    set ns ::Utilities::ns_tree::test::mydata
    if {![[set ns]::does_node_exist $path]} {
      return 0
    }
    if {![[set ns]::has_children $path]} {
      return 1
    }
    if {[llength [[set ns]::get_children_names $path]]} {
      return 1
    }
    
    return 0
  }

  set current_parent_id {root}
  proc update_gui_r {command path args} {
    variable tree
    variable treeview
    variable current_parent_id
    set ns ::Utilities::ns_tree::test::mydata

    if {$command == "post_visit"} {
      if {[[set ns]::has_children $path]} {
        if {![is_opened $path]} {
          $tree insert [lindex $current_parent_id end] -label ____dummy_____
          $treeview entry configure [lindex $current_parent_id end] -opencommand [list [set ns]::open_node $path]
        } else {
          $treeview open [lindex $current_parent_id end]
        }
      }
      set current_parent_id [lrange $current_parent_id 0 end-1]
      
      return
    }
#    puts "$tree insert $current_parent_id -label [lindex $path end]"
    lappend current_parent_id [$tree insert [lindex $current_parent_id end] -label [lindex $path end]]
  }

  proc update_gui {} {
    variable tree
    set ns ::Utilities::ns_tree::test::mydata
    $tree delete 0
    [set ns]::traverse_tree "" [namespace current]::update_gui_r
  }


#  trace variable ::VisualClientBackAPI::structure w visual::mini_visual::Example_GUI::show_structure


  proc main {} {
    
    set ns ::Utilities::ns_tree::test::mydata
    if {[namespace exists $ns] } {namespace delete $ns}
    ::Utilities::ns_tree::construct_tree $ns
    namespace eval $ns {
      proc virtual_get_node_data {path} {
        set fs_path [join $path /]
        if {![file exist $fs_path]} {
          return {}
        }
        set children [glob -nocomplain -directory $fs_path *]
        set has_children [expr {[llength $children] > 0}]
        return [list $has_children [file type $fs_path]]
      }
      proc virtual_get_children_names {path} {
         set fs_path [join $path /]
        if {![file exist $fs_path]} {
          return {}
        }
        return [glob -nocomplain -tails -directory $fs_path *]
      }
      proc virtual_on_node_changed {path} {
        puts "!!![info level 0]"
        ::Utilities::ns_tree::test::update_gui
      }
      proc virtual_on_tree_removed {path} {
        puts "!!![info level 0]"
        ::Utilities::ns_tree::test::update_gui
      }
    }


    createGUI

  }




  main
}

  
::Utilities::ns_tree::test::mydata::get_children_names {.}

proc monitor {} {
  after 1000 monitor
  ::Utilities::ns_tree::test::mydata::update_tree
}
monitor
