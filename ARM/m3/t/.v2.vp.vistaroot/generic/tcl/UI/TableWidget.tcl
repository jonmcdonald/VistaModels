#trace variable ::errorInfo w ::onerr
#proc ::onerr {args} { if { $::errorInfo != "" } { puts "errorInfo = $::errorInfo" } }

namespace eval ::UI {
  class TableWidget {
    inherit ::UI::TreeTableBase

    constructor {_document args} {
      ::UI::TreeTableBase::constructor $_document
    } {
      
      eval itk_initialize $args

      create_vscroll_buttons
      set_binding

      focus $itk_component(table)
    }
    
    private method create_vscroll_buttons {} {
      itk_component add vscroll_buttons {
        frame $itk_interior.vscroll_buttons
      }
      
      Button $itk_component(vscroll_buttons).home -image [::UI::getimage home] -helptext "First Page"
      attach $itk_component(vscroll_buttons).home HomeCommand
      grid $itk_component(vscroll_buttons).home -row 1 -padx 5 -pady 1
      
      Button $itk_component(vscroll_buttons).page_up -image [::UI::getimage page_up] -helptext "Previous Page"
      attach $itk_component(vscroll_buttons).page_up PageUpCommand
      grid $itk_component(vscroll_buttons).page_up -row 2 -padx 5 -pady 1
      
      Button $itk_component(vscroll_buttons).up -image [::UI::getimage up] -helptext "Scroll Up"
      attach $itk_component(vscroll_buttons).up UpCommand
      grid $itk_component(vscroll_buttons).up -row 3 -padx 5 -pady 1
      
      Button $itk_component(vscroll_buttons).down -image [::UI::getimage down] -helptext "Scroll Down"
      attach $itk_component(vscroll_buttons).down DownCommand
      grid $itk_component(vscroll_buttons).down -row 4 -padx 5 -pady 1
      
      Button $itk_component(vscroll_buttons).page_down -image [::UI::getimage page_down] -helptext "Next Page"
      attach $itk_component(vscroll_buttons).page_down PageDownCommand
      grid $itk_component(vscroll_buttons).page_down -row 5 -padx 5 -pady 1
      
      Button $itk_component(vscroll_buttons).end -image [::UI::getimage end] -helptext "Last Page"
      attach $itk_component(vscroll_buttons).end EndCommand
      grid $itk_component(vscroll_buttons).end -row 6 -padx 5 -pady 1
      
      
      $itk_component(table) configure -yscrollcommand [code $this yscrollcommand]
      
      grid $itk_component(vscroll_buttons) -column 2 -row 1 -rowspan 2 -sticky ns
      grid columnconfigure $itk_interior 2 -weight 0
    }
    
    private method set_binding {} {
      chain
      
      foreach key {"Home" "Prior" "Up" "Down" "Next" "End"} {
        bind $itk_component(table) <$key> "[code $this key_command %K]; break"
      }
      
      bind $itk_component(table) <MouseWheel> {
        %W yview scroll [expr {- (%D / 120) * 4}] units
      }
      
      if {[string equal "x11" [tk windowingsystem]]} {
        #if {!$tk_strictMotif} {
        bind $itk_component(table) <Button-5> "[code $this key_command Down]"
        bind $itk_component(table) <Button-4> "[code $this key_command Up]"
        bind $itk_component(table) <Control-Button-5> "[code $this key_command Next]"
        bind $itk_component(table) <Control-Button-4> "[code $this key_command Prior]"
        #}
      }
    }

    private method yscrollcommand {first end} {
      process_yscrollcommand_requests
    }

    private method swap_command {anchorIndex dir} {
      catch {
        set anchorPosition [get_position_by_index $anchorIndex]
        if {$anchorPosition == {}} {
          set anchorPosition 0
        }
        $document run_command SwapCommand SwapDirection $dir AnchorPosition $anchorPosition
      }
    }
    
    ###############################################################
    ###                     Public Interface
    ###############################################################
    
    # This is called from CPP/tcl/dynamic_tree/[Up|Down|PageUp|PageDown|Home|End]Command
    public method scroll_command {type} {
      catch {
        switch $type {
          "home" {
            home_scroll_command
          }
          "end" {
            end_scroll_command
          }
          "up" {
            up_scroll_command
          }
          "down" {
            down_scroll_command
          }
          "page_up" {
            page_up_scroll_command
          }
          "page_down" {
            page_down_scroll_command
          }
        }
      }
    }
    
    public method refresh {} {
      set anchorIndex [get_focus_index]
      if {$anchorIndex == ""} {
        set anchorIndex [$itk_component(table) index view.fulltop]
        if {$anchorIndex == ""} {
          set anchorIndex 0
        }
      }
      
      swap_command $anchorIndex "none"
    }
    
    public method see_index {id place} {
      set_yscrollcommand_request [code $this see_index_internal $id $place]
    }
    
    public method get_position_by_index {index} {
      set tree [$itk_component(table) cget -tree]
      if {$tree != ""} {
        if {[key_is_exist "Position" $index]} {
          return [$tree get $index "Position"]
        }
      }
      return 0
    }

    public method set_yscrollcommand_request {request} {
      set yscrollcommand_requests [list $request]
    }

    ###############################################################

    private method see_index_internal {id place} {
      if {$place == "top"} {
        seefirst $id
      } else {
        seelast $id
      }
    }

    private method seefirst {id {script ""}} {
      if {$id == ""} {
        return
      }
      if { [$itk_component(table) index view.fulltop] != $id } {
        seebottom
        $itk_component(table) see $id
      }
      if {$script != ""} {
        ::Utilities::ff_schedule_script $script
      }
    }

    private method seelast {id {script ""}} {
      if {$id == ""} {
        return
      }
      if { [$itk_component(table) index view.fullbottom] != $id } {
        seetop
        $itk_component(table) see $id
      }
      if {$script != ""} {
        ::Utilities::ff_schedule_script $script
      }
    }

    private method seetop {{script ""}} {
      if { [lindex [$itk_component(table) yview] 0] != 0 } {
        $itk_component(table) yview moveto 0
      }
      if {$script != ""} {
        ::Utilities::ff_schedule_script $script
      }
    }

    private method seebottom {{script ""}} {
      if { [lindex [$itk_component(table) yview] 1] != 1 } {
        $itk_component(table) yview moveto 1
      }
      if {$script != ""} {
        ::Utilities::ff_schedule_script $script
      }
    }
    

    private method select_top {} {
      catch { configure -selectedNodeIDs [$itk_component(table) index view.fulltop] }
    }

    private method select_bottom {} {
      catch { configure -selectedNodeIDs [$itk_component(table) index view.fullbottom] }
    }

    private method up {{script ""}} {
      $itk_component(table) yview scroll -1 units
      if {$script != ""} {
        add_yscrollcommand_request $script
      }
    }

    private method down {{script ""}} {
      $itk_component(table) yview scroll 1 units
      if {$script != ""} {
        add_yscrollcommand_request $script
      }
    }

    private method page_up {{script ""}} {
      $itk_component(table) yview scroll -1 pages
      if {$script != ""} {
        add_yscrollcommand_request $script
      }
    }

    private method page_down {{script ""}} {
      $itk_component(table) yview scroll 1 pages
      if {$script != ""} {
        add_yscrollcommand_request $script
      }
    }

    private method is_node_visible {index} {
      if {$index == ""} {
        return 0
      }
      set bbox [$itk_component(table) bbox -screen $index]
      if {$bbox == ""} {
        return 0
      } else {
        if {[lindex $bbox 3] < [lindex [$itk_component(table) bbox $index] 3]} {
          return 0
        } else {
          return 1
        }
      }
    }

    private method get_focus_index {} {
      return [lindex [$itk_component(table) curselection] end]
    }

    private method is_focus_visible {} {
      return [is_node_visible [get_focus_index]]
    }
    ############################## Scroll Commands ###############################

    private method home_scroll_command {{script ""}} {
      swap_command 0 "home" 
      set_yscrollcommand_request [code $this seetop $script]
    }

    private method end_scroll_command {{script ""}} {
      swap_command 0 "end"
      set_yscrollcommand_request [code $this seebottom $script]
    }

    private method up_scroll_command {{script ""}} {
      set anchorIndex [$itk_component(table) index view.fulltop]
      set first_index [$itk_component(table) index -at 0 down]
      if {$anchorIndex != $first_index} {
        up $script
        return
      }

      swap_command $anchorIndex "none"
      set_yscrollcommand_request \
          [code $this seefirst $anchorIndex [code $this up $script]]
    }

    private method down_scroll_command {{script ""}} {
      set anchorIndex [$itk_component(table) index view.fullbottom]
      set end_index [lindex [$itk_component(table) range -open 0] end]
      if {$anchorIndex != $end_index} {
        down $script
        return
      }
      swap_command $anchorIndex "none"
      set_yscrollcommand_request \
          [code $this seelast $anchorIndex [code $this down $script]]
    }
    
    private method page_up_scroll_command {{script ""}} {
      set anchorIndex [$itk_component(table) index view.fulltop]
      set start_list [lrange [$itk_component(table) range -open 0] 0 35]
      if {[lsearch -exact $start_list $anchorIndex] == -1} {
        page_up $script
        return
      }
      swap_command $anchorIndex "none"
      set_yscrollcommand_request \
          [code $this seefirst $anchorIndex [code $this page_up $script]]
    }

    private method page_down_scroll_command {{script ""}} {
      set anchorIndex [$itk_component(table) index view.fullbottom]
      set end_list [lrange [$itk_component(table) range -open 0] end-35 end]
      if {[lsearch -exact $end_list $anchorIndex] == -1} {
        page_down $script
        return
      }
      swap_command $anchorIndex "none"
      set_yscrollcommand_request \
          [code $this seelast $anchorIndex [code $this page_down $script]]
    }

    private variable yscrollcommand_requests {}
    private method add_yscrollcommand_request {request} {
      lappend yscrollcommand_requests $request
    }
    private method clear_yscrollcommand_requests {} {
      set yscrollcommand_requests {}
    }

    private method process_yscrollcommand_requests {} {
      foreach request $yscrollcommand_requests {
        ::Utilities::ff_schedule_script $request
      }
      set yscrollcommand_requests {}
    }

    ######################  Keys Commands   ###############################

    private method key_command {key} {
      catch { [string tolower $key]_key_command }
    }
    
    private method home_key_command {} {
      home_scroll_command [code $this select_top]
    }
    
    private method end_key_command {} {
      end_scroll_command [code $this select_bottom]
    }

    private method next_key_command {} {
      if {![is_focus_visible]} {
        select_top
        return
      }
      if {[get_focus_index] == [$itk_component(table) index view.fulltop]} {
        select_bottom
        return
      }
      page_down_scroll_command [code $this select_bottom]
    }
    
    private method prior_key_command {} {
      if {![is_focus_visible]} {
        select_bottom
        return
      }
      if {[get_focus_index] == [$itk_component(table) index view.fullbottom]} {
        select_top
        return
      }
      page_up_scroll_command [code $this select_top]
    }

    private method down_key_command {} {
      if {![is_focus_visible]} {
        select_top
        return
      }
      set focus_index [get_focus_index]
      if {$focus_index != [$itk_component(table) index view.fullbottom]} {
        catch { configure -selectedNodeIDs [$itk_component(table) index -at $focus_index down] }
        return
      }
      down_scroll_command [code $this select_bottom]
    }

    private method up_key_command {} {
      if {![is_focus_visible]} {
        select_bottom
        return
      }
      set focus_index [get_focus_index]
      if {$focus_index != [$itk_component(table) index view.fulltop]} {
        catch { configure -selectedNodeIDs [$itk_component(table) index -at $focus_index up] }
        return
      }
      up_scroll_command [code $this select_top]
    }
    
  }
}

namespace eval ::UI {
  ::itcl::class UI/TableWidget/DocumentLinker {
    inherit UI/TreeTableBase/DocumentLinker
    protected method attach_to_data {widget document SelectedNodeIDs} {
      $widget configure \
          -selectedNodeIDsvariable [$document get_variable_name $SelectedNodeIDs]
    }
  }
  
  UI/TableWidget/DocumentLinker UI/TableWidget/DocumentLinkerObject
}
