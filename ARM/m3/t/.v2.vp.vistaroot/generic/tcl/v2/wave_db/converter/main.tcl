namespace eval ::v2::wave_db::converter {

  set requested_data(for_analysis) 0
  set requested_data(track_list) {}
  set requested_data(update_called) 0
  set requested_data(db_size) 0
  set requested_data(pool_event) 0
  set pooling_flag 0

  proc pop_requested_data {} {
    variable requested_data
    variable pooling_flag
    set for_analysis $requested_data(for_analysis)
    set track_list $requested_data(track_list)
    set update_called $requested_data(update_called)
    set db_size $requested_data(db_size)
    set pooling_flag_value $pooling_flag

    if {[llength $track_list]} {
      set requested_data(track_list) {}
    }
    if {$update_called} {
      set requested_data(update_called) 0
    }
    if {$for_analysis} {
      set requested_data(for_analysis) 0
    }
    if {$requested_data(db_size)} {
      set requested_data(db_size) 0
    }

    set pooling_flag 0

    return [list $for_analysis $track_list $update_called $db_size $pooling_flag_value]
  }

  proc add_tracks {for_analysis list_of_tracks} {
    variable requested_data
    eval lappend requested_data(track_list) $list_of_tracks
    set requested_data(for_analysis) $for_analysis
  }

  #Ilia will make db_size parameter mandatory
  proc update {{db_size 0}} {
    variable requested_data
    set requested_data(update_called) 1
    set requested_data(db_size) $db_size
  }

  proc pooling {args} {
    variable pooling_flag
    after 5000 [list catch [namespace current]::pooling]
    variable requested_data
    set pooling_flag 1
    set requested_data(pool_event) 1
  }

  ::Utilities::ff_trace variable ::v2::wave_db::converter::requested_data w [namespace current]::handle_remote_request

  pooling
}

