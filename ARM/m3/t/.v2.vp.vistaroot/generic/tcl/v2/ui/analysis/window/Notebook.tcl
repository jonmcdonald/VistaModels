namespace eval ::v2::ui::analysis::window {

  class Notebook {
    inherit ::UI::Notebook
    
    private variable gr_win
    private variable report_tabs_names "power sockets attributes"
    private variable summary_tabs_names "summary_tree summary_power summary_sockets summary_attr"
    private variable plots {}
    private variable plot_pady_tops
    private variable plot_current_point_markers
    private variable bg_color #bfbfbf

    constructor {_document args} {
      ::UI::Notebook::constructor $_document
    } {
      eval itk_initialize $args
      
      create_body
    }

    public method show {}
    public method update_current_report_table {}
    public method update_current_summary_table {}
    public method show_pane {pane}
    public method hide_pane {pane}
    public method set_current_tree {clicked_widget}
    
    private method create_body {}
    private method create_tree_view {}
    private method create_graphs_view {}
    private method create_reports_view {}
    private method fill_graphs_view_toolbar {}
    private method fill_tree_view_toolbar {}
    private method set_path_view {widget args}
    private method pack_graphic_components {args}

    private method plot_mouse_move {unit W x y} {
      
      if {[$W inside $x $y]} {
        $W crosshairs configure -position "@$x,$y"
        
        if {$y > 25} {
          set marker_y $y
        } else {
          set marker_y [expr $y + 25]
        }
        set plot_width [$W extents plotwidth]
        if {$x < [expr $plot_width - 100]} {
          set marker_x $x
        } else {
          set marker_x [expr $plot_width - 50]
        }
        set text_logical_coords [$W invtransform $marker_x $marker_y]
        set logical_coords [$W invtransform $x $y]
        $W marker configure $plot_current_point_markers($W) -coords $text_logical_coords -text [$unit point_values_text $logical_coords]
      } else {
        $W crosshairs configure -position "@$x,$plot_pady_tops($W)"
        $W marker configure $plot_current_point_markers($W) -coords "-1000000000 -1000000000" -text {}
      }
      foreach graph $plots {
        if {![string equal $W $graph]} {
          $graph crosshairs configure -position "@$x,$plot_pady_tops($graph)"
          $graph marker configure $plot_current_point_markers($graph) -coords "-1000000000 -1000000000" -text {}
        }
      }
    }

    private method plot_mouse_leave {W} {
      foreach graph $plots {
        $graph crosshairs configure -position "@-1,-1"
        $graph marker configure $plot_current_point_markers($graph) -coords "-1000000000 -1000000000" -text {}
      }
    }

    private method change_state {args} {
      if {[$document get_variable_value ShowAttribute] || [$document get_variable_value ShowHitMissRatio]} {
        $itk_component(show_min_values) configure -state normal
      } else {
        $itk_component(show_min_values) configure -state disabled 
      }
    }


  } ;# class

  body Notebook::show {} {

    pack $itk_component(graphs) -side top -fill both -expand 1
    pack $itk_component(pane_ver) -side top -fill both -expand 1 -anchor nw
    pack $itk_component(summary_tabs) -side top -fill both -expand 1
    pack $itk_component(summary_tabs).header -side top -anchor e -padx 5
    pack $itk_component(summary_tree_tree_view) -side top -fill both -expand 1
    pack $itk_component(summary_tree_power_view) -side top -fill both -expand 1
    pack $itk_component(summary_tree_socket_view) -side top -fill both -expand 1
    pack $itk_component(summary_tree_attr_view) -side top -fill both -expand 1
    pack $itk_component(report_tree_view) -side top -fill both -expand 1
    pack $itk_component(report_tree_attr_view) -side top -fill both -expand 1
    pack $itk_component(report_tree_power_view) -side top -fill both -expand 1
    pack $itk_component(report_tabs) -side top -fill both -expand 1
    pack $itk_component(report_tabs).header -side top -anchor e -padx 30

    foreach var {
      ShowPower 
      ShowPowerDetailed1
      ShowPowerDetailed2
      ShowThroughputTransactions 
      ShowThroughputTransactionsDetailed1 
      ShowThroughputTransactionsDetailed2 
      ShowThroughputData 
      ShowThroughputDataDetailed1 
      ShowThroughputDataDetailed2 
      ShowLatency 
      ShowArbitration
      ShowContention
      ShowUtilization 
      ShowAttribute
      ShowHitMissRatio
    } {
      ::UI::auto_trace_with_init variable [$document get_variable_name $var] \
          w $itk_interior [code $this pack_graphic_components]
    }
  }

  body Notebook::create_body {} {
    itk_component add pane_ver {
      ::UI::PaneContainer $itk_interior.pane_ver $document -orient vertical -isselected 1 \
          -withsashbitmap 0
    } { }

    set itk_component(pane_tree) \
        [$itk_component(pane_ver) add pane tree -minimum 50 -thickness 400 -withtoolbar 1 \
             -toolbarheight 18 -showInCreate [$document get_variable_value ShowDesignTree]]

    attach [$itk_component(pane_ver) component tree] ShowDesignTree

    set itk_component(pane_hor) \
        [$itk_component(pane_ver) add container right \
             -minimum 0 -orient horizontal -withsashbitmap 0]


    create_tree_view
    create_graphs_view
    create_reports_view

  }

  body Notebook::create_tree_view {} {
    pack forget [[$itk_component(pane_ver) component tree] get_button_close]
    fill_tree_view_toolbar

    itk_component add summary_tabs {
      blt::tabset [$itk_component(pane_ver) childsite tree].summary_tabs \
          -side top -relief flat  -highlightthickness 0 -samewidth 0 \
          -gap 1 -borderwidth 0 -outerpad 0 -selectpad 2 \
          -tabbackground $bg_color -selectbackground $bg_color -activebackground $bg_color 
    } {}

    label $itk_component(summary_tabs).header -text "Summary"

    itk_component add summary_tree_fr { 
      frame $itk_component(summary_tabs).tree_fr 
    } { }
    itk_component add summary_power_fr { 
      frame $itk_component(summary_tabs).power_fr 
    } { }
    itk_component add summary_sockets_fr { 
      frame $itk_component(summary_tabs).sockets_fr 
    } { }
    itk_component add summary_attr_fr { 
      frame $itk_component(summary_tabs).attr_fr 
    } { }

    $itk_component(summary_tabs) insert end summary_tree -text "Tree" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(summary_tree_fr)
    $itk_component(summary_tabs) insert end summary_power -text "Power" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(summary_power_fr)
    $itk_component(summary_tabs) insert end summary_sockets -text "Sockets" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(summary_sockets_fr)
    $itk_component(summary_tabs) insert end summary_attr -text "Attributes" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(summary_attr_fr)
    
    itk_component add summary_tree_tree_view {
      ::v2::ui::analysis::window::TreeSummaryTableView $itk_component(summary_tree_fr).tree_summary_view $document
    } {}

    itk_component add summary_tree_power_view {
      ::v2::ui::analysis::window::PowerSummaryTableView $itk_component(summary_power_fr).power_summary_view $document
    } {}

    itk_component add summary_tree_socket_view {
      ::v2::ui::analysis::window::SocketSummaryTableView $itk_component(summary_sockets_fr).socket_summary_view $document
    } {}

    itk_component add summary_tree_attr_view {
      ::v2::ui::analysis::window::AttrSummaryTableView $itk_component(summary_attr_fr).attr_summary_view $document
    } {}
  }

  body Notebook::create_graphs_view {} {
    set itk_component(pane_graph) \
        [$itk_component(pane_hor) add pane graph -minimum 50 -thickness 400 -withtoolbar 1 \
             -toolbarheight 18 -showInCreate [$document get_variable_value ShowGraphsView]]

    attach [$itk_component(pane_hor) component graph] ShowGraphsView
    
    pack forget [[$itk_component(pane_hor) component graph] get_button_close]
    fill_graphs_view_toolbar
    
    # graphs
    #set mu [encoding convertfrom utf-8 "\xc2\xb5"]
    set mu $::LETTER_MU

    itk_component add graphs {
      frame [$itk_component(pane_hor) childsite graph].graphs -background white
    } {}
    
    set plots {}
    foreach {unit doctype title} [list \
                                      power_unit DocumentTypeAnalysisPower "Power, mW" \
                                      power_unit_detailed1 DocumentTypeAnalysisPowerDetailed1 "Power Distribution, mW" \
                                      power_unit_detailed2 DocumentTypeAnalysisPowerDetailed2 "Power Distribution, mW" \
                                      transactions_unit DocumentTypeAnalysisThroughputTransactions "Throughput, trans/[set mu]s" \
                                      transactions_unit_detailed1 DocumentTypeAnalysisThroughputTransactionsDetailed1 "Bus Throughput, trans/[set mu]s" \
                                      transactions_unit_detailed2 DocumentTypeAnalysisThroughputTransactionsDetailed2 "Bus Throughput, trans/[set mu]s" \
                                      throughput_data_unit DocumentTypeAnalysisThroughputData "Throughput, bytes/[set mu]s" \
                                      throughput_data_unit_detailed1 DocumentTypeAnalysisThroughputDataDetailed1 "Bus Throughput, bytes/[set mu]s" \
                                      throughput_data_unit_detailed2 DocumentTypeAnalysisThroughputDataDetailed2 "Bus Throughput, bytes/[set mu]s" \
                                      latency_unit DocumentTypeAnalysisLatency "Latency, ns" \
                                      arbitration_unit DocumentTypeAnalysisArbitration "Arbitration, ns" \
                                      contention_unit DocumentTypeAnalysisContention "Contention, requests" \
                                      utilization_unit DocumentTypeAnalysisUtilization "Utilization (%)" \
                                      attr_unit DocumentTypeAnalysisAttribute "Attributes" \
                                      ratio_unit DocumentTypeAnalysisRatio "Hit/Miss Ratio, %"
                                      ] {
      itk_component add $unit {
        ::v2::ui::analog_wave::PlotView $itk_component(graphs).$unit \
            [$document create_tcl_sub_document $doctype] $title \
            -value_formatter [code $document run_command_with_result DefaultFormatGraphValue ValueArg] \
            -time_formatter [code $document run_command_with_result FormatTimeValueCommand TimeArg]
      } {}

      set graph [$itk_component($unit) get_graph]
      lappend plots $graph
      ;#set plot_pady_tops($graph) [$itk_component($unit) get_highest_graph_point]
      set plot_pady_tops($graph) -10
      set plot_current_point_markers($graph) [$graph marker create text  -anchor sw -background {} -padx 5 -pady 5]
      bind $graph <Motion> "+[itcl::code $this plot_mouse_move $itk_component($unit) %W %x %y]"
      bind $graph <Leave> "+[itcl::code $this plot_mouse_leave %W]"
    }
#     $itk_component(transactions_unit) config \
#         -value_formatter [code $document run_command_with_result FormatTransactionsPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveTransactionsPerUSTicks YLimitsArg]
#     $itk_component(transactions_unit_detailed1) config \
#         -value_formatter [code $document run_command_with_result FormatTransactionsPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveTransactionsPerUSTicks YLimitsArg]
#     $itk_component(transactions_unit_detailed2) config \
#         -value_formatter [code $document run_command_with_result FormatTransactionsPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveTransactionsPerUSTicks YLimitsArg]

#     $itk_component(throughput_data_unit) config \
#         -value_formatter [code $document run_command_with_result FormatBytesPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveBytesPerUSTicks YLimitsArg]
#     $itk_component(throughput_data_unit_detailed1) config \
#         -value_formatter [code $document run_command_with_result FormatBytesPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveBytesPerUSTicks YLimitsArg]
#     $itk_component(throughput_data_unit_detailed2) config \
#         -value_formatter [code $document run_command_with_result FormatBytesPerUSValue ValueArg] \
#         -tick_resolver [code $document run_command_with_result ResolveBytesPerUSTicks YLimitsArg]
  }
  
  body Notebook::create_reports_view {} {
    set itk_component(pane_report) \
        [$itk_component(pane_hor) add pane report -minimum 200 -thickness 220 -withtoolbar 1 -toolbarheight 8 \
             -showInCreate [$document get_variable_value ShowReportView]]
    attach [$itk_component(pane_hor) component report] ShowReportView
    set report_toolbar [$itk_component(pane_hor) component report toolbar]
    set report_toolbar_fr [$report_toolbar get_frame]
    pack forget $report_toolbar_fr $report_toolbar

    itk_component add report_tabs {
      blt::tabset [$itk_component(pane_hor) childsite report].report_tabs \
          -side top -relief flat  -highlightthickness 0 -samewidth 0 \
          -gap 1 -borderwidth 0 -outerpad 0 -selectpad 2 \
          -tabbackground $bg_color -selectbackground $bg_color -activebackground $bg_color
    } {}
    
    label $itk_component(report_tabs).header -text "Segment"

    itk_component add sockets_fr { 
      frame $itk_component(report_tabs).sockets_fr 
    } { }
    itk_component add power_fr { 
      frame $itk_component(report_tabs).power_fr 
    } { }
    itk_component add attr_fr { 
      frame $itk_component(report_tabs).attr_fr 
    } { }

    $itk_component(report_tabs) insert end power -text "Power" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(power_fr)
    $itk_component(report_tabs) insert end sockets -text "Sockets" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(sockets_fr)
     $itk_component(report_tabs) insert end attributes -text "Attributes" \
        -fill both -anchor c -background {} -selectbackground {} -selectforeground {} \
        -window $itk_component(attr_fr)

    itk_component add report_tree_view {
      ::v2::ui::analysis::window::ReportTableView $itk_component(sockets_fr).table_view $document
    } {}

    itk_component add report_tree_attr_view {
      ::v2::ui::analysis::window::AttrReportTableView $itk_component(attr_fr).attr_table_view $document
    } {}

    itk_component add report_tree_power_view {
      ::v2::ui::analysis::window::PowerReportTableView $itk_component(power_fr).power_table_view $document
    } {}
  }

  body Notebook::fill_graphs_view_toolbar {} {
    set toolbar [$itk_component(pane_hor) component graph toolbar]
    set toolbar_fr [$toolbar get_frame]

    set buttons [frame $toolbar_fr.btn -bg $itk_option(-background)]

    itk_component add show_transactions {
      ::UI::Checkbutton $buttons.show_transactions \
          -text "Throughput trans" -padx 3
      } {}
    attach $itk_component(show_transactions) ShowThroughputTransactions


#     itk_component add show_transactions_detailed1 {
#       ::UI::Checkbutton $buttons.show_transactions_detailed1 \
#           -text "d1" -padx 3
#       } {}
#     attach $itk_component(show_transactions_detailed1) ShowThroughputTransactionsDetailed1

#     itk_component add show_transactions_detailed2 {
#       ::UI::Checkbutton $buttons.show_transactions_detailed2 \
#           -text "d2" -padx 3
#       } {}
#     attach $itk_component(show_transactions_detailed2) ShowThroughputTransactionsDetailed2

      
    itk_component add show_throughput {
        ::UI::Checkbutton $buttons.show_throughput \
            -text "Throughput bytes" -padx 3
      } {}
    attach $itk_component(show_throughput) ShowThroughputData

      
#     itk_component add show_throughput_detailed1 {
#         ::UI::Checkbutton $buttons.show_throughput_detailed1 \
#             -text "d1" -padx 3
#       } {}
#     attach $itk_component(show_throughput_detailed1) ShowThroughputDataDetailed1

#     itk_component add show_throughput_detailed2 {
#         ::UI::Checkbutton $buttons.show_throughput_detailed2 \
#             -text "d2" -padx 3
#       } {}
#     attach $itk_component(show_throughput_detailed2) ShowThroughputDataDetailed2

      
    itk_component add show_latency {
      ::UI::Checkbutton $buttons.show_latency \
          -text "Latency" -padx 3
    } {}
    attach $itk_component(show_latency) ShowLatency

    # itk_component add show_arbitration {
#       ::UI::Checkbutton $buttons.show_arbitration \
#           -text "Arbitration" -padx 3
#     } {}

   # attach $itk_component(show_arbitration) ShowArbitration
    
    itk_component add show_utilization {
        ::UI::Checkbutton $buttons.show_utilization \
          -text "Utilization" -padx 3
      } {}
    attach $itk_component(show_utilization) ShowUtilization
    
    itk_component add show_power {
      ::UI::Checkbutton $buttons.show_power \
          -text "Power" -padx 3
    } {}
    attach $itk_component(show_power) ShowPower
    
    itk_component add show_attribute {
      ::UI::Checkbutton $buttons.show_attribute \
          -text "Attributes" -padx 3
    } {}
    attach $itk_component(show_attribute) ShowAttribute
    
    itk_component add show_max_values {
      ::UI::Checkbutton $buttons.show_max_values \
          -text "Max" -padx 3
    } {}
    attach $itk_component(show_max_values) ShowMaxValues

    itk_component add show_min_values {
      ::UI::Checkbutton $buttons.show_min_values \
          -text "Min" -padx 3
    } {}
    attach $itk_component(show_min_values) ShowMinValues

    itk_component add max_sep {
      frame $buttons.max_sep -bd 1 -width 2  -relief sunken  -takefocus 0;#-height [expr $itk_option(-buttonheight) + 4]
    } 
    pack \
        $itk_component(show_power) \
        $itk_component(show_transactions) \
        $itk_component(show_throughput) \
        $itk_component(show_latency) \
        $itk_component(show_attribute) \
        -side left -anchor w -padx 1
    pack $itk_component(max_sep) -side left -anchor w -padx 10 -fill y     
    pack $itk_component(show_max_values) -side left -anchor w ;#-padx 20
    pack $itk_component(show_min_values) -side left -anchor w 
    
    UI::auto_trace_with_init variable [$document get_variable_name ShowAttribute] w $itk_interior [::itcl::code $this change_state ShowAttribute]
    UI::auto_trace_with_init variable [$document get_variable_name ShowHitMissRatio] w $itk_interior [::itcl::code $this change_state ShowHitMissRatio]


#        $itk_component(show_transactions_detailed1) \
#        $itk_component(show_transactions_detailed2) \
#        $itk_component(show_throughput_detailed1) \
#        $itk_component(show_throughput_detailed2) \

# UTILIZATION TEMPORARY DISABLED: REMOVED $itk_component(show_utilization) above (should be before $itk_component(show_attribute))

    pack $buttons -side top -anchor center ;#-fill x

  }

  body Notebook::fill_tree_view_toolbar {} {

    set toolbar [$itk_component(pane_ver) component tree toolbar]
    set toolbar_fr [$toolbar get_frame]
    set buttons [frame $toolbar_fr.btn -bg $itk_option(-background)]
    
    set db_fr [frame $buttons.db_fr]

    itk_component add a_sim_check {
      ::UI::Checkbutton $db_fr.a -text "A" -padx 4
    } {}
    
    itk_component add a_sim_symbol {
      label $db_fr.a_symbol -text "" -image [::UI::getimage square] -width 12
    } {}
      
    itk_component add a_sim_path {
      ::UI::FlushFileChooser $db_fr.a_chooser -browsetype directory -dialogtitle "Select Simulation Directory" \
          -filenamevariable [$document get_variable_name A_SimPath] ;#-initialdir $simDir
    } {}
    
    itk_component add b_sim_check {
      ::UI::Checkbutton $db_fr.b -text "B" -padx 4
    } {}
    
    itk_component add b_sim_symbol {
      label $db_fr.b_symbol -text "" -image [::UI::getimage triangle] -width 12
    } {}
    
    itk_component add b_sim_path {
      ::UI::FlushFileChooser $db_fr.b_chooser -browsetype directory -dialogtitle "Select Simulation Directory" \
          -filenamevariable [$document get_variable_name B_SimPath] ;#-initialdir $simDir
    } {}
    
    attach $itk_component(a_sim_check) A_SimOn
    attach $itk_component(b_sim_check) B_SimOn
    
    grid $itk_component(a_sim_check)  -row 0 -column 0 -sticky nw -padx 1
    grid $itk_component(a_sim_symbol) -row 0 -column 1 -sticky w -padx 1
    grid $itk_component(a_sim_path)   -row 0 -column 2 -sticky ew -padx 1
    grid $itk_component(b_sim_check)  -row 1 -column 0 -sticky nw -padx 1
    grid $itk_component(b_sim_symbol) -row 1 -column 1 -sticky w -padx 1
    grid $itk_component(b_sim_path)   -row 1 -column 2 -sticky ew -padx 1

    grid rowconfig $db_fr 0 -weight 1
    grid columnconfig $db_fr 2 -weight 1

    pack $db_fr -side top -fill x -expand 1
    
    ::UI::auto_trace_with_init variable [$document get_variable_name A_SimPath] \
        w $itk_interior [code $this set_path_view $itk_component(a_sim_path)]
    ::UI::auto_trace_with_init variable [$document get_variable_name B_SimPath] \
        w $itk_interior [code $this set_path_view $itk_component(b_sim_path)]

    bind [$itk_component(a_sim_path) get_entry] [list <Control-c> <Control-C>] [$document run_command CopyCommand]
    bind [$itk_component(b_sim_path) get_entry] [list <Control-c> <Control-C>] [$document run_command CopyCommand]
    bind [$itk_component(a_sim_path) get_entry] [list <Control-v> <Control-V>] [$document run_command PasteCommand]
    bind [$itk_component(b_sim_path) get_entry] [list <Control-v> <Control-V>] [$document run_command PasteCommand]

    pack $buttons -side top -anchor w -fill x -expand 1 
  }

  body Notebook::pack_graphic_components {args} {
    set visibilities [list \
                          [$document get_variable_value ShowPower] \
                          [$document get_variable_value ShowPowerDetailed1] \
                          [$document get_variable_value ShowPowerDetailed2] \
                          [$document get_variable_value ShowThroughputTransactions] \
                          [$document get_variable_value ShowThroughputTransactionsDetailed1] \
                          [$document get_variable_value ShowThroughputTransactionsDetailed2] \
                          [$document get_variable_value ShowThroughputData] \
                          [$document get_variable_value ShowThroughputDataDetailed1] \
                          [$document get_variable_value ShowThroughputDataDetailed2] \
                          [$document get_variable_value ShowLatency] \
                          [$document get_variable_value ShowArbitration] \
                          [$document get_variable_value ShowContention] \
                          [$document get_variable_value ShowUtilization] \
                          [$document get_variable_value ShowAttribute] \
                          [$document get_variable_value ShowHitMissRatio]]
    set order_list [list \
                        $itk_component(power_unit) \
                        $itk_component(power_unit_detailed1) \
                        $itk_component(power_unit_detailed2) \
                        $itk_component(transactions_unit) \
                        $itk_component(transactions_unit_detailed1) \
                        $itk_component(transactions_unit_detailed2) \
                        $itk_component(throughput_data_unit) \
                        $itk_component(throughput_data_unit_detailed1) \
                        $itk_component(throughput_data_unit_detailed2) \
                        $itk_component(latency_unit) \
                        $itk_component(arbitration_unit) \
                        $itk_component(contention_unit) \
                        $itk_component(utilization_unit) \
                        $itk_component(attr_unit) \
                        $itk_component(ratio_unit) ]
    set first_staying_visible_widget {}
    for {set index 0} {$index < [llength $order_list]} {incr index} {
      set widget [lindex $order_list $index]
      set visible [lindex $visibilities $index]
      if {![winfo exists $widget]} {
        continue
      }
      if {!$visible} {
        if {[winfo ismapped $widget]} {
          pack forget $widget
        }
      } else {
        if {$first_staying_visible_widget == {}} {
          if {[winfo ismapped $widget]} {
            set first_staying_visible_widget $widget
          }
        }
      }
    }
    set last_visible_widget {}
    for {set index 0} {$index < [llength $order_list]} {incr index} {
      set widget [lindex $order_list $index]
      set visible [lindex $visibilities $index]
      if {![winfo exists $widget]} {
        continue
      }
      if {$visible} {
        set previous_widget $last_visible_widget
        set last_visible_widget $widget
        if {$previous_widget != {}} {
          $previous_widget hide_xaxis 1
          if {![winfo ismapped $widget]} {
            pack $widget -fill both -expand 1 -after $previous_widget
          }
        } else {
          if {$first_staying_visible_widget == {}} {
            pack $widget -fill both -expand 1
          } else {
            pack $widget -fill both -expand 1 -before $first_staying_visible_widget
          }
        }
      }
    }
    if {$last_visible_widget != {}} {
      $last_visible_widget hide_xaxis 0
    }
  }

  body Notebook::update_current_report_table {} {
    set tab_name [$document get_variable_value CurrentReportTable]
    set idx [lsearch $report_tabs_names $tab_name]
    if {$idx != -1} {
      $itk_component(report_tabs) select $idx
    }
  }
  
  body Notebook::update_current_summary_table {} {
    set tab_name [$document get_variable_value CurrentSummaryTable]
    set idx [lsearch $summary_tabs_names $tab_name]
    if {$idx != -1} {
      $itk_component(summary_tabs) select $idx
    }
  }

  body Notebook::show_pane {pane} {
    switch $pane {
      "tree" {
        $itk_component(pane_ver) show tree
      }
      "graphs" {
        $itk_component(pane_hor) show graph
      }
      "report" {
        $itk_component(pane_hor) show report
      }
    }
  }

  body Notebook::hide_pane {pane} {
    switch $pane {
      "tree" {
        $itk_component(pane_ver) hide tree
      }
      "graphs" {
        $itk_component(pane_hor) hide graph
      }
      "report" {
        $itk_component(pane_hor) hide report
      }
    }
  }

  body Notebook::set_current_tree {clicked_widget} {
    if {[::UI::is_parent_of $itk_component(pane_tree) $clicked_widget]} {
      $document set_variable_value CurrentTree [$itk_component(summary_tabs) get select]
      $document set_variable_value CurrentSummaryTable [$itk_component(summary_tabs) get select]
    } elseif {[::UI::is_parent_of $itk_component(pane_report) $clicked_widget]} {
      $document set_variable_value CurrentTree [$itk_component(report_tabs) get select]
      $document set_variable_value CurrentReportTable [$itk_component(report_tabs) get select]
    } elseif {\
                  [::UI::is_parent_of $itk_component(power_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(power_unit_detailed1) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(power_unit_detailed2) $clicked_widget] \
                } {
      $document set_variable_value CurrentReportTable power
    } elseif {\
                  [::UI::is_parent_of $itk_component(transactions_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(transactions_unit_detailed1) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(transactions_unit_detailed2) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(throughput_data_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(throughput_data_unit_detailed1) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(throughput_data_unit_detailed2) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(latency_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(arbitration_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(contention_unit) $clicked_widget] || \
                  [::UI::is_parent_of $itk_component(utilization_unit) $clicked_widget] \
                } {
      $document set_variable_value CurrentReportTable sockets
    } elseif {[::UI::is_parent_of $itk_component(attr_unit) $clicked_widget] || [::UI::is_parent_of $itk_component(ratio_unit) $clicked_widget]} {
      $document set_variable_value CurrentReportTable attributes
    }
  }

  body Notebook::set_path_view {widget args} {
    set ent [$widget get_entry]
    set txt_len [string length [$ent get]]
    
    if {$txt_len == 0} {
      return
    }
    set ent_len [$ent cget -width]
    set fraction [expr 1.0*$ent_len/$txt_len]
    set location [expr 1 - $fraction]
    $ent xview moveto $location
  }
  
} ;#namespace
  
namespace eval ::UI {
  ::itcl::class v2/ui/analysis/window/Notebook/DocumentLinker {
    inherit UI/Notebook/DocumentLinker
  }

  v2/ui/analysis/window/Notebook/DocumentLinker v2/ui/analysis/window/Notebook/DocumentLinkerObject
}
