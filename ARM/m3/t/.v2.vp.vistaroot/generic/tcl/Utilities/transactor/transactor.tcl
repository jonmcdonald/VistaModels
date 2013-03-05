namespace eval ::Utilities {
  namespace eval transactor {
    set transaction_queue {}
    set break_flag 0
    set loop_counter 0

    proc transaction_dbg {text} {
      puts "TransactionDBG: $text"
    }
    proc log_error {text} {
      puts "TransactionError: $text"
    }

    proc evaluate_transactions {} {
      variable transaction_queue
      variable break_flag
      while {[llength $transaction_queue]} {
        if {$break_flag} {
          break
        }
        set transaction [lindex $transaction_queue 0]
        set transaction_queue [lrange $transaction_queue 1 end]
        evaluate_transaction $transaction
      }
    }

    proc evaluate_transaction {transaction} {
      if {[catch {
        uplevel \#0 $transaction
        #transaction_dbg "$transaction evaluated"
      } msg ]} {
        log_error "Error while evaluating $transaction: $msg"
      }
    }

    proc start_mainloop {} {
      variable transaction_queue
      variable break_flag
      variable loop_counter
      if {$loop_counter}  {
        return
      }
      incr loop_counter
      set break_flag 0
      after idle [list [namespace current]::touch_transaction_queue]
      catch {
        while {1} {
          after 1000 [list [namespace current]::touch_transaction_queue]
          vwait [namespace current]::transaction_queue
          evaluate_transactions
          if {$break_flag} {
            break
          }
        }
      }
      incr loop_counter -1
      return ""
    }

    proc break_mainloop {} {
      variable break_flag
      set break_flag 1
      touch_transaction_queue
    }

    proc touch_transaction_queue {} {
      variable transaction_queue
      set transaction_queue $transaction_queue
    }
   
    proc clear_transaction_queue {} {
      variable transaction_queue
      set transaction_queue {}
    }

    proc append_one_transaction {transaction} {
      variable transaction_queue
      lappend transaction_queue $transaction
    }
    
    proc append_transactions {transaction_list} {
      variable transaction_queue
      set transaction_queue [concat $transaction_queue $transaction_list]
    }

    proc prepend_one_transaction {transaction} {
      variable transaction_queue
      set transaction_queue [linsert $transaction_queue 0 $transaction]
    }

    proc prepend_transactions {transaction_list} {
      variable transaction_queue
      set transaction_queue [concat  $transaction_list $transaction_queue]
    }

    proc tk_test {} {
      proc test_on_button_start_loop {} {
        start_mainloop
      }
      proc test_on_button_append_transaction {} {
        variable test_command
        append_one_transaction $test_command
      }

      proc test_on_button_prepend_transaction {} {
        variable test_command
        prepend_one_transaction $test_command
      }

      proc test_on_button_break_loop {} {
        variable test_timeout
        break_mainloop
      }

      proc test_on_button_clear_queue {} {
        variable test_timeout
        clear_transaction_queue
      }

      variable transaction_queue
      toplevel .transaction_test
      pack [label .transaction_test.counter_text -text "Loop Number:"]
      pack [label .transaction_test.counter -textvariable [namespace current]::loop_counter]

      pack [label .transaction_test.lb_text -text "Current Transactions:"]
      pack [listbox .transaction_test.lb -listvariable [namespace current]::transaction_queue] -fill both -expand y

      pack [label .transaction_test.command_text_text -text "Transaction:"]
      pack [entry .transaction_test.command -textvariable [namespace current]::test_command] -fill both -expand y
      foreach b {start_loop break_loop append_transaction prepend_transaction clear_queue} {
        pack [button .transaction_test.button_$b -text $b -command [namespace current]::test_on_button_$b] -side top
      }
    }
    
  }

}
