wm withdraw .

proc bgerror {message} {
  puts stderr $message
}

summit_package_require v2:ui:profilingwindow

set ::env(V2_BATCH_MODE) 0
$::main_doc run_command_ex OpenProfilingWindowCommand


#update
